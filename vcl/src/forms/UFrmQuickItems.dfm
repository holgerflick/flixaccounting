inherited FrmQuickItems: TFrmQuickItems
  BorderStyle = bsSizeToolWin
  Caption = 'Quick Items'
  ClientHeight = 385
  ClientWidth = 698
  ExplicitWidth = 714
  ExplicitHeight = 424
  TextHeight = 21
  object Splitter1: TSplitter
    Left = 0
    Top = 225
    Width = 698
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 243
    ExplicitWidth = 723
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 698
    Height = 184
    Align = alTop
    DataSource = sourceItems
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'JetBrains Mono'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Width = 155
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Category'
        Width = 166
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantity'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Value'
        Visible = True
      end>
  end
  object DBMemo1: TDBMemo
    Left = 0
    Top = 230
    Width = 698
    Height = 155
    Align = alClient
    DataField = 'Description'
    DataSource = sourceItems
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 698
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      698
      41)
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = 8
      Width = 540
      Height = 25
      DataSource = sourceItems
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object btnUse: TButton
      Left = 553
      Top = 8
      Width = 135
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Use item'
      TabOrder = 1
      OnClick = btnUseClick
    end
  end
  object Items: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Id'
        Attributes = [faReadonly, faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Description'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Category'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Quantity'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'Value'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    CreateSelfField = False
    Left = 48
    Top = 312
    DesignClass = 'UInvoice.TQuickItem'
    object ItemsId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
      Required = True
    end
    object ItemsName: TStringField
      FieldName = 'Name'
      Size = 255
    end
    object ItemsCategory: TStringField
      FieldName = 'Category'
      Required = True
      Size = 255
    end
    object ItemsQuantity: TFloatField
      FieldName = 'Quantity'
      Required = True
    end
    object ItemsValue: TFloatField
      FieldName = 'Value'
      Required = True
    end
    object ItemsDescription: TStringField
      FieldName = 'Description'
      Required = True
      Size = 255
    end
  end
  object sourceItems: TDataSource
    DataSet = Items
    Left = 104
    Top = 312
  end
end
