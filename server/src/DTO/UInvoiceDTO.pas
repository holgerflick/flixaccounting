unit UInvoiceDTO;

interface

uses
    Bcl.Json.Attributes
  , Bcl.Json.NamingStrategies

  , System.Generics.Collections

  , UInvoice
  , UTransaction
  ;

type
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TInvoiceDTO = class
  private
    FId: Integer;
    FNumber: Integer;
    FDueOn: TDate;
    FCustomerName: String;
    FIssuedOn: TDate;
    FAmountPaid: Double;
    FCanModify: Boolean;
    FAmountDue: Double;
    FStatusText: String;
    FBillTo: String;
    FCanBeProcessed: Boolean;
    FTotalAmount: Double;

  private
    procedure Transfer( AInvoice: TInvoice );
  public
    constructor Create( AInvoice: TInvoice );

    property Id: Integer read FId write FId;
    property Number: Integer read FNumber write FNumber;
    property CustomerName: String read FCustomerName write FCustomerName;
    property IssuedOn: TDate read FIssuedOn write FIssuedOn;
    property DueOn: TDate read FDueOn write FDueOn;
    property StatusText: String read FStatusText write FStatusText;
    property TotalAmount: Double read FTotalAmount write FTotalAmount;
    property AmountDue: Double read FAmountDue write FAmountDue;
    property AmountPaid: Double read FAmountPaid write FAmountPaid;
    property BillTo: String read FBillTo write FBillTo;
    property CanBeProcessed: Boolean read FCanBeProcessed write FCanBeProcessed;
    property CanModify: Boolean read FCanModify write FCanModify;
  end;

  TInvoicesDTO = TList<TInvoiceDTO>;

  TInvoiceTransactionDTO = class
  private
    FId: Integer;
    FKind: TTransactionKind;
    FPaidOn: TDateTime;
    FCategory: String;
    FTitle: String;
    FAmountTotal: Double;
  public
    constructor Create( ATx: TTransaction );

    property Id: Integer read FId write FId;
    property Kind: TTransactionKind read FKind write FKind;
    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property AmountTotal: Double read FAmountTotal write FAmountTotal;

  end;

  TInvoicePaymentDTO = class
  private
    FId: Integer;
    FPaidOn: TDateTime;
    FAmount: Double;
  public
    constructor Create( APayment: TInvoicePayment );

    property Id: Integer read FId write FId;
    property PaidOn: TDateTime read FPaidOn write FPaidOn;
    property Amount: Double read FAmount write FAmount;
  end;

  TInvoiceItemDTO = class
  private
    FId: Integer;
    FIdx: Integer;
    FCategory: String;
    FQuantity: Double;
    FValue: Double;
    FTotalValue: Double;
  public
    constructor Create(AItem: TInvoiceItem);

    property Id: Integer read FId write FId;
    property Idx: Integer read FIdx write FIdx;
    property Category: String read FCategory write FCategory;
    property Quantity: Double read FQuantity write FQuantity;
    property Value: Double read FValue write FValue;
    property TotalValue: Double read FTotalValue write FTotalValue;
  end;

  TInvoiceTransactionsDTO = TList<TInvoiceTransactionDTO>;
  TInvoicePaymentsDTO = TList<TInvoicePaymentDTO>;
  TInvoiceItemsDTO = TList<TInvoiceItemDTO>;

implementation

{ TInvoiceDTO }

constructor TInvoiceDTO.Create(AInvoice: TInvoice);
begin
  inherited Create;

  Transfer(AInvoice);
end;

procedure TInvoiceDTO.Transfer(AInvoice: TInvoice);
begin
  Id := AInvoice.Id;
  Number := AInvoice.Number;
  IssuedOn := AInvoice.IssuedOn;
  DueOn := AInvoice.DueOn;
  TotalAmount := AInvoice.TotalAmount;
  AmountDue := AInvoice.AmountDue;
  AmountPaid := AInvoice.AmountPaid;
  BillTo := AInvoice.BillTo;
  StatusText := AInvoice.StatusText;
  CanBeProcessed := AInvoice.CanBeProcessed;
  CanModify := AInvoice.CanBeProcessed;
  CustomerName := AInvoice.Customer.Name;
end;

{ TInvoiceItemDTO }

constructor TInvoiceItemDTO.Create(AItem: TInvoiceItem);
begin
  inherited Create;

  self.Id := AItem.Id;
  self.Idx := AItem.Idx;
  self.Category := AItem.Category;
  self.Quantity := AItem.Quantity;
  self.Value := AItem.Value;
  self.TotalValue := AItem.TotalValue;
end;

{ TInvoicePaymentDTO }

constructor TInvoicePaymentDTO.Create(APayment: TInvoicePayment);
begin
  inherited Create;

  self.Id := APayment.Id;
  self.PaidOn := APayment.PaidOn;
  self.Amount := APayment.Amount;
end;

{ TInvoiceTransactionDTO }

constructor TInvoiceTransactionDTO.Create(ATx: TTransaction);
begin
  inherited Create;

  self.Id := ATx.Id;
  self.Kind := ATx.Kind;
  self.PaidOn := ATx.PaidOn;
  self.Category := ATx.Category;
  self.Title := ATx.Title;
  self.AmountTotal := ATx.AmountTotal;
end;

end.
