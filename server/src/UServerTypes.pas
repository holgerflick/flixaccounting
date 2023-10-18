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
unit UServerTypes;

interface
uses
    Bcl.Json.Attributes
  , Bcl.Json.NamingStrategies

  , System.Generics.Collections
  , UProfitLoss
  , UInvoice
  ;

type

  TPLTransactionDTO = class
  private
    FTitle: String;
    FAmount: Double;
    FPaidOn: TDateTime;
  public
    constructor Create( APLTx: TPLTransaction );

    property PaidOn: TDateTime read FPaidOn;
    property Title: String read FTitle;
    property Amount: Double read FAmount;
  end;

  TPLTransactionsDTO = TObjectList<TPLTransactionDTO>;

  TPLCategoryDTO = class
  private
    FTransactions: TPLTransactionsDTO;
    FTotal: Double;
    FSection: TPLSection;
    FCategory: String;

  public
    constructor Create( APLCategory: TPLCategory );
    destructor Destroy; override;

    procedure TransferFrom(APLCategory: TPLCategory);

    property Category: String read FCategory;
    property Section: TPLSection read FSection;

    property Total: Double read FTotal;
    property Transactions: TPLTransactionsDTO read FTransactions;
  end;

  TPLCategoriesDTO = TObjectList<TPLCategoryDTO>;

  TProfitLossDTO = class
  private
    FCreated: TDateTime;
    FTotalIncome: Double;
    FTotalExpense: Double;

    FCategories: TPLCategoriesDTO;
  public
    constructor Create( AProfitLoss: TProfitLoss );
    destructor Destroy; override;

    procedure TransferFrom(AProfitLoss: TProfitLoss);

    property Created: TDateTime read FCreated;
    property Categories: TPLCategoriesDTO read FCategories;

    property TotalIncome: Double read FTotalIncome;
    property TotalExpense: Double read FTotalExpense;
  end;

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

  TInvoiceDetailsDTO = class

  end;

implementation

{ TProfitLossDTO }

constructor TProfitLossDTO.Create(AProfitLoss: TProfitLoss);
begin
  inherited Create;

  FCategories := TPLCategoriesDTO.Create;

  TransferFrom(AProfitLoss);
end;


destructor TProfitLossDTO.Destroy;
begin
  FCategories.Free;

  inherited;
end;

procedure TProfitLossDTO.TransferFrom(AProfitLoss: TProfitLoss);
begin
  FCreated := AProfitLoss.Created;
  FTotalIncome := AProfitLoss.TotalIncome;
  FTotalExpense := AProfitLoss.TotalExpense;

  for var LCat in AProfitLoss.Categories do
  begin
    Categories.Add( TPLCategoryDTO.Create( LCat ) );
  end;
end;

{ TPLCategoryDTO }

constructor TPLCategoryDTO.Create(APLCategory: TPLCategory);
begin
  inherited Create;

  FTransactions := TPLTransactionsDTO.Create;

  TransferFrom(APLCategory);
end;

destructor TPLCategoryDTO.Destroy;
begin
  FTransactions.Free;

  inherited;
end;

procedure TPLCategoryDTO.TransferFrom(APLCategory: TPLCategory);
begin
  FTotal := APLCategory.Total;
  FSection := APLCategory.Section;
  FCategory := APLCategory.Category;

  for var LTx in APLCategory.Transactions do
  begin
    self.Transactions.Add( TPLTransactionDTO.Create( LTx ) );
  end;
end;

{ TPLTransactionDTO }

constructor TPLTransactionDTO.Create(APLTx: TPLTransaction);
begin
  inherited Create;

  FPaidOn := APLTx.PaidOn;
  FAmount := APLTx.Amount;
  FTitle := APLTx.Title;
end;

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
