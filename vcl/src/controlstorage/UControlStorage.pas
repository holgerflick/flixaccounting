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

  , System.Classes
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
  [Inheritance(TInheritanceStrategy.JoinedTables)]
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

    [Column('Name', [],500)]
    FName: String;

    [Association([], CascadeTypeAllButRemove)]
    FOwner: TCSControl;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FOwner')]
    FChildren: Proxy<TCSControls>;
    function GetChildren: TCSControls;
    procedure SetChildren(const Value: TCSControls);

  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure UpdateFromControl(AControl: TControl); virtual;
    procedure UpdateControl(AControl: TControl); virtual;

    property Id: Integer read FId write FId;

    property Name: String read FName write FName;

    property Owner: TCSControl read FOwner write FOwner;
    property Children: TCSControls read GetChildren write SetChildren;

    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
  end;

  TCSDBGridControl = class;

  [Automapping, Entity]
  TCSDBGridColumn = class
  private
    FId: Integer;
    FWidth: Integer;

    FIdx: Integer;

    FVisible: Boolean;

    [Association([],CascadeTypeAllButRemove)]
    FGrid: TCSDBGridControl;

  public
    property Grid: TCSDBGridControl read FGrid write FGrid;

    property Id: Integer read FId write FId;
    property Idx: Integer read FIdx write FIdx;

    property Width: Integer read FWidth write FWidth;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TCSDBGridColumns = TList<TCSDBGridColumn>;

  [Automapping, Entity]
  [PrimaryJoinColumn('CSControlId')]
  TCSDBGridControl = class(TCSControl)
  private
    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAll, 'FGrid')]
    FColumns: Proxy<TCSDBGridColumns>;

    function GetColumns: TCSDBGridColumns;
  public
    constructor Create;  override;
    destructor Destroy; override;

    procedure UpdateFromControl(AControl: TControl); override;
    procedure UpdateControl(AControl: TControl); override;

    property Columns: TCSDBGridColumns read GetColumns;
  end;

  TFormStorageUtils = class
  public
    class function ControlToName( AControl: TControl ): String;
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

constructor TCSDBGridControl.Create;
begin
  inherited;

  FColumns.SetInitialValue( TCSDBGridColumns.Create );
end;

destructor TCSDBGridControl.Destroy;
begin
  FColumns.DestroyValue;

  inherited;
end;

function TCSDBGridControl.GetColumns: TCSDBGridColumns;
begin
  Result := FColumns.Value;
end;

procedure TCSDBGridControl.UpdateControl(AControl: TControl);
begin
  //raise ENotImplemented.Create('Grid columns not implemented');


  inherited;

  // retrieve columns
  var LGrid := AControl as TDBGrid;

  // this should never ever fail...
  if Assigned(LGrid) then
  begin

  end;
end;

procedure TCSDBGridControl.UpdateFromControl(AControl: TControl);
var
  LPotentialColumn,
  LFound: TCSDBGridColumn;

begin
  inherited;

  // add columns to storage
  var LGrid := AControl as TDBGrid;

  // this should never fail...
  if Assigned(LGrid) then
  begin
    for var c := 0 to LGrid.Columns.Count-1 do
    begin
      var LColumn := LGrid.Columns[c];

      // find if column exists
      LFound := nil;
      var i := 0;
      while (LFound = nil) AND ( i<self.Columns.Count ) do
      begin
        LPotentialColumn := self.Columns[i];
        if LPotentialColumn.Idx = LColumn.Index then
        begin
          LFound := LPotentialColumn;
        end;
        Inc(i);
      end;

      if not Assigned(LFound) then
      begin
        LFound := TCSDBGridColumn.Create;
        LFound.Idx := LColumn.Index;
        LFound.Grid := self;
        self.Columns.Add(LFound);
      end;

      LFound.Width := LColumn.Width;
      LFound.Visible := LColumn.Visible;
    end;
  end;
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
  LLog: String;
  LControl: TControl;
  LChild,
  LPotentialChild: TCSControl;

