unit UDownloadManager;

interface

uses
    System.Classes
  , System.SysUtils

  , Aurelius.Criteria.Expression
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

  , XData.Sys.Exceptions
  , XData.Server.Module

  , FlexCel.Render
  , FlexCel.XlsAdapter
  , Flexcel.Pdf
  ;

type
  TDownloadManager = class
  strict private
    FObjectManager: TObjectManager;

  public
    constructor Create;
    destructor Destroy; override;

    function Download(AToken: String): TStream;

    property ObjectManager: TObjectManager read FObjectManager write FObjectManager;
  end;


implementation

uses
    UServerContainer
  , UTokenValidator
  , UInvoicePrinter
  , UApi
  , UInvoice
  , UDictionary
  ;

{ TDownloadManager }

constructor TDownloadManager.Create;
begin
  inherited;

  FObjectManager := TXDataOperationContext.Current.CreateManager(
      ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection
    );

end;

destructor TDownloadManager.Destroy;
begin
  FObjectManager.Free;

  inherited;
end;

function TDownloadManager.Download(AToken: String): TStream;
var
  LXlsBlob: TMemoryStream;
  LPdfExport: TFlexCelPdfExport;
  LXlsInput: TXlsFile;

begin

  if AToken.IsEmpty then
  begin
    raise EXDataHttpUnauthorized.Create('Token required.');
  end;

  // find invoice that matches token -- also check if token is not expired
  var LInvoice := ObjectManager.Find<TInvoice>
    .Where( Dic.Invoice.ApiToken.Token = AToken )
    .UniqueResult
    ;

  if not Assigned(LInvoice) then
  begin
    raise EXDataHttpUnauthorized.Create('Token not found.');
  end;

  if LInvoice.ApiToken.IsExpired then
  begin
    raise EXDataHttpUnauthorized.Create('Token expired.');
  end;

  // either retrieve invoice as Excel document from object instance
  // or create it.

  LXlsBlob := TMemoryStream.Create;
  LPdfExport := nil;
  LXlsInput := nil;

  try
    if LInvoice.ProcessedCopy.IsNull then
    begin
      var LPrinter := TInvoicePrinter.Create(ObjectManager);
      try
        LPrinter.Print(LInvoice, LXlsBlob);
      finally
        LPrinter.Free;
      end;
    end
    else
    begin
      LInvoice.ProcessedCopy.SaveToStream(LXlsBlob);
    end;

    LXlsBlob.Position := 0;

    LXlsInput := TXlsFile.Create(LXlsBlob, true);
    LPdfExport := TFlexCelPdfExport.Create(LXlsInput, true );

    Result := TMemoryStream.Create;
    LPdfExport.Export(Result);
  finally
    LXlsInput.Free;
    LPdfExport.Free;
    LXlsBlob.Free;
  end;
end;

end.
