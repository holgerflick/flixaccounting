unit UCustomer;

interface
uses
    Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Types.Proxy
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections
  , System.DateUtils

  , UDictionary

  ;

type
  [Entity]
  [Automapping]
  TCustomer = class
  private


    FAddress: string;
    FEmail: String;
    FId: Integer;

    [Column('Name', [TColumnProp.Unique])]
    FName: string;
    FContact: String;

  public
    property Id: Integer read FId write FId;

    property Name: string read FName write FName;
    property Contact: String read FContact write FContact;
    property Address: string read FAddress write FAddress;
    property Email: String read FEmail write FEmail;
  end;

implementation

{ TCustomer }


initialization
  RegisterEntity(TCustomer);

end.
