object DataManager: TDataManager
  OnCreate = DataModuleCreate
  Height = 252
  Width = 328
  object Connection: TAureliusConnection
    AdapterName = 'FireDac'
    Params.Strings = (
      'Database=C:\dev\FlixLLCPL\vcl\bin\flixllcpl.db'
      'EnableForeignKeys=True')
    Left = 48
    Top = 24
  end
  object MySQLUnits: TFDPhysMySQLDriverLink
    Left = 48
    Top = 152
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=flixllcpl'
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 48
    Top = 88
  end
  object MemConnection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=:memory:'
      'EnableForeignKeys=True')
    Left = 200
    Top = 24
  end
  object SQLiteUnits: TFDPhysSQLiteDriverLink
    Left = 208
    Top = 152
  end
end
