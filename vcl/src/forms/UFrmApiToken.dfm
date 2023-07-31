inherited FrmApiToken: TFrmApiToken
  BorderStyle = bsSizeToolWin
  Caption = 'Add token'
  ClientHeight = 131
  ClientWidth = 649
  ExplicitWidth = 665
  ExplicitHeight = 170
  TextHeight = 21
  object txtToken: TEdit [0]
    Left = 8
    Top = 8
    Width = 633
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Text = 'txtToken'
  end
  object dtExpiresOn: TDateTimePicker [1]
    Left = 8
    Top = 37
    Width = 633
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    Date = 45138.000000000000000000
    Time = 0.646972071757772900
    DoubleBuffered = True
    Kind = dtkDateTime
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object btnCopy: TButton [2]
    Left = 504
    Top = 91
    Width = 137
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Copy Link'
    TabOrder = 2
    OnClick = btnCopyClick
  end
  inherited actFrmBase: TActionList
    Left = 16
    Top = 72
  end
end
