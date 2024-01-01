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

    [Column('Address', [], 2000)]
    FAddress: string;
    FEmail: String;
    FId: Integer;

    [Column('Name', [TColumnProp.Unique])]
    FName: String;

    FContact: String;
    function GetAddressExcel: String;

  public
    constructor Create;

    property Id: Integer read FId write FId;

    property Name: string read FName write FName;
    property Contact: String read FContact write FContact;
    property Address: string read FAddress write FAddress;
    property Email: String read FEmail write FEmail;

    property AddressExcel: String read GetAddressExcel;
  end;

implementation

{ TCustomer }

constructor TCustomer.Create;
begin
  FName := String.Empty;
  FContact := String.Empty;
  FAddress := String.Empty;
  FEmail := String.Empty;
end;

function TCustomer.GetAddressExcel: String;
begin
  Result := Address.Replace(#13, String.Empty );
end;

initialization
  RegisterEntity(TCustomer);

end.
