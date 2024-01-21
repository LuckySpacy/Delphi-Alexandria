object wem_Webservice: Twem_Webservice
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Login'
      PathInfo = '/Login'
      OnAction = wem_Webservicewai_LoginAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Energieverbrauch_Zaehler_ReadAll'
      PathInfo = '/Energieverbrauch/Zaehler/ReadAll'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehler_ReadAllAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Energieverbrauch_Zaehler_Update'
      PathInfo = '/Energieverbrauch/Zaehler/Update'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehler_UpdateAction
    end
    item
      MethodType = mtDelete
      Name = 'wai_Energieverbrauch_Zaehler_Delete'
      PathInfo = '/Energieverbrauch/Zaehler/Delete'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehler_DeleteAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Energieverbrauch_Zaehlerstand_ReadZeitraum'
      PathInfo = '/Energieverbrauch/Zaehlerstand/ReadZeitraum'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehlerstand_ReadZeitraumAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Energieverbrauch_Zaehlerstand_Update'
      PathInfo = '/Energieverbrauch/Zaehlerstand/Update'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehlerstand_UpdateAction
    end
    item
      MethodType = mtDelete
      Name = 'wai_Energieverbrauch_Zaehlerstand_Delete'
      PathInfo = '/Energieverbrauch/Zaehlerstand/Delete'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehlerstand_DeleteAction
    end>
  Height = 230
  Width = 415
end
