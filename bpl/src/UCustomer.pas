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


  ;

type
  [Entity]
  [Automapping]
  TCustomer = class
  private
    FAddress: string;
    FEmail: String;
    FId: Integer;

    [Column('LookupName', [TColumnProp.Unique])]
    FLookupName: String;

    FName: string;
    function GetName: string;
  public
    property Id: Integer read FId write FId;

    property LookupName: String read FLookupName write FLookupName;
    property Name: string read GetName write FName;
    property Address: string read FAddress write FAddress;
    property Email: String read FEmail write FEmail;

  end;

implementation

{ TCustomer }

function TCustomer.GetName: string;
begin
  if FName.IsEmpty then
  begin
    Result := LookupName;
  end
  else
  begin
    Result := FName;
  end;
end;

initialization
  RegisterEntity(TCustomer);

end.
