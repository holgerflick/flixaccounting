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
    FPercentage: Double;
    FIsMonthly: Boolean;

    function GetMonth: Integer;
    function GetYear: Integer;
    function GetDocument: TDocument;
    procedure SetDocument(const Value: TDocument);
    function GetMonthsPaid: Integer;

  protected
    function GetAmountTotal: Double; virtual;

  public
    constructor Create;


    property Id: Integer read FId write FId;
    property Kind: TTransactionKind read FKind write FKind;
    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;
    property Document: TDocument read GetDocument write SetDocument;

    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;
    property Percentage: Double read FPercentage write FPercentage;

    property MonthsPaid: Integer read GetMonthsPaid;

    property Year: Integer read GetYear;
    property Month: Integer read GetMonth;
    property AmountTotal: Double read GetAmountTotal;
  end;

  TTransactions = TList<TTransaction>;


implementation

{ TTransaction }

constructor TTransaction.Create;
begin
  inherited;

  FPercentage := 1;
  FIsMonthly := False;
end;

function TTransaction.GetAmountTotal: Double;
begin
  Result := Amount * MonthsPaid * Percentage;
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

function TTransaction.GetYear: Integer;
begin
  Result := PaidOn.Year;
end;

procedure TTransaction.SetDocument(const Value: TDocument);
begin
  FDocument.Value := Value;
end;

end.
