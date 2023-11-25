object Form1: TForm1
  Left = 271
  Top = 114
  Caption = 'Form1'
  ClientHeight = 323
  ClientWidth = 748
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object ButtonStart: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Starten'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 105
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Anhalten'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 24
    Top = 67
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '8079'
  end
  object ButtonOpenBrowser: TButton
    Left = 186
    Top = 8
    Width = 107
    Height = 25
    Caption = 'Browser '#246'ffnen'
    TabOrder = 3
    OnClick = ButtonOpenBrowserClick
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 104
    Width = 681
    Height = 105
    Caption = 'Datenbank'
    TabOrder = 4
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label3: TLabel
      Left = 16
      Top = 51
      Width = 22
      Height = 13
      Caption = 'Pfad'
    end
    object Label4: TLabel
      Left = 16
      Top = 77
      Width = 82
      Height = 13
      Caption = 'Datenbankname:'
    end
    object edt_Host: TEdit
      Left = 104
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '8079'
    end
    object edt_Datenbankpfad: TEdit
      Left = 104
      Top = 48
      Width = 561
      Height = 21
      TabOrder = 1
      Text = '8079'
    end
    object edt_Datenbankname: TEdit
      Left = 104
      Top = 75
      Width = 235
      Height = 21
      TabOrder = 2
      Text = '8079'
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 328
    Top = 32
  end
end
