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
  FrmExpenses: TFrmExpenses;

implementation

{$R *.dfm}

uses
    UFrmReportImport
  , UDataImportManager
  ;


procedure TFrmExpenses.btnImportClick(Sender: TObject);
begin
  ImportFromFolder;
end;

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

  OpenDataset;
end;

procedure TFrmExpenses.ImportFromFolder;
var
  LPath: String;

begin
  if DlgOpen.Execute then
  begin
    LPath := DlgOpen.FileName;
    var LImport := TDataImportManager.Create(self.ObjectManager);
    try
      LImport.ImportExpensesFromFolder(LPath);

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

procedure TFrmExpenses.OpenDataset;
begin
  dbExpenses.Close;
  dbExpenses.Manager := self.ObjectManager;
  dbExpenses.SetSourceCriteria( self.ObjectManager
    .Find<TExpense>
    .OrderBy(Linq['PaidOn'], False)
   );
  dbExpenses.Active := True;
end;

end.
