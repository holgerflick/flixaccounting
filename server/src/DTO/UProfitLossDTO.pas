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
unit UProfitLossDTO;

interface
uses
    Bcl.Json.Attributes
  , Bcl.Json.NamingStrategies

  , System.Generics.Collections
  , UProfitLoss
  , UInvoice
  ;

type

  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
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

  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
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

  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
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


end.
