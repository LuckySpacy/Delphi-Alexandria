object frm_NFSRichViewEditPreview: Tfrm_NFSRichViewEditPreview
  Left = 0
  Top = 0
  Caption = 'Vorschau'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 38
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 431
      Top = 11
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object cmb: TComboBox
      Left = 13
      Top = 8
      Width = 132
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemIndex = 2
      TabOrder = 0
      Text = '100%'
      OnClick = DoZoom
      OnExit = DoZoom
      OnKeyDown = cmbKeyDown
      Items.Strings = (
        '200%'
        '150%'
        '100%'
        '75%'
        '50%'
        '25%'
        '10%'
        'Bildschirmbreite'
        'Ganze Seite')
    end
    object btn_First: TButton
      Left = 151
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Erste'
      TabOrder = 1
      OnClick = btn_FirstClick
    end
    object btn_Prev: TButton
      Left = 218
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Vorherige'
      TabOrder = 2
      OnClick = btn_PrevClick
    end
    object btn_Next: TButton
      Left = 284
      Top = 6
      Width = 65
      Height = 25
      Caption = 'N'#228'chste'
      TabOrder = 3
      OnClick = btn_NextClick
    end
    object btn_Last: TButton
      Left = 351
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Letzte'
      TabOrder = 4
      OnClick = btn_LastClick
    end
  end
  object rvpp: TRVPrintPreview
    Left = 0
    Top = 38
    Width = 635
    Height = 261
    Cursor = 103
    MarginsPen.Style = psDot
    Align = alClient
    TabOrder = 1
    BorderStyle = bsSingle
    WheelStep = 20
  end
end
