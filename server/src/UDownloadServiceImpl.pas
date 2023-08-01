unit UDownloadServiceImpl;

interface

uses
    System.Classes
  , XData.Server.Module
  , XData.Service.Common
  , XData.Sys.Exceptions

  , UDownloadService
  ;

type
  [ServiceImplementation]
  TDownloadService = class(TInterfacedObject, IDownloadService)
    function Download(AToken: String): TStream;
  end;

implementation

uses
  UDownloadManager
  ;

{ TDownloadService }

function TDownloadService.Download(AToken: String): TStream;
begin
  var LManager := TDownloadManager.Create;
  try
    Result := LManager.Download(AToken);
  finally
    LManager.Free;
  end;

  if Result = nil then
  begin
    raise EXDataHttpException.Create(404, 'Not found.');
  end;
end;

initialization
  RegisterServiceType(TDownloadService);

end.
