unit UAppSettings;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Generics.Collections
  , System.IniFiles
  ;


type
  TAppSettings = class
  strict private
    class var FInstance: TAppSettings;

    FIniFile: TIniFile;


  public

    constructor Create;
    destructor Destroy; override;

    procedure GetDatabaseParams( AParams: TStrings );

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

end.
