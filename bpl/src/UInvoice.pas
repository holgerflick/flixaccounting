unit UInvoice;

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
    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FInvoice')]
    FItems: Proxy<TInvoiceItems>;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FInvoice')]
    FPayments: Proxy<TInvoicePayments>;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll)]
    FIncomeItems: Proxy<TIncomes>;

    FId: Integer;

    [Column('Number', [TColumnProp.Unique] )]
    FNumber: Integer;
    FIssuedOn: TDate;
    FDueOn: TDate;

    procedure Process;

    function GetTotalAmount: Double;
    function GetAmountDue: Double;
    function GetAmountPaid: Double;
    function GetItems: TInvoiceItems;
    function GetPayments: TInvoicePayments;
    procedure SetItems(const Value: TInvoiceItems);
    procedure SetPayments(const Value: TInvoicePayments);
    function GetCanBeProcessed: Boolean;
    function GetIncomeItems: TIncomes;
    procedure SetIncomeItems(const Value: TIncomes);

  public
    constructor Create;
    destructor  Destroy; override;

    property Id: Integer read FId write FId;

    property Number: Integer read FNumber write FNumber;
    property IssuedOn: TDate read FIssuedOn write FIssuedOn;
    property DueOn: TDate read FDueOn write FDueOn;

    property Items: TInvoiceItems read GetItems write SetItems;
    property Payments: TInvoicePayments read GetPayments write SetPayments;

    property IncomeItems: TIncomes read GetIncomeItems write SetIncomeItems;

    property TotalAmount: Double read GetTotalAmount;
    property AmountDue: Double read GetAmountDue;
    property AmountPaid: Double read GetAmountPaid;

    property CanBeProcessed: Boolean read GetCanBeProcessed;

  end;


implementation
uses
  UExceptions
  ;

resourcestring
  SCannotProcessInvoice = 'Cannot process invoice  %d as not fully paid or no total amount.';


{ TInvoiceItem }

function TInvoiceItem.GetTotalValue: Double;
begin
  Result := Quantity * Value;
end;

{ TInvoice }

constructor TInvoice.Create;
begin
  inherited;

  FItems.SetInitialValue(TInvoiceItems.Create);
  FPayments.SetInitialValue(TInvoicePayments.Create);
  FIncomeItems.SetInitialValue(TIncomes.Create);
end;

destructor TInvoice.Destroy;
begin
  FIncomeItems.DestroyValue;
  FPayments.DestroyValue;
  FItems.DestroyValue;

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

function TInvoice.GetCanBeProcessed: Boolean;
begin
  Result := (AmountDue = 0) and (TotalAmount>0) and (IncomeItems.Count=0)
end;

function TInvoice.GetIncomeItems: TIncomes;
begin
  Result := FIncomeItems.Value;
end;

function TInvoice.GetItems: TInvoiceItems;
begin
  Result := FItems.Value;
end;

function TInvoice.GetPayments: TInvoicePayments;
begin
  Result := FPayments.Value;
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
  // only allow processing if all has been paid
  // -- otherwise it is tough to decide which items have been paid
  //    and which have not
  if not CanBeProcessed then
  begin
    raise ECannotProcessInvoice.CreateFmt(SCannotProcessInvoice, [self.Number]);
  end;
end;

procedure TInvoice.SetIncomeItems(const Value: TIncomes);
begin
  FIncomeItems.Value := Value;
end;

procedure TInvoice.SetItems(const Value: TInvoiceItems);
begin
  FItems.Value := Value;
end;

procedure TInvoice.SetPayments(const Value: TInvoicePayments);
begin
  FPayments.Value := Value;
end;

initialization
  RegisterEntity(TInvoiceItem);
  RegisterEntity(TInvoice);

end.
