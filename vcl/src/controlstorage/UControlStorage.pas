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
  TControlList = TList<TControl>;

  TCSControl = class;
  TCSControls = TList<TCSControl>;

  [Automapping, Entity]
  TCSControl = class
  private
    FId: Integer;

    [Column('Y')]
    FTop: Integer;

    [Column('X')]
    FLeft: Integer;

    [Column('W')]
    FWidth: Integer;

    [Column('H')]
    FHeight: Integer;

    [Column('Name', [TColumnProp.Unique],500)]
    FName: String;

    [Association([], CascadeTypeAllButRemove)]
    FOwner: TCSControl;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FOwner')]
    FChildren: Proxy<TCSControls>;
    function GetChildren: TCSControls;
    procedure SetChildren(const Value: TCSControls);

  public
    constructor Create;
    destructor Destroy; override;

    procedure UpdateFromControl(AControl: TControl);

    property Id: Integer read FId write FId;

    property Name: String read FName write FName;

    property Owner: TCSControl read FOwner write FOwner;
    property Children: TCSControls read GetChildren write SetChildren;

    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FTop;
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

  TFormStorageManager = class
  strict private
    class var FInstance: TFormStorageManager;

  private
    FObjectManager: TObjectManager;

    procedure AddControlsToList(
      AControl: TControl;
      AList: TControlList );

  public
    class function Shared: TFormStorageManager;
    class destructor Destroy;

    constructor Create;
    destructor Destroy; override;

    procedure StoreForm( AForm: TForm );
    procedure RestoreForm( AForm: TForm );

    property ObjectManager: TObjectManager read FObjectManager;
  end;

implementation

uses
    UDictionary
  , UDataManager
  , Vcl.StdCtrls
  , Vcl.ExtCtrls
  , Vcl.DBGrids
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

procedure TFormStorageManager.StoreForm(AForm: TForm);
var
  LList: TControlList;
  LName: String;

begin
  // check if form has been stored before -- name is unique
  // form is a control like any other - just has children

  var LForm := ObjectManager.Find<TCSControl>
    .Where(Dic.CSControl.Name = 'Form.' + AForm.Name )
    .UniqueResult
    ;

  if not Assigned(LForm) then
  begin
    LForm := TCSControl.Create;
    LForm.Name := 'Form.' + AForm.Name;
    ObjectManager.Save(LForm);
  end;

  LForm.UpdateFromControl( AForm );

  // get a flattened list of all controls on the form
  LList := TControlList.Create;
  try
    AddControlsToList(AForm, LList );

    for var LControl in LList do
    begin
      if LControl = AForm then
      begin
        continue;   // skip the form
      end;


      // we have to do this for each control
      if (LControl is TSplitter)  then
      begin
        // check if control is already in list of form
        var LChild := ObjectManager.Find<TCSControl>
          .Where(
            (Dic.CSControl.Owner.Id = LForm.Id) AND
            (Dic.CSControl.Name = LControl.Name)
            )
          .UniqueResult
          ;

        if not Assigned(LChild) then
        begin
          LChild := TCSControl.Create;
          LChild.Name := LControl.Name;
          LForm.Children.Add(LChild);
        end;

        LChild.UpdateFromControl( LControl );
      end;
    end;
  finally
    LList.Free;
  end;

  ObjectManager.Flush;
end;

class function TFormStorageManager.Shared: TFormStorageManager;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TFormStorageManager.Create;
  end;

  Result := FInstance;
end;

procedure TFormStorageManager.RestoreForm(AForm: TForm);
begin
  // restore specific form controls
end;

procedure TFormStorageManager.AddControlsToList(AControl: TControl;
  AList: TControlList);
begin
  if not Assigned( AControl ) then
  begin
    exit;
  end;

  AList.Add(AControl);

  if AControl is TWinControl then
  begin
    var LWinControl := TWinControl( AControl );

    if LWinControl.ControlCount > 0 then
    begin
      for var i := 0 to LWinControl.ControlCount -1 do
      begin
        var LControl := LWinControl.Controls[i];

        // forms hosted on panels will trigger their own
        // storage and should not be stored as a child of the form hosting them
        if not (LControl is TForm) then
        begin
          AddControlsToList( LWinControl.Controls[i], AList );
        end;
      end;
    end;
  end;
end;

constructor TFormStorageManager.Create;
begin
  inherited;

  FObjectManager := TDataManager.Shared.ObjectManager;
end;

{ TCSControl }

constructor TCSControl.Create;
begin
  inherited;

  FChildren.SetInitialValue(TCSControls.Create);
end;

destructor TCSControl.Destroy;
begin
  FChildren.DestroyValue;

  inherited;
end;

function TCSControl.GetChildren: TCSControls;
begin
  Result := FChildren.Value;
end;

procedure TCSControl.SetChildren(const Value: TCSControls);
begin
  FChildren.Value := Value;
end;

procedure TCSControl.UpdateFromControl(AControl: TControl);
begin
  self.Left := AControl.Left;
  self.Top := AControl.Top;
  self.Width := AControl.Width;
  self.Height := AControl.Height;
end;

initialization
  RegisterEntity(TCSControl);
  RegisterEntity(TCSDBGrid);
  RegisterEntity(TCSDBGridColumn);

end.
