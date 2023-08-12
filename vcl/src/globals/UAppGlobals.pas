{*******************************************************************************}
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
unit UAppGlobals;

interface

type
  TAppGlobals = class
  public
    class function AppTitle: String;
    class function AppVersion: String;
    class function AppFullName: String;

    class function DefaultGridHeaderFontSize: Integer;
    class function DefaultGridFontSize: Integer;

    class function DefaultGridHeaderFontName: String;
    class function DefaultGridMonospaceFontName: String;
    class function DefaultGridFontName: String;
  end;

implementation

uses
   ExeInfo
   ;

{ TAppGlobals }

class function TAppGlobals.AppFullName: String;
begin
  Result := AppTitle + ' (' + AppVersion + ')';
end;

class function TAppGlobals.AppTitle: String;
var
  LExeInfo: TExeInfo;

begin
  Result := '';

  LExeInfo := TExeInfo.Create(nil);
  try
    Result := LExeInfo.ProductName;
  finally
    LExeInfo.Free;
  end;
end;

class function TAppGlobals.AppVersion: String;
var
  LExeInfo: TExeInfo;

begin
  Result := '';

  LExeInfo := TExeInfo.Create(nil);
  try
    Result := LExeInfo.FileVersion;
  finally
    LExeInfo.Free;
  end;
end;

class function TAppGlobals.DefaultGridFontName: String;
begin
  Result := 'Noto Sans'
end;

class function TAppGlobals.DefaultGridFontSize: Integer;
begin
  Result := 11;
end;

class function TAppGlobals.DefaultGridHeaderFontName: String;
begin
  Result := 'Arial';
end;

class function TAppGlobals.DefaultGridHeaderFontSize: Integer;
begin
  Result := 12;
end;

class function TAppGlobals.DefaultGridMonospaceFontName: String;
begin
 Result := 'Cascadia Code';
end;

end.
