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
  , UDocument
  , UTransaction

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

  TFilenameData = class
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

    procedure AssignToTransaction(ATx: TTransaction);

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
    procedure UnclutterFilename(APath: String; AData: TFilenameData);
  strict private
    FManager: TObjectManager;

    FDuplicates: TStringList;
    FImportErrors: TImportErrors;

    procedure SetDuplicates(const Value: TStringList);
    function FileIsInDatabase( AFile: String ): Boolean;
  private
    function GetHasNoErrors: Boolean;
  public
    constructor Create(AManager: TObjectManager);
    destructor  Destroy; override;

    procedure ImportTransactionsFromFolder(
      ATxKind: TTransactionKind;
      AFolder: String );

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

function TDataImportManager.FileIsInDatabase(AFile: String): Boolean;
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

procedure TDataImportManager.ImportTransactionsFromFolder(
  ATxKind: TTransactionKind;
  AFolder: String
  );
var
  LTx: TTransaction;
  LFiles: TArray<String>;
  LData: TFilenameData;

begin
  FImportErrors.Clear;
  FDuplicates.Clear;

  LFiles := TDirectory.GetFiles(AFolder);
  for var LFile in LFiles do
  begin
    // check if file is already in database
    if FileIsInDatabase( LFile ) = False  then
    begin
      LData := TFilenameData.Create;
      try
        try
          UnclutterFilename( LFile, LData );

          LTx := TTransaction.Create;
          LTx.Kind := ATxKind;

          LData.AssignToTransaction(LTx);
          FManager.Save(LTx);
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
        LData.Free;
      end;
    end
    else
    begin
      FDuplicates.Add(TPath.GetFileName(LFile));
    end;
  end;
end;

procedure TDataImportManager.SetDuplicates(const Value: TStringList);
begin
  FDuplicates := Value;
end;

procedure TDataImportManager.UnclutterFilename(APath: String;
    AData: TFilenameData);
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
    AData.PaidOn := LPaidOn;
  end
  else
  begin
    AData.PaidOn := SNull;
  end;

  if AData.HasValidDate = false then
  begin
    raise EConvertError.Create('Invalid date');
  end;

  if AData.HasValidDate then
  begin
    AData.Category := LSplits[1];
    AData.Title := LSplits[2];

    LFormat.DecimalSeparator := '.';
    if not TryStrToFloat( LSplits[3], LAmount, LFormat ) then
    begin
      raise EConvertError.Create('Invalid amount');
    end;
    AData.Amount := LAmount;

    if Length(LSplits) > 4 then
    begin
      if LowerCase(LSplits[4]) = 'm' then
      begin
        AData.IsMonthly := True;
      end;
    end;

    if Length(LSplits) > 5 then
    begin
      var LPercentage: Integer := 0;
      if TryStrToInt( LSplits[5], LPercentage ) then
      begin
        AData.Percentage := LPercentage / 100;
      end;
    end;

    AData.OriginalFileName := APath;
  end;
end;

{ TImportFileName }

procedure TFilenameData.AssignToTransaction(ATx: TTransaction);
begin
  ATx.PaidOn := self.PaidOn;
  ATx.IsMonthly := self.IsMonthly;
  ATx.Category := self.Category;
  ATx.Title := self.Title;
  ATx.Amount := self.Amount;
  ATx.Document := TDocument.Create;
  ATx.Document.OriginalFilename := self.OriginalFileName;
  ATx.Document.Document := TFile.ReadAllBytes(self.OriginalFileName);
end;

constructor TFileNameData.Create;
begin
  inherited;

  FPercentage := 1;
  FIsMonthly := False;
end;

function TFileNameData.GetHasValidDate: Boolean;
begin
  Result := self.PaidOn.IsNull = False;
end;

end.
