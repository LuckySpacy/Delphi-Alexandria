inherited frm_RestTest: Tfrm_RestTest
  Caption = 'frm_RestTest'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 49
    Width = 640
    Height = 431
    Align = alClient
    Lines.Strings = (
      'Memo')
    TabOrder = 1
    ExplicitTop = 55
  end
end
