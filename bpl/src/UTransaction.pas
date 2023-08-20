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
unit UTransaction;

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
  , System.Generics.Collections
  , System.DateUtils

  , UDocument
  ;

type
  [Automapping]
  TTransactionKind = ( Income, Expense, All ); // all is used for filtering

  [Entity]
  [Automapping]
  [Table('TRANSACT')]
  TTransaction = class
  private
    FTitle: String;
    FId: Integer;
    FAmount: Double;
    FCategory: String;
    FPaidOn: TDateTime;

    [Association([TAssociationProp.Lazy], CascadeTypeAll )]
    FDocument: Proxy<TDocument>;

    FKind: TTransactionKind;
    FIsMonthly: Boolean;

    function GetMonth: Integer;
    function GetDocument: TDocument;
    procedure SetDocument(const Value: TDocument);
    function GetMonthsPaid: Integer;
    function GetAmountTotal: Double;

  public
    constructor Create; overload;
    constructor Create( AKind: TTransactionKind ); overload;

    property Id: Integer read FId write FId;
    property Kind: TTransactionKind read FKind write FKind;
    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;

    property Document: TDocument read GetDocument write SetDocument;
    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;

    property MonthsPaid: Integer read GetMonthsPaid;

    property Month: Integer read GetMonth;
    property AmountTotal: Double read GetAmountTotal;
  end;

  TTransactions = TList<TTransaction>;


implementation

{ TTransaction }

constructor TTransaction.Create;
begin
  inherited;

  FIsMonthly := False;
end;

constructor TTransaction.Create(AKind: TTransactionKind);
begin
  Create;

  Kind := AKind;
end;

function TTransaction.GetAmountTotal: Double;
begin
  Result := Amount * MonthsPaid;
end;

function TTransaction.GetDocument: TDocument;
begin
  Result := FDocument.Value;
end;

function TTransaction.GetMonth: Integer;
begin
  Result := PaidOn.Month;
end;

function TTransaction.GetMonthsPaid: Integer;
begin
  if self.IsMonthly then
  begin
    Result := 12 - Month + 1
  end
  else
  begin
    Result := 1;
  end;
end;

procedure TTransaction.SetDocument(const Value: TDocument);
begin
  FDocument.Value := Value;
end;

initialization
  RegisterEntity(TTransaction);

end.
