object frm_Main: Tfrm_Main
  Left = 0
  Top = 0
  Caption = 'frm_Main'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = -7
    ExplicitWidth = 635
    object btn_Neu: TButton
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 75
      Height = 31
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Neu'
      TabOrder = 0
    end
    object btn_Loeschen: TButton
      AlignWithMargins = True
      Left = 84
      Top = 5
      Width = 75
      Height = 31
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'L'#246'schen'
      TabOrder = 1
    end
    object btn_Starten: TButton
      AlignWithMargins = True
      Left = 165
      Top = 5
      Width = 75
      Height = 31
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Starten'
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 420
    Width = 628
    Height = 22
    Align = alBottom
    BevelOuter = bvLowered
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = -7
    ExplicitTop = 277
    ExplicitWidth = 635
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 613
      Height = 14
      Margins.Right = 10
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Version 1.0.0.0 vom 21.02.2021 von Thomas Bachmann'
      ExplicitLeft = 338
      ExplicitWidth = 286
      ExplicitHeight = 15
    end
  end
  object grd: TAdvStringGrid
    Left = 0
    Top = 41
    Width = 628
    Height = 379
    Align = alClient
    DrawingStyle = gdsClassic
    FixedColor = clWhite
    TabOrder = 2
    GridLineColor = 13948116
    GridFixedLineColor = 11250603
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ActiveCellColor = 11565130
    ActiveCellColorTo = 11565130
    BorderColor = 11250603
    ControlLook.FixedGradientFrom = clWhite
    ControlLook.FixedGradientTo = clWhite
    ControlLook.FixedGradientMirrorFrom = clWhite
    ControlLook.FixedGradientMirrorTo = clWhite
    ControlLook.FixedGradientHoverFrom = clGray
    ControlLook.FixedGradientHoverTo = clWhite
    ControlLook.FixedGradientHoverMirrorFrom = clWhite
    ControlLook.FixedGradientHoverMirrorTo = clWhite
    ControlLook.FixedGradientHoverBorder = 11645361
    ControlLook.FixedGradientDownFrom = clGray
    ControlLook.FixedGradientDownTo = clSilver
    ControlLook.FixedGradientDownMirrorFrom = clWhite
    ControlLook.FixedGradientDownMirrorTo = clWhite
    ControlLook.FixedGradientDownBorder = 11250603
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -11
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Visible = True
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -11
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Visible = True
    ControlLook.DropDownFooter.Buttons = <>
    ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
    ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
    ControlLook.ToggleSwitch.CaptionFont.Height = -11
    ControlLook.ToggleSwitch.CaptionFont.Name = 'Tahoma'
    ControlLook.ToggleSwitch.CaptionFont.Style = []
    ControlLook.ToggleSwitch.Shadow = False
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDown.TextChecked = 'Checked'
    FilterDropDown.TextUnChecked = 'Unchecked'
    FilterDropDownClear = '(All)'
    FilterEdit.TypeNames.Strings = (
      'Starts with'
      'Ends with'
      'Contains'
      'Not contains'
      'Equal'
      'Not equal'
      'Larger than'
      'Smaller than'
      'Clear')
    FixedRowHeight = 22
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    HoverButtons.Buttons = <>
    HTMLSettings.ImageFolder = 'images'
    HTMLSettings.ImageBaseName = 'img'
    Look = glCustom
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'Tahoma'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    SearchFooter.ColorTo = clWhite
    SearchFooter.FindNextCaption = 'Find &next'
    SearchFooter.FindPrevCaption = 'Find &previous'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    SearchFooter.HighLightCaption = 'Highlight'
    SearchFooter.HintClose = 'Close'
    SearchFooter.HintFindNext = 'Find next occurrence'
    SearchFooter.HintFindPrev = 'Find previous occurrence'
    SearchFooter.HintHighlight = 'Highlight occurrences'
    SearchFooter.MatchCaseCaption = 'Match case'
    SearchFooter.ResultFormat = '(%d of %d)'
    SelectionColor = 13744549
    SortSettings.HeaderColor = clWhite
    SortSettings.HeaderColorTo = clWhite
    SortSettings.HeaderMirrorColor = clWhite
    SortSettings.HeaderMirrorColorTo = clWhite
    Version = '9.0.0.2'
    ExplicitLeft = -7
    ExplicitWidth = 635
    ExplicitHeight = 236
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      22
      22
      22
      22
      22
      22
      22
      22
      22
      22)
  end
end
