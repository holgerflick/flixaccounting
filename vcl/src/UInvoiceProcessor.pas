unit UInvoiceProcessor;

interface

uses
    System.Classes
  , System.SysUtils

  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer
  , Aurelius.Engine.ObjectManager
  , Aurelius.Criteria.Projections
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Expression

  , UExceptions
  , UTransaction
  , UInvoice
  ;

type
  TInvoiceProcessor = class
  public
    class procedure Process(AInvoice: TInvoice; AObjectManager: TObjectManager);
  end;

implementation

uses
  System.Generics.Collections

  ,  UInvoicePrinter
  ;

resourcestring
  SCannotProcessInvoice = 'Cannot process invoice  %d as not fully paid or no total amount.';


{ TInvoiceProcessor }

class procedure TInvoiceProcessor.Process(AInvoice: TInvoice; AObjectManager: TObjectManager);
var
  LTxCats : TDictionary<String, TTransaction>;
  LTx: TTransaction;
  LOutput: TBytesStream;
  LPrinter: TInvoicePrinter;

begin
  // only allow processing if all has been paid
  // -- otherwise it is tough to decide which items have been paid
  //    and which have not

  if not Assigned(AInvoice) then
  begin
    raise EArgumentNilException.Create('Invoice cannot be nil');
  end;

  if not AInvoice.CanBeProcessed then
  begin
    raise ECannotProcessInvoice.CreateFmt(SCannotProcessInvoice, [AInvoice.Number]);
  end;

  // get last payment for paid on date
  var LLastPayment := AInvoice.Payments.LastPaymentDate;

  if LLastPayment.IsNull then
  begin
    raise ECannotProcessInvoice.CreateFmt('No payments found. (%d)', [AInvoice.Number] );
  end;

  // process each category in invoice as one transaction
  // thus we create a transaction for each category and add total amounts

  LTxCats := TDictionary<String, TTransaction>.Create;
  try
    for var LItem in AInvoice.Items do
    begin
      var LCurrentCat := LItem.Category;
      if not LTxCats.ContainsKey(LCurrentCat) then
      begin
        LTx := TTransaction.Create(TTransactionKind.Income);
        LTx.Amount := 0;
        LTx.IsMonthly := False;
        LTx.Percentage := 1;
        LTxCats.Add( LCurrentCat, LTx );
      end
      else
      begin
        LTx := LTxCats[LCurrentCat];
      end;

      LTx.PaidOn := AInvoice.Payments.LastPaymentDate;
      LTx.Category := LItem.Category;
      LTx.Title := 'Invoice ' + AInvoice.Number.ToString;
      LTx.Amount := LTx.Amount + LItem.TotalValue;
    end;

    // add all transactions to invoice
    // this will lock it from any further processing
    for LTx in LTxCats.Values do
    begin
      AInvoice.Transactions.Add(LTx)
    end;

    // add copy of invoice
    LPrinter := nil;
    LOutput := TBytesStream.Create;
    try
      LPrinter := TInvoicePrinter.Create(AObjectManager);
      LPrinter.Print(AInvoice, LOutput);
      LOutput.Position := 0;
      AInvoice.ProcessedCopy.Clear;
      AInvoice.ProcessedCopy.LoadFromStream(LOutput);
    finally
      LOutput.Free;
      LPrinter.Free;
    end;

    AObjectManager.Flush;
  finally
    LTxCats.Free;
  end;
end;


end.
