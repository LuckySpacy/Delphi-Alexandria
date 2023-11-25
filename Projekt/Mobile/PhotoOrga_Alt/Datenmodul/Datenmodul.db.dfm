object dm_db: Tdm_db
  Height = 480
  Width = 640
  object Connection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Projects\BAScloud\alexandria_mobile_bascloud\Demo3\D' +
        'atenbank\BasCloud.db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = ConnectionBeforeConnect
    Left = 20
    Top = 12
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 44
    Top = 96
  end
  object FDQuery1: TFDQuery
    Connection = Connection
    Left = 128
    Top = 52
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 216
    Top = 100
  end
  object fdt_Trans: TFDTransaction
    Connection = Connection
    Left = 352
    Top = 248
  end
  object FDManager1: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 448
    Top = 96
  end
end
