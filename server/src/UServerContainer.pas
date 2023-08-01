unit UServerContainer;

interface

uses
    Aurelius.Comp.Connection
  , Aurelius.Drivers.FireDac
  , Aurelius.Drivers.Interfaces
  , Aurelius.Drivers.SQLite
  , Aurelius.Schema.MySQL
  , Aurelius.Sql.MySQL
  , Aurelius.Engine.DatabaseManager
  , Aurelius.Mapping.Explorer

  , Data.DB

  , FireDAC.Comp.Client
  , FireDAC.Phys
  , FireDAC.Phys.Intf
  , FireDAC.Stan.Async
  , FireDAC.Stan.Def
  , FireDAC.Stan.Error
  , FireDAC.Stan.Intf
  , FireDAC.Stan.Option
  , FireDAC.Stan.Pool
  , FireDAC.UI.Intf
  , FireDAC.VCLUI.Wait
  , FireDAC.Phys.MySQLDef
  , FireDAC.Phys.MySQL

  , Sparkle.Comp.HttpSysDispatcher
  , Sparkle.Comp.Server
  , Sparkle.HttpServer.Context
  , Sparkle.HttpServer.Module

  , System.Classes
  , System.SysUtils

  , XData.Comp.ConnectionPool
  , XData.Comp.Server
  , XData.Server.Module, Sparkle.Comp.GenericMiddleware,
  Sparkle.Comp.ForwardMiddleware, Sparkle.Comp.CompressMiddleware,
  Sparkle.Comp.CorsMiddleware

  ;


type
  TServerContainer = class(TDataModule)
    SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher;
    XDataServer: TXDataServer;
    DefaultConnectionPool: TXDataConnectionPool;
    DefaultModelConnection: TAureliusConnection;
    MySQLConnection: TFDConnection;
    TemporaryModelConnection: TAureliusConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    XDataServerCORS: TSparkleCorsMiddleware;
    XDataServerCompress: TSparkleCompressMiddleware;
    XDataServerForward: TSparkleForwardMiddleware;
    procedure DataModuleCreate(Sender: TObject);
    procedure XDataServerForwardAcceptHost(Sender: TObject; const Value: string;
        var Accept: Boolean);
    procedure XDataServerForwardAcceptProxy(Sender: TObject; const Value: string;
        var Accept: Boolean);

  private
    FTemporaryConnection: IDBConnection;

    procedure InitializeConnections;

  public
    property TemporaryConnection: IDBConnection read FTemporaryConnection;
  end;

var
  ServerContainer: TServerContainer;

implementation
uses
    UAppSettings

  , XData.Sys.Exceptions
  ;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TServerContainer.DataModuleCreate(Sender: TObject);
begin
  InitializeConnections;
end;

procedure TServerContainer.InitializeConnections;
var
  LDatabase: TDatabaseManager;
begin
  TAppSettings.Shared.GetDatabaseParams( MySQLConnection.Params );

  FTemporaryConnection := TemporaryModelConnection.CreateConnection;

  LDatabase := TDatabaseManager.Create( FTemporaryConnection, TMappingExplorer.Get('Temporary') );
  try
    LDatabase.BuildDatabase;
  finally
    LDatabase.Free;
  end;
end;

procedure TServerContainer.XDataServerForwardAcceptHost(Sender: TObject; const
    Value: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TServerContainer.XDataServerForwardAcceptProxy(Sender: TObject; const
    Value: string; var Accept: Boolean);
begin
  Accept := True;
end;

end.
