object frm_FontFav: Tfrm_FontFav
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Font Favoriten'
  ClientHeight = 349
  ClientWidth = 437
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
    Top = 308
    Width = 437
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      437
      41)
    object btn_Close: TButton
      Left = 356
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Schlie'#223'en'
      TabOrder = 0
      OnClick = btn_CloseClick
    end
    object btn_Cancel: TButton
      Left = 275
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
    Left = 0
    Top = 0
    Width = 208
    Height = 307
    TabOrder = 1
    object pnl_Fonts: TPanel
      Left = 1
      Top = 1
      Width = 206
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Fonts'
      TabOrder = 0
    end
    object lsb_Font: TListBox
      Left = 1
      Top = 25
      Width = 206
      Height = 281
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
