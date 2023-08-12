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
unit UDownloadService;

interface

uses
  System.Classes
  , XData.Service.Common;

type
  [ServiceContract]
  [Route('')]
  IDownloadService = interface(IInvokable)
    ['{37D96ED4-06F3-4C1B-A471-5B510F65AB0F}']

    [HttpGet]
    [Route('download/{AToken}')]
    function Download(AToken: String): TStream;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IDownloadService));

end.
