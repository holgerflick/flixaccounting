unit UApi;

{$SCOPEDENUMS ON}

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
  , System.DateUtils
  , System.Generics.Collections
  ;

type
  [Automapping]
  TApiTokenKind = ( User, Invoice );

  [Entity, Automapping]
  TApiToken = class
  private
    FToken: String;
    FId: Integer;
    FKind: TApiTokenKind;
    FExpiresOn: TDateTime;
  public
    class function NewToken: String;

    constructor Create;

    property Id: Integer read FId write FId;
    property Kind: TApiTokenKind read FKind write FKind;
    property Token: String read FToken write FToken;
    property ExpiresOn: TDateTime read FExpiresOn write FExpiresOn;
  end;

  [Entity, Automapping]
  TApiUser = class
  private
    FName: String;
    FId: Integer;
    FEmail: String;

    [Association([], CascadeTypeAllRemoveOrphan)]
    FApiToken: TApiToken;

  public
    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Email: String read FEmail write FEmail;
    property ApiToken: TApiToken read FApiToken write FApiToken;
  end;


implementation
uses
  System.NetEncoding
  ;

{ TApiUser }

constructor TApiToken.Create;
begin
  inherited;

  FExpiresOn := TDateTime.NowUTC.IncMonth(1);
  FKind := TApiTokenKind.User;
  FToken := NewToken;
end;

class function TApiToken.NewToken: String;
var
  LGuid: String;

begin
  LGuid := TGuid.NewGuid.ToString;

  Result := TNetEncoding.Base64String.Encode(LGuid);
end;

initialization
  RegisterEntity(TApiUser);

end.
