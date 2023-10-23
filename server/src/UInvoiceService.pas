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

    [HttpGet]
    [Route('items/{id}/{token}')]
    function InvoiceItems(Id: Integer; Token: String): TInvoiceItemsDTO;

    [HttpGet]
    [Route('payments/{id}/{token}')]
    function InvoicePayments(Id: Integer; Token: String): TInvoicePaymentsDTO;

    [HttpGet]
    [Route('transactions/{id}/{token}')]
    function InvoiceTransactions(Id: Integer; Token: String): TInvoiceTransactionsDTO;

  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IInvoiceService));

end.
