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


  , UTransaction
  , UCustomer

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

  TInvoicePayments = class( TList<TInvoicePayment> )
  public
    function LastPaymentDate: NullableDate;
  end;

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
    FTransactions: Proxy<TTransactions>;

    FId: Integer;

    [Column('Number', [TColumnProp.Unique] )]
    FNumber: Integer;
    FIssuedOn: TDate;
    FDueOn: TDate;

    [Association([TAssociationProp.Lazy], CascadeTypeAllButRemove )]
    FCustomer: Proxy<TCustomer>;

    procedure Process;

    function GetTotalAmount: Double;
    function GetAmountDue: Double;
    function GetAmountPaid: Double;
    function GetItems: TInvoiceItems;
    function GetPayments: TInvoicePayments;
    procedure SetItems(const Value: TInvoiceItems);
    procedure SetPayments(const Value: TInvoicePayments);
    function GetCanBeProcessed: Boolean;
    function GetTransactions: TTransactions;
    procedure SetTransactions(const Value: TTransactions);
    function GetCanModify: Boolean;
    function GetCustomer: TCustomer;
    procedure SetCustomer(const Value: TCustomer);

  public
    constructor Create;
    destructor  Destroy; override;

    property Id: Integer read FId write FId;

    property Number: Integer read FNumber write FNumber;
    property IssuedOn: TDate read FIssuedOn write FIssuedOn;
    property DueOn: TDate read FDueOn write FDueOn;

    property Customer: TCustomer read GetCustomer write SetCustomer;

    property Items: TInvoiceItems read GetItems write SetItems;
    property Payments: TInvoicePayments
      read GetPayments write SetPayments;

    property Transactions: TTransactions
      read GetTransactions write SetTransactions;

    property TotalAmount: Double read GetTotalAmount;
    property AmountDue: Double read GetAmountDue;
    property AmountPaid: Double read GetAmountPaid;

    property CanBeProcessed: Boolean read GetCanBeProcessed;
    property CanModify: Boolean read GetCanModify;

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
  FTransactions.SetInitialValue(TTransactions.Create);
end;

destructor TInvoice.Destroy;
begin
  FTransactions.DestroyValue;
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
  Result := (AmountDue = 0) and (TotalAmount>0) and (Transactions.Count=0)
end;

function TInvoice.GetCanModify: Boolean;
begin
  Result := Transactions.Count = 0;
end;

function TInvoice.GetCustomer: TCustomer;
begin
  Result := FCustomer.Value;
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

function TInvoice.GetTransactions: TTransactions;
begin
  Result := FTransactions.Value;
end;

procedure TInvoice.Process;
var
  LTxCats : TDictionary<String, TTransaction>;
  LTx: TTransaction;

begin
  // only allow processing if all has been paid
  // -- otherwise it is tough to decide which items have been paid
  //    and which have not
  if not CanBeProcessed then
  begin
    raise ECannotProcessInvoice.CreateFmt(SCannotProcessInvoice, [self.Number]);
  end;

  // get last payment for paid on date
  var LLastPayment := self.Payments.LastPaymentDate;

  if LLastPayment.IsNull then
  begin
    raise ECannotProcessInvoice.CreateFmt('No payments found. (%d)', [self.Number] );
  end;

  // process each category in invoice as one transaction
  // thus we create a transaction for each category and add total amounts

  LTxCats := TDictionary<String, TTransaction>.Create;

  for var LItem in self.Items do
  begin
    var LCurrentCat := LItem.Category;
    if not LTxCats.ContainsKey(LCurrentCat) then
    begin
      LTx := TTransaction.Create(TTransactionKind.Income);
      LTx.Amount := 0;
      LTx.IsMonthly := False;
      LTx.Percentage := 1;
      LTxCats.Add( LCurrentCat, LTx );
    end
    else
    begin
      LTx := LTxCats[LCurrentCat];
    end;

    LTx.PaidOn := self.Payments.LastPaymentDate;
    LTx.Category := LItem.Category;
    LTx.Title := 'Invoice ' + self.Number.ToString;
    LTx.Amount := LTx.Amount + LItem.TotalValue;
  end;

  // add all transactions to invoice
  // this will lock it from any further processing
  for LTx in LTxCats.Values do
  begin
    self.Transactions.Add(LTx)
  end;
end;

procedure TInvoice.SetCustomer(const Value: TCustomer);
begin
  FCustomer.Value := Value;
end;

procedure TInvoice.SetItems(const Value: TInvoiceItems);
begin
  FItems.Value := Value;
end;

procedure TInvoice.SetPayments(const Value: TInvoicePayments);
begin
  FPayments.Value := Value;
end;

procedure TInvoice.SetTransactions(const Value: TTransactions);
begin
  FTransactions.Value := Value;
end;

{ TInvoicePayments }

function TInvoicePayments.LastPaymentDate: NullableDate;
begin
  Result := SNull;

  for var LPayment in self do
  begin
    if Result.IsNull then
    begin
      Result := LPayment.PaidOn;
    end
    else
    begin
      if Result < LPayment.PaidOn then
      begin
        Result := LPayment.PaidOn;
      end;
    end;
  end;
end;

initialization
  RegisterEntity(TInvoiceItem);
  RegisterEntity(TInvoice);

end.
