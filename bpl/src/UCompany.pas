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
unit UCompany;

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
  TCompany = class
  private
    FId: Integer;
    FName: String;
    FAddressLine: String;
    FCityZipLine: String;
    FLogo: TBlob;

  public
    property Id: Integer
      read FId write FId;
    property Name: String
      read FName write FName;
    property AddressLine: String
      read FAddressLine write FAddressLine;
    property CityZipLine: String
      read FCityZipLine write FCityZipLine;
    property Logo: TBlob
      read FLogo write FLogo;
  end;


implementation

initialization
  RegisterEntity(TCompany)

end.
