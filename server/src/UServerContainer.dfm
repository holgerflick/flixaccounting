object ServerContainer: TServerContainer
  Height = 278
  Width = 472
  object SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher
    Active = True
    Left = 72
    Top = 16
  end
  object XDataServer: TXDataServer
    BaseUrl = 'http://+:2001/tms/xdata'
    Dispatcher = SparkleHttpSysDispatcher
    Pool = DefaultConnectionPool
    EntitySetPermissions = <>
    Left = 224
    Top = 72
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
    Left = 72
    Top = 216
  end
  object TemporaryModelConnection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=:memory:'
      'EnableForeignKeys=True')
    Left = 264
    Top = 152
  end
end
