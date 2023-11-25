object frm_NFSRichViewEditTable: Tfrm_NFSRichViewEditTable
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tabelle einf'#252'gen'
  ClientHeight = 251
  ClientWidth = 170
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 71
    Height = 13
    Caption = 'Anzahl Spalten'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 63
    Height = 13
    Caption = 'Anzahl Zeilen'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 69
    Height = 13
    Caption = 'Rahmenst'#228'rke'
  end
  object Label4: TLabel
    Left = 16
    Top = 108
    Width = 58
    Height = 13
    Caption = 'Zellenst'#228'rke'
  end
  object Label5: TLabel
    Left = 16
    Top = 136
    Width = 66
    Height = 13
    Caption = 'Tabellenfarbe'
  end
  object Label6: TLabel
    Left = 16
    Top = 162
    Width = 65
    Height = 13
    Caption = 'Rahmenfarbe'
  end
  object Label7: TLabel
    Left = 16
    Top = 188
    Width = 90
    Height = 13
    Caption = 'Zellenrahmenfarbe'
  end
  object pnl_Button: TPanel
    Left = 0
    Top = 210
    Width = 170
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 212
    ExplicitWidth = 173
    DesignSize = (
      170
      41)
    object btn_Ok: TButton
      Left = 85
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_OkClick
      ExplicitLeft = 88
    end
    object btn_Cancel: TButton
      Left = 4
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
      ExplicitLeft = 7
    end
  end
  object edt_Spalten: TSpinEdit
    Left = 112
    Top = 21
    Width = 44
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object edt_Zeilen: TSpinEdit
    Left = 112
    Top = 49
    Width = 44
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object edt_Rahmendicke: TSpinEdit
    Left = 112
    Top = 77
    Width = 44
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object edt_Zellendicke: TSpinEdit
    Left = 112
    Top = 105
    Width = 44
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object cmd_TableColor: TPanel
    Left = 112
    Top = 133
    Width = 44
    Height = 20
    ParentBackground = False
    TabOrder = 5
    OnMouseDown = PnlButtonColorMouseDown
    OnMouseUp = PnlButtonColorMouseUp
  end
  object cmd_BorderColor: TPanel
    Left = 112
    Top = 159
    Width = 44
    Height = 20
    ParentBackground = False
    TabOrder = 6
    OnMouseDown = PnlButtonColorMouseDown
    OnMouseUp = PnlButtonColorMouseUp
  end
  object cmd_CellBorderColor: TPanel
    Left = 112
    Top = 185
    Width = 44
    Height = 20
    ParentBackground = False
    TabOrder = 7
    OnMouseDown = PnlButtonColorMouseDown
    OnMouseUp = PnlButtonColorMouseUp
  end
  object ColorDialog: TColorDialog
    Left = 8
  end
end
