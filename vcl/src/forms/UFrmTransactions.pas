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
unit UFrmTransactions;

interface

uses
    AdvGrid
  , AdvObj
  , AdvUtil
  , AsgLinks

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Linq

  , BaseGrid

  , Data.DB

  , DBAdvGrid

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.Menus
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  , UTransaction, System.Actions, Vcl.ActnList
  ;


type
  TFrmTransactions = class(TFrmBase)
    dbTransactions: TAureliusDataset;
    dbTransactionsSelf: TAureliusEntityField;
    dbTransactionsId: TIntegerField;
    dbTransactionsPaidOn: TDateTimeField;
    dbTransactionsIsMonthly: TBooleanField;
    dbTransactionsCategory: TStringField;
    dbTransactionsTitle: TStringField;
    dbTransactionsAmount: TFloatField;
    dbTransactionsDocument: TAureliusEntityField;
    dbTransactionsYear: TIntegerField;
    dbTransactionsMonth: TIntegerField;
    dbTransactionsMonthsPaid: TIntegerField;
    dbTransactionsAmountTotal: TFloatField;
    sourceTransactions: TDataSource;
    Grid: TDBAdvGrid;
    btnImport: TButton;
    DlgOpen: TFileOpenDialog;
    rbFilterKind: TRadioGroup;
    popTxKind: TPopupMenu;
    menTxKindIncome: TMenuItem;
    menTxKindExpenses: TMenuItem;
    DBNavigator1: TDBNavigator;
    dbTransactionsKindEnumName: TStringField;
    procedure btnImportClick(Sender: TObject);
    procedure dbTransactionsNewRecord(DataSet: TDataSet);
    procedure dbTransactionsPercentageGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
    procedure dbTransactionsPercentageSetText(Sender: TField; const Text: string);

    procedure FormCreate(Sender: TObject);
    procedure menTxKindExpensesClick(Sender: TObject);
    procedure rbFilterKindClick(Sender: TObject);

  private
    { Private declarations }
    function GetFilterTxKind: TTransactionKind;

    procedure ImportFromFolder(AKind: TTransactionKind);
    procedure OpenDataset;
    procedure InitGrid;

  public
    { Public declarations }

    property FilterKind: TTransactionKind read GetFilterTxKind;
  end;

implementation

{$R *.dfm}

uses
    System.Types
  , UAppGlobals
  , UFrmReportImport
  , UGridUtils

  , UDataImportManager
  , UDictionary
  ;

resourcestring
  SCaption = 'List of all transactions';

procedure TFrmTransactions.btnImportClick(Sender: TObject);
var
  LP: TPoint;

begin
  LP := btnImport.ClientToScreen( Point( 0, btnImport.ClientHeight ) );
  popTxKind.Popup( LP.X, LP.Y );
end;

procedure TFrmTransactions.dbTransactionsNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('IsMonthly').AsBoolean := False;

  if FilterKind = TTransactionKind.Income then
    DataSet.FieldByName('Kind.EnumName').AsString := 'Income'
  else
    DataSet.FieldByName('Kind.EnumName').AsString := 'Expense';

end;

procedure TFrmTransactions.dbTransactionsPercentageGetText(Sender: TField; var Text:
    string; DisplayText: Boolean);
begin
  Text := FloatToStr(Sender.AsFloat * 100);
end;

procedure TFrmTransactions.dbTransactionsPercentageSetText(Sender: TField; const Text:
    string);
begin
  Sender.AsFloat := StrToInt(Text) / 100;
end;

procedure TFrmTransactions.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := SCaption;

  OpenDataset;

  InitGrid;
end;

procedure TFrmTransactions.ImportFromFolder( AKind: TTransactionKind );
var
  LPath: String;

begin
  if DlgOpen.Execute then
  begin
    LPath := DlgOpen.FileName;
    var LImport := TDataImportManager.Create(self.ObjectManager);
    try
      LImport.ImportTransactionsFromFolder(AKind, LPath);

      // show report only if there are errors or duplicates
      if LImport.HasNoErrors = False then
      begin
        var LReport := TFrmReportImport.Create(self, LImport );
        try
          LReport.ShowModal;
        finally
          LReport.Free;
        end;
      end;

      OpenDataset;

    finally
      LImport.Free;
    end;
  end;
end;

procedure TFrmTransactions.InitGrid;
begin
  TGridUtils.UseMonospaceFont(Grid.Columns);
  TGridUtils.UseDefaultHeaderFont(Grid.Columns);
end;

procedure TFrmTransactions.OpenDataset;
begin
  var LCriteria := self.ObjectManager
    .Find<TTransaction>
    .OrderBy(Dic.Transaction.PaidOn, False)
    ;

  if FilterKind <> TTransactionKind.All then
  begin
    LCriteria.Add( Dic.Transaction.Kind = FilterKind );
  end;

  dbTransactions.Close;
  dbTransactions.DefaultsFromObject := True;
  dbTransactions.Manager := self.ObjectManager;
  dbTransactions.SetSourceCriteria( LCriteria );
  dbTransactions.Active := True;
end;

function TFrmTransactions.GetFilterTxKind: TTransactionKind;
begin
  Result := TTransactionKind.All;

  case rbFilterKind.ItemIndex of
    0 : Result := TTransactionKind.Income;
    1 : Result := TTransactionKind.Expense;
  end;
end;

procedure TFrmTransactions.menTxKindExpensesClick(Sender: TObject);
begin
  Assert(Sender is TMenuItem);

  ImportFromFolder(TTransactionKind(TMenuItem(Sender).Tag));
end;

procedure TFrmTransactions.rbFilterKindClick(Sender: TObject);
begin
  OpenDataset;
end;

end.
