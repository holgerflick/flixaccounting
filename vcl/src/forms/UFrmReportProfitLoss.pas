unit UFrmReportProfitLoss;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, UReportInterfaces, Data.DB,
  Vcl.Grids, Vcl.DBGrids  , UReportManager, Vcl.ExtCtrls, Vcl.StdCtrls,
  uFlxPanel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls
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

  public
    property RangeStart: TDate read FRangeStart write FRangeStart;
    property RangeEnd: TDate read FRangeEnd write FRangeEnd;

    procedure BuildReport;
    function GetName: String;
    procedure SaveToFile(AFilename: String);
    procedure SetParent(AComponent: TWinControl);
    procedure SetRangeEnd(ADate: TDate);
    procedure SetRangeStart(ADate: TDate);
    procedure SetVisible(AVisible: Boolean);

  end;

var
  FrmReportProfitLoss: TFrmReportProfitLoss;

implementation

{$R *.dfm}



procedure TFrmReportProfitLoss.FormDestroy(Sender: TObject);
begin
  FReportManager.Free;

  inherited;
end;

procedure TFrmReportProfitLoss.FormCreate(Sender: TObject);
begin
  inherited;

  FReportManager := TReportManager.Create(ObjectManager);
end;

procedure TFrmReportProfitLoss.BuildReport;
begin
  FReportManager.RangeStart := self.RangeStart;
  FReportManager.RangeEnd := self.RangeEnd;
  FReportManager.BuildProfitLoss(Income, Expense);
end;

function TFrmReportProfitLoss.GetName: String;
begin
  Result := 'Profit and Loss';
end;

procedure TFrmReportProfitLoss.SaveToFile(AFilename: String);
begin
  //
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

procedure TFrmReportProfitLoss.SetVisible(AVisible: Boolean);
begin
  Visible := AVisible;
end;

end.
