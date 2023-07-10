unit UFrmMain;

interface

uses
      Aurelius.Dictionary.Generator
    , Aurelius.Engine.ObjectManager

    , System.Classes
    , System.SysUtils
    , System.UITypes
    , System.Variants

    , Vcl.Controls
    , Vcl.Dialogs
    , Vcl.Forms
    , Vcl.Graphics
    , Vcl.StdCtrls

    , Winapi.Messages
    , Winapi.Windows

    , UFrmBase
    ;


type
  TFrmMain = class(TFrmBase)
    btnExpenses: TButton;
    btnCreateDatabase: TButton;
    btnReportEndOfYear: TButton;
    btnCustomers: TButton;
    btnDictionary: TButton;
    btnInvoices: TButton;
    procedure btnCreateDatabaseClick(Sender: TObject);
    procedure btnCustomersClick(Sender: TObject);
    procedure btnDictionaryClick(Sender: TObject);
    procedure btnExpensesClick(Sender: TObject);
    procedure btnInvoicesClick(Sender: TObject);
  private

  public

  end;

var
  FrmMain: TFrmMain;

implementation

uses
    UReportManager
  , UFrmTransactions
  , UFrmCustomer
  , UFrmInvoices
  ;

resourcestring
  SDictionaryFile = 'C:\dev\FlixLLCPL\bpl\src\UDictionary.pas';

{$R *.dfm}

procedure TFrmMain.btnCreateDatabaseClick(Sender: TObject);
begin

  if MessageDlg('Recreate database?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    self.DataManager.CreateDatabase;
  end;

end;

procedure TFrmMain.btnCustomersClick(Sender: TObject);
begin
  var LFrm := TFrmCustomer.Create(nil);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.btnDictionaryClick(Sender: TObject);
begin
  {$IFDEF DEBUG}
  TDictionaryGenerator.GenerateFile(SDictionaryFile);
  {$ENDIF}
end;

procedure TFrmMain.btnExpensesClick(Sender: TObject);
begin
  var LFrm := TFrmTransactions.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.btnInvoicesClick(Sender: TObject);
begin
  var LFrm := TFrmInvoices.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

end.
