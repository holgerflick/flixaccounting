unit UInvoiceDTO;

interface

uses
    System.Generics.Collections

  , UInvoice
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

(*

    function Transactions(AId, AToken: String): TInvoiceTransactionsDTO;
    function Payments(AId, AToken: String): TInvoicePaymentsDTO;
    function Items(AId, AToken: String): TInvoiceItemsDTO;
    *)

  TInvoiceTransactionDTO = class

  end;

  TInvoicePaymentDTO = class

  end;

  TInvoiceItemDTO = class

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


end.
