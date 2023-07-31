unit UReportManager;

interface

uses
    Aurelius.Criteria.Expression
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Projections
  , Aurelius.Engine.ObjectManager
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Explorer
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob

  , Bcl.Types.Nullable

  , Data.DB

  , FireDAC.Comp.Client
  , FireDAC.Comp.DataSet
  , FireDAC.DApt.Intf
  , FireDAC.DatS
  , FireDAC.Phys.Intf
  , FireDAC.Stan.Error
  , FireDAC.Stan.Intf
  , FireDAC.Stan.Option
  , FireDAC.Stan.Param
  , FireDAC.Stan.StorageJSON
  , FireDAC.Stan.StorageBin

  , System.Classes
  , System.Generics.Collections
  , System.SysUtils

  , UCustomer
  , UInvoice
  , UTransaction
  , UDictionary
  , UDictionaryTemporary
  , UProfitLoss
  ;

type
  TReportManager = class(TDataModule)
    CustomerReport: TFDMemTable;
    CustomerReportCustomerId: TIntegerField;
    CustomerReportTotal: TFloatField;
    CustomerReportName: TStringField;
    CustomerReportInvoices: TDataSetField;
    CRInvoiceTotals: TFDMemTable;
    CRInvoiceTotalsInvoiceId: TIntegerField;
    CRInvoiceTotalsNumber: TIntegerField;
    CRInvoiceTotalsIssued: TDateField;
    CRInvoiceTotalsPaid: TDateField;
    CRInvoiceTotalsTotal: TFloatField;
    CRInvoiceTotalsCategories: TDataSetField;
    CRCategoryTotals: TFDMemTable;
    CRCategoryTotalsCategory: TStringField;
    CRCategoryTotalsTotal: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
  strict private
    FObjManager: TObjectManager;

    FRangeStart: TDate;
    FRangeEnd: TDate;
    FObjectManager: TObjectManager;


  public
    { Public declarations }

    constructor Create( AObjManager: TObjectManager ); reintroduce;

    procedure GetCategories(ACategories: TStrings);

    property ObjectManager: TObjectManager read FObjectManager write FObjectManager;
    property RangeStart: TDate read FRangeStart write FRangeStart;
    property RangeEnd: TDate read FRangeEnd write FRangeEnd;

    procedure BuildProfitsCustomer;
    function GetProfitLoss( AObjManager: TObjectManager ): TProfitLoss;

  end;

var
  ReportManager: TReportManager;

implementation

uses
    System.DateUtils
  , System.Variants
  ;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TReportManager.Create(AObjManager: TObjectManager);
begin
  inherited Create(nil);

  FObjectManager := AObjManager;
end;

function TReportManager.GetProfitLoss( AObjManager: TObjectManager ) : TProfitLoss;
  function TransactionKindToPLSection( ATxKind: TTransactionKind ): TPLSection;
  begin
    Result := TPLSection.Income;
    if ATxKind = TTransactionKind.Expense then
    begin
      Result := TPLSection.Expense;
    end;
  end;

begin
  Result := TProfitLoss.Create;
  AObjManager.Save(Result);

  // get all transactions that need to be considered
  // -- don't care if it is income or expense
  // -- also look this up in the persistent object manager
  var LTransactions := ObjectManager.Find<TTransaction>
    .Where(
      (Dic.Transaction.PaidOn >= self.RangeStart) AND
      (Dic.Transaction.PaidOn <= self.RangeEnd)
    )
    .OrderBy(Dic.Transaction.PaidOn)
    .List;

  try
    // iterate all transactions
    for var LTx in LTransactions do
    begin
      var LCategory := LTx.Category;
      var LSection := TransactionKindToPLSection( LTx.Kind );

      // look up and create if does not exist
      var LPLCategory := AObjManager.Find<TPLCategory>
        .Where(
          (DicTemp.PLCategory.Category = LCategory) AND
          (DicTemp.PLCategory.Section = LSection ) AND
          (DicTemp.PLCategory.ProfitLoss.Id = Result.Id)
          )
        .UniqueResult
        ;

      // if does not exist, create
      if not Assigned( LPLCategory ) then
      begin
        LPLCategory := TPLCategory.Create;
        LPLCategory.Category := LCategory;
        LPLCategory.Section := LSection;
        Result.Categories.Add( LPLCategory );
      end;

      // create transaction in profit loss
      var LPLTransaction := TPLTransaction.Create;
      LPLTransaction.PaidOn := LTx.PaidOn;
      LPLTransaction.Title := LTx.Title;
      LPLTransaction.Amount := LTx.AmountTotal;
      LPLCategory.Transactions.Add( LPLTransaction );

      AObjManager.Flush;
    end;
  finally
    LTransactions.Free;
  end;
