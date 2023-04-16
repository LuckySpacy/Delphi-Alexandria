object dm: Tdm
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 236
  Width = 357
  object IBD_Optima: TIBDatabase
    DatabaseName = 'localhost:c:/Datenbank/demo4.fdb'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'sql_dialect=1')
    LoginPrompt = False
    ServerType = 'IBServer'
    SQLDialect = 1
    TraceFlags = [tfQExecute, tfTransact]
    Left = 24
    Top = 8
  end
  object IBT_Optima: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = IBD_Optima
    Left = 125
    Top = 8
  end
end
