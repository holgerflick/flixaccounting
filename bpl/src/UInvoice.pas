unit UInvoice;

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

  , UIncome
  ;

type
  TInvoice = class;

  [Entity]
  [Automapping]
  TInvoicePayment = class
  private
    FPaidOn: TDate;
    FAmount: Double;

    [Association([], CascadeTypeAllButRemove)]
    FInvoice: TInvoice;

    FId: Integer;
  public
    property Id: Integer read FId write FId;

    property Invoice: TInvoice read FInvoice write FInvoice;

    property PaidOn: TDate read FPaidOn write FPaidOn;
    property Amount: Double read FAmount write FAmount;
  end;

  TInvoicePayments = TList<TInvoicePayment>;

  [Entity]
  [Automapping]
  TInvoiceItem = class
  private
    FId: Integer;

    [Association([], CascadeTypeAllButRemove)]
    FInvoice: TInvoice;
    FIdx: Integer;
    FTitle: String;
    FQuantity: Double;
    FValue: Double;
    FCategory: String;
    function GetTotalValue: Double;

  public
    property Id: Integer read FId write FId;
    property Idx: Integer read FIdx write FIdx;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Quantity: Double read FQuantity write FQuantity;
    property Value: Double read FValue write FValue;

    property TotalValue: Double read GetTotalValue;
  end;

  TInvoiceItems = TList<TInvoiceItem>;

  [Entity]
  [Automapping]
  TInvoice = class

  private
    [ManyValuedAssociation([], CascadeTypeAll, 'FInvoice')]
    FItems: TInvoiceItems;

    [ManyValuedAssociation([], CascadeTypeAll, 'FInvoice')]
    FPayments: TInvoicePayments;
    FId: Integer;

    [Column('Number', [TColumnProp.Unique] )]
    FNumber: Integer;
    FIssuedOn: TDate;
    FDueOn: TDate;
    FIncome: TIncome;

    procedure Process;

    function GetTotalAmount: Double;
    function GetAmountDue: Double;
    function GetAmountPaid: Double;

  public
    constructor Create;
    destructor  Destroy; override;

    property Id: Integer read FId write FId;

    property Number: Integer read FNumber write FNumber;
    property IssuedOn: TDate read FIssuedOn write FIssuedOn;
    property DueOn: TDate read FDueOn write FDueOn;

    property Items: TInvoiceItems read FItems;
    property Payments: TInvoicePayments read FPayments;

    property TotalAmount: Double read GetTotalAmount;
    property AmountDue: Double read GetAmountDue;
    property AmountPaid: Double read GetAmountPaid;

    property Income: TIncome read FIncome;

  end;


implementation

{ TInvoiceItem }

function TInvoiceItem.GetTotalValue: Double;
begin
  Result := Quantity * Value;
end;

{ TInvoice }

constructor TInvoice.Create;
begin
  FItems := TInvoiceItems.Create;
  FPayments := TInvoicePayments.Create;
end;

destructor TInvoice.Destroy;
begin
  FPayments.Free;
  FItems.Free;

  inherited;
end;

function TInvoice.GetAmountDue: Double;
begin
  Result := TotalAmount - AmountPaid;
end;

function TInvoice.GetAmountPaid: Double;
begin
  Result := 0;

  for var LPayment in self.Payments do
  begin
    Result := Result + LPayment.FAmount;
  end;
end;

function TInvoice.GetTotalAmount: Double;
begin
  Result := 0;
  for var LItem in Items do
  begin
    Result := Result + LItem.TotalValue;
  end;
end;

procedure TInvoice.Process;
begin
  // only create income for amount that was paid
  if AmountPaid > 0 then
  begin

  end;

end;


initialization
  RegisterEntity(TInvoiceItem);
  RegisterEntity(TInvoice);

end.
