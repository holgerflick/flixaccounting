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
    InvoicesBillTo: TStringField;
    InvoicesStatus: TIntegerField;
    InvoicesStatusText: TStringField;
    btnProcess: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnPaymentClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintClick(Sender: TObject);
  private
    procedure OpenDataset;

    function GetNextNumber: Integer;

    procedure New;
    procedure PrintCurrent;
    procedure OpenPayments;
    procedure Delete;
    procedure Process;
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
  , UFrmReportPreview
  , UInvoiceProcessor
  ;

{$R *.dfm}

procedure TFrmInvoices.btnDeleteClick(Sender: TObject);
begin
  Delete;
end;

procedure TFrmInvoices.btnModifyClick(Sender: TObject);
begin
  if InvoicesCanModify.AsBoolean then
  begin
    var LFrm := TFrmInvoice.Create( self, ObjectManager, sourceInvoices );
    try
      LFrm.ShowModal;
    finally
      LFrm.Free;
    end;
  end
  else
  begin
    MessageDlg(
      'Invoice cannot be modified. Payments or transactions already exist.',
      mtError,
      [mbOK], 0 );

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

procedure TFrmInvoices.btnProcessClick(Sender: TObject);
begin
  Process;
end;

procedure TFrmInvoices.Delete;
begin
  if InvoicesCanModify.AsBoolean then
  begin
    if MessageDlg('Do you really want to delete this invoice?',
      mtInformation, [mbYes, mbNo], 0 ) = mrYes then
    begin
      if Invoices.State in dsEditModes then
      begin
        Invoices.Cancel;
      end;

      Invoices.Delete;
    end;
  end
  else
  begin
    MessageDlg('Invoice cannot be deleted from system. Transactions or payments have already been processed.',
      mtError, [mbOK], 0 );
  end;
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
    .OrderBy(Dic.Invoice.Number, True )
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
  LReport: TMemoryStream;

begin
  LReport := nil;

  var LCurrent := Invoices.Current<TInvoice>;
  LPrinter := TInvoicePrinter.Create(ObjectManager);
  try
    LReport := TMemoryStream.Create;
    LPrinter.Print(LCurrent, LReport);
    TFrmReportPreview.Execute(LReport);
  finally
    LReport.Free;
    LPrinter.Free;
  end;
end;

procedure TFrmInvoices.Process;
var
  LCurrent: TInvoice;

begin
  LCurrent := Invoices.Current<TInvoice>;

  if Assigned( LCurrent ) then
  begin
    if LCurrent.CanBeProcessed then
    begin
      TInvoiceProcessor.Process(LCurrent, ObjectManager);
      Invoices.RefreshRecord;
    end;
  end;
end;

end.
