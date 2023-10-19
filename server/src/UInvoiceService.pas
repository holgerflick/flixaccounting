unit UInvoiceService;

interface

uses
    XData.Service.Common
  , UServerTypes
  ;

type
  [ServiceContract]
  [Route('v1/invoices')]
  IInvoiceService = interface(IInvokable)
    ['{5FFE6361-B607-432B-8046-2CB39F3F5E57}']


    [HttpGet]
    [Route('{token}')]
    function Invoices(Token:String): TInvoicesDTO;

    [Route('{id}/{token}')]
    function Invoice(Id: Integer; Token: String): TInvoiceDetailsDTO;

  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IInvoiceService));

end.
