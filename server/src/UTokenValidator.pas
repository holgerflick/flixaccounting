{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
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
