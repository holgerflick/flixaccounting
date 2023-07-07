unit UFrmBase;

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
  , Vcl.ComCtrls
  , UDataManager

  , Aurelius.Engine.ObjectManager

  ;

type
  TFrmBase = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  protected
    FObjectManager: TObjectManager;
    FDataManager: TDataManager;

    function GetObjectManager: TObjectManager;
    procedure SetObjectManager(const Value: TObjectManager);

  public

    property ObjectManager: TObjectManager
      read GetObjectManager write SetObjectManager;

    property DataManager: TDataManager
      read FDataManager write FDataManager;
  end;

var
  FrmBase: TFrmBase;

implementation

uses
  UAppGlobals
  ;

{$R *.dfm}

procedure TFrmBase.FormDestroy(Sender: TObject);
begin
  FObjectManager.Free;
end;

procedure TFrmBase.FormCreate(Sender: TObject);
begin
  if self.Caption = '' then
  begin
    Caption := TAppGlobals.AppFullName;
  end;

  FDataManager := TDataManager.Shared;
  FObjectManager := nil;
end;

function TFrmBase.GetObjectManager: TObjectManager;
begin
  if not Assigned( FObjectManager ) then
  begin
    FObjectManager := DataManager.ObjectManager;
  end;

  Result := FObjectManager;
end;

procedure TFrmBase.SetObjectManager(const Value: TObjectManager);
begin
  if Assigned(Value) then
  begin
    FObjectManager.Free;
    FObjectManager := Value;
  end;
end;

end.
