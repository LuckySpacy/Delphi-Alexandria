object frm_TSIAnsicht: Tfrm_TSIAnsicht
  Left = 0
  Top = 0
  Caption = 'TSI-Ansicht'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object pg: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    ActivePage = tbs_TSI2
    Align = alClient
    TabOrder = 0
    object tbs_RestTest: TTabSheet
      Caption = 'Resttest'
    end
    object tbs_TSI2: TTabSheet
      Caption = 'TSI2'
      ImageIndex = 1
    end
  end
  object NetHTTPClient: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 264
    Top = 64
  end
  object NetHTTPRequest: TNetHTTPRequest
    Client = NetHTTPClient
    Left = 288
    Top = 160
  end
end
