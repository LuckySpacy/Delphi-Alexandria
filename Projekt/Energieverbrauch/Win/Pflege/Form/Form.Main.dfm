inherited frm_Main: Tfrm_Main
  Caption = 'frm_Main'
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
end
