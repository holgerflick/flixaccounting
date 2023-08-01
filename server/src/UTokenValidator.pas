unit UTokenValidator;

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
  TTokenValidator = class

  public
    class function IsValidUserToken(AToken: String): Boolean;
  end;

implementation
uses
    UApi
  , UDictionary

  , System.DateUtils

  , UServerContainer
  ;

{ TTokenAuthentication }

class function TTokenValidator.IsValidUserToken(AToken: String): Boolean;
var
  LUser: TApiUser;

begin
  var LObjManager := TObjectManager.Create(
    ServerContainer.DefaultConnectionPool.GetPoolInterface.GetConnection );
  try
    LUser := LObjManager.Find<TApiUser>
      .Where(
        (Dic.ApiUser.ApiToken.Token = AToken) AND
        (Dic.ApiUser.ApiToken.ExpiresOn > TDateTime.NowUTC)
      )
      .UniqueResult
      ;

    Result := Assigned(LUser);
  finally
    LObjManager.Free;
  end;
end;

end.
