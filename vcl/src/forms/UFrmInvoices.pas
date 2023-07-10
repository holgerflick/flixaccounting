unit UFrmInvoices;

interface

uses
    AdvGrid
  , AdvObj
  , AdvUtil

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset

  , BaseGrid

  , Data.DB

  , DBAdvGrid

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  ;



type
  TFrmInvoices = class(TFrmBase)
    GridInvoices: TDBAdvGrid;
    Invoices: TAureliusDataset;
    sourceInvoices: TDataSource;
    InvoicesSelf: TAureliusEntityField;
    InvoicesId: TIntegerField;
    InvoicesNumber: TIntegerField;
    InvoicesIssuedOn: TDateField;
    InvoicesDueOn: TDateField;
    InvoicesCustomer: TAureliusEntityField;
    InvoicesItems: TDataSetField;
    InvoicesPayments: TDataSetField;
    InvoicesTransactions: TDataSetField;
    InvoicesTotalAmount: TFloatField;
    InvoicesAmountDue: TFloatField;
    InvoicesAmountPaid: TFloatField;
    InvoicesCanBeProcessed: TBooleanField;
    InvoicesCanModify: TBooleanField;
    InvoicesCustomerName: TStringField;
    btnNew: TButton;
    btnModify: TButton;
    btnDelete: TButton;
    Print: TButton;
    btnPayment: TButton;
    procedure btnModifyClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnPaymentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintClick(Sender: TObject);
  private
    procedure OpenDataset;

    function GetNextNumber: Integer;

    procedure New;
    procedure PrintCurrent;
    procedure OpenPayments;
  public

  end;

var
  FrmInvoices: TFrmInvoices;

implementation

uses
    System.DateUtils
  , UFrmInvoice
  , UDictionary
  , UInvoice
  , UInvoicePrinter
  , UFrmPayments
  ;

{$R *.dfm}

procedure TFrmInvoices.btnModifyClick(Sender: TObject);
begin
  var LFrm := TFrmInvoice.Create( self, ObjectManager, sourceInvoices );
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmInvoices.btnNewClick(Sender: TObject);
begin
  New;
end;

procedure TFrmInvoices.btnPaymentClick(Sender: TObject);
begin
  OpenPayments;
end;

procedure TFrmInvoices.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Invoices';

  OpenDataset;
end;

function TFrmInvoices.GetNextNumber: Integer;
begin
  var LNumber := ObjectManager.Find<TInvoice>
    .Select(Dic.Invoice.Number.Max.As_('MaxNo'))
    .UniqueValue;

  try
    var LRes := LNumber.Values[0];
    if VarIsNumeric(LRes) then
    begin
      Result := LRes + 1;
    end
    else
    begin
      Result := 1;
    end;

  finally
    LNumber.Free;
  end;
end;

procedure TFrmInvoices.New;
begin
  Invoices.Append;
  InvoicesNumber.AsInteger := GetNextNumber;

  var LFrm := TFrmInvoice.Create(
    self, ObjectManager, sourceInvoices );
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmInvoices.OpenDataset;
begin
  var LInvoices := ObjectManager.Find<TInvoice>
    .OrderBy(Dic.Invoice.Number, False )
    .List;

  Invoices.Close;
  Invoices.DefaultsFromObject := True;
  Invoices.Manager := ObjectManager;
  Invoices.SetSourceList( LInvoices, True );
  Invoices.Open;
end;

procedure TFrmInvoices.OpenPayments;
begin
  var LFrm := TFrmPayments.Create(
    ObjectManager,
    sourceInvoices );
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmInvoices.PrintClick(Sender: TObject);
begin
  PrintCurrent;
end;

procedure TFrmInvoices.PrintCurrent;
var
  LPrinter: TInvoicePrinter;
begin
  var LCurrent := Invoices.Current<TInvoice>;
  LPrinter := TInvoicePrinter.Create(ObjectManager);
  try
    LPrinter.Print(LCurrent);
  finally
    LPrinter.Free;
  end;
end;

end.
