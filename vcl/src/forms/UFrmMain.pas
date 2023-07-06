unit UFrmMain;

interface

uses
    Winapi.Windows
  , Winapi.Messages

  , System.SysUtils
  , System.Variants
  , System.Classes

  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.StdCtrls

  , Aurelius.Engine.ObjectManager
  , UFrmBase
  ;

type
  TFrmMain = class(TFrmBase)
    btnExpenses: TButton;
    btnCreateDatabase: TButton;
    btnReportEndOfYear: TButton;
    procedure btnCreateDatabaseClick(Sender: TObject);
    procedure btnExpensesClick(Sender: TObject);
    procedure btnReportEndOfYearClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
    UReportManager
  , UFrmTransactions
  ;



{$R *.dfm}

procedure TFrmMain.btnCreateDatabaseClick(Sender: TObject);
begin

  if MessageDlg('Recreate database?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    self.DataManager.CreateDatabase;
  end;
end;

procedure TFrmMain.btnExpensesClick(Sender: TObject);
var
  LFrm: TFrmTransactions;

begin
  LFrm := TFrmTransactions.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmMain.btnReportEndOfYearClick(Sender: TObject);
begin
  var LReport := TReportManager.Create(self.ObjectManager);
  try

  finally
    LReport.Free;
  end;
end;

end.
