unit UApi;

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
  [Entity, Automapping]
  TApiToken = class
  private
    FToken: String;
    FId: Integer;
  public
    property Id: Integer read FId write FId;
    property Token: String read FToken write FToken;
  end;

  [Entity, Automapping]
  TApiUser = class
  private
    FName: String;
    FId: Integer;
    FEmail: String;
    FToken: String;
    FExpiresOn: TDateTime;

  public
    constructor Create;

    class function NewToken: String;

    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Email: String read FEmail write FEmail;
    property Token: String read FToken write FToken;
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

  Token := NewToken;
  ExpiresOn := TDateTime.NowUTC.IncMonth(1);
end;

class function TApiUser.NewToken: String;
var
  LGuid: String;

begin
  LGuid := TGuid.NewGuid.ToString;

  Result := TNetEncoding.Base64String.Encode(LGuid);
end;

initialization
  RegisterEntity(TApiUser);

end.
