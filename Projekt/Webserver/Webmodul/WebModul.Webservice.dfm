object wem_Webservice: Twem_Webservice
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Login'
      PathInfo = '/Login'
      OnAction = wem_Webservicewai_LoginAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Energieverbrauch_Zaehler_ReadAll'
      PathInfo = '/Energieverbrauch/Zaehler/ReadAll'
      OnAction = wem_Webservicewai_Energieverbrauch_Zaehler_ReadAllAction
    end>
  Height = 230
  Width = 415
end
