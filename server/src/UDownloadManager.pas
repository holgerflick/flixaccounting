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

    function DownloadInvoice(AToken: String): TStream;

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
begin

  if AToken.IsEmpty then
  begin
    raise EXDataHttpUnauthorized.Create('Token required.');
  end;

  // first find what kind of token it is in order to branch to the method that
  // handles the download

  var LToken := ObjectManager.Find<TApiToken>
    .Where( Dic.ApiToken.Token = AToken )
    .UniqueResult
    ;

  // is the token found?
  if not Assigned(LToken) then
  begin
    raise EXDataHttpUnauthorized.Create('Token not found.');
  end;

  // is it still not expired?
  if LToken.IsExpired then
  begin
    raise EXDataHttpUnauthorized.Create('Token expired.');
  end;

  // is it a token for a user and not a download?
  if LToken.Kind = TApiTokenKind.User then
  begin
    raise EXDataHttpUnauthorized.Create('Token not valid for download.');
  end;

  // init with nada
  Result := nil;

  // is it a token for an invoice?
  if LToken.Kind = TApiTokenKind.Invoice then
  begin
    Result := DownloadInvoice(AToken);
  end;

end;

function TDownloadManager.DownloadInvoice(AToken: String): TStream;
var
  LXlsBlob: TMemoryStream;
  LPdfExport: TFlexCelPdfExport;
  LXlsInput: TXlsFile;
  LFilename: String;

begin
  // find invoice that matches token -- also check if token is not expired
  var LInvoice := ObjectManager.Find<TInvoice>
    .Where( Dic.Invoice.ApiToken.Token = AToken )
    .UniqueResult
    ;


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

    LFilename := 'Invoice_' + LInvoice.Number.ToString;
  finally
    LXlsInput.Free;
    LPdfExport.Free;
    LXlsBlob.Free;
  end;

  // set up the response
  TXDataOperationContext.Current.Response.ContentType := 'application/pdf';
  TXDataOperationContext.Current.Response.Headers.AddValue(
    'Content-Disposition', 'filename=' + LFilename + '.pdf'
    );

end;

end.
