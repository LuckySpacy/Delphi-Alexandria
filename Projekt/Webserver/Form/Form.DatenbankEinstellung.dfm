object frm_Datenbankeinstellung: Tfrm_Datenbankeinstellung
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frm_Datenbankeinstellung'
  ClientHeight = 329
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 10
    Width = 842
    Height = 183
    Margins.Top = 10
    Align = alTop
    Caption = 'Datenbank'
    TabOrder = 0
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object Label3: TLabel
      Left = 16
      Top = 51
      Width = 24
      Height = 15
      Caption = 'Pfad'
    end
    object Label4: TLabel
      Left = 16
      Top = 77
      Width = 90
      Height = 15
      Caption = 'Datenbankname:'
    end
    object edt_Host: TEdit
      Left = 112
      Top = 21
      Width = 121
      Height = 23
      TabOrder = 0
      Text = '8079'
      OnExit = EingabefelderExit
    end
    object edt_Datenbankpfad: TEdit
      Left = 112
      Top = 48
      Width = 449
      Height = 23
      TabOrder = 1
      Text = '8079'
      OnExit = EingabefelderExit
    end
    object edt_Datenbankname: TEdit
      Left = 112
      Top = 75
      Width = 235
      Height = 23
      TabOrder = 2
      Text = '8079'
      OnExit = EingabefelderExit
    end
    object cbx_Aktiv: TCheckBox
      Left = 112
      Top = 105
      Width = 97
      Height = 17
      Caption = 'Aktiv'
      TabOrder = 3
      OnExit = EingabefelderExit
    end
    object btn_CheckConnection: TButton
      Left = 112
      Top = 144
      Width = 137
      Height = 25
      Caption = 'Pr'#252'fe Verbindung'
      TabOrder = 4
      OnClick = btn_CheckConnectionClick
    end
  end
end
