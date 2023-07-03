unit UDataImportManager;

interface

uses
    System.Classes
  , System.Generics.Collections
  , Bcl.Types.Nullable

  , Aurelius.Engine.ObjectManager
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Projections
  , Aurelius.Criteria.Exceptions

  , UDataManager
  , UExpense
  , UIncome
  , UDocument
  ;

type
  TImportError = class
  private
    FFileName: String;
    FDescription: String;
  public
    property FileName: String read FFileName write FFileName;
    property Description: String read FDescription write FDescription;
  end;

  TImportErrors = TObjectList<TImportError>;

  TExpenseFilename = class
  strict private
    FTitle: String;
    FAmount: Double;
    FCategory: String;
    FPaidOn: Nullable<TDateTime>;
    FIsMonthly: Boolean;
    FOriginalFileName: String;
    FPercentage: Double;

  private

    function GetHasValidDate: Boolean;
  public
    constructor Create;

    procedure AssignToExpense(AExpense: TExpense);

    property HasValidDate: Boolean read GetHasValidDate;

    property PaidOn: Nullable<TDateTime> read FPaidOn write FPaidOn;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;
    property IsMonthly: Boolean read FIsMonthly write FIsMonthly;
    property OriginalFileName: String
      read FOriginalFileName
      write FOriginalFileName;
    property Percentage: Double read FPercentage write FPercentage;
  end;

type
  TDataImportManager = class
  strict private
    procedure UnclutterExpenseFilename(APath: String; AExpenseFilename: TExpenseFilename );
  strict private
    FManager: TObjectManager;

    FDuplicates: TStringList;
    FImportErrors: TImportErrors;

    procedure SetDuplicates(const Value: TStringList);
    function ExpenseFileIsInDatabase( AFile: String ): Boolean;
  private
    function GetHasNoErrors: Boolean;
  public
    constructor Create(AManager: TObjectManager);
    destructor  Destroy; override;

    procedure ImportExpensesFromFolder(AFolder: String );
    procedure ImportIncomeFromFolder(AFolder: String);

    property ImportErrors: TImportErrors read FImportErrors;
    property Duplicates: TStringList read FDuplicates write SetDuplicates;

    property HasNoErrors: Boolean read GetHasNoErrors;

  end;

implementation

uses
    System.IOUtils
  , System.SysUtils
  , System.DateUtils


  ;

const
  CSeparators: Array of String = [ '__' ];

{ TDataImportManager }

constructor TDataImportManager.Create( AManager: TObjectManager );
begin
  inherited Create;

  FManager := AManager;
  FImportErrors := TImportErrors.Create(true);
  FDuplicates := TStringlist.Create;
end;

destructor TDataImportManager.Destroy;
begin
  FDuplicates.Free;
  FImportErrors.Free;

  inherited;
end;

function TDataImportManager.ExpenseFileIsInDatabase(AFile: String): Boolean;
begin
  var LDocument := FManager.Find<TDocument>
    .Where( Linq['OriginalFilename'] = AFile )
    .UniqueResult
    ;

  Result := Assigned( LDocument );
end;

function TDataImportManager.GetHasNoErrors: Boolean;
begin
  Result := (FDuplicates.Count=0) AND (FImportErrors.Count=0);
end;

procedure TDataImportManager.ImportExpensesFromFolder(AFolder: String);
var
  LExpense: TExpense;
  LFiles: TArray<String>;
  LExpenseData: TExpenseFilename;

begin
  FImportErrors.Clear;
  FDuplicates.Clear;

  LFiles := TDirectory.GetFiles(AFolder);
  for var LFile in LFiles do
  begin
    // check if file is already in database
    if ExpenseFileIsInDatabase( LFile ) = False  then
    begin
      LExpenseData := TExpenseFilename.Create;
      try
        try
          UnclutterExpenseFilename( LFile, LExpenseData );

          LExpense := TExpense.Create;
          LExpenseData.AssignToExpense(LExpense);
          FManager.Save(LExpense);
        except
          on E: EConvertError do
          begin
            var LError := TImportError.Create;
            LError.FileName := TPath.GetFileName(LFile);
            LError.Description := E.Message;
            FImportErrors.Add( LError );
          end;
        end;
      finally
        LExpenseData.Free;
      end;
    end
    else
    begin
      FDuplicates.Add(TPath.GetFileName(LFile));
    end;
  end;
end;

procedure TDataImportManager.ImportIncomeFromFolder(AFolder: String);
begin

end;


procedure TDataImportManager.SetDuplicates(const Value: TStringList);
begin
  FDuplicates := Value;
end;

procedure TDataImportManager.UnclutterExpenseFilename(APath: String;
    AExpenseFilename: TExpenseFilename);
var
  LSplits: TArray<string>;
  LPaidOn: TDateTime;
  LFormat: TFormatSettings;

  LAmount: Double;

begin
  var LFileName := TPath.GetFileNameWithoutExtension(APath);
  LSplits := LFilename.Split(CSeparators);

  LFormat := TFormatSettings.Create;  // this is a record, no Free
  LFormat.ShortDateFormat := 'yymmdd';

  if Length( LSplits ) < 4 then
  begin
    raise EConvertError.Create('Information missing.');
  end;

  if TryStrToDate( LSplits[0], LPaidOn, LFormat ) then
  begin
    AExpenseFilename.PaidOn := LPaidOn;
  end
  else
  begin
    AExpenseFilename.PaidOn := SNull;
  end;

  if AExpenseFilename.HasValidDate = false then
  begin
    raise EConvertError.Create('Invalid date');
  end;

  if AExpenseFilename.HasValidDate then
  begin
    AExpenseFilename.Category := LSplits[1];
    AExpenseFilename.Title := LSplits[2];

    LFormat.DecimalSeparator := '.';
    if not TryStrToFloat( LSplits[3], LAmount, LFormat ) then
    begin
      raise EConvertError.Create('Invalid amount');
    end;
    AExpenseFilename.Amount := LAmount;

    if Length(LSplits) > 4 then
    begin
      if LowerCase(LSplits[4]) = 'm' then
      begin
        AExpenseFilename.IsMonthly := True;
      end;
    end;

    if Length(LSplits) > 5 then
    begin
      var LPercentage: Integer := 0;
      if TryStrToInt( LSplits[5], LPercentage ) then
      begin
        AExpenseFilename.Percentage := LPercentage / 100;
      end;
    end;

    AExpenseFilename.OriginalFileName := APath;
  end;
end;

{ TImportFileName }

procedure TExpenseFilename.AssignToExpense(AExpense: TExpense);
begin
  AExpense.PaidOn := self.PaidOn;
  AExpense.IsMonthly := self.IsMonthly;
  AExpense.Category := self.Category;
  AExpense.Title := self.Title;
  AExpense.Amount := self.Amount;
  AExpense.Percentage := self.Percentage;
  AExpense.Document := TDocument.Create;
  AExpense.Document.OriginalFilename := self.OriginalFileName;
  AExpense.Document.Document := TFile.ReadAllBytes(self.OriginalFileName);
end;

constructor TExpenseFileName.Create;
begin
  inherited;



  FPercentage := 1;
  FIsMonthly := False;
end;

function TExpenseFileName.GetHasValidDate: Boolean;
begin
  Result := self.PaidOn.IsNull = False;
end;

end.
