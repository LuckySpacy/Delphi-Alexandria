object frm_FontFavoriten: Tfrm_FontFavoriten
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Font Favoriten'
  ClientHeight = 350
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Buttton: TPanel
    Left = 0
    Top = 309
    Width = 438
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      438
      41)
    object btn_Close: TButton
      Left = 357
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Schlie'#223'en'
      TabOrder = 0
      OnClick = btn_CloseClick
    end
    object btn_Cancel: TButton
      Left = 276
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
    end
  end
  object pnl_Left: TPanel
    Left = -1
    Top = -5
    Width = 214
    Height = 312
    TabOrder = 1
    object pnl_Fonts: TPanel
      Left = 1
      Top = 1
      Width = 212
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Fonts'
      TabOrder = 0
    end
    object lsb_Font: TListBox
      Left = 1
      Top = 25
      Width = 212
      Height = 286
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = lsb_FontDblClick
    end
  end
  object pnl_Right: TPanel
    Left = 263
    Top = 0
    Width = 172
    Height = 307
    TabOrder = 2
    object pnl_Favoriten: TPanel
      Left = 1
      Top = 1
      Width = 170
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Favoriten'
      TabOrder = 0
    end
    object lsb_Favoriten: TListBox
      Left = 1
      Top = 25
      Width = 170
      Height = 281
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = lsb_FavoritenDblClick
    end
  end
  object pnl_Client: TPanel
    Left = 213
    Top = 0
    Width = 50
    Height = 307
    TabOrder = 3
    object cmd_Right: TSpeedButton
      Left = 6
      Top = 72
      Width = 36
      Height = 41
      Caption = '->'
      OnClick = cmd_RightClick
    end
    object cmd_Left: TSpeedButton
      Left = 6
      Top = 136
      Width = 36
      Height = 41
      Caption = '<-'
      OnClick = cmd_LeftClick
    end
  end
end
