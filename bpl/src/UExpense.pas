unit UExpense;

interface
uses
  Aurelius.Mapping.Automapping,
  Aurelius.Mapping.Attributes,
  Aurelius.Mapping.Metadata,
  Aurelius.Types.Blob,
  Aurelius.Mapping.Explorer,

  Bcl.Types.Nullable,

  System.SysUtils,
  System.Generics.Collections

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
    function GetAmountTotal: Double;
    function GetMonth: Integer;
    function GetMonthsPaid: Integer;
    function GetYear: Integer;

  public
    property Id: Integer read FId write FId;

    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;

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

end.
