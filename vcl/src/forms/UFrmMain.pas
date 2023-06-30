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

  , UDataManager
  ;

type
  TFrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDataManager: TDataManager;

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  UAppGlobals
  ;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
   Caption := TAppGlobals.AppFullName;

   FDataManager := TDataManager.Shared;
end;

end.
