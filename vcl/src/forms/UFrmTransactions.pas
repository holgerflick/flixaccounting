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

  , UTransaction, Vcl.DBCtrls

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
    Expenses: TDBAdvGrid;
    btnImport: TButton;
    DlgOpen: TFileOpenDialog;
    rbFilterKind: TRadioGroup;
    popTxKind: TPopupMenu;
    menTxKindIncome: TMenuItem;
    menTxKindExpenses: TMenuItem;
    DBNavigator1: TDBNavigator;
    procedure btnImportClick(Sender: TObject);
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
  public
    { Public declarations }

    property FilterKind: TTransactionKind read GetFilterTxKind;
  end;

implementation

{$R *.dfm}

uses
    System.Types
  , UFrmReportImport

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
