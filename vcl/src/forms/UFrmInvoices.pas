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

  , System.Actions
  , System.Classes
  , System.ImageList
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.BaseImageCollection
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.ImageCollection
  , Vcl.ImgList
  , Vcl.StdCtrls
  , Vcl.VirtualImageList

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
    Actions: TActionList;
    actInvoiceNew: TAction;
    actInvoiceModify: TAction;
    actInvoiceDelete: TAction;
    actInvoicePrint: TAction;
    actInvoicePayments: TAction;
    actInvoiceProcess: TAction;
    ImgCollection: TImageCollection;
    Images: TVirtualImageList;
    procedure actInvoiceDeleteExecute(Sender: TObject);
    procedure actInvoiceDeleteUpdate(Sender: TObject);
    procedure actInvoiceModifyExecute(Sender: TObject);
    procedure actInvoiceModifyUpdate(Sender: TObject);
    procedure actInvoiceNewExecute(Sender: TObject);
    procedure actInvoiceNewUpdate(Sender: TObject);
    procedure actInvoicePaymentsExecute(Sender: TObject);
    procedure actInvoicePaymentsUpdate(Sender: TObject);
    procedure actInvoicePrintExecute(Sender: TObject);
    procedure actInvoicePrintUpdate(Sender: TObject);
    procedure actInvoiceProcessExecute(Sender: TObject);
    procedure actInvoiceProcessUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure OpenDataset;

    function GetNextNumber: Integer;

    procedure New;
    procedure PrintCurrent;
    procedure OpenPayments;
    procedure Delete;
    procedure Process;
    procedure Modify;
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

procedure TFrmInvoices.actInvoiceDeleteExecute(Sender: TObject);
begin
  Delete;
end;

procedure TFrmInvoices.actInvoiceDeleteUpdate(Sender: TObject);
var
  LResult: Boolean;
  LCurrent: TInvoice;

begin
  LCurrent := Invoices.Current<TInvoice>;
  LResult := LCurrent <> nil;

  if LResult then
  begin
    LResult := LCurrent.Status <> TInvoiceStatus.Processed;
  end;

  actInvoiceDelete.Enabled := LResult;
end;

procedure TFrmInvoices.actInvoiceModifyExecute(Sender: TObject);
begin
  Modify;
end;

procedure TFrmInvoices.actInvoiceModifyUpdate(Sender: TObject);
var
  LResult: Boolean;
  LCurrent: TInvoice;
begin
  LCurrent := Invoices.Current<TInvoice>;
  LResult := LCurrent <> nil;

  if LResult then
  begin
    LResult := LCurrent.CanModify;
  end;

  actInvoiceModify.Enabled := LResult;
end;

procedure TFrmInvoices.actInvoiceNewExecute(Sender: TObject);
begin
  New;
end;

procedure TFrmInvoices.actInvoiceNewUpdate(Sender: TObject);
begin
  actInvoiceNew.Enabled := Invoices.Active;
end;

procedure TFrmInvoices.actInvoicePaymentsExecute(Sender: TObject);
begin
  OpenPayments;
end;

procedure TFrmInvoices.actInvoicePaymentsUpdate(Sender: TObject);
begin
  var LCurrent := Invoices.Current<TInvoice>;
  var LResult := LCurrent <> nil;

  if LResult then
  begin
    LResult := LCurrent.Status in
      [ TInvoiceStatus.ReadyPayments, TInvoiceStatus.ReadyProcess,
        TInvoiceStatus.Overpaid ];
  end;

  actInvoicePayments.Enabled := LResult;
end;

procedure TFrmInvoices.actInvoicePrintExecute(Sender: TObject);
begin
  PrintCurrent;
end;

procedure TFrmInvoices.actInvoicePrintUpdate(Sender: TObject);
begin
  var LCurrent := Invoices.Current<TInvoice>;
  var LResult := LCurrent <> nil;

  if LResult then
  begin
    LResult := LCurrent.Status in
     [ TInvoiceStatus.ReadyPayments, TInvoiceStatus.Processed ];
  end;

  actInvoicePrint.Enabled := LResult;
end;

procedure TFrmInvoices.actInvoiceProcessExecute(Sender: TObject);
begin
  Process;
end;

procedure TFrmInvoices.actInvoiceProcessUpdate(Sender: TObject);
begin
  var LCurrent := Invoices.Current<TInvoice>;
  var LResult := LCurrent <> nil;

  if LResult then
  begin
    LResult := LCurrent.Status = TInvoiceStatus.ReadyProcess;
  end;

  actInvoiceProcess.Enabled := LResult;
end;

procedure TFrmInvoices.Delete;
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
    if Invoices.State in dsEditModes then
    begin
      Invoices.Post;
    end;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmInvoices.PrintCurrent;
var
  LPrinter: TInvoicePrinter;
  LReport: TMemoryStream;

begin
  var LCurrent := Invoices.Current<TInvoice>;

  LReport := TMemoryStream.Create;
  try
    // if invoice has been processed, we have a copy
    // copy will be loaded from database
    if LCurrent.Status <> TInvoiceStatus.Processed then
    begin
      LPrinter := TInvoicePrinter.Create(ObjectManager);
      try
        LPrinter.Print(LCurrent, LReport);
      finally
        LPrinter.Free;
      end;
    end
    else
    begin
      LCurrent.ProcessedCopy.SaveToStream(LReport);
    end;

    // show preview
    LReport.Position := 0;
    TFrmReportPreview.Execute(LReport);
  finally
    LReport.Free;
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

procedure TFrmInvoices.Modify;
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

end.
