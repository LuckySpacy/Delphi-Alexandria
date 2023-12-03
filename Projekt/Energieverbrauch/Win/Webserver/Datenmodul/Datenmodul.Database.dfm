object dm: Tdm
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 463
  Width = 532
  object IB: TIBDatabase
    DatabaseName = 'localhost:d:\datenbank\energieverbrauch.fdb'
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 160
    Top = 96
  end
  object IBTrans: TIBTransaction
    DefaultDatabase = IB
    Left = 272
    Top = 96
  end
  object qry: TIBQuery
    Database = IB
    Transaction = IBTrans
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 376
    Top = 144
  end
end
