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

  , UProfitLoss
  , UServerTypes
  ;

type
  TReportServiceManager = class

  public
    function ProfitLoss: TProfitLossDTO;
  end;

implementation

uses
    UServerContainer
  , UReportManager
  ;


{ TReportServiceManager }

function TReportServiceManager.ProfitLoss: TProfitLossDTO;
var
  LObjManager,
  LObjManagerTemp : TObjectManager;
  LManager: TReportManager;
  LConnection: IDBConnection;

begin
  Result := nil;

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
end;

end.
