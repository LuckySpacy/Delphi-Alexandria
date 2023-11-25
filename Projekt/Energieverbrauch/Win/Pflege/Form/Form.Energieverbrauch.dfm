object frm_Energieverbrauch: Tfrm_Energieverbrauch
  Left = 0
  Top = 0
  Caption = 'Energieverbrauch'
  ClientHeight = 595
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object pnl_Client: TPanel
    Left = 0
    Top = 0
    Width = 470
    Height = 595
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_Client'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 466
    ExplicitHeight = 594
  end
end
