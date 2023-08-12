{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
unit UControlStorage;

interface

uses
    AdvGrid
  , dbadvgrid

  , Aurelius.Mapping.Automapping
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

    [Association([], [])]
    FOwner: TCSControl;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAllRemoveOrphan, 'FOwner')]
    FChildren: Proxy<TCSControls>;
    function GetChildren: TCSControls;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure UpdateFromControl(AControl: TControl); virtual;
    procedure UpdateControl(AControl: TControl); virtual;

    function ChildByName(AName: String): TCSControl;

    property Id: Integer read FId write FId;

    property Name: String read FName write FName;

    property Owner: TCSControl read FOwner write FOwner;
    property Children: TCSControls read GetChildren;

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

    [Association([], [])]
    FGrid: TCSDBGridControl;
    FFieldName: String;

  public
    property Grid: TCSDBGridControl read FGrid write FGrid;

    property Id: Integer read FId write FId;
    property FieldName: String read FFieldName write FFieldName;
    property Idx: Integer read FIdx write FIdx;
    property Width: Integer read FWidth write FWidth;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TCSDBGridColumns = TList<TCSDBGridColumn>;

  [Automapping, Entity]
  [PrimaryJoinColumn('CSCONTROLID')]
  TCSDBGridControl = class(TCSControl)
  private
    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAllRemoveOrphan, 'FGrid')]
    FColumns: Proxy<TCSDBGridColumns>;

    function GetColumns: TCSDBGridColumns;
  public
    constructor Create;  override;
    destructor Destroy; override;

    procedure UpdateFromControl(AControl: TControl); override;
    procedure UpdateControl(AControl: TControl); override;

    function ColumnByFieldName(AName: String): TCSDBGridColumn;

    property Columns: TCSDBGridColumns read GetColumns;
  end;

  [Automapping, Entity]
  [PrimaryJoinColumn('CSCONTROLID')]
  TCSAdvStringGrid = class(TCSControl)
  private
    [Column('COLDEF', [], 1000 )]
    FColumnDefinition: String;

  public
    procedure UpdateFromControl(AControl: TControl); override;
    procedure UpdateControl(AControl: TControl); override;

    property ColumnDefinition: String read FColumnDefinition write FColumnDefinition;
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
    procedure RemoveAndCloseForm( AForm: TForm );

    property ObjectManager: TObjectManager read FObjectManager;
  end;

implementation

uses
    UDictionary
  , UDataManager
  , UFrmBase

  , Vcl.StdCtrls
  , Vcl.ExtCtrls
  , Vcl.DBGrids
  ;

{ TCSDBGrid }

function TCSDBGridControl.ColumnByFieldName(AName: String): TCSDBGridColumn;
begin
  Result := nil;

  for var i := 0 to self.Columns.Count-1 do
  begin
    if self.Columns[i].FieldName = AName then
    begin
      Result := self.Columns[i];
      break;
    end;
  end;
end;

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
  inherited;

  // retrieve columns
  var LGrid := AControl as TDBGrid;

  // this should never ever fail...
  if Assigned(LGrid) then
  begin
    // restore column visibility and width
    for var LCSCol in self.Columns do
    begin
      // find column in grid
      var LColumn: TColumn := nil;
      for var i := 0 to LGrid.Columns.Count-1 do
      begin
        if LGrid.Columns[i].FieldName = LCSCol.FieldName then
        begin
          LColumn := LGrid.Columns[i];
          break;
        end;
      end;

      // column might no longer exist...
      if Assigned(LColumn) then
      begin
        LColumn.Index := LCSCol.Idx;
        LColumn.Width := LCSCol.Width;
        LColumn.Visible := LCSCol.Visible;
      end;
    end;
  end;
end;

procedure TCSDBGridControl.UpdateFromControl(AControl: TControl);
var
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
      var LFieldName := LColumn.FieldName;

      // find if column exists
      LFound := self.ColumnByFieldName(LFieldName);

      if not Assigned(LFound) then
      begin
        LFound := TCSDBGridColumn.Create;
        LFound.FieldName := LColumn.FieldName;
        self.Columns.Add(LFound);
      end;

      LFound.Idx := LColumn.Index;
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
  LControl: TControl;
  LChild: TCSControl;

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
  ObjectManager.Flush(LForm);

  // get a flattened list of all controls on the form
  LList := TControlList.Create;
  try
    AddControlsToList(AForm, LList );

    for LControl in LList do
    begin
      var LName := TFormStorageUtils.ControlToName(LControl);

      LChild := LForm.ChildByName(LName);

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
        else if (LControl is TAdvStringGrid) or (LControl is TDBAdvGrid) then
        begin
          LChild := TCSAdvStringGrid.Create;
        end
        else
        begin
          LChild := TCSControl.Create;
        end;

        LChild.Name := LName;
        LChild.Owner := LForm;
        LForm.Children.Add(LChild);
        ObjectManager.Save(LChild);
      end;

      LChild.UpdateFromControl( LControl );
      ObjectManager.Flush(LChild);
    end;
  finally
    LList.Free;
  end;
end;

class function TFormStorageManager.Shared: TFormStorageManager;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TFormStorageManager.Create;
  end;

  Result := FInstance;
end;

procedure TFormStorageManager.RemoveAndCloseForm(AForm: TForm);
begin
  var LForm := ObjectManager.Find<TCSControl>
    .Where(Dic.CSControl.Name = TFormStorageUtils.ControlToName(AForm))
    .UniqueResult
    ;

  if Assigned(LForm) then
  begin
    ObjectManager.Remove(LForm);
    if AForm is TFrmBase then
    begin
      TFrmBase( AForm ).StoreControls := False;
    end;
    AForm.Close;
  end;
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

function TCSControl.ChildByName(AName: String): TCSControl;
begin
  Result := nil;

  for var i := 0 to self.Children.Count-1 do
  begin
    if self.Children[i].Name = AName then
    begin
      Result := self.Children[i];
      break;
    end;
  end;
end;

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

{ TCSDBAdvGrid }

procedure TCSAdvStringGrid.UpdateControl(AControl: TControl);
begin
  inherited;

  if AControl is TAdvStringGrid then
  begin
    var LGrid := TAdvStringGrid( AControl );
    LGrid.StringToColumnStates( self.ColumnDefinition );
  end;
end;

procedure TCSAdvStringGrid.UpdateFromControl(AControl: TControl);
begin
  inherited;

  if AControl is TAdvStringGrid then
  begin
    var LGrid := TAdvStringGrid( AControl );
    self.ColumnDefinition := LGrid.ColumnStatesToString;
  end;
end;

initialization
  RegisterEntity(TCSControl);
  RegisterEntity(TCSDBGridControl);
  RegisterEntity(TCSDBGridColumn);
  RegisterEntity(TCSAdvStringGrid);

end.
