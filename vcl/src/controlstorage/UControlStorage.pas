unit UControlStorage;

interface

uses
    Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Engine.ObjectManager
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Expression
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Projections
  , Aurelius.Types.Blob
  , Aurelius.Types.Proxy
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections
  , System.DateUtils

  , Vcl.Forms
  , Vcl.Controls
  ;

type
  [Automapping, Entity]
  TCSControl = class
  private
    FTop: Integer;
    FLeft: Integer;
    FWidth: Integer;
    FHeight: Integer;
  public
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
  end;

  TCSDBGrid = class;

  [Automapping, Entity]
  TCSDBGridColumn = class
  private
    FId: Integer;
    FWidth: Integer;
    FIdx: Integer;
    FVisible: Boolean;

    [Association([],CascadeTypeAllButRemove)]
    FGrid: TCSDBGrid;

  public
    property Grid: TCSDBGrid read FGrid write FGrid;

    property Id: Integer read FId write FId;
    property Width: Integer read FWidth write FWidth;
    property Idx: Integer read FIdx write FIdx;
    property Visible: Boolean read FVisible write FVisible;
  end;


  TCSDBGridColumns = TList<TCSDBGridColumn>;

  [Automapping, Entity]
  TCSDBGrid = class
  private
    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FGrid')]
    FColumns: Proxy<TCSDBGridColumns>;
    FId: Integer;
    function GetColumns: TCSDBGridColumns;
    procedure SetColumns(const Value: TCSDBGridColumns);
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property Columns: TCSDBGridColumns read GetColumns write SetColumns;
  end;

  TControlList = TList<TWinControl>;

  TFormStorageManager = class
  strict private
    class var FInstance: TFormStorageManager;

  private
    FObjectManager: TObjectManager;

    procedure AddControlsToList(
      AControl: TWinControl;
      AList: TControlList );

  public
    class function Shared: TFormStorageManager;
    class destructor Destroy;

    constructor Create;
    destructor Destroy; override;

    procedure StoreForm( AForm: TForm );
    procedure RestoreForm( AForm: TForm );

  end;

implementation

uses
    UDataManager
  ;

{ TCSDBGrid }

constructor TCSDBGrid.Create;
begin
  inherited;

  FColumns.SetInitialValue( TCSDBGridColumns.Create );
end;

destructor TCSDBGrid.Destroy;
begin
  FColumns.DestroyValue;

  inherited;
end;

function TCSDBGrid.GetColumns: TCSDBGridColumns;
begin
  Result := FColumns.Value;
end;

procedure TCSDBGrid.SetColumns(const Value: TCSDBGridColumns);
begin
  FColumns.Value := Value;
end;

{ TFormStorageManager }

class destructor TFormStorageManager.Destroy;
begin
  FInstance.Free;
end;

destructor TFormStorageManager.Destroy;
begin
  FObjectManager.Free;

  inherited;
end;

procedure TFormStorageManager.RestoreForm(AForm: TForm);
begin
  // restore specific form controls
end;

class function TFormStorageManager.Shared: TFormStorageManager;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TFormStorageManager.Create;
  end;

  Result := FInstance;
end;

procedure TFormStorageManager.StoreForm(AForm: TForm);
begin
// store specific form controls
end;

procedure TFormStorageManager.AddControlsToList(AControl: TWinControl;
  AList: TControlList);
begin
  if not Assigned( AControl ) then
  begin
    exit;
  end;

  AList.Add(AControl);

  if AControl.ControlCount > 0 then
  begin
    for var i := 0 to AControl.ControlCount -1 do
    begin
      var LControl := AControl.Controls[i];
      if LControl is TWinControl then
      begin
        AddControlsToList( AControl.Controls[i] as TWinControl, AList );
      end;
    end;
  end;
end;

constructor TFormStorageManager.Create;
begin
  inherited;

  FObjectManager := TDataManager.Shared.ObjectManager;
end;

initialization
  RegisterEntity(TCSControl);
  RegisterEntity(TCSDBGrid);

end.
