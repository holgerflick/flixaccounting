object DataManager: TDataManager
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Connection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=C:\dev\FlixLLCPL\vcl\bin\flixllcpl.db'
      'EnableForeignKeys=True')
    Left = 104
    Top = 264
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 232
    Top = 360
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=flixllcpl'
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=192.168.0.50'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 104
    Top = 360
  end
end
