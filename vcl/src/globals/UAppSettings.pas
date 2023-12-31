﻿{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
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

    FIniFileName: String;
    FIniFile: TIniFile;


  public

    constructor Create;
    destructor Destroy; override;

    function IsLaunchPossible: Boolean;

    procedure GetDatabaseParams( AParams: TStrings );

    function WebserviceBaseUrl: String;

    class function Shared: TAppSettings;
    class destructor Destroy;

  end;

implementation

uses
    System.IOUtils
  ;


const
  SECTION_DATABASE = 'Database';

{ TAppSettings }

constructor TAppSettings.Create;
begin
  inherited;

  FIniFilename := TPath.Combine( TPath.GetLibraryPath, 'settings.ini' );

  FIniFile := TIniFile.Create(FIniFilename);
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
    FIniFile.ReadSectionValues(SECTION_DATABASE, LParams);

    LParams.Text := LParams.Text.Replace('{APP}', TPath.GetLibraryPath );
    LParams.Text := LParams.Text.Replace('{HOME}', TPath.GetHomePath );
    LParams.Text := LParams.Text.Replace('{DOCUMENTS}', TPath.GetDocumentsPath );

    AParams.Text := LParams.Text;
  finally
    LParams.Free;
  end;
end;

function TAppSettings.IsLaunchPossible: Boolean;
var
  LParams: TStringlist;

begin
  Result := False;

  // quick sanity test that database configuration exists
  LParams := TStringList.Create;
  try
    FIniFile.ReadSectionValues(SECTION_DATABASE, LParams);
    Result := LParams.Count > 0;
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

function TAppSettings.WebserviceBaseUrl: String;
begin
  Result := FIniFile.ReadString('API', 'BaseURL', '' );
end;

end.

