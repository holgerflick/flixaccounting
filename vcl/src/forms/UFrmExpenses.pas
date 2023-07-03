unit UFrmExpenses;

interface

uses
  UFrmBase
  , Winapi.Windows
  , Winapi.Messages
  , System.SysUtils
  , System.Variants
  , System.Classes
  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.StdCtrls

  , Data.DB

  , Vcl.Grids
  , Vcl.DBGrids

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Linq

  , UExpense

  , AdvUtil
  , AdvObj
  , AsgLinks
  , AdvGrid
  , BaseGrid
  , DBAdvGrid

  ;

type
  TFrmExpenses = class(TFrmBase)
    dbExpenses: TAureliusDataset;
    dbExpensesSelf: TAureliusEntityField;
    dbExpensesId: TIntegerField;
    dbExpensesPaidOn: TDateTimeField;
    dbExpensesIsMonthly: TBooleanField;
    dbExpensesCategory: TStringField;
    dbExpensesTitle: TStringField;
    dbExpensesAmount: TFloatField;
    dbExpensesPercentage: TFloatField;
    dbExpensesDocument: TAureliusEntityField;
    dbExpensesYear: TIntegerField;
    dbExpensesMonth: TIntegerField;
    dbExpensesMonthsPaid: TIntegerField;
    dbExpensesAmountTotal: TFloatField;
    sourceExpenses: TDataSource;
    Expenses: TDBAdvGrid;
    btnImport: TButton;

    procedure dbExpensesPercentageGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
    procedure dbExpensesPercentageSetText(Sender: TField; const Text: string);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmExpenses: TFrmExpenses;

implementation

{$R *.dfm}



procedure TFrmExpenses.dbExpensesPercentageGetText(Sender: TField; var Text:
    string; DisplayText: Boolean);
begin
  Text := FloatToStr(Sender.AsFloat * 100);
end;

procedure TFrmExpenses.dbExpensesPercentageSetText(Sender: TField; const Text:
    string);
begin
  Sender.AsFloat := StrToInt(Text) / 100;
end;

procedure TFrmExpenses.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'List of all expenses';
  dbExpenses.Manager := self.ObjectManager;
  dbExpenses.SetSourceCriteria( self.ObjectManager
    .Find<TExpense>
    .OrderBy(Linq['PaidOn'], False)
   );
  dbExpenses.Active := True;
end;

end.
