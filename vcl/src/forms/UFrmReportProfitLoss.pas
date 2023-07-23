unit UFrmReportProfitLoss;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, UReportInterfaces, Data.DB,
  Vcl.Grids, Vcl.DBGrids  , UReportManager, Vcl.ExtCtrls, Vcl.StdCtrls,
  uFlxPanel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls,
  Aurelius.Engine.ObjectManager
  ;

type
  TFrmReportProfitLoss = class(TFrmBase, IReportConfiguration)
    sourceIncome: TDataSource;
    FlxPanel1: TFlxPanel;
    GridIncomeTx: TDBGrid;
    Label1: TLabel;
    Splitter1: TSplitter;
    GridIncome: TDBGrid;
    sourceIncomeTx: TDataSource;
    Splitter2: TSplitter;
    panExpense: TFlxPanel;
    Label2: TLabel;
    Splitter3: TSplitter;
    GridExpenseTx: TDBGrid;
    GridExpense: TDBGrid;
    sourceExpense: TDataSource;
    sourceExpenseTx: TDataSource;
    Income: TFDMemTable;
    IncomeCategory: TStringField;
    IncomeTotal: TFloatField;
    IncomeTransactions: TDataSetField;
    IncomeTxCount: TIntegerField;
    TxIncome: TFDMemTable;
    TxIncomePaidOn: TDateField;
    TxIncomeTitle: TStringField;
    TxIncomeAmount: TFloatField;
    TxIncomeTxId: TIntegerField;
    Expense: TFDMemTable;
    ExpenseCategory: TStringField;
    ExpenseTotal: TFloatField;
    ExpenseTransactions: TDataSetField;
    ExpenseTxCount: TIntegerField;
    TxExpense: TFDMemTable;
    TxExpensePaidOn: TDateField;
    TxExpenseTitle: TStringField;
    TxExpenseAmount: TFloatField;
    TxExpenseTxId: TIntegerField;
    IncomeIsLoss: TBooleanField;
    ExpenseIsLoss: TBooleanField;
    IncomeSumTotal: TAggregateField;
    ExpenseSumTotal: TAggregateField;
    FlxPanel2: TFlxPanel;
    DBText1: TDBText;
    FlxPanel3: TFlxPanel;
    DBText2: TDBText;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRangeStart: TDate;
    FRangeEnd: TDate;
    FReportManager: TReportManager;
    FMemoryObjManager: TObjectManager;

  public
    property RangeStart: TDate read FRangeStart write FRangeStart;
    property RangeEnd: TDate read FRangeEnd write FRangeEnd;

    procedure Display;
    procedure Preview;

    function GetName: String;
    procedure SaveToFile(AFilename: String);
    procedure SetParent(AComponent: TWinControl);
    procedure SetRangeEnd(ADate: TDate);
    procedure SetRangeStart(ADate: TDate);

    function CanPreview: Boolean;
    function CanExport: Boolean;
  end;

var
  FrmReportProfitLoss: TFrmReportProfitLoss;

implementation

uses
    UDataManager
  , UProfitLoss
  ;

{$R *.dfm}



procedure TFrmReportProfitLoss.FormDestroy(Sender: TObject);
begin
  FReportManager.Free;
  FMemoryObjManager.Free;

  inherited;
end;

function TFrmReportProfitLoss.CanExport: Boolean;
begin
  Result := False;
end;

function TFrmReportProfitLoss.CanPreview: Boolean;
begin
  Result := False;
end;

procedure TFrmReportProfitLoss.Display;
var
  LProfitLoss: TProfitLoss;

begin
  FReportManager.RangeStart := self.RangeStart;
  FReportManager.RangeEnd := self.RangeEnd;
//  FReportManager.BuildProfitLoss(Income, Expense);
  LProfitLoss := FReportManager.GetProfitLoss( FMemoryObjManager );
  self.Visible := True;
end;

procedure TFrmReportProfitLoss.FormCreate(Sender: TObject);
begin
  inherited;

  FReportManager := TReportManager.Create(ObjectManager);
  FMemoryObjManager := TDataManager.Shared.MemoryObjectManager;
end;

function TFrmReportProfitLoss.GetName: String;
begin
  Result := 'Profit and Loss';
end;

procedure TFrmReportProfitLoss.Preview;
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportProfitLoss.SaveToFile(AFilename: String);
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportProfitLoss.SetParent(AComponent: TWinControl);
begin
  self.Parent := AComponent;
end;

procedure TFrmReportProfitLoss.SetRangeEnd(ADate: TDate);
begin
  FRangeEnd := ADate;
end;

procedure TFrmReportProfitLoss.SetRangeStart(ADate: TDate);
begin
  FRangeStart := ADate;
end;

end.
