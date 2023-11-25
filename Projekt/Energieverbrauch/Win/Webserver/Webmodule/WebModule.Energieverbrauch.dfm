object wm_Energieverbrauch: Twm_Energieverbrauch
  OnCreate = WebModuleCreate
  OnDestroy = WebModuleDestroy
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      Name = 'wai_CheckConnect'
      PathInfo = '/CheckConnect'
      OnAction = wm_Energieverbrauchwai_CheckConnectAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Zaehler_Update'
      PathInfo = '/Zaehler/Update'
      OnAction = wm_Energieverbrauchwai_Zaehler_UpdateAction
    end>
  Height = 230
  Width = 415
end
