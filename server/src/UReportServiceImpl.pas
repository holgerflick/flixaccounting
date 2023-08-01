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
