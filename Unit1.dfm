object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'DirToLotsia'
  ClientHeight = 626
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 115
    Height = 13
    Caption = #1055#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1088#1077#1089#1091#1088#1089
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 91
    Height = 13
    Caption = #1054#1073#1098#1077#1082#1090'-'#1087#1088#1080#1077#1084#1085#1080#1082
  end
  object SpeedButton1: TSpeedButton
    Left = 14
    Top = 230
    Width = 65
    Height = 22
    Caption = 'start'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 85
    Top = 230
    Width = 58
    Height = 22
    Caption = 'stop'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 264
    Top = 230
    Width = 120
    Height = 25
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1082#1072#1079
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 176
    Top = 230
    Width = 73
    Height = 25
    OnClick = SpeedButton4Click
  end
  object Button1: TButton
    Left = 448
    Top = 19
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 129
    Top = 21
    Width = 313
    Height = 21
    TabOrder = 1
    Text = '\\Filesrv\'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1074#1077#1088#1089#1080#1080
  end
  object Edit2: TEdit
    Left = 129
    Top = 61
    Width = 313
    Height = 21
    TabOrder = 2
    Text = '100001247000000'
  end
  object Button2: TButton
    Left = 448
    Top = 59
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 96
    Width = 273
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1090#1100' '#1092#1072#1081#1083#1099' '#1080#1079' '#1080#1089#1090#1086#1095#1085#1080#1082#1072' '#1087#1086#1089#1083#1077' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103
    TabOrder = 4
  end
  object Button3: TButton
    Left = 406
    Top = 230
    Width = 75
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100
    TabOrder = 5
    OnClick = Button3Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 119
    Width = 473
    Height = 105
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
    TabOrder = 6
    object Label3: TLabel
      Left = 24
      Top = 24
      Width = 73
      Height = 13
      Caption = #1042#1089#1077#1075#1086' '#1092#1072#1081#1083#1086#1074':'
    end
    object Label4: TLabel
      Left = 24
      Top = 40
      Width = 65
      Height = 13
      Caption = #1042#1089#1077#1075#1086' '#1087#1072#1087#1086#1082':'
    end
    object Label5: TLabel
      Left = 208
      Top = 24
      Width = 57
      Height = 13
      Caption = 'TreadWork:'
    end
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 80
      Width = 441
      Height = 17
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 261
    Width = 478
    Height = 357
    Lines.Strings = (
      '')
    TabOrder = 7
  end
  object Memo2: TMemo
    Left = 492
    Top = 24
    Width = 185
    Height = 594
    Lines.Strings = (
      'Memo2')
    TabOrder = 8
  end
  object ApplicationFactory1: TApplicationFactory
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 448
    Top = 104
  end
end
