inherited FrmReportProfitLoss: TFrmReportProfitLoss
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Profit Loss'
  ClientHeight = 706
  ClientWidth = 1155
  ExplicitWidth = 1155
  ExplicitHeight = 706
  TextHeight = 21
  object Splitter1: TSplitter
    Left = 599
    Top = 0
    Height = 706
    Align = alRight
    ExplicitLeft = 311
    ExplicitTop = 8
    ExplicitHeight = 510
  end
  object FlxPanel1: TFlxPanel
    Left = 0
    Top = 0
    Width = 599
    Height = 706
    Align = alClient
    BevelOuter = bvNone
    Caption = 'FlxPanel1'
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 599
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
      Top = 377
      Width = 599
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 297
      ExplicitWidth = 137
    end
    object GridIncomeTx: TDBGrid
      Left = 0
      Top = 380
      Width = 599
      Height = 279
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
      Width = 599
      Height = 352
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
    object FlxPanel2: TFlxPanel
      AlignWithMargins = True
      Left = 3
      Top = 662
      Width = 566
      Height = 34
      Margins.Right = 30
      Margins.Bottom = 10
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'FlxPanel2'
      ShowCaption = False
      TabOrder = 2
      object DBText1: TDBText
        Left = 0
        Top = 0
        Width = 566
        Height = 34
        Align = alClient
        Alignment = taRightJustify
        DataField = 'SumTotal'
        DataSource = sourceIncome
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = 8
        ExplicitWidth = 599
        ExplicitHeight = 33
      end
    end
  end
  object panExpense: TFlxPanel
    Left = 602
    Top = 0
    Width = 553
    Height = 706
    Align = alRight
    BevelOuter = bvNone
    Caption = 'FlxPanel1'
    ShowCaption = False
    TabOrder = 1
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
      Height = 279
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
    object FlxPanel3: TFlxPanel
      AlignWithMargins = True
      Left = 3
      Top = 662
      Width = 520
      Height = 34
      Margins.Right = 30
      Margins.Bottom = 10
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'FlxPanel2'
      ShowCaption = False
      TabOrder = 2
      object DBText2: TDBText
        Left = 0
        Top = 0
        Width = 520
        Height = 34
        Align = alClient
        Alignment = taRightJustify
        DataField = 'SumTotal'
        DataSource = sourceExpense
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = 8
        ExplicitWidth = 599
        ExplicitHeight = 33
      end
    end
  end
  object sourceIncome: TDataSource
    DataSet = Income
    Left = 456
    Top = 176
  end
  object sourceIncomeTx: TDataSource
    DataSet = TxIncome
    Left = 440
    Top = 472
  end
  object sourceExpense: TDataSource
    DataSet = Expense
    Left = 688
    Top = 184
  end
  object sourceExpenseTx: TDataSource
    DataSet = TxExpense
    Left = 696
    Top = 480
  end
  object Income: TFDMemTable
    IndexesActive = False
    AggregatesActive = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 224
    Top = 440
    object IncomeCategory: TStringField
      FieldName = 'Category'
      Size = 500
    end
    object IncomeTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
    object IncomeTransactions: TDataSetField
      FieldName = 'Transactions'
    end
    object IncomeTxCount: TIntegerField
      FieldName = 'TxCount'
    end
    object IncomeIsLoss: TBooleanField
      FieldName = 'IsLoss'
    end
    object IncomeSumTotal: TAggregateField
      FieldName = 'SumTotal'
      Active = True
      DisplayName = ''
      DisplayFormat = '0,.00'
      Expression = 'SUM(Total)'
    end
  end
  object TxIncome: TFDMemTable
    DataSetField = IncomeTransactions
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'byCategory'
        Fields = 'Category;IsLoss'
      end>
    IndexesActive = False
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StoreItems = [siMeta, siData]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 224
    Top = 504
    object TxIncomePaidOn: TDateField
      FieldName = 'PaidOn'
    end
    object TxIncomeTitle: TStringField
      FieldName = 'Title'
      Size = 500
    end
    object TxIncomeAmount: TFloatField
      FieldName = 'Amount'
      DisplayFormat = '0,.00'
    end
    object TxIncomeTxId: TIntegerField
      FieldName = 'TxId'
    end
  end
  object Expense: TFDMemTable
    IndexesActive = False
    AggregatesActive = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 896
    Top = 456
    object ExpenseCategory: TStringField
      FieldName = 'Category'
      Size = 500
    end
    object ExpenseTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
    object ExpenseTransactions: TDataSetField
      FieldName = 'Transactions'
    end
    object ExpenseTxCount: TIntegerField
      FieldName = 'TxCount'
    end
    object ExpenseIsLoss: TBooleanField
      FieldName = 'IsLoss'
    end
    object ExpenseSumTotal: TAggregateField
      FieldName = 'SumTotal'
      Active = True
      DisplayName = ''
      DisplayFormat = '0,.00'
      Expression = 'SUM(Total)'
    end
  end
  object TxExpense: TFDMemTable
    DataSetField = ExpenseTransactions
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'byCategory'
        Fields = 'Category;IsLoss'
      end>
    IndexesActive = False
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StoreItems = [siMeta, siData]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 896
    Top = 520
    object TxExpensePaidOn: TDateField
      FieldName = 'PaidOn'
    end
    object TxExpenseTitle: TStringField
      FieldName = 'Title'
      Size = 500
    end
    object TxExpenseAmount: TFloatField
      FieldName = 'Amount'
      DisplayFormat = '0,.00'
    end
    object TxExpenseTxId: TIntegerField
      FieldName = 'TxId'
    end
  end
end
