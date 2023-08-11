unit UDataManager;

interface

uses
    System.SysUtils
  , System.Classes

  , System.IOUtils

  , Data.DB

  , Aurelius.Drivers.Interfaces
  , Aurelius.Drivers.SQLite
  , Aurelius.Drivers.FireDac
  , Aurelius.Sql.MySQL
  , Aurelius.Schema.MySQL
  , Aurelius.Sql.SQLite
  , Aurelius.Sql.Register
  , Aurelius.Engine.DatabaseManager
  , Aurelius.Engine.ObjectManager
  , Aurelius.Comp.Connection
  , Aurelius.Mapping.Explorer

  , FireDAC.Phys.MySQLDef
  , FireDAC.Stan.Intf
  , FireDAC.Phys
  , FireDAC.Phys.MySQL
  , FireDAC.Stan.Option
  , FireDAC.Stan.Error
  , FireDAC.UI.Intf
  , FireDAC.Phys.Intf
  , FireDAC.Stan.Def
  , FireDAC.Stan.Pool
  , FireDAC.Stan.Async
  , FireDAC.VCLUI.Wait
  , FireDAC.Comp.Client
  , FireDAC.Stan.ExprFuncs
  , FireDAC.Phys.SQLiteWrapper.Stat
  , FireDAC.Phys.SQLiteDef
  , FireDAC.Phys.SQLite

  ;

type
  TDataManager = class(TDataModule)
    Connection: TAureliusConnection;
    FDConnection: TFDConnection;

    MySQLUnits: TFDPhysMySQLDriverLink;
    SQLiteUnits: TFDPhysSQLiteDriverLink;

    MemConnection: TAureliusConnection;

    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FMemoryConnection: IDBConnection;

    function GetConnection: IDBConnection;
    function GetDatabaseManager: TDatabaseManager;
    function GetObjectManager: TObjectManager;
    function GetMemoryObjectManager: TObjectManager;
  strict private
    class var FInstance: TDataManager;

  public
    { Public declarations }
    class destructor Destroy;
    class function Shared: TDataManager;

    procedure CreateDatabase;
    procedure UpdateDatabase;

    procedure CreateTemporaryDatabase;

    property DatabaseManager: TDatabaseManager read GetDatabaseManager;
    property ObjectManager: TObjectManager read GetObjectManager;

    property MemoryObjectManager: TObjectManager read GetMemoryObjectManager;
  end;

var
  DataManager: TDataManager;

implementation
uses
  UAppSettings
  ;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataManager.CreateDatabase;
begin
  {$IFDEF DEBUG}
  var LDatabaseManager := DatabaseManager;
  try
    LDatabaseManager.DestroyDatabase;
    LDatabaseManager.BuildDatabase;
  finally
    LDatabaseManager.Free;
  end;
  {$ENDIF}
end;

procedure TDataManager.CreateTemporaryDatabase;
begin
  // initialize database manager for temporary model
  var LDatabase := TDatabaseManager.Create(
    FMemoryConnection,
    TMappingExplorer.Get('Temporary')
    );
  try
    LDatabase.BuildDatabase;
  finally
    LDatabase.Free;
  end;
end;

procedure TDataManager.DataModuleCreate(Sender: TObject);
begin
  // load FireDAC connection parameters
  TAppSettings.Shared.GetDatabaseParams(FDConnection.Params);

  // set adapted connection AFTER FireDAC has been set
  // make sure that SQLDialect is empty when assigned, otherwise it will
  // not be set automatically by Aurelius.
  Connection.AdaptedConnection := FDConnection;

  // init the memory database used for reports
  FMemoryConnection := MemConnection.CreateConnection;
  CreateTemporaryDatabase;

  // update the physical database
  UpdateDatabase;
end;

{ TDataManager }

class destructor TDataManager.Destroy;
begin
  FInstance.Free;
end;

function TDataManager.GetConnection: IDBConnection;
begin
  Result := Connection.CreateConnection;
end;

function TDataManager.GetDatabaseManager: TDatabaseManager;
begin
  Result := TDatabaseManager.Create(GetConnection);
end;

function TDataManager.GetMemoryObjectManager: TObjectManager;
begin
  Result := TObjectManager.Create(
    FMemoryConnection,
    TMappingExplorer.Get('Temporary')
    );
end;

function TDataManager.GetObjectManager: TObjectManager;
begin
  Result := TObjectManager.Create(GetConnection);
end;

class function TDataManager.Shared: TDataManager;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TDataManager.Create(nil);
  end;

  Result := FInstance;
end;

procedure TDataManager.UpdateDatabase;
var
  LDatabaseManager: TDatabaseManager;

begin
  LDatabaseManager := DatabaseManager;
  try
    LDatabaseManager.UpdateDatabase;
  finally
    LDatabaseManager.Free;
  end;
end;

end.
