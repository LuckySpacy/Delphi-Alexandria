object dm: Tdm
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object IB_TSI: TIBDatabase
    DatabaseName = 
      'localhost/3050:D:\MeineProgramme\VServerStrato\Datenbank\TSI2.FD' +
      'B'
    Params.Strings = (
      'user_name=sysdba'
      '')
    ServerType = 'IBServer'
    Left = 48
    Top = 32
  end
  object IBT_TSI: TIBTransaction
    DefaultDatabase = IB_TSI
    Left = 120
    Top = 32
  end
  object IB_Kurse: TIBDatabase
    DatabaseName = 'localhost:D:\MeineProgramme\VServerStrato\Datenbank\REZEPT.FDB'
    Params.Strings = (
      'user_name=sysdba')
    ServerType = 'IBServer'
    Left = 48
    Top = 88
  end
  object IBT_Kurse: TIBTransaction
    DefaultDatabase = IB_Kurse
    Left = 128
    Top = 88
  end
end
