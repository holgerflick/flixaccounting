unit UFrmMain;

interface

uses
    Aurelius.Dictionary.Generator
  , Aurelius.Engine.ObjectManager
  , Aurelius.Mapping.Explorer

  , System.Actions
  , System.Classes
  , System.ImageList
  , System.SysUtils
  , System.UITypes
  , System.Variants

  , Vcl.ActnList
  , Vcl.BaseImageCollection
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.ImageCollection
  , Vcl.ImgList
  , Vcl.Menus
  , Vcl.StdCtrls
  , Vcl.VirtualImageList

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  ;

type
  TFrmMain = class(TFrmBase)
    btnTransactions: TButton;
    btnCreateDatabase: TButton;
    btnReports: TButton;
    btnCustomers: TButton;
    btnDictionary: TButton;
    btnInvoices: TButton;
    Collection: TImageCollection;
    Images: TVirtualImageList;
    Actions: TActionList;
    actTransactions: TAction;
    actCustomers: TAction;
    actReports: TAction;
    ImagesDisabled: TVirtualImageList;
    actInvoices: TAction;
    actExpandForm: TAction;
    procedure actCustomersExecute(Sender: TObject);
    procedure actExpandFormExecute(Sender: TObject);
    procedure actInvoicesExecute(Sender: TObject);
    procedure actReportsExecute(Sender: TObject);
    procedure actTransactionsExecute(Sender: TObject);
    procedure btnCreateDatabaseClick(Sender: TObject);
    procedure btnDictionaryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Invoices;
    procedure Customers;
    procedure Transactions;
    procedure CreateDictionary;
    procedure CreateDatabase;
    procedure Reports;

  public

  end;

var
  FrmMain: TFrmMain;

implementation

uses
    System.IOUtils

  , UFrmReportHost
  , UAppSettings
  , UFrmTransactions
  , UFrmCustomer
  , UFrmInvoices
  ;

resourcestring
//  SDictionaryFile = 'C:\dev\FlixLLCPL\bpl\src\UDictionary.pas';
  SDictionaryFile = 'D:\flixllcpl\bpl\src\UDictionary.pas';
  SDictionaryFileMemory  = 'D:\flixllcpl\bpl\src\UDictionaryTemporary.pas';

{$R *.dfm}

procedure TFrmMain.actCustomersExecute(Sender: TObject);
begin
  Customers;
end;

procedure TFrmMain.actExpandFormExecute(Sender: TObject);
begin
  if self.ClientHeight < btnDictionary.Top then
  begin
    self.ClientHeight := btnDictionary.Top + btnDictionary.Height + 10;
  end
  else
  begin
    self.ClientHeight := btnDictionary.Top - 7;
  end;
end;

procedure TFrmMain.actInvoicesExecute(Sender: TObject);
begin
  Invoices;
end;

procedure TFrmMain.actReportsExecute(Sender: TObject);
begin
  Reports;
end;

procedure TFrmMain.actTransactionsExecute(Sender: TObject);
begin
  Transactions;
end;

procedure TFrmMain.btnCreateDatabaseClick(Sender: TObject);
begin
  CreateDatabase;
end;

procedure TFrmMain.btnDictionaryClick(Sender: TObject);
begin
  CreateDictionary;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  self.ClientWidth := btnReports.Left + btnReports.Width + 10;
  self.ClientHeight := btnDictionary.Top - 7;
end;

procedure TFrmMain.Invoices;
begin
  var LFrm := TFrmInvoices.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.Reports;
begin
  var LReport := TFrmReportHost.Create(nil);
  try
    LReport.ShowModal;
  finally
    LReport.Free;
  end;
end;

procedure TFrmMain.Customers;
begin
  var LFrm := TFrmCustomer.Create(nil);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.Transactions;
begin
  var LFrm := TFrmTransactions.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.CreateDictionary;
var
  LGenerator: TDictionaryGenerator;

begin
  {$IFDEF DEBUG}
  TDictionaryGenerator.GenerateFile(SDictionaryFile);

  LGenerator := TDictionaryGenerator.Create( TMappingExplorer.Get('Temporary') );
  try
    LGenerator.GlobalVarName := 'DicTemp';
    var LSourceCode := LGenerator.GenerateSource;
    TFile.WriteAllText( SDictionaryFileMemory, LSourceCode );
  finally
    LGenerator.Free;
  end;
  {$ENDIF}
end;

procedure TFrmMain.CreateDatabase;
begin
  {$IFDEF DEBUG}
  if MessageDlg('Recreate database?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    self.DataManager.CreateDatabase;
  end;
  {$ENDIF}
end;

end.
