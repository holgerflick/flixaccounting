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
