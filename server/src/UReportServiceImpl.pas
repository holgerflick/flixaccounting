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
    function ProfitLoss: TProfitLossDTO;
  end;

implementation

uses
  UReportServiceManager
  ;

{ TReportService }

function TReportService.ProfitLoss: TProfitLossDTO;
var
  LManager: TReportServiceManager;

begin
  LManager := TReportServiceManager.Create;
  try
    Result := LManager.ProfitLoss;
  finally
    LManager.Free;
  end;
end;

initialization
  RegisterServiceType(TReportService);

end.
