object frm_RveLinie: Tfrm_RveLinie
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Linie einf'#252'gen'
  ClientHeight = 144
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 28
    Height = 13
    Caption = 'Breite'
  end
  object Label2: TLabel
    Left = 24
    Top = 52
    Width = 15
    Height = 13
    Caption = 'Art'
  end
  object Label3: TLabel
    Left = 24
    Top = 79
    Width = 28
    Height = 13
    Caption = 'Farbe'
  end
  object pnl_Button: TPanel
    Left = 0
    Top = 103
    Width = 219
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 100
    ExplicitWidth = 227
    DesignSize = (
      219
      41)
    object btn_Ok: TButton
      Left = 134
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Schlie'#223'en'
      TabOrder = 0
      OnClick = btn_OkClick
      ExplicitLeft = 142
    end
    object btn_Cancel: TButton
      Left = 53
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
      ExplicitLeft = 61
    end
  end
  object edt_Width: TSpinEdit
    Left = 63
    Top = 21
    Width = 42
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 1
  end
  object cob_Linienart: TComboBox
    Left = 63
    Top = 49
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'Normale Linie'
    Items.Strings = (
      'Normale Linie'
      'Gepunktet Linie'
      'Gestrichelt Linie'
      'Rechteck')
  end
  object btn_Color: TPanel
    Left = 63
    Top = 76
    Width = 44
    Height = 20
    Color = clBlack
    ParentBackground = False
    TabOrder = 3
    OnMouseDown = btn_ColorMouseDown
    OnMouseUp = btn_ColorMouseUp
  end
  object ColorDialog: TColorDialog
    Left = 128
    Top = 72
  end
end
