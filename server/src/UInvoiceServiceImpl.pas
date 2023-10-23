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
    function Invoices(Year: Integer; Token:String): TInvoicesDTO;
    function InvoiceItems(Id: Integer; Token: String): TInvoiceItemsDTO;
    function InvoicePayments(Id: Integer; Token: String): TInvoicePaymentsDTO;
    function InvoiceTransactions(Id: Integer; Token: String): TInvoiceTransactionsDTO;

  end;

implementation

uses
  UInvoiceServiceManager
  ;

{ TInvoiceService }

function TInvoiceService.InvoiceItems(Id: Integer;
  Token: String): TInvoiceItemsDTO;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Items(Id, Token);
  finally
    LManager.Free;
  end;
end;

function TInvoiceService.InvoicePayments(Id: Integer;
  Token: String): TInvoicePaymentsDTO;
begin

end;

function TInvoiceService.Invoices(Year: Integer; Token:String): TInvoicesDTO;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Invoices(Year, Token)
  finally
    LManager.Free;
  end;
end;

function TInvoiceService.InvoiceTransactions(Id: Integer;
  Token: String): TInvoiceTransactionsDTO;
begin

end;

initialization
  RegisterServiceType(TInvoiceService);

end.
