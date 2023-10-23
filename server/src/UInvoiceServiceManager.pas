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

  , XData.Server.Module
  , XData.Sys.Exceptions

  , Bcl.Types.Nullable

  , System.SysUtils
  , UInvoiceDTO
  ;

type
  TInvoiceServiceManager = class

  public
    constructor Create;
    destructor Destroy; override;

    function Invoices(AToken: String): TInvoicesDTO;

  end;

implementation

uses
    UServerContainer
  , UTokenValidator
  , UInvoice
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

function TInvoiceServiceManager.Invoices(AToken: String): TInvoicesDTO;
begin
  if AToken.IsEmpty then
  begin
    raise EXDataHttpUnauthorized.Create('Token required.');
  end;

  // check token first
  if TTokenValidator.IsValidUserToken(AToken) then
  begin
    var LObjectManager := TXDataOperationContext.Current.CreateManager(
      ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection
      );

    var LInvoices := LObjectManager
      .Find<TInvoice>
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
end;

end.
