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
    Server: TXDataServer;
    DefaultConnectionPool: TXDataConnectionPool;
    DefaultModelConnection: TAureliusConnection;
    MySQLConnection: TFDConnection;
    TemporaryModelConnection: TAureliusConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    ServerCORS: TSparkleCorsMiddleware;
    ServerCompress: TSparkleCompressMiddleware;
    ServerForward: TSparkleForwardMiddleware;
    procedure DataModuleCreate(Sender: TObject);
    procedure ServerForwardAcceptHost(Sender: TObject; const Value: string;
        var Accept: Boolean);
    procedure ServerForwardAcceptProxy(Sender: TObject; const Value: string;
        var Accept: Boolean);

  private
    FTemporaryConnection: IDBConnection;

    procedure InitializeConnections;
    procedure InitializeServer;
    function GetCanStart: Boolean;

  public

    property CanStart: Boolean read GetCanStart;
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
  InitializeServer;
end;

function TServerContainer.GetCanStart: Boolean;
begin
  Result := Server.BaseUrl.IsEmpty = False;
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

procedure TServerContainer.InitializeServer;
begin
  Server.BaseUrl := TAppSettings.Shared.WebserviceBaseUrl;
end;

procedure TServerContainer.ServerForwardAcceptHost(Sender: TObject; const
    Value: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TServerContainer.ServerForwardAcceptProxy(Sender: TObject; const
    Value: string; var Accept: Boolean);
begin
  Accept := True;
end;

end.
