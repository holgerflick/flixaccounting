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
unit UProfitLoss;

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
  TProfitLoss = class;

  [Automapping]
  [Model('Temporary')]
  TPLSection = ( Income = 0, Expense = 1);

  [Entity]
  [Automapping]
  [Model('Temporary')]
  TPLTransaction = class
  private
    FTitle: String;
    FId: Integer;
    FAmount: Double;
    FPaidOn: TDateTime;

  public
    property Id: Integer read FId write FId;
    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;
  end;

  TPLTransactions = TList<TPLTransaction>;

  [Entity]
  [Automapping]
  [Model('Temporary')]
  TPLCategory = class
  private
    FTransactions: TPLTransactions;

    FId: Integer;
    FCategory: String;
    FSection: TPLSection;

    [Association([], CascadeTypeAllButRemove)]
    FProfitLoss: TProfitLoss;

    function GetTotal: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;

    property ProfitLoss: TProfitLoss read FProfitLoss write FProfitLoss;

    property Category: String read FCategory write FCategory;
    property Section: TPLSection read FSection write FSection;

    property Total: Double read GetTotal;
    property Transactions: TPLTransactions read FTransactions write FTransactions;
  end;

  TPLCategories = TList<TPLCategory>;

  [Entity]
  [Automapping]
  [Model('Temporary')]
  TProfitLoss = class
  private
    FId: Integer;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FProfitLoss')]
    FItems: Proxy<TPLCategories>;
    FCreated: TDateTime;

    function GetTotalExpense: Double;
    function GetTotalIncome: Double;
    function GetTotalFor(ASection: TPLSection): Double;
    function GetCategories: TPLCategories;

  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;

    property Created: TDateTime read FCreated write FCreated;
    property Categories: TPLCategories read GetCategories;

    property TotalIncome: Double read GetTotalIncome;
    property TotalExpense: Double read GetTotalExpense;
  end;

implementation

{ TProfitLoss }

constructor TProfitLoss.Create;
begin
  inherited;

  FCreated := TDateTime.NowUtc;
  FItems.SetInitialValue(TPLCategories.Create);
end;

destructor TProfitLoss.Destroy;
begin
  FItems.DestroyValue;

  inherited;
end;

function TProfitLoss.GetCategories: TPLCategories;
begin
  Result := FItems.Value;
end;

function TProfitLoss.GetTotalExpense: Double;
begin
  Result := GetTotalFor(TPLSection.Expense);
end;

function TProfitLoss.GetTotalFor(ASection: TPLSection): Double;
begin
  Result := 0;

  for var LCategory in Categories do
  begin
    if LCategory.Section = ASection then
    begin
      Result := LCategory.Total + Result;
    end;
  end;
end;

function TProfitLoss.GetTotalIncome: Double;
begin
  Result := GetTotalFor(TPLSection.Income);
end;

{ TPLCategory }

constructor TPLCategory.Create;
begin
  inherited;

  FTransactions := TPLTransactions.Create;
end;

destructor TPLCategory.Destroy;
begin
  FTransactions.Free;

  inherited;
end;

function TPLCategory.GetTotal: Double;
begin
  Result := 0;
  for var LTx in Transactions do
  begin
    Result := Result + LTx.Amount;
  end;
end;

initialization
  RegisterEntity(TProfitLoss);

end.
