unit UAppGlobals;

interface

type
  TAppGlobals = class

  public
    class function AppTitle: String;
    class function AppVersion: String;
    class function AppFullName: String;
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

end.
