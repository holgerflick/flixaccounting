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
unit UFrmReportProfitLoss;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Engine.ObjectManager

  , Data.DB

  , FireDAC.Comp.Client
  , FireDAC.Comp.DataSet
  , FireDAC.DApt.Intf
  , FireDAC.DatS
  , FireDAC.Phys.Intf
  , FireDAC.Stan.Error
  , FireDAC.Stan.Intf
  , FireDAC.Stan.Option
  , FireDAC.Stan.Param

  , System.Actions
  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , uFlxPanel
  , UFrmBase
  , UReportInterfaces
  , UReportManager
  ;


type
  TFrmReportProfitLoss = class(TFrmBase, IReportConfiguration)
    sourceIncome: TDataSource;
    FlxPanel1: TPanel;
    GridIncomeTx: TDBGrid;
    Label1: TLabel;
    Splitter1: TSplitter;
    GridIncome: TDBGrid;
    sourceIncomeTx: TDataSource;
    Splitter2: TSplitter;
    panExpense: TPanel;
    Label2: TLabel;
    Splitter3: TSplitter;
    GridExpenseTx: TDBGrid;
    GridExpense: TDBGrid;
    sourceExpense: TDataSource;
    sourceExpenseTx: TDataSource;
    FlxPanel2: TPanel;
    FlxPanel3: TPanel;
    Income: TAureliusDataset;
    IncomeTx: TAureliusDataset;
    IncomeSelf: TAureliusEntityField;
    IncomeId: TIntegerField;
    IncomeCategory: TStringField;
    IncomeSection: TIntegerField;
    IncomeTotal: TFloatField;
    IncomeTxSelf: TAureliusEntityField;
    IncomeTxId: TIntegerField;
    IncomeTxPaidOn: TDateTimeField;
    IncomeTxTitle: TStringField;
    IncomeTxAmount: TFloatField;
    IncomeTransactions: TDataSetField;
    txtTotalIncome: TLabel;
    txtTotalExpense: TLabel;
    Expense: TAureliusDataset;
    AureliusEntityField1: TAureliusEntityField;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    IntegerField2: TIntegerField;
    FloatField1: TFloatField;
    ExpenseTransactions: TDataSetField;
    ExpenseTx: TAureliusDataset;
    AureliusEntityField2: TAureliusEntityField;
    IntegerField3: TIntegerField;
    DateTimeField1: TDateTimeField;
    StringField2: TStringField;
    FloatField2: TFloatField;
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
    procedure Print;

    function GetName: String;
    procedure SaveToFile(AFilename: String);
    procedure SetHostControl(AControl: TWinControl);
    procedure SetRangeEnd(ADate: TDate);
    procedure SetRangeStart(ADate: TDate);

    function CanPrint: Boolean;
    function CanExport: Boolean;
  end;

var
  FrmReportProfitLoss: TFrmReportProfitLoss;

implementation

uses
    UDictionaryTemporary
  , UDataManager
  , UProfitLoss
  , UGridUtils
  ;

{$R *.dfm}

procedure TFrmReportProfitLoss.FormDestroy(Sender: TObject);
begin
  IncomeTx.Close;
  ExpenseTx.Close;
  Income.Close;
  Expense.Close;

  FReportManager.Free;
  FMemoryObjManager.Free;

  inherited;
end;

function TFrmReportProfitLoss.CanExport: Boolean;
begin
  Result := False;
end;

function TFrmReportProfitLoss.CanPrint: Boolean;
begin
  Result := False;
end;

procedure TFrmReportProfitLoss.Display;
var
  LProfitLoss: TProfitLoss;

begin
  IncomeTx.Close;
  Income.Close;

  ExpenseTx.Close;
  Expense.Close;

  FReportManager.RangeStart := self.RangeStart;
  FReportManager.RangeEnd := self.RangeEnd;

  LProfitLoss := FReportManager.GetProfitLoss( FMemoryObjManager );

  var LIncomeList := FMemoryObjManager.Find<TPLCategory>
    .Where(
      (DicTemp.PLCategory.Section = TPLSection.Income) AND
      (DicTemp.PLCategory.ProfitLoss.Id = LProfitLoss.Id)
      )
    .List
    ;

  var LExpenseList := FMemoryObjManager.Find<TPLCategory>
    .Where(
      (DicTemp.PLCategory.Section = TPLSection.Expense) AND
      (DicTemp.PLCategory.ProfitLoss.Id = LProfitLoss.Id)
      )
    .List
    ;

  Income.SetSourceList( LIncomeList, True );
  Expense.SetSourceList( LExpenseList, True );

  txtTotalIncome.Caption := Format( '%.2n', [ LProfitLoss.TotalIncome ] );
  txtTotalExpense.Caption := Format( '%.2n', [ LProfitLoss.TotalExpense ] );

  Income.Open;
  IncomeTx.Open;

  Expense.Open;
  ExpenseTx.Open;

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

procedure TFrmReportProfitLoss.Print;
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportProfitLoss.SaveToFile(AFilename: String);
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportProfitLoss.SetHostControl(AControl: TWinControl);
begin
  self.Parent := AControl;
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
