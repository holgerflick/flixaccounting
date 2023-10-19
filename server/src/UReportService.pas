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
unit UReportService;

interface

uses
    UServerTypes
  , XData.Service.Common
  ;

type
  [ServiceContract]
  [Route('v1/reports')]
  IReportService = interface(IInvokable)
    ['{170D2E6C-D884-4D79-8D72-1539DE0852DF}']

    [HttpGet]
    [Route('pl/{AToken}')]
    function ProfitLossCurrentYear(AToken: String): TProfitLossDTO;

    [HttpGet]
    [Route('pl/{AToken}/{ARangeStart}/{ARangeEnd}')]
    function ProfitLoss(AToken: String;
      ARangeStart, ARangeEnd: String): TProfitLossDTO;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IReportService));

end.
