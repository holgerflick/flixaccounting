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
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  UFrmExpenses
  ;



{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
var
  LFrm: TFrmExpenses;

begin
  LFrm := TFrmExpenses.Create(self);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

end.
