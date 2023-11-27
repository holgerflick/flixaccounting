unit UInvoiceServiceImpl;

interface

uses
    System.Classes

  , XData.Server.Module
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
    function InvoiceExcel(Id: Integer; Token: String): TStream;
    function InvoicePdf(Id: Integer; Token: String): TStream;
  end;

implementation

uses
  UInvoiceServiceManager
  ;

{ TInvoiceService }

function TInvoiceService.InvoiceExcel(Id: Integer; Token: String): TStream;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.ExcelDocument(Id, Token);
  finally
    LManager.Free;
  end;
end;

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
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Payments(Id, Token);
  finally
    LManager.Free;
  end;
end;

function TInvoiceService.InvoicePdf(Id: Integer; Token: String): TStream;
begin
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.PdfDocument(Id, Token);
  finally
    LManager.Free;
  end;
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
  var LManager := TInvoiceServiceManager.Create;
  try
    Result := LManager.Transactions(Id, Token);
  finally
    LManager.Free;
  end;

end;

initialization
  RegisterServiceType(TInvoiceService);

end.
