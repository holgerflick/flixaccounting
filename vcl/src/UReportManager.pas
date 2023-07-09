unit UReportManager;

interface

uses
    System.SysUtils
  , System.Classes
  , System.Generics.Collections

  , Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer
  , Aurelius.Engine.ObjectManager
  , Aurelius.Criteria.Projections
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Expression

  , Bcl.Types.Nullable

  , UTransaction
  , UInvoice

  ;

type
  TReportManager = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  strict private
    FObjManager: TObjectManager;

    FRangeStart: TDate;
    FRangeEnd: TDate;
    FObjectManager: TObjectManager;


  public
    { Public declarations }

    constructor Create( AObjManager: TObjectManager ); reintroduce;

    procedure GetCategories(ACategories: TStrings);

    property ObjectManager: TObjectManager read FObjectManager write FObjectManager;
    property RangeStart: TDate read FRangeStart write FRangeStart;
    property RangeEnd: TDate read FRangeEnd write FRangeEnd;

  end;

var
  ReportManager: TReportManager;

implementation

uses
  System.DateUtils
  ;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TReportManager.Create(AObjManager: TObjectManager);
begin
  inherited Create(nil);

  FObjectManager := AObjManager;
end;

procedure TReportManager.DataModuleCreate(Sender: TObject);
begin
  // default current year
  RangeStart := TDateTime.Now.StartOfTheYear;
  RangeEnd   := TDateTime.Now.EndOfTheYear;
end;

procedure TReportManager.GetCategories(ACategories: TStrings);
begin
  if not Assigned(ACategories) then
  begin
    raise EArgumentNilException.Create('List of categories cannot be nil.');
  end;

  ACategories.Clear;

  // retrieve all categories in defined range
  var LCategories := ObjectManager.Find<TTransaction>
    .Select(TProjections.Group('Category'))
    .Where(
       (Linq['PaidOn'] > self.RangeStart) AND (Linq['PaidOn'] < self.RangeEnd)
    )
    .ListValues
    ;
  try
    // assign category names to list of strings
    for var i := 0 to LCategories.Count -1 do
    begin
      ACategories.Add( LCategories[i].Values[0] );
    end;
  finally
    LCategories.Free;  // list needs to be freed
  end;
end;



end.
