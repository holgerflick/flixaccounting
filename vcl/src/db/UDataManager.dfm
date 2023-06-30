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
end
