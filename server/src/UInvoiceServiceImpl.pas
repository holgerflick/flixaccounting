unit UInvoiceServiceImpl;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , UInvoiceService
  , UInvoiceDTO
  ;

type
  [ServiceImplementation]
  TInvoiceService = class(TInterfacedObject, IInvoiceService)
    function Invoices(Token:String): TInvoicesDTO;

  end;

implementation

uses
  UInvoiceServiceManager
  ;

{ TInvoiceService }

function TInvoiceService.Invoices(Token:String): TInvoicesDTO;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Invoices(Token)
  finally
    LManager.Free;
  end;
end;

initialization
  RegisterServiceType(TInvoiceService);

end.
