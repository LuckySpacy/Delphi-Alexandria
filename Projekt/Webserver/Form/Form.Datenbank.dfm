object frm_Datenbank: Tfrm_Datenbank
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frm_Datenbank'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pg: TPageControl
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    ActivePage = tbs_Energieverbrauch
    Align = alClient
    TabOrder = 0
    object tbs_Token: TTabSheet
      Caption = 'Token'
    end
    object tbs_Energieverbrauch: TTabSheet
      Caption = 'Energieverbrauch'
      ImageIndex = 1
    end
  end
end
