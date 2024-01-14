object dm: Tdm
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 506
  Width = 524
  object IB_Token: TIBDatabase
    DatabaseName = 'localhost:d:\datenbank\energieverbrauch.fdb'
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 40
    Top = 24
  end
  object IBTrans_Token: TIBTransaction
    DefaultDatabase = IB_Token
    Left = 120
    Top = 24
  end
  object qry_Token: TIBQuery
    Database = IB_Token
    Transaction = IBTrans_Token
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 216
    Top = 32
  end
  object IB_Energieverbrauch: TIBDatabase
    DatabaseName = 'localhost:d:\datenbank\energieverbrauch.fdb'
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 40
    Top = 96
  end
  object IBTrans_Energieverbrauch: TIBTransaction
    DefaultDatabase = IB_Energieverbrauch
    Left = 120
    Top = 96
  end
  object qry_Energieverbrauch: TIBQuery
    Database = IB_Energieverbrauch
    Transaction = IBTrans_Energieverbrauch
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 248
    Top = 104
  end
end
