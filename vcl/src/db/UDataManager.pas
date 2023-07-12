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
  , Aurelius.Engine.ObjectManager, Aurelius.Comp.Connection

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


  , UInvoice
  ;

type
  TDataManager = class(TDataModule)
    Connection: TAureliusConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

    function GetConnection: IDBConnection;
    function GetDatabaseManager: TDatabaseManager;
    function GetObjectManager: TObjectManager;
  strict private
    class var FInstance: TDataManager;

  public
    { Public declarations }
    class destructor Destroy;
    class function Shared: TDataManager;

    property DatabaseManager: TDatabaseManager read GetDatabaseManager;
    property ObjectManager: TObjectManager read GetObjectManager;

    procedure UpdateDatabase;
    procedure CreateDatabase;
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
  var LDatabaseManager := DatabaseManager;
  try
    LDatabaseManager.DestroyDatabase;
    LDatabaseManager.BuildDatabase;

  finally
    LDatabaseManager.Free;
  end;

end;

procedure TDataManager.DataModuleCreate(Sender: TObject);
begin
  TAppSettings.Shared.GetDatabaseParams(FDConnection.Params);

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