end;

procedure TReportManager.BuildProfitsCustomer;
var
  LCustomers: TObjectList<TCriteriaResult>;
begin
  CustomerReport.DisableControls;
  CustomerReport.Close;
  CustomerReport.Open;

  // sum up total of all invoices for all customers in range
  LCustomers := ObjectManager.Find<TInvoice>
    .Select(TProjections.ProjectionList
      .Add(Dic.Invoice.Transactions.Amount.Sum.As_('Total'))
      .Add(Dic.Invoice.Customer.Id.Group.As_('CustomerId'))
      .Add(Dic.Invoice.Customer.Name.As_('Name'))
    )
    .Where( (Dic.Invoice.IssuedOn >= self.RangeStart) AND
      ( Dic.Invoice.IssuedOn <= self.RangeEnd ) AND
      ( Dic.Invoice.Transactions.Id>0 )
    )
    .OrderBy(Dic.Invoice.Customer.Name)
    .ListValues;

  try
    for var LCustomer in LCustomers do
    begin
      CustomerReport.Append;
      CustomerReportCustomerId.AsInteger := LCustomer['CustomerId'];
      CustomerReportTotal.AsFloat := LCustomer['Total'];
      CustomerReportName.AsString := LCustomer['Name'];

      // determine list of invoices for that customer
      var LInvoices := ObjectManager.Find<TInvoice>
        .Where(
          (Dic.Invoice.Transactions.Id>0) AND
          (Dic.Invoice.Customer.Id = LCustomer.Values['CustomerId'] ) AND
          (Dic.Invoice.IssuedOn >= self.RangeStart) AND
          (Dic.Invoice.IssuedOn <= self.RangeEnd )
          )
        .List
        ;
      try
        for var LInvoice in LInvoices do
        begin
          CRInvoiceTotals.Append;

          // drill down into categories for that invoice
          var LCategories := ObjectManager.Find<TInvoice>
            .Select(TProjections.ProjectionList
              .Add(Dic.Invoice.Transactions.Amount.Sum.As_('Total'))
              .Add(Dic.Invoice.Transactions.Category.Group.As_('Category'))
            )
            .Where(
              (Dic.Invoice.IssuedOn >= self.RangeStart) AND
              (Dic.Invoice.IssuedOn <= self.RangeEnd ) AND
              (Dic.Invoice.Id = LInvoice.Id)
            )
            .ListValues
            ;
          try
            for var LCategory in LCategories do
            begin
              CRCategoryTotals.Append;
              CRCategoryTotalsCategory.AsString := LCategory.Values['Category'];
              CRCategoryTotalsTotal.AsFloat := LCategory.Values['Total'];
              CRCategoryTotals.Post;
            end;
          finally
            LCategories.Free;
          end;

          CRInvoiceTotalsInvoiceId.AsInteger := LInvoice.Id;
          CRInvoiceTotalsNumber.AsInteger := LInvoice.Number;
          CRInvoiceTotalsIssued.AsDateTime := LInvoice.IssuedOn;
          CRInvoiceTotalsPaid.AsDateTime := LInvoice.Payments.LastPaymentDate;
          CRInvoiceTotalsTotal.AsFloat := LInvoice.TotalAmount;
          CRInvoiceTotals.Post;
        end;
      finally
        LInvoices.Free;
      end;

      CustomerReport.Post;
    end;
  finally
    LCustomers.Free;

    CustomerReport.First;
    CustomerReport.EnableControls;
  end;
end;

procedure TReportManager.DataModuleCreate(Sender: TObject);
begin
  // default current year
  RangeStart := TDateTime.Now.StartOfTheYear;
  RangeEnd   := TDateTime.Now.EndOfTheYear;
end;

procedure TReportManager.GetCategories(ACategories: TStrings);
begin
  if not Assigned(ACategories) then
  begin
    raise EArgumentNilException.Create('List of categories cannot be nil.');
  end;

  ACategories.Clear;

  // retrieve all categories in defined range
  var LCategories := ObjectManager.Find<TTransaction>
    .Select(TProjections.Group('Category'))
    .Where(
       (Linq['PaidOn'] > self.RangeStart) AND (Linq['PaidOn'] < self.RangeEnd)
    )
    .ListValues
    ;
  try
    // assign category names to list of strings
    for var i := 0 to LCategories.Count -1 do
    begin
      ACategories.Add( LCategories[i].Values[0] );
    end;
  finally
    LCategories.Free;  // list needs to be freed
  end;
end;

end.
