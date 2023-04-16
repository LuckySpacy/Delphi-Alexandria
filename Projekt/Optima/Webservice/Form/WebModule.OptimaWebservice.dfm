object WebModule1: TWebModule1
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtPost
      Name = 'wai_LoginPost'
      PathInfo = '/Login'
      OnAction = WebModule1wai_LoginPostAction
    end
    item
      MethodType = mtPost
      Name = 'wai_alive'
      PathInfo = '/alive'
      OnAction = WebModule1wai_aliveAction
    end
    item
      MethodType = mtPost
      Name = 'wai_EAN'
      PathInfo = '/ean'
      OnAction = WebModule1wai_EANAction
    end>
  Height = 230
  Width = 415
end
