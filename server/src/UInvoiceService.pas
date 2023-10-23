unit UInvoiceService;

interface

uses
    XData.Service.Common
  , UInvoiceDTO
  ;

type
  [ServiceContract]
  [Route('v1/invoices')]
  IInvoiceService = interface(IInvokable)
    ['{5FFE6361-B607-432B-8046-2CB39F3F5E57}']


    [HttpGet]
    [Route('{token}')]
    function Invoices(Token:String): TInvoicesDTO;


  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IInvoiceService));

end.
