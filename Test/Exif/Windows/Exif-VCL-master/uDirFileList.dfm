object fmDirFileList: TfmDirFileList
  Left = 0
  Top = 0
  Caption = 'fmDirFileList'
  ClientHeight = 666
  ClientWidth = 866
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 249
    Top = 206
    Width = 4
    Height = 302
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitHeight = 582
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 866
    Height = 206
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      866
      206)
    object SpeedButton1: TSpeedButton
      Left = 399
      Top = 38
      Width = 80
      Height = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1074#1099#1073#1088#1072#1090#1100
      OnClick = SpeedButton1Click
    end
    object Label2: TLabel
      Left = 146
      Top = 22
      Width = 104
      Height = 13
      Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1092#1072#1081#1083#1099
    end
    object btCancel: TButton
      Left = 362
      Top = 167
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1054#1090#1084#1077#1085#1072
      Enabled = False
      TabOrder = 5
      OnClick = btCancelClick
    end
    object leRoot: TLabeledEdit
      Left = 10
      Top = 44
      Width = 381
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      EditLabel.Width = 39
      EditLabel.Height = 13
      EditLabel.Margins.Left = 4
      EditLabel.Margins.Top = 4
      EditLabel.Margins.Right = 4
      EditLabel.Margins.Bottom = 4
      EditLabel.Caption = 'Root Dir'
      TabOrder = 0
      Text = 'C:\Users\asovtsov\Downloads'
    end
    object btMongo: TButton
      Left = 261
      Top = 167
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072
      TabOrder = 1
      OnClick = btMongoClick
    end
    object grpOptions: TGroupBox
      Left = 499
      Top = 12
      Width = 250
      Height = 185
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      TabOrder = 2
      object cbBatch: TCheckBox
        Left = 139
        Top = 78
        Width = 121
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #1055#1072#1082#1077#1090#1085#1086
        TabOrder = 0
      end
      object cbInsert: TCheckBox
        Left = 139
        Top = 50
        Width = 121
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074' '#1041#1044
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object cbWThumb: TCheckBox
        Left = 10
        Top = 24
        Width = 121
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #1089' '#1084#1080#1085#1080#1072#1090#1102#1088#1086#1081
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 2
      end
      object cbShow: TCheckBox
        Left = 139
        Top = 22
        Width = 121
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show'
        TabOrder = 3
      end
      object cbStandards: TCheckBox
        Left = 10
        Top = 51
        Width = 121
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Standards'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 4
      end
      object cbMkNotes: TCheckBox
        Left = 10
        Top = 78
        Width = 121
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'MakerNotes'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 5
      end
      object RadioGroup1: TRadioGroup
        Left = 43
        Top = 123
        Width = 185
        Height = 55
        Caption = #1047#1072#1087#1080#1089#1100' '#1074' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1074' '#1086#1076#1085#1091
          #1074' '#1076#1074#1077)
        TabOrder = 6
      end
    end
    object edtFileMask: TEdit
      Left = 257
      Top = 19
      Width = 134
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 3
      Text = '.jpg,.png,.psd,.tif,.cr2'
    end
    object grMongo: TGroupBox
      Left = 10
      Top = 73
      Width = 227
      Height = 125
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #1057#1077#1088#1074#1077#1088
      TabOrder = 4
      object Label1: TLabel
        Left = 15
        Top = 23
        Width = 46
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Host:port'
      end
      object Label3: TLabel
        Left = 55
        Top = 56
        Width = 14
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #1041#1044
      end
      object Label4: TLabel
        Left = 55
        Top = 90
        Width = 62
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      end
      object Label5: TLabel
        Left = 156
        Top = 23
        Width = 4
        Height = 13
        Caption = ':'
      end
      object ToggleSwitch1: TToggleSwitch
        Left = 140
        Top = 85
        Width = 74
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        FrameColor = clScrollBar
        StateCaptions.CaptionOn = #1044#1072
        StateCaptions.CaptionOff = #1053#1077#1090
        SwitchHeight = 24
        SwitchWidth = 49
        TabOrder = 0
        OnClick = ToggleSwitch1Click
      end
      object Edit2: TEdit
        Left = 84
        Top = 19
        Width = 69
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 1
        Text = 'mslasovt02'
      end
      object Edit1: TEdit
        Left = 84
        Top = 50
        Width = 136
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 2
        Text = 'Grafics'
      end
      object Edit3: TEdit
        Left = 168
        Top = 19
        Width = 51
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Text = '27017'
      end
    end
    object grpThumbnail: TGroupBox
      AlignWithMargins = True
      Left = 759
      Top = 12
      Width = 103
      Height = 185
      Margins.Left = 6
      Margins.Top = 12
      Margins.Right = 0
      Margins.Bottom = 0
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = #1050#1072#1088#1090#1080#1085#1082#1072
      TabOrder = 6
      object imgThumbnail: TImage
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 93
        Height = 162
        Align = alClient
        IncrementalDisplay = True
        Proportional = True
        Stretch = True
        OnClick = imgThumbnailClick
        ExplicitLeft = 4
        ExplicitTop = 16
        ExplicitWidth = 95
        ExplicitHeight = 331
      end
    end
  end
  object ListBox1: TListBox
    AlignWithMargins = True
    Left = 4
    Top = 210
    Width = 241
    Height = 294
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 642
    Width = 866
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Panels = <>
    SimplePanel = True
  end
  object ListBox2: TListBox
    AlignWithMargins = True
    Left = 257
    Top = 210
    Width = 605
    Height = 294
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 3
    OnClick = ListBox2Click
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 4
    Top = 512
    Width = 858
    Height = 126
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object ActivityIndicator1: TActivityIndicator
    Left = 290
    Top = 83
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    FrameDelay = 5
    IndicatorSize = aisXLarge
    IndicatorType = aitSectorRing
  end
  object btFileListClear: TButton
    Left = 399
    Top = 81
    Width = 80
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080
    TabOrder = 6
    OnClick = btFileListClearClick
  end
  object btDelFilesSelected: TButton
    Left = 399
    Top = 121
    Width = 80
    Height = 25
    Caption = #1059#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087'.'
    TabOrder = 7
    OnClick = btDelFilesSelectedClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=mslasovt02'
      'DriverID=Mongo')
    BeforeConnect = FDConnection1BeforeConnect
    Left = 512
    Top = 224
  end
  object NotificationCenter1: TNotificationCenter
    Left = 408
    Top = 224
  end
end
