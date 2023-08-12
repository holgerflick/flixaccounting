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
unit UReportServiceManager;

interface
uses
    Aurelius.Criteria.Expression
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Projections
  , Aurelius.Drivers.Interfaces
  , Aurelius.Engine.ObjectManager
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Explorer
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob

  , XData.Server.Module
  , XData.Sys.Exceptions

  , Bcl.Types.Nullable

  , System.SysUtils

  , UProfitLoss
  , UServerTypes
  ;

type
  TReportServiceManager = class
  public
    function ProfitLoss(AToken: String): TProfitLossDTO;
  end;

implementation

uses
    UServerContainer
  , UReportManager
  , UTokenValidator
  ;

{ TReportServiceManager }

function TReportServiceManager.ProfitLoss(AToken: String): TProfitLossDTO;
var
  LObjManager,
  LObjManagerTemp : TObjectManager;
  LManager: TReportManager;
  LConnection: IDBConnection;

begin
  if AToken.IsEmpty then
  begin
    raise EXDataHttpUnauthorized.Create('Token required.');
  end;

  // check token first
  if TTokenValidator.IsValidUserToken(AToken) then
  begin
    LConnection := ServerContainer.TemporaryConnection;

    LObjManager := TXDataOperationContext.Current.CreateManager(
      ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection
      );
    LObjManagerTemp := TXDataOperationContext.Current.CreateManager(
      LConnection,
      TMappingExplorer.Get('Temporary')
      );

    LManager := TReportManager.Create(LObjManager);
    try
      var LProfitLoss := LManager.GetProfitLoss(LObjManagerTemp);
      Result := TProfitLossDTO.Create(LProfitLoss);
    finally
      LManager.Free;
    end;

    if not Assigned(Result) then
    begin
      raise EXDataHttpException.Create( 404, 'Not found.' );
    end;
  end
  else
  begin
    raise EXDataHttpUnauthorized.Create('Token invalid or expired.');
  end;
end;

end.
