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
  public
    class function NewToken: String;

    constructor Create;

    property Id: Integer read FId write FId;
    property Kind: TApiTokenKind read FKind write FKind;
    property Token: String read FToken write FToken;
  end;

  [Entity, Automapping]
  TApiUser = class
  private
    FName: String;
    FId: Integer;
    FEmail: String;

    [Association([], CascadeTypeAllRemoveOrphan)]
    FApiToken: TApiToken;

    FExpiresOn: TDateTime;

  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Email: String read FEmail write FEmail;
    property ApiToken: TApiToken read FApiToken write FApiToken;
    property ExpiresOn: TDateTime read FExpiresOn write FExpiresOn;
  end;


implementation
uses
  System.NetEncoding
  ;

{ TApiUser }

constructor TApiUser.Create;
begin
  inherited;

  ExpiresOn := TDateTime.NowUTC.IncMonth(1);
end;

constructor TApiToken.Create;
begin
  inherited;

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

destructor TApiUser.Destroy;
begin
  inherited;
end;

initialization
  RegisterEntity(TApiUser);

end.
