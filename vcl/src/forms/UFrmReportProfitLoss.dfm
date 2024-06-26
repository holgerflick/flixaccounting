inherited FrmReportProfitLoss: TFrmReportProfitLoss
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Profit Loss'
  ClientHeight = 531
  ClientWidth = 1045
  ExplicitWidth = 1045
  ExplicitHeight = 531
  TextHeight = 21
  object Splitter1: TSplitter [0]
    Left = 489
    Top = 0
    Height = 531
    Align = alRight
    ExplicitLeft = 311
    ExplicitTop = 8
    ExplicitHeight = 510
  end
  object FlxPanel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 489
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 599
    ExplicitHeight = 706
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 489
      Height = 25
      Align = alTop
      Alignment = taCenter
      Caption = 'Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 66
    end
    object Splitter2: TSplitter
      Left = 0
      Top = 380
      Width = 489
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 297
      ExplicitWidth = 137
    end
    object GridIncomeTx: TDBGrid
      Left = 0
      Top = 383
      Width = 489
      Height = 101
      Align = alClient
      DataSource = sourceIncomeTx
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'PaidOn'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Title'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Amount'
          Visible = True
        end>
    end
    object GridIncome: TDBGrid
      Left = 0
      Top = 25
      Width = 489
      Height = 355
      Align = alTop
      DataSource = sourceIncome
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Category'
          Width = 307
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Total'
          Width = 161
          Visible = True
        end>
    end
    object FlxPanel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 487
      Width = 456
      Height = 34
      Margins.Right = 30
      Margins.Bottom = 10
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      ExplicitTop = 662
      ExplicitWidth = 566
      object txtTotalIncome: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 450
        Height = 28
        Align = alClient
        Alignment = taRightJustify
        Caption = 'txtTotalIncome'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 305
        ExplicitWidth = 148
        ExplicitHeight = 24
      end
    end
  end
  object panExpense: TPanel [2]
    Left = 492
    Top = 0
    Width = 553
    Height = 531
    Align = alRight
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 602
    ExplicitHeight = 706
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 553
      Height = 25
      Align = alTop
      Alignment = taCenter
      Caption = 'Expense'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 73
    end
    object Splitter3: TSplitter
      Left = 0
      Top = 377
      Width = 553
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 297
      ExplicitWidth = 137
    end
    object GridExpenseTx: TDBGrid
      Left = 0
      Top = 380
      Width = 553
      Height = 104
      Align = alClient
      DataSource = sourceExpenseTx
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'PaidOn'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Title'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Amount'
          Visible = True
        end>
    end
    object GridExpense: TDBGrid
      Left = 0
      Top = 25
      Width = 553
      Height = 352
      Align = alTop
      DataSource = sourceExpense
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Category'
          Width = 307
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Total'
          Width = 161
          Visible = True
        end>
    end
    object FlxPanel3: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 487
      Width = 520
      Height = 34
      Margins.Right = 30
      Margins.Bottom = 10
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      ExplicitTop = 662
      object txtTotalExpense: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 514
        Height = 28
        Align = alClient
        Alignment = taRightJustify
        Caption = 'txtTotalIncome'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 369
        ExplicitWidth = 148
        ExplicitHeight = 24
      end
    end
  end
  inherited actFrmBase: TActionList
    Left = 40
    Top = 104
  end
  object sourceIncome: TDataSource
    DataSet = Income
    Left = 280
    Top = 256
  end
  object sourceIncomeTx: TDataSource
    DataSet = IncomeTx
    Left = 400
    Top = 200
  end
  object sourceExpense: TDataSource
    DataSet = Expense
    Left = 280
    Top = 200
  end
  object sourceExpenseTx: TDataSource
    DataSet = ExpenseTx
    Left = 400
    Top = 256
  end
  object Income: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Self'
        Attributes = [faReadonly]
        DataType = ftVariant
      end
      item
        Name = 'Id'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Category'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Section'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Total'
        Attributes = [faReadonly, faRequired]
        DataType = ftFloat
      end>
    Left = 40
    Top = 192
    DesignClass = 'UProfitLoss.TPLCategory'
    object IncomeSelf: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object IncomeId: TIntegerField
      FieldName = 'Id'
      Required = True
    end
    object IncomeCategory: TStringField
      FieldName = 'Category'
      Required = True
      Size = 255
    end
    object IncomeSection: TIntegerField
      FieldName = 'Section'
      Required = True
    end
    object IncomeTotal: TFloatField
      FieldName = 'Total'
      ReadOnly = True
      Required = True
      DisplayFormat = '0,.00'
    end
    object IncomeTransactions: TDataSetField
      FieldName = 'Transactions'
    end
  end
  object IncomeTx: TAureliusDataset
    DatasetField = IncomeTransactions
    FieldDefs = <
      item
        Name = 'Self'
        Attributes = [faReadonly]
        DataType = ftVariant
      end
      item
        Name = 'Id'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'PaidOn'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'Title'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Amount'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    Left = 40
    Top = 256
    DesignClass = 'UProfitLoss.TPLTransaction'
    object IncomeTxSelf: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object IncomeTxId: TIntegerField
      FieldName = 'Id'
      Required = True
    end
    object IncomeTxPaidOn: TDateTimeField
      FieldName = 'PaidOn'
      Required = True
    end
    object IncomeTxTitle: TStringField
      FieldName = 'Title'
      Required = True
      Size = 255
    end
    object IncomeTxAmount: TFloatField
      FieldName = 'Amount'
      Required = True
      DisplayFormat = '0,.00'
    end
  end
  object Expense: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Self'
        Attributes = [faReadonly]
        DataType = ftVariant
      end
      item
        Name = 'Id'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Category'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Section'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Total'
        Attributes = [faReadonly, faRequired]
        DataType = ftFloat
      end>
    Left = 120
    Top = 192
    DesignClass = 'UProfitLoss.TPLCategory'
    object AureliusEntityField1: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object IntegerField1: TIntegerField
      FieldName = 'Id'
      Required = True
    end
    object StringField1: TStringField
      FieldName = 'Category'
      Required = True
      Size = 255
    end
    object IntegerField2: TIntegerField
      FieldName = 'Section'
      Required = True
    end
    object FloatField1: TFloatField
      FieldName = 'Total'
      ReadOnly = True
      Required = True
      DisplayFormat = '0,.00'
    end
    object ExpenseTransactions: TDataSetField
      FieldName = 'Transactions'
    end
  end
  object ExpenseTx: TAureliusDataset
    DatasetField = ExpenseTransactions
    FieldDefs = <
      item
        Name = 'Self'
        Attributes = [faReadonly]
        DataType = ftVariant
      end
      item
        Name = 'Id'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'PaidOn'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'Title'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Amount'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    Left = 120
    Top = 256
    DesignClass = 'UProfitLoss.TPLTransaction'
    object AureliusEntityField2: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object IntegerField3: TIntegerField
      FieldName = 'Id'
      Required = True
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'PaidOn'
      Required = True
    end
    object StringField2: TStringField
      FieldName = 'Title'
      Required = True
      Size = 255
    end
    object FloatField2: TFloatField
      FieldName = 'Amount'
      Required = True
      DisplayFormat = '0,.00'
    end
  end
end
