object Member: TMember
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Manage SwimClubMeet Members ...'
  ClientHeight = 290
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 21
  object Label1: TLabel
    Left = 48
    Top = 19
    Width = 45
    Height = 21
    Alignment = taRightJustify
    Caption = 'Server'
  end
  object Label2: TLabel
    Left = 15
    Top = 59
    Width = 78
    Height = 21
    Alignment = taRightJustify
    Caption = 'User Name'
  end
  object Label3: TLabel
    Left = 27
    Top = 99
    Width = 66
    Height = 21
    Alignment = taRightJustify
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 523
    Top = 19
    Width = 111
    Height = 21
    Alignment = taRightJustify
    Caption = 'Swimming Club'
  end
  object lblAniIndicatorStatus: TLabel
    Left = 576
    Top = 112
    Width = 79
    Height = 21
    Caption = 'Connecting'
  end
  object chkbUseOsAuthentication: TCheckBox
    Left = 99
    Top = 136
    Width = 206
    Height = 24
    Caption = 'Use OS Authentication'
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 99
    Top = 96
    Width = 263
    Height = 29
    TabOrder = 1
    Text = 'edtPassword'
  end
  object edtServerName: TEdit
    Left = 99
    Top = 16
    Width = 387
    Height = 29
    TabOrder = 2
    Text = 'edtServerName'
  end
  object edtUser: TEdit
    Left = 99
    Top = 56
    Width = 335
    Height = 29
    TabOrder = 3
    Text = 'edtUser'
  end
  object DBComboBox1: TDBComboBox
    Left = 640
    Top = 16
    Width = 313
    Height = 29
    TabOrder = 4
  end
  object btnConnect: TButton
    Left = 99
    Top = 176
    Width = 150
    Height = 32
    Action = actnConnect
    TabOrder = 5
  end
  object btnDisconnect: TButton
    Left = 287
    Top = 176
    Width = 150
    Height = 32
    Action = actnDisconnect
    TabOrder = 6
  end
  object btnManageMembers: TButton
    Left = 803
    Top = 58
    Width = 150
    Height = 32
    Action = actnManageMembers
    TabOrder = 7
  end
  object ActivityIndicator1: TActivityIndicator
    Left = 586
    Top = 99
    IndicatorSize = aisLarge
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 264
    Width = 971
    Height = 26
    Panels = <>
  end
  object ActionList1: TActionList
    Left = 384
    Top = 96
    object actnConnect: TAction
      Caption = 'Connect'
      OnExecute = actnConnectExecute
      OnUpdate = actnConnectUpdate
    end
    object actnDisconnect: TAction
      Caption = 'Disconnect'
      OnExecute = actnDisconnectExecute
      OnUpdate = actnDisconnectUpdate
    end
    object actnManageMembers: TAction
      Caption = 'Manage Members'
    end
  end
  object Timer1: TTimer
    Left = 608
    Top = 160
  end
end
