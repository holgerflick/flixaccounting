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

  , UDataManager

  , Aurelius.Engine.ObjectManager
  ;

type
  TFrmMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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
  , UDataImportManager
  ;

{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
var
  LObjManager : TObjectManager;

begin
  LObjManager := FDataManager.ObjectManager;
  var LManager := TDataImportManager.Create(LObjManager);
  LManager.ImportExpensesFromFolder('\\192.168.0.50\fe\accounting\expenses\2023');
  ShowMessage( LManager.Duplicates.CommaText );
  ShowMessage( LManager.ImportErrors.Count.ToString );
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
   Caption := TAppGlobals.AppFullName;

   FDataManager := TDataManager.Shared;
end;

end.
