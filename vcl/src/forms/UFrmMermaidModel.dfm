inherited FrmMermaidModel: TFrmMermaidModel
  BorderStyle = bsSizeToolWin
  Caption = 'Generate class model of entities'
  ClientHeight = 486
  ExplicitHeight = 525
  TextHeight = 21
  object txtDiagram: TMemo [0]
    Left = 8
    Top = 48
    Width = 695
    Height = 392
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'txtDiagram')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitHeight = 377
  end
  object cbEntities: TComboBox [1]
    Left = 8
    Top = 8
    Width = 695
    Height = 29
    AutoDropDown = True
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    Sorted = True
    TabOrder = 1
    OnChange = cbEntitiesChange
  end
  object Button1: TButton [2]
    Left = 568
    Top = 446
    Width = 135
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'Copy Markdown'
    TabOrder = 2
    OnClick = Button1Click
    ExplicitTop = 431
  end
  inherited actFrmBase: TActionList
    Left = 48
    Top = 328
  end
end
