object frm_RveLinespace: Tfrm_RveLinespace
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Zeilenabstand'
  ClientHeight = 116
  ClientWidth = 175
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 12
    Width = 16
    Height = 13
    Caption = 'Vor'
  end
  object Label2: TLabel
    Left = 40
    Top = 40
    Width = 24
    Height = 13
    Caption = 'Nach'
  end
  object pnl_Button: TPanel
    Left = 0
    Top = 75
    Width = 175
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 56
    ExplicitTop = 120
    ExplicitWidth = 185
    object btn_Cancel: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      TabOrder = 0
      OnClick = btn_CancelClick
    end
    object btn_Ok: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Schlie'#223'en'
      TabOrder = 1
      OnClick = btn_OkClick
    end
  end
  object edt_Vor: TSpinEdit
    Left = 80
    Top = 8
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object edt_Nach: TSpinEdit
    Left = 80
    Top = 37
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
end
