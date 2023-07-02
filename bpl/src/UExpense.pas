unit UExpense;

interface
uses
  Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer
  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections

  , UDocument

  ;

type
  [Entity]
  [Automapping]
  TExpense = class
  private
    FId: Integer;
    FPaidOn: TDateTime;
    FIsMonthly: Boolean;
    FCategory: String;
    FTitle: String;
    FAmount: Double;
    FPercentage: Double;

    [Association([], CascadeTypeAll )]
    FDocument: TDocument;

    function GetAmountTotal: Double;
    function GetMonth: Integer;
    function GetMonthsPaid: Integer;
    function GetYear: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;

    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;
    property Percentage: Double read FPercentage write FPercentage;

    property Document: TDocument read FDocument write FDocument;

    property Year: Integer read GetYear;
    property Month: Integer read GetMonth;
    property MonthsPaid: Integer read GetMonthsPaid;
    property AmountTotal: Double read GetAmountTotal;

  end;

implementation

uses
  System.DateUtils
  ;

{ TExpense }

constructor TExpense.Create;
begin
  FDocument := nil;
  FPercentage := 1;
  FIsMonthly := False;
end;

destructor TExpense.Destroy;
begin

end;

function TExpense.GetAmountTotal: Double;
begin
  Result := Amount * MonthsPaid;
end;

function TExpense.GetMonth: Integer;
begin
  Result := PaidOn.Month;
end;

function TExpense.GetMonthsPaid: Integer;
begin
  Result := 12 - Month + 1;
end;

function TExpense.GetYear: Integer;
begin
  Result := PaidOn.Year;
end;

initialization
  RegisterEntity(TExpense);

end.
