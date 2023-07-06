unit UFrmTransactions;

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

  , AdvUtil
  , AdvObj
  , AsgLinks
  , AdvGrid
  , BaseGrid
  , DBAdvGrid

  ;

type
  TFrmTransactions = class(TFrmBase)
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
    DlgOpen: TFileOpenDialog;
    procedure btnImportClick(Sender: TObject);
    procedure dbExpensesPercentageGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
    procedure dbExpensesPercentageSetText(Sender: TField; const Text: string);

    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ImportFromFolder;
    procedure OpenDataset;
  public
    { Public declarations }
  end;

var
  FrmTransactions: TFrmTransactions;

implementation

{$R *.dfm}

uses
    UFrmReportImport

  , UDataImportManager
  , UTransaction
  ;


procedure TFrmTransactions.btnImportClick(Sender: TObject);
begin
  ImportFromFolder;
end;

procedure TFrmTransactions.dbExpensesPercentageGetText(Sender: TField; var Text:
    string; DisplayText: Boolean);
begin
  Text := FloatToStr(Sender.AsFloat * 100);
end;

procedure TFrmTransactions.dbExpensesPercentageSetText(Sender: TField; const Text:
    string);
begin
  Sender.AsFloat := StrToInt(Text) / 100;
end;

procedure TFrmTransactions.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'List of all expenses';

  OpenDataset;
end;

procedure TFrmTransactions.ImportFromFolder;
var
  LPath: String;

begin
  if DlgOpen.Execute then
  begin
    LPath := DlgOpen.FileName;
    var LImport := TDataImportManager.Create(self.ObjectManager);
    try
      LImport.ImportTransactionsFromFolder(TTransactionKind.Expense, LPath);

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

procedure TFrmTransactions.OpenDataset;
begin
  dbExpenses.Close;
  dbExpenses.Manager := self.ObjectManager;
  dbExpenses.SetSourceCriteria( self.ObjectManager
    .Find<TTransaction>
    .Where(Linq['Kind'] = TTransactionKind.Expense )
    .OrderBy(Linq['PaidOn'], False)
   );
  dbExpenses.Active := True;
end;

end.
