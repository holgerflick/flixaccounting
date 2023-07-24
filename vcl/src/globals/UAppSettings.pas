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
  TControlList = TList<TWinControl>;

  TAppSettings = class
  strict private
    class var FInstance: TAppSettings;

    FIniFile: TIniFile;

  private
    procedure AddControlsToList(
      AControl: TWinControl;
      AList: TControlList );

  public

    constructor Create;
    destructor Destroy; override;

    procedure StoreControl(AControl: TControl);
    procedure RestoreControl(AControl: TControl);

    procedure StoreFileSaveDialog( ADialog: TFileSaveDialog );
    procedure RestoreFileSaveDialog( ADialog: TFileSaveDialog );

    procedure GetDatabaseParams( AParams: TStrings );

    class function Shared: TAppSettings;
    class destructor Destroy;

  end;

implementation

uses
    System.IOUtils
  ;

{ TAppSettings }

procedure TAppSettings.AddControlsToList(AControl: TWinControl;
  AList: TControlList);
begin
  if not Assigned( AControl ) then
  begin
    exit;
  end;

  AList.Add(AControl);

  if AControl.ControlCount > 0 then
  begin
    for var i := 0 to AControl.ControlCount -1 do
    begin
      var LControl := AControl.Controls[i];
      if LControl is TWinControl then
      begin
        AddControlsToList( AControl.Controls[i] as TWinControl, AList );
      end;
    end;
  end;
end;

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


procedure TAppSettings.GetDatabaseParams(AParams: TStrings);
var
  LParams: TStrings;

begin
  LParams := TStringlist.Create;
  try
    FIniFile.ReadSectionValues('Database', LParams);

    LParams.Text := LParams.Text.Replace('{APP}', TPath.GetLibraryPath );
    LParams.Text := LParams.Text.Replace('{HOME}', TPath.GetHomePath );
    LParams.Text := LParams.Text.Replace('{DOCUMENTS}', TPath.GetDocumentsPath );

    AParams.Text := LParams.Text;
  finally
    LParams.Free;
  end;
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
  FIniFile.WriteInteger( LSection, 'Height', AControl.Height );
end;

procedure TAppSettings.StoreFileSaveDialog(ADialog: TFileSaveDialog);
begin
  Assert(Assigned(ADialog));

  var LSection := ADialog.Name;

  FIniFile.WriteString(LSection, 'Filename', ADialog.FileName);
end;

end.
