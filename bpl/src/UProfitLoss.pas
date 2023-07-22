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
  , System.Generics.Collections
  ;

type
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
    function GetTotal: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property Category: String read FCategory write FCategory;
    property Total: Double read GetTotal;
    property Transactions: TPLTransactions read FTransactions write FTransactions;
  end;

  TPLCategories = TList<TPLCategory>;

  [Automapping]
  [Model('Temporary')]
  TPLSection = ( Income, Expense );

  TPLSections = Array[TPLSection] of TPLCategories;

  [Entity]
  [Automapping]
  [Model('Temporary')]
  TProfitLoss = class
  private
    FCategories: TPLSections;
    function GetTotalExpense: Double;
    function GetTotalIncome: Double;

    function GetTotalFor( ASection: TPLSection ): Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Categories: TPLSections read FCategories write FCategories;

    property TotalIncome: Double read GetTotalIncome;
    property TotalExpense: Double read GetTotalExpense;
  end;

implementation

{ TProfitLoss }

constructor TProfitLoss.Create;
begin
  inherited;

  for var LSection := Low(TPLSection) to High(TPLSection) do
  begin
    FCategories[LSection] := TPLCategories.Create;
  end;
end;

destructor TProfitLoss.Destroy;
begin
  for var LSection := Low(TPLSection) to High(TPLSection) do
  begin
    FCategories[LSection].Free;
  end;

  inherited;
end;

function TProfitLoss.GetTotalExpense: Double;
begin
  Result := GetTotalFor(TPLSection.Expense);
end;

function TProfitLoss.GetTotalFor(ASection: TPLSection): Double;
begin
  Result := 0;

  for var LCategory in Categories[ASection] do
  begin
    Result := LCategory.Total + Result;
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
