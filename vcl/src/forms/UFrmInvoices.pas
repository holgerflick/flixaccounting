{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
unit UFrmInvoices;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset

  , Data.DB

  , System.Actions
  , System.Classes
  , System.ImageList
  , System.SysUtils
  , System.Variants
  , System.UITypes

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
  , Vcl.DBGrids

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  ;

type
  TFrmInvoices = class(TFrmBase)
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
    btnPreview: TButton;
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
    btnLink: TButton;
    actInvoiceApiToken: TAction;
    GridInvoices: TDBGrid;
    btnCompany: TAction;
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure actInvoiceApiTokenExecute(Sender: TObject);
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
    procedure btnCompanyExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure OpenDataset;
    procedure InitGrids;

    function GetNextNumber: Integer;

    procedure New;
    procedure PrintCurrent;
    procedure OpenPayments;
    procedure Delete;
    procedure Process;
    procedure Modify;
    procedure ShowApiToken;
    procedure EditCompanyInfo;
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
  , UApi
  , UInvoicePrinter
  , UFrmPayments
  , UFrmReportPreview
  , UInvoiceProcessor
  , UGridUtils
  , UFrmApiToken
  , UFrmCompany
  ;

{$R *.dfm}

procedure TFrmInvoices.FormDestroy(Sender: TObject);
begin
  Invoices.Close;

  inherited;
end;

procedure TFrmInvoices.actInvoiceApiTokenExecute(Sender: TObject);
begin
  ShowApiToken;
end;

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

procedure TFrmInvoices.btnCompanyExecute(Sender: TObject);
begin
  EditCompanyInfo;
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

procedure TFrmInvoices.EditCompanyInfo;
begin
  var LFrm := TFrmCompany.Create(nil);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmInvoices.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Invoices';

  InitGrids;
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

procedure TFrmInvoices.InitGrids;
begin
  TGridUtils.UseMonospaceFont(GridInvoices.Columns);
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
    .Open;

  Invoices.Close;
  Invoices.DefaultsFromObject := True;
  Invoices.Manager := ObjectManager;
  Invoices.SetSourceCursor(LInvoices);
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

procedure TFrmInvoices.ShowApiToken;
var
  LFrm: TFrmApiToken;
  LCurrent: TInvoice;
  LToken: TApiToken;

begin
  LCurrent := Invoices.Current<TInvoice>;
  if Assigned( LCurrent ) then
  begin
    LToken := LCurrent.ApiToken;

    if not Assigned(LToken) then
    begin
      LToken := TApiToken.Create;
      LToken.Kind := TApiTokenKind.Invoice;
      ObjectManager.Save(LToken);
      LCurrent.ApiToken := LToken;
    end;

    LFrm := TFrmApiToken.Create(nil);
    try
      LFrm.EditToken('Download link for invoice',
        LToken );
      ObjectManager.Flush(LCurrent);
    finally
      LFrm.Free;
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
