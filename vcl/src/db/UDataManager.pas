unit UDataManager;

interface

uses
  System.SysUtils
  , System.Classes

  , Aurelius.Drivers.Interfaces
  , Aurelius.Drivers.SQLite
  , Aurelius.Drivers.FireDac
  , Aurelius.Sql.MySQL
  , Aurelius.Schema.MySQL
  , Aurelius.Sql.SQLite
  , Aurelius.Engine.DatabaseManager
  , Aurelius.Engine.ObjectManager, Aurelius.Comp.Connection

  ;

type
  TDataManager = class(TDataModule)
    Connection: TAureliusConnection;
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
  end;

var
  DataManager: TDataManager;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

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
