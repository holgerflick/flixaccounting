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
unit UReportServiceImpl;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , UServerTypes
  , UReportService
  ;

type
  [ServiceImplementation]
  TReportService = class(TInterfacedObject, IReportService)

  public
    function ProfitLoss(AToken: String): TProfitLossDTO;
  end;

implementation

uses
  UReportServiceManager
  ;

{ TReportService }

function TReportService.ProfitLoss(AToken: String): TProfitLossDTO;
var
  LManager: TReportServiceManager;

begin
  LManager := TReportServiceManager.Create;
  try
    Result := LManager.ProfitLoss(AToken);
  finally
    LManager.Free;
  end;
end;

initialization
  RegisterServiceType(TReportService);

end.
