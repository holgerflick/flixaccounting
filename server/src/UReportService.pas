unit UReportService;

interface

uses
    UServerTypes
  , XData.Service.Common
  ;

type
  [ServiceContract]
  [Route('')]
  IReportService = interface(IInvokable)
    ['{170D2E6C-D884-4D79-8D72-1539DE0852DF}']

    [HttpGet]
    [Route('profitloss/{AToken}')]
    function ProfitLoss(AToken: String): TProfitLossDTO;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IReportService));

end.
