object ServerContainer: TServerContainer
  OnCreate = DataModuleCreate
  Height = 305
  Width = 392
  object SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher
    Left = 72
    Top = 16
  end
  object Server: TXDataServer
    Dispatcher = SparkleHttpSysDispatcher
    Pool = DefaultConnectionPool
    RoutingPrecedence = Service
    EntitySetPermissions = <>
    SwaggerOptions.Enabled = True
    SwaggerUIOptions.Enabled = True
    SwaggerUIOptions.DocExpansion = None
    SwaggerUIOptions.DisplayOperationId = True
    SwaggerUIOptions.TryItOutEnabled = True
    Left = 248
    Top = 80
    object ServerCORS: TSparkleCorsMiddleware
    end
    object ServerCompress: TSparkleCompressMiddleware
    end
    object ServerForward: TSparkleForwardMiddleware
      OnAcceptProxy = ServerForwardAcceptProxy
      OnAcceptHost = ServerForwardAcceptHost
    end
  end
  object DefaultConnectionPool: TXDataConnectionPool
    Connection = DefaultModelConnection
    Left = 72
    Top = 80
  end
  object DefaultModelConnection: TAureliusConnection
    AdapterName = 'FireDac'
    AdaptedConnection = MySQLConnection
    SQLDialect = 'MySQL'
    Left = 72
    Top = 152
  end
  object MySQLConnection: TFDConnection
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 72
    Top = 216
  end
  object TemporaryModelConnection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=:memory:'
      'EnableForeignKeys=True')
    Left = 248
    Top = 152
  end
  object MySQLLink: TFDPhysMySQLDriverLink
    Left = 248
    Top = 216
  end
end
