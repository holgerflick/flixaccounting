unit UInvoiceServiceManager;

interface

uses
    Aurelius.Criteria.Expression
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Projections
  , Aurelius.Drivers.Interfaces
  , Aurelius.Engine.ObjectManager
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Explorer
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob

  , FlexCel.Pdf
  , FlexCel.XlsAdapter
  , FlexCel.Render

  , XData.Server.Module
  , XData.Sys.Exceptions

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Classes

  , UInvoiceDTO
  , UInvoice
  ;

type
  TInvoiceServiceManager = class
  private
    function InvoiceById(AId: Integer): TInvoice;
  public
    constructor Create;
    destructor Destroy; override;

    function Invoices(AYear: Integer; AToken: String): TInvoicesDTO;

    function Transactions(AId: Integer; AToken: String): TInvoiceTransactionsDTO;
    function Payments(AId: Integer; AToken: String): TInvoicePaymentsDTO;
    function Items(AId: Integer; AToken: String): TInvoiceItemsDTO;
    function ExcelDocument( AId: Integer; AToken: String): TStream;
    function PDFDocument( AId: Integer; AToken: String): TStream;

  end;

implementation

uses
    UServerContainer
  , UTokenValidator

  , UDictionary
  ;

{ TInvoiceServiceManager }

constructor TInvoiceServiceManager.Create;
begin
  inherited;

end;

destructor TInvoiceServiceManager.Destroy;
begin

  inherited;
end;


// ezEyMUYyMjFGLTNEQzgtNDRFRS1CMUEyLUVFOUU2QzdEQjRFNX0=

function TInvoiceServiceManager.InvoiceById(AId: Integer): TInvoice;
begin
  var LObjectManager := TXDataOperationContext.Current.CreateManager(
    ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection
    );

  Result := LObjectManager.Find<TInvoice>
    .Where(Dic.Invoice.Id = AId)
    .UniqueResult
    ;

  if not Assigned(Result) then
  begin
    raise EXDataHttpException.Create(404, 'Invoice not found.');
  end;

end;

function TInvoiceServiceManager.Invoices(AYear: Integer; AToken: String): TInvoicesDTO;
begin
  // check token first
  TTokenValidator.ValidateUserToken(AToken);

  var LObjectManager := TXDataOperationContext.Current.CreateManager(
    ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection
    );

  var LInvoices := LObjectManager
    .Find<TInvoice>
    .Where(Dic.Invoice.IssuedOn.Year = AYear)
    .OrderBy(Dic.Invoice.Number)
    .List
    ;
  try
    Result := TInvoicesDTO.Create;
    TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);

    for var LInvoice in LInvoices do
    begin
      var LDTO := TInvoiceDTO.Create(LInvoice);
      Result.Add(LDTO);
    end;
  finally
    LInvoices.Free;
  end;
end;

function TInvoiceServiceManager.Items(AId: Integer; AToken: String): TInvoiceItemsDTO;
begin
  // check token first
  TTokenValidator.ValidateUserToken(AToken);

  var LInvoice := InvoiceById(AId);

  Result := TInvoiceItemsDTO.Create;
  TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);

  for var LItem in LInvoice.Items do
  begin
    var LItemDTO := TInvoiceItemDTO.Create(LItem);
    Result.Add(LItemDTO);
  end;
end;

function TInvoiceServiceManager.Payments(AId: Integer;
  AToken: String): TInvoicePaymentsDTO;
begin
  // check token first
  TTokenValidator.ValidateUserToken(AToken);

  var LInvoice := InvoiceById(AId);

  Result := TInvoicePaymentsDTO.Create;
  TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);

  for var LPmt in LInvoice.Payments do
  begin
    var LPmtDTO := TInvoicePaymentDTO.Create(LPmt);
    Result.Add(LPmtDTO);
  end;
end;

function TInvoiceServiceManager.PDFDocument(AId: Integer;
  AToken: String): TStream;
begin
  var LXlsStream := ExcelDocument(AId, AToken);
  LXlsStream.Position := 0;

  var LXlsFile := TXlsFile.Create(LXlsStream, True);
  try
    var LExporter := TFlexCelPdfExport.Create(LXlsFile);
    try
      Result := TMemoryStream.Create;
      LExporter.Export(Result);
      Result.Position := 0;
      TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);
      TXDataOperationContext.Current.Response.ContentType := 'application/pdf';

    finally
      LExporter.Free;
    end;
  finally
    LXlsFile.Free;
  end;

end;

function TInvoiceServiceManager.ExcelDocument(AId: Integer; AToken: String): TStream;
begin
  // check token first
  TTokenValidator.ValidateUserToken(AToken);

  var LInvoice := InvoiceById(AId);

  if LInvoice.ProcessedCopy.IsNull then
  begin
    raise EXDataHttpException.Create(404, 'Invoice document not available.');
  end;

  Result := TBytesStream.Create(LInvoice.ProcessedCopy.AsBytes);

  TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);
  TXDataOperationContext.Current.Response.ContentType := 'application/msexcel';
end;

function TInvoiceServiceManager.Transactions(AId: Integer;
  AToken: String): TInvoiceTransactionsDTO;
begin
  // check token first
  TTokenValidator.ValidateUserToken(AToken);

  var LInvoice := InvoiceById(AId);

  Result := TInvoiceTransactionsDTO.Create;
  TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);

  for var LTx in LInvoice.Transactions do
  begin
    var LTxDTO := TInvoiceTransactionDTO.Create(LTx);
    Result.Add(LTxDTO);
  end;
end;

end.
