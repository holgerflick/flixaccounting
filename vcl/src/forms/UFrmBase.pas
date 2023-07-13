unit UFrmBase;

interface

uses
    Aurelius.Engine.ObjectManager

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ComCtrls
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UDataManager
  ;


type
  TFrmBase = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FOwnsObjectManager: Boolean;

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

    property OwnsObjectManager: Boolean read FOwnsObjectManager;
  end;

var
  FrmBase: TFrmBase;

implementation

uses
    UAppGlobals
  , UAppSettings
  ;

{$R *.dfm}



procedure TFrmBase.FormCreate(Sender: TObject);
begin
  inherited;

  TAppSettings.Shared.RestoreControl(self);

  if self.Caption = '' then
  begin
    Caption := TAppGlobals.AppFullName;
  end;

  FDataManager := TDataManager.Shared;
  FObjectManager := nil;

  FOwnsObjectManager := False;
end;

procedure TFrmBase.FormDestroy(Sender: TObject);
begin
 if FOwnsObjectManager then
  begin
    FObjectManager.Free;
  end;

  TAppSettings.Shared.StoreControl(self);

  inherited;
end;



function TFrmBase.GetObjectManager: TObjectManager;
begin
  if not Assigned( FObjectManager ) then
  begin
    FObjectManager := DataManager.ObjectManager;
    FOwnsObjectManager := True;
  end;

  Result := FObjectManager;
end;

procedure TFrmBase.SetObjectManager(const Value: TObjectManager);
begin
  if Assigned(Value) then
  begin
    FObjectManager.Free;
    FObjectManager := Value;
    FOwnsObjectManager := False;
  end;
end;

end.
