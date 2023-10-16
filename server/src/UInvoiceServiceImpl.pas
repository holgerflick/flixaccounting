unit UInvoiceServiceImpl;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , UInvoiceService
  , UServerTypes
  ;

type
  [ServiceImplementation]
  TInvoiceService = class(TInterfacedObject, IInvoiceService)
    function Invoices(Token:String): TInvoicesDTO;
    function Invoice(Id: Integer; Token: String): TInvoiceDetailsDTO;
  end;

implementation

uses
  UInvoiceServiceManager
  ;

{ TInvoiceService }

function TInvoiceService.Invoice(Id: Integer; Token: String):
    TInvoiceDetailsDTO;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Invoice(Id, Token);
  finally
    LManager.Free;
  end;
end;

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
