unit UExpense;

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

  , UTransaction
  , UDocument

  ;

type
  [Entity]
  [Automapping]
  TExpense = class(TTransaction)
  private
    FIsMonthly: Boolean;
    FPercentage: Double;

    [Association([TAssociationProp.Lazy], CascadeTypeAll )]
    FDocument: Proxy<TDocument>;

    function GetMonthsPaid: Integer;
    function GetDocument: TDocument;
    procedure SetDocument(const Value: TDocument);

  protected
    function GetAmountTotal: Double; override;

  public
    constructor Create;
    destructor Destroy; override;

    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;
    property Percentage: Double read FPercentage write FPercentage;

    property Document: TDocument read GetDocument write SetDocument;

    property MonthsPaid: Integer read GetMonthsPaid;

  end;

implementation

uses
  System.DateUtils
  ;

{ TExpense }

constructor TExpense.Create;
begin
  FPercentage := 1;
  FIsMonthly := False;
end;

destructor TExpense.Destroy;
begin
  // nothing
end;

function TExpense.GetAmountTotal: Double;
begin
  Result := Amount * MonthsPaid * Percentage;
end;

function TExpense.GetDocument: TDocument;
begin
  Result := FDocument.Value;
end;


function TExpense.GetMonthsPaid: Integer;
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

procedure TExpense.SetDocument(const Value: TDocument);
begin
  FDocument.Value := Value;
end;

initialization
  RegisterEntity(TExpense);

end.
