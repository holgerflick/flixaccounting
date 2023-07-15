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

  , System.Classes
  , System.Generics.Collections
  , System.SysUtils

  , UCustomer
  , UInvoice
  , UTransaction
  , UDictionary, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin
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
    PLTransactions: TFDMemTable;
    PLTransactionsPaidOn: TDateField;
    PLTransactionsTitle: TStringField;
    PLTransactionsAmount: TFloatField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    PLTransactionsTxId: TIntegerField;
    ProfitLoss: TFDMemTable;
    ProfitLossCategory: TStringField;
    ProfitLossTotal: TFloatField;
    ProfitLossTransactions: TDataSetField;
    ProfitLossTxCount: TIntegerField;
    ProfitLossIsLoss: TBooleanField;
    ProfitLossSumTotal: TAggregateField;
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
    procedure BuildProfitLoss(ATblIncome, ATblExpense: TFDMemTable);

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

procedure TReportManager.BuildProfitLoss( ATblIncome, ATblExpense: TFDMemTable );
begin

  ProfitLoss.Close;

  ProfitLoss.Filtered := False;
  ProfitLoss.Open;

  var LTransactions := ObjectManager.Find<TTransaction>
    .Where(
      (Dic.Transaction.PaidOn >= self.RangeStart) AND
      (Dic.Transaction.PaidOn <= self.RangeEnd)
    )
    .OrderBy(Dic.Transaction.PaidOn)
    .List;

  try
    for var LTx in LTransactions do
    begin
      var LCategory := LTx.Category;
      var LIsLoss := LTx.Kind = TTransactionKind.Expense;

      // look up and create if does not exist
      if not ProfitLoss.Locate('Category;IsLoss', VarArrayOf( [LCategory, LIsLoss] ), [] ) then
      begin
        ProfitLoss.Append;
        ProfitLossCategory.AsString := LCategory;
        ProfitLossIsLoss.AsBoolean := LIsLoss;
        ProfitLossTotal.AsFloat := 0;
        ProfitLossTxCount.AsInteger := 0;
      end
      else
      begin
        ProfitLoss.Edit;
      end;

      PLTransactions.Append;

      ProfitLossTotal.AsFloat := ProfitLossTotal.AsFloat + LTx.AmountTotal;

      PLTransactionsPaidOn.AsDateTime := LTx.PaidOn;
      PLTransactionsTitle.AsString := LTx.Title;
      PLTransactionsAmount.AsFloat := LTx.AmountTotal;
      PLTransactionsTxId.AsInteger := LTx.Id;
      PLTransactions.Post;
    end;
  finally
    LTransactions.Free;
  end;


  // copy into actual datasets
  ProfitLoss.Filter := 'IsLoss=False';
  ProfitLoss.Filtered := True;
  ATblIncome.Close;
//  ATblIncome.CopyDataSet(ProfitLoss, [coStructure, coRestart, coAppend]);
  ATblIncome.Data := ProfitLoss.FilteredData;

  ProfitLoss.Filtered := False;
  ProfitLoss.Filter := 'IsLoss=True';
  ProfitLoss.Filtered := True;

  ATblExpense.Close;
//  ATblExpense.CopyDataSet(ProfitLoss, [coStructure, coRestart, coAppend]);
  ATblExpense.Data := ProfitLoss.FilteredData;
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
