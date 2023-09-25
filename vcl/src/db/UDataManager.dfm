object DataManager: TDataManager
  OnCreate = DataModuleCreate
  Height = 252
  Width = 328
  object Connection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=C:\db\acc_flix.db'
      'EnableForeignKeys=True')
    Left = 48
    Top = 24
  end
  object MemConnection: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=:memory:'
      'EnableForeignKeys=True')
    Left = 200
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 200
    Top = 160
  end
end
