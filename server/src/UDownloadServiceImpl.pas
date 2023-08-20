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
