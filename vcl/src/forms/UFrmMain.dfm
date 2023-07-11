inherited FrmMain: TFrmMain
  ClientHeight = 441
  ClientWidth = 624
  CustomTitleBar.BackgroundColor = clWhite
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clWhite
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15395562
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  DoubleBuffered = True
  Font.Height = -12
  StyleElements = [seFont, seClient]
  ExplicitWidth = 640
  ExplicitHeight = 480
  TextHeight = 15
  object btnExpenses: TButton
    Left = 8
    Top = 16
    Width = 209
    Height = 73
    Caption = 'Transactions'
    TabOrder = 0
    OnClick = btnExpensesClick
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
