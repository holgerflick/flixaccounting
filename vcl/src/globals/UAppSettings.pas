unit UAppSettings;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Generics.Collections
  , System.IniFiles
  , Vcl.Controls
  , Vcl.Dialogs
  ;


type
  TAppSettings = class
  strict private
    class var FInstance: TAppSettings;

    FIniFile: TIniFile;

  public

    constructor Create;
    destructor Destroy; override;

    procedure StoreControl(AControl: TControl);
    procedure RestoreControl(AControl: TControl);

    procedure StoreFileSaveDialog( ADialog: TFileSaveDialog );
    procedure RestoreFileSaveDialog( ADialog: TFileSaveDialog );

    procedure GetDatabaseParams( AParams: TStringlist );

    class function Shared: TAppSettings;
    class destructor Destroy;

  end;

implementation

uses
    System.IOUtils
  ;

{ TAppSettings }

constructor TAppSettings.Create;
begin
  inherited;

  var LFilename := TPath.Combine( TPath.GetLibraryPath, 'settings.ini' );

  FIniFile := TIniFile.Create(LFilename);
end;

class destructor TAppSettings.Destroy;
begin
  FInstance.Free;
end;


procedure TAppSettings.GetDatabaseParams(AParams: TStringlist);
begin
  FIniFile.ReadSectionValues('Database', AParams);
end;

procedure TAppSettings.RestoreControl(AControl: TControl);
begin
  Assert( Assigned(AControl) );

  var LSection := AControl.Name;

  AControl.Left := FIniFile.ReadInteger( LSection, 'Left', AControl.Left);
  AControl.Top := FIniFile.ReadInteger( LSection, 'Top', AControl.Top);
  AControl.Width := FIniFile.ReadInteger( LSection, 'Width', AControl.Width);
  AControl.Height := FIniFile.ReadInteger( LSection, 'Height', AControl.Height);
end;

procedure TAppSettings.RestoreFileSaveDialog(ADialog: TFileSaveDialog);
begin
  Assert(Assigned(ADialog));

  var LSection := ADialog.Name;

  ADialog.FileName := FIniFile.ReadString(LSection, 'Filename', ADialog.FileName);
end;

destructor TAppSettings.Destroy;
begin
  FIniFile.Free;

  inherited;
end;

class function TAppSettings.Shared: TAppSettings;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TAppSettings.Create;
  end;

  Result := FInstance;
end;

procedure TAppSettings.StoreControl(AControl: TControl);
begin
  Assert( Assigned(AControl) );

  var LSection := AControl.Name;

  FIniFile.WriteInteger( LSection, 'Left', AControl.Left );
  FIniFile.WriteInteger( LSection, 'Top', AControl.Top );
  FIniFile.WriteInteger( LSection, 'Width', AControl.Width );
  FIniFile.WriteInteger( LSection, 'Height', AControl.Width );
end;

procedure TAppSettings.StoreFileSaveDialog(ADialog: TFileSaveDialog);
begin
  Assert(Assigned(ADialog));

  var LSection := ADialog.Name;

  FIniFile.WriteString(LSection, 'Filename', ADialog.FileName);
end;

end.
