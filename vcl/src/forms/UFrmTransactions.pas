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
  , Vcl.Menus
  , Vcl.ExtCtrls

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

  , UTransaction

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
    rbFilterKind: TRadioGroup;
    popTxKind: TPopupMenu;
    menTxKindIncome: TMenuItem;
    menTxKindExpenses: TMenuItem;
    procedure btnImportClick(Sender: TObject);
    procedure dbExpensesPercentageGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
    procedure dbExpensesPercentageSetText(Sender: TField; const Text: string);

    procedure FormCreate(Sender: TObject);
    procedure rbFilterKindClick(Sender: TObject);
  private
    { Private declarations }
    function GetFilterTxKind: TTransactionKind;

    procedure ImportFromFolder;
    procedure OpenDataset;
  public
    { Public declarations }

    property FilterKind: TTransactionKind read GetFilterTxKind;
  end;

var
  FrmTransactions: TFrmTransactions;

implementation

{$R *.dfm}

uses
    UFrmReportImport

  , UDataImportManager

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

  Caption := SCaption;

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
  var LCriteria := self.ObjectManager
    .Find<TTransaction>
    .OrderBy(Linq['PaidOn'], False)
    ;

  if FilterKind <> TTransactionKind.All then
  begin
    LCriteria.Add( Linq['Kind'] = FilterKind );
  end;


  dbExpenses.Close;
  dbExpenses.Manager := self.ObjectManager;
  dbExpenses.SetSourceCriteria( LCriteria );
  dbExpenses.Active := True;
end;

function TFrmTransactions.GetFilterTxKind: TTransactionKind;
begin
  case rbFilterKind.ItemIndex of
    0 : Result := TTransactionKind.Income;
    1 : Result := TTransactionKind.Expense;
    2 : Result := TTransactionKind.All;
  end;
end;

procedure TFrmTransactions.rbFilterKindClick(Sender: TObject);
begin
  OpenDataset;
end;

end.
