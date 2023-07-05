unit UTransaction;

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

  ;

type
  [Entity]
  [Automapping]
  TTransaction = class
  private
    FTitle: String;
    FId: Integer;
    FAmount: Double;
    FCategory: String;
    FPaidOn: TDateTime;

    function GetMonth: Integer;
    function GetYear: Integer;

  protected
    function GetAmountTotal: Double; virtual;

  public
    property Id: Integer read FId write FId;

    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;
    property Year: Integer read GetYear;
    property Month: Integer read GetMonth;

    property AmountTotal: Double read GetAmountTotal;
  end;


implementation

{ TTransaction }

function TTransaction.GetAmountTotal: Double;
begin
  Result := Amount;
end;

function TTransaction.GetMonth: Integer;
begin
  Result := PaidOn.Month;
end;

function TTransaction.GetYear: Integer;
begin
  Result := PaidOn.Year;
end;

end.
