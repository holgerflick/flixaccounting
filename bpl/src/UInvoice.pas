{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
unit UInvoice;

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


  , UTransaction
  , UCustomer
  , UApi

  ;

type
  TInvoice = class;

  [Automapping]
  TInvoiceStatus = (
    ReadyItems,
    ReadyPayments,
    ReadyProcess,
    Processed,
    Overpaid );

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
    constructor Create;

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
  TQuickItem = class
  private
    FCategory: String;

    [Column('Name', [TColumnProp.Unique])]
    FName: String;
    FId: Integer;
    FQuantity: Double;
    FValue: Double;
    FDescription: String;
  public
    property Id: Integer read FId write FId;

    property Name: String read FName write FName;
    property Description: String read FDescription write FDescription;
    property Category: String read FCategory write FCategory;
    property Quantity: Double read FQuantity write FQuantity;
    property Value: Double read FValue write FValue;
  end;

  [Entity]
  [Automapping]
  TInvoiceItem = class
  private
    FId: Integer;

    [Association([], CascadeTypeAllButRemove)]
    FInvoice: TInvoice;

    FIdx: Integer;

    [Column('DESCRIPTION',[], 5000)]
    FDescription: String;
    FQuantity: Double;
    FValue: Double;
    FCategory: String;

    function GetTotalValue: Double;

  public
    property Id: Integer read FId write FId;
    property Idx: Integer read FIdx write FIdx;
    property Category: String read FCategory write FCategory;
    property Description: String read FDescription write FDescription;
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
    [OrderBy('Idx')]
    FItems: Proxy<TInvoiceItems>;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FInvoice')]
    [OrderBy('PaidOn')]
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

    [Column('ProcessedCopy', [TColumnProp.Lazy])]
    FProcessedCopy: TBlob;

    [Association([], CascadeTypeAllRemoveOrphan)]
    FApiToken: TApiToken;

    function GetTotalAmount: Double;
    function GetAmountDue: Double;
    function GetAmountPaid: Double;
    function GetItems: TInvoiceItems;
    function GetPayments: TInvoicePayments;
    function GetCanBeProcessed: Boolean;
    function GetTransactions: TTransactions;
    function GetCanModify: Boolean;
    function GetCustomer: TCustomer;
    procedure SetCustomer(const Value: TCustomer);
    function GetBillTo: String;
    function GetStatus: TInvoiceStatus;
    function GetStatusText: String;

  public
    constructor Create;
    destructor  Destroy; override;

    function NextItemIndex: Integer;

    property Id: Integer read FId write FId;

    property Number: Integer read FNumber write FNumber;
    property IssuedOn: TDate read FIssuedOn write FIssuedOn;
    property DueOn: TDate read FDueOn write FDueOn;

    property Customer: TCustomer read GetCustomer write SetCustomer;

    property ApiToken: TApiToken read FApiToken write FApiToken;

    property Items: TInvoiceItems read GetItems;
    property Payments: TInvoicePayments
      read GetPayments;

    property Transactions: TTransactions
      read GetTransactions;

    property TotalAmount: Double read GetTotalAmount;
    property AmountDue: Double read GetAmountDue;
    property AmountPaid: Double read GetAmountPaid;

    property ProcessedCopy: TBlob read FProcessedCopy write FProcessedCopy;

    property BillTo: String read GetBillTo;

    property Status: TInvoiceStatus read GetStatus;
    property StatusText: String read GetStatusText;
    property CanBeProcessed: Boolean read GetCanBeProcessed;
    property CanModify: Boolean read GetCanModify;
  end;


implementation
uses
    System.DateUtils
  , UExceptions
  ;

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

  FIssuedOn := TDateTime.Today;
  FDueOn := TDateTime.Now.IncDay(7);
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

function TInvoice.GetBillTo: String;
begin
  Result := '';

  if Assigned( self.Customer ) then
  begin
    Result := self.Customer.AddressExcel;
  end;
end;

function TInvoice.GetCanBeProcessed: Boolean;
begin
  Result :=
    (AmountDue = 0) and
    (TotalAmount>0) and
    (Transactions.Count=0) and
    (Payments.Count>0);
end;

function TInvoice.GetCanModify: Boolean;
begin
  Result := (Transactions.Count = 0) AND (Payments.Count = 0);
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

function TInvoice.GetStatus: TInvoiceStatus;
begin
  Result := TInvoiceStatus.ReadyItems;
  if self.TotalAmount > 0 then
  begin
    if self.AmountDue > 0 then
    begin
      Result := TInvoiceStatus.ReadyPayments;
    end
    else
    begin
      if self.AmountDue < 0 then
      begin
        Result := TInvoiceStatus.Overpaid;
      end
      else
      begin
        if self.Transactions.Count=0 then
        begin
          Result := TInvoiceStatus.ReadyProcess;
        end
        else
        begin
          Result := TInvoiceStatus.Processed;
        end;
      end;
    end;
  end;
end;

function TInvoice.GetStatusText: String;
begin
  case Status of
    TInvoiceStatus.ReadyItems: Result := 'Add items';
    TInvoiceStatus.ReadyPayments: Result := 'Make payments';
    TInvoiceStatus.ReadyProcess: Result := 'Ready to process';
    TInvoiceStatus.Processed: Result := 'Processed';
    TInvoiceStatus.Overpaid: Result := 'Overpaid';
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

function TInvoice.GetTransactions: TTransactions;
begin
  Result := FTransactions.Value;
end;

function TInvoice.NextItemIndex: Integer;
var
  LMax: Integer;

begin
  LMax := 1;
  for var LItem in self.Items do
  begin
    if LItem.Idx > LMax then
    begin
      LMax := LItem.Idx+1;
    end;
  end;

  Result := LMax;
end;

procedure TInvoice.SetCustomer(const Value: TCustomer);
begin
  FCustomer.Value := Value;
end;

{ TInvoicePayments }

function TInvoicePayments.LastPaymentDate: NullableDate;
begin
  if self.Count=0 then
  begin
    Result := SNull;
    Exit;
  end;

  Result := self.Items[0].PaidOn;

  for var i := 1 to self.Count-1 do
  begin
    var LPayment := self.Items[i];
    if Result < LPayment.PaidOn then
    begin
      Result := LPayment.PaidOn;
    end;
  end;
end;

{ TInvoicePayment }

constructor TInvoicePayment.Create;
begin
  FPaidOn := TDateTime.Today;
end;

initialization
  RegisterEntity(TQuickItem);
  RegisterEntity(TInvoiceItem);
  RegisterEntity(TInvoice);

end.
