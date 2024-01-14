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
    end
    item
      MethodType = mtDelete
      Name = 'wai_Zaehler_Delete'
      PathInfo = '/Zaehler/Update'
      OnAction = wm_Energieverbrauchwai_Zaehler_DeleteAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Zaehler_Read'
      PathInfo = '/Zaehler/Read'
      OnAction = wm_Energieverbrauchwai_Zaehler_ReadAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Zaehlerstand_Update'
      PathInfo = '/Zaehlerstand/Update'
      OnAction = wm_Energieverbrauchwai_Zaehlerstand_UpdateAction
    end
    item
      MethodType = mtDelete
      Name = 'wai_Zaehlerstand_Delete'
      PathInfo = '/Zaehlerstand/Update'
      OnAction = wm_Energieverbrauchwai_Zaehlerstand_DeleteAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Zaehlerstand_ReadJahr'
      PathInfo = '/Zaehlerstand/ReadJahr'
      OnAction = wm_Energieverbrauchwai_ZaehlerstandReadJahrAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Zaehlerstand_ReadZeitraum'
      PathInfo = '/Zaehlerstand/ReadZeitraum'
      OnAction = wm_Energieverbrauchwai_Zaehlerstand_ReadZeitraumAction
    end>
  Height = 230
  Width = 415
end
