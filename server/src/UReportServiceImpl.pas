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

  , UProfitLossDTO
  , UReportService
  ;

type
  [ServiceImplementation]
  TReportService = class(TInterfacedObject, IReportService)

  public
    function ProfitLossCurrentYear(AToken: String): TProfitLossDTO;
    function ProfitLoss(AToken: String; ARangeStart, ARangeEnd: String): TProfitLossDTO;
  end;

implementation

uses
    Bcl.Utils
  , System.DateUtils
  , UReportServiceManager
  ;

{ TReportService }

function TReportService.ProfitLoss(AToken, ARangeStart,
  ARangeEnd: String): TProfitLossDTO;
var
  LManager: TReportServiceManager;
  LStart,
  LEnd: TDate;

begin
  LManager := TReportServiceManager.Create;
  try
    LStart := TBclUtils.ISOToDate(ARangeStart);
    LEnd := TBclUtils.ISOToDate(ARangeEnd);

    Result := LManager.ProfitLoss(AToken, LStart, LEnd);
  finally
    LManager.Free;
  end;
end;

function TReportService.ProfitLossCurrentYear(AToken: String): TProfitLossDTO;
var
  LStartOfYear,
  LEndOfYear: TDate;
  LManager: TReportServiceManager;

begin
  LManager := TReportServiceManager.Create;
  try
    LStartOfYear := TDateTime.NowUtc.StartOfTheYear;
    LEndOfYear := TDateTime.NowUtc.EndOfTheYear;
    Result := LManager.ProfitLoss(AToken, LStartOfYear, LEndOfYear);
  finally
    LManager.Free;
  end;
end;

initialization
  RegisterServiceType(TReportService);

end.