begin
  // check if form has been stored before -- name is unique
  // form is a control like any other - just has children

  var LForm := ObjectManager.Find<TCSControl>
    .Where(Dic.CSControl.Name = TFormStorageUtils.ControlToName(AForm) )
    .UniqueResult
    ;

  if not Assigned(LForm) then
  begin
    LForm := TCSControl.Create;
    LForm.Name := TFormStorageUtils.ControlToName(AForm);
    ObjectManager.Save(LForm);
  end;

  LForm.UpdateFromControl( AForm );

  // get a flattened list of all controls on the form
  LList := TControlList.Create;
  try
    AddControlsToList(AForm, LList );

    for LControl in LList do
    begin
      var LName := TFormStorageUtils.ControlToName(LControl);

      LChild := nil;

      var i:= 0;
      while (not Assigned(LChild)) AND (i<LForm.Children.Count) do
      begin
        LPotentialChild := LForm.Children[i];

        if LPotentialChild.Name = LName then
        begin
          LChild := LPotentialChild;
        end;

        Inc(i);
      end;

      if not Assigned(LChild) then
      begin

        // removed functionalty as there is no way to retrieve these
        // instances. Aurelius always returns TCSControl and does
        // not consider TCSDBGridControl. Instances are neither in the list
        // `Children` not can they be found using `Find`.
        //
        if LControl is TDBGrid then
        begin
          LChild := TCSDBGridControl.Create;
        end
        else
        begin
          LChild := TCSControl.Create;
        end;

        LChild.Name := LName;
        LForm.Children.Add(LChild);
      end;

      LChild.UpdateFromControl( LControl );
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
var
  LForm: TCSControl;
  LControl: TControl;

begin
  // look up form an if it exists, update all controls associated with it
  LForm := ObjectManager.Find<TCSControl>
    .Where(Dic.CSControl.Name = TFormStorageUtils.ControlToName(AForm) )
    .UniqueResult
    ;

  if not Assigned(LForm) then
  begin
    Exit;
  end;

  LForm.UpdateControl(AForm);

  // build list of all controls
  var LList := TControlList.Create;
  try
    AddControlsToList(AForm, LList);

    // update size of all children
    for var LChild in LForm.Children do
    begin
      // find associated control
      LControl := nil;
      var i := 0;
      while (LControl = nil) AND (i<LList.Count) do
      begin
        if TFormStorageUtils.ControlToName(LList[i]) = LChild.Name then
        begin
          LControl := LList[i];
        end;

        Inc(i);
      end;

      // it might happen that a control has been stored that no longer
      // exists on the form...
      if Assigned(LControl) then
      begin
        LChild.UpdateControl(LControl);
      end;
    end;
  finally
    LList.Free;
  end;
end;

procedure TFormStorageManager.AddControlsToList(AControl: TControl;
  AList: TControlList);
begin
  if not Assigned( AControl ) then
  begin
    exit;
  end;

  if AControl is TForm then
  begin
    if AControl.ComponentCount > 0 then
    begin
      for var i := 0 to AControl.ComponentCount -1 do
      begin
        var LComponent := AControl.Components[i];

        if LComponent is TControl then
        begin
          AList.Add( LComponent as TControl );
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

procedure TCSControl.UpdateControl(AControl: TControl);
begin
  AControl.Left := self.Left;
  AControl.Top := self.Top;
  AControl.Height := self.Height;
  AControl.Width := self.Width;
end;

procedure TCSControl.UpdateFromControl(AControl: TControl);
begin
  self.Left := AControl.Left;
  self.Top := AControl.Top;
  self.Width := AControl.Width;
  self.Height := AControl.Height;
end;

{ TFormStorageUtils }

class function TFormStorageUtils.ControlToName(AControl: TControl): String;
var
  LBuffer: String;


begin
  LBuffer := AControl.ClassName + '.' + AControl.Name;

  if LBuffer.IsEmpty then
  begin
    raise EArgumentException.Create('Control name cannot be empty.');
  end;

  if AControl is TForm then
  begin
    var LSplits := LBuffer.Split(['_']);

    if Length(LSplits)>1 then
    begin
      // it might be that the form is a sub form
      // names then go like Name_1, Name_2, Name_3
      //
      // if the right-most split is a number, cut it off
      var LNumber := 0;
      if TryStrToInt( LSplits[ Length(LSplits)-1 ], LNumber ) then
      begin
        LBuffer := LBuffer.Replace( '_' + LNumber.ToString, '' );
      end;
    end;
  end;

  Result := LBuffer;
end;

initialization
  RegisterEntity(TCSControl);
  RegisterEntity(TCSDBGridControl);
  RegisterEntity(TCSDBGridColumn);

end.
