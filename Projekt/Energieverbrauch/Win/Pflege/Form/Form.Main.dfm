inherited frm_Main: Tfrm_Main
  Caption = 'frm_Main'
  OnShow = FormShow
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 602
    Height = 38
    ButtonHeight = 38
    ButtonWidth = 39
    Caption = 'ToolBar1'
    Images = dm_Bilder.SVGIconImageList
    TabOrder = 0
    object btn_Einstellung: TToolButton
      Left = 0
      Top = 0
      Caption = 'btn_Einstellung'
      ImageIndex = 0
      ImageName = 'process'
      OnClick = btn_EinstellungClick
    end
  end
  object ListView1: TListView
    Left = 104
    Top = 216
    Width = 250
    Height = 150
    Columns = <
      item
      end>
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 121
    Top = 72
    Width = 233
    Height = 65
    Caption = 'Panel1'
    TabOrder = 2
  end
end
