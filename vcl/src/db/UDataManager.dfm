object DataManager: TDataManager
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Connection: TAureliusConnection
    AdapterName = 'FireDac'
    AdaptedConnection = FDConnection
    SQLDialect = 'MySQL'
    Params.Strings = (
      'Database=C:\dev\FlixLLCPL\vcl\bin\flixllcpl.db'
      'EnableForeignKeys=True')
    Left = 104
    Top = 264
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 320
    Top = 256
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=flixllcpl'
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 104
    Top = 360
  end
end
