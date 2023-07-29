unit UTokenAuthentication;

interface
uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq
  , Aurelius.Engine.ObjectManager

  , XData.Server.Module
  ;

type
  TTokenAuthentication = class

  public
    constructor Create;

    function IsValidToken(AToken: String): Boolean;
  end;

implementation
uses
    UApi
  , UDictionary

  , System.DateUtils

  , UServerContainer
  ;

{ TTokenAuthentication }

constructor TTokenAuthentication.Create;
begin
  inherited Create;
end;

function TTokenAuthentication.IsValidToken(AToken: String): Boolean;
var
  LUser: TApiUser;

begin
  var LObjManager := TObjectManager.Create(
    ServerContainer.DefaultConnectionPool.Connection.CreateConnection );
  try
    LUser := LObjManager.Find<TApiUser>
      .Where(
        (Dic.ApiUser.Token = AToken) AND
        (Dic.ApiUser.ExpiresOn > TDateTime.NowUTC)
      )
      .UniqueResult
      ;

    Result := Assigned(LUser);
  finally
    LObjManager.Free;
  end;
end;

end.
