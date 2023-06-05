object WebModule1: TWebModule1
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Number'
      PathInfo = '/Number'
      OnAction = WebModule1wai_NumberAction
    end
    item
      Name = 'wai_AktieList'
      PathInfo = '/Aktielist'
      OnAction = WebModule1wai_AktieListAction
    end
    item
      MethodType = mtPost
      Name = 'wai_Aktiewkn'
      PathInfo = '/aktiewkn'
      OnAction = WebModule1wai_AktiewknAction
    end
    item
      MethodType = mtGet
      Name = 'wai_Ansichtlist'
      PathInfo = '/Ansichtlist'
      OnAction = WebModule1wai_AnsichtlistAction
    end>
  Height = 230
  Width = 415
end
