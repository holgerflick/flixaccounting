inherited FrmMain: TFrmMain
  ClientHeight = 441
  ClientWidth = 624
  DoubleBuffered = True
  Font.Height = -12
  StyleElements = [seFont, seClient]
  ExplicitWidth = 640
  ExplicitHeight = 480
  TextHeight = 15
  object btnTransactions: TButton
    Left = 8
    Top = 16
    Width = 209
    Height = 73
    Caption = 'Transactions'
    TabOrder = 0
    OnClick = btnTransactionsClick
  end
  object btnCreateDatabase: TButton
    Left = 431
    Top = 376
    Width = 185
    Height = 57
    Caption = 'Create database'
    TabOrder = 1
    OnClick = btnCreateDatabaseClick
  end
  object btnReportEndOfYear: TButton
    Left = 8
    Top = 95
    Width = 209
    Height = 73
    Caption = 'End of year report'
    TabOrder = 2
  end
  object btnCustomers: TButton
    Left = 8
    Top = 174
    Width = 209
    Height = 73
    Caption = 'Customers'
    TabOrder = 3
    OnClick = btnCustomersClick
  end
  object btnDictionary: TButton
    Left = 240
    Top = 376
    Width = 185
    Height = 57
    Caption = 'Create dictionary'
    TabOrder = 4
    OnClick = btnDictionaryClick
  end
  object btnInvoices: TButton
    Left = 8
    Top = 253
    Width = 209
    Height = 73
    Caption = 'Invoices'
    TabOrder = 5
    OnClick = btnInvoicesClick
  end
end
