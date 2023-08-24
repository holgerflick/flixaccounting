object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'FlixLLC Example == API Server =='
  ClientHeight = 242
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Noto Sans'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    472
    242)
  TextHeight = 18
  object mmInfo: TMemo
    Left = 8
    Top = 40
    Width = 456
    Height = 194
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 0
  end
  object btStart: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = btStartClick
  end
  object btStop: TButton
    Left = 90
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = btStopClick
  end
  object btnSwaggerUi: TButton
    Left = 370
    Top = 9
    Width = 94
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SwaggerUI'
    TabOrder = 3
    OnClick = btnSwaggerUiClick
  end
end
