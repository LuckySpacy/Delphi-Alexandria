object frm_Webservice: Tfrm_Webservice
  Left = 271
  Top = 114
  Caption = 'Webservice'
  ClientHeight = 455
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnl_Button: TPanel
    Left = 0
    Top = 0
    Width = 625
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_Button'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 621
    object Label1: TLabel
      Left = 208
      Top = 12
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object ButtonStart: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Starten'
      TabOrder = 0
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 97
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Anhalten'
      TabOrder = 1
      OnClick = ButtonStopClick
    end
    object edt_Port: TEdit
      Left = 243
      Top = 11
      Width = 62
      Height = 21
      TabOrder = 2
      Text = '8079'
    end
    object ButtonOpenBrowser: TButton
      Left = 338
      Top = 9
      Width = 107
      Height = 25
      Caption = 'Browser '#246'ffnen'
      TabOrder = 3
      OnClick = ButtonOpenBrowserClick
    end
  end
  object pnl_Client: TPanel
    Left = 0
    Top = 41
    Width = 625
    Height = 414
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_Button'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 621
    ExplicitHeight = 413
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 400
    Top = 40
  end
end
