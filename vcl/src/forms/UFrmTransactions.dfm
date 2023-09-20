inherited FrmTransactions: TFrmTransactions
  BorderIcons = [biSystemMenu]
  Caption = 'popTxKind'
  ClientHeight = 296
  ClientWidth = 759
  DoubleBuffered = True
  ExplicitWidth = 775
  ExplicitHeight = 335
  TextHeight = 21
  object btnImport: TButton [0]
    Left = 605
    Top = 8
    Width = 146
    Height = 41
    Anchors = [akTop, akRight]
    Caption = 'Import'
    DoubleBuffered = True
    DropDownMenu = popTxKind
    ParentDoubleBuffered = False
    Style = bsSplitButton
    TabOrder = 0
    OnClick = btnImportClick
  end
  object rbFilterKind: TRadioGroup [1]
    Left = 8
    Top = 8
    Width = 241
    Height = 41
    Caption = 'Show Transactions'
    Columns = 3
    DefaultHeaderFont = False
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -13
    HeaderFont.Name = 'Segoe UI Semibold'
    HeaderFont.Style = [fsBold]
    ItemIndex = 1
    Items.Strings = (
      '&Income'
      '&Expense')
    ShowFrame = False
    TabOrder = 1
    OnClick = rbFilterKindClick
  end
  object DBNavigator1: TDBNavigator [2]
    Left = 184
    Top = 23
    Width = 384
    Height = 25
    DataSource = sourceTransactions
    VisibleButtons = [nbFirst, nbLast, nbInsert, nbDelete, nbPost, nbCancel]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object Transactions: TDBGrid [3]
    Left = 8
    Top = 55
    Width = 743
    Height = 233
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = sourceTransactions
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'PaidOn'
        Title.Caption = 'Date'
        Width = 128
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Category'
        Width = 155
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Title'
        Title.Caption = 'Description'
        Width = 136
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IsMonthly'
        PickList.Strings = (
          'Yes'
          'No')
        Title.Caption = 'Monthly'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Amount'
        Width = 105
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AmountTotal'
        Title.Caption = 'Amount/Yr.'
        Width = 106
        Visible = True
      end>
  end
  inherited actFrmBase: TActionList
    Left = 48
    Top = 104
  end
  object dbTransactions: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Self'
        Attributes = [faReadonly]
        DataType = ftVariant
      end
      item
        Name = 'Id'
        Attributes = [faReadonly, faRequired]
        DataType = ftInteger
      end
      item
        Name = 'PaidOn'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'IsMonthly'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'Category'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
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
      end
      item
        Name = 'Percentage'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'Document'
        DataType = ftVariant
      end
      item
        Name = 'Year'
        Attributes = [faReadonly, faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Month'
        Attributes = [faReadonly, faRequired]
        DataType = ftInteger
      end
      item
        Name = 'MonthsPaid'
        Attributes = [faReadonly, faRequired]
        DataType = ftInteger
      end
      item
        Name = 'AmountTotal'
        Attributes = [faReadonly, faRequired]
        DataType = ftFloat
      end>
    OnNewRecord = dbTransactionsNewRecord
    Left = 408
    Top = 128
    DesignClass = 'UExpense.TExpense'
    object dbTransactionsSelf: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object dbTransactionsId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
      Required = True
    end
    object dbTransactionsPaidOn: TDateTimeField
      Alignment = taRightJustify
      FieldName = 'PaidOn'
      Required = True
      DisplayFormat = 'mm/dd/yy'
      EditMask = '!99/99/00;1;_'
    end
    object dbTransactionsIsMonthly: TBooleanField
      FieldName = 'IsMonthly'
      Required = True
      DisplayValues = 'Yes;No'
    end
    object dbTransactionsCategory: TStringField
      FieldName = 'Category'
      Required = True
      Size = 255
    end
    object dbTransactionsTitle: TStringField
      FieldName = 'Title'
      Required = True
      Size = 255
    end
    object dbTransactionsAmount: TFloatField
      FieldName = 'Amount'
      Required = True
      DisplayFormat = '0,.00'
    end
    object dbTransactionsDocument: TAureliusEntityField
      FieldName = 'Document'
    end
    object dbTransactionsYear: TIntegerField
      FieldName = 'Year'
      ReadOnly = True
      Required = True
    end
    object dbTransactionsMonth: TIntegerField
      FieldName = 'Month'
      ReadOnly = True
      Required = True
    end
    object dbTransactionsMonthsPaid: TIntegerField
      FieldName = 'MonthsPaid'
      ReadOnly = True
      Required = True
    end
    object dbTransactionsAmountTotal: TFloatField
      FieldName = 'AmountTotal'
      ReadOnly = True
      Required = True
      DisplayFormat = '0,.00'
    end
    object dbTransactionsKindEnumName: TStringField
      FieldName = 'Kind.EnumName'
    end
  end
  object sourceTransactions: TDataSource
    DataSet = dbTransactions
    Left = 408
    Top = 184
  end
  object DlgOpen: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    OkButtonLabel = 'Import'
    Options = [fdoPickFolders, fdoPathMustExist]
    Title = 'Pick folder with expense documents'
    Left = 216
    Top = 128
  end
  object popTxKind: TPopupMenu
    Left = 288
    Top = 128
    object menTxKindIncome: TMenuItem
      Caption = 'Income'
      OnClick = menTxKindExpensesClick
    end
    object menTxKindExpenses: TMenuItem
      Tag = 1
      Caption = 'Expenses'
      OnClick = menTxKindExpensesClick
    end
  end
end
