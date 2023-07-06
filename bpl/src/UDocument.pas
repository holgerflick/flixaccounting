unit UDocument;

interface
uses
    Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections

  ;

type
  [Entity]
  [Automapping]
  TDocument = class
  private
    [Column('Document', [TColumnProp.Lazy])]
    FDocument: TBlob;

    FId: Integer;
    FOriginalFilename: String;

    function GetKeyFilename: String;

  public
    property Id: Integer read FId write FId;

    property Document: TBlob read FDocument write FDocument;

    property OriginalFilename: String
      read FOriginalFilename
      write FOriginalFilename;

    property KeyFilename: String read GetKeyFilename;
  end;

implementation

uses
  System.IOUtils
  ;

{ TDocument }

function TDocument.GetKeyFilename: String;
begin
  Result := TPath.GetFileNameWithoutExtension( FOriginalFilename );
end;

initialization
  RegisterEntity(TDocument);


end.
