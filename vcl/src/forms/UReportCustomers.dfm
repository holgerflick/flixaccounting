inherited FrmReportCustomers: TFrmReportCustomers
  BorderStyle = bsNone
  Caption = 'Customer Report'
  ClientHeight = 593
  ClientWidth = 801
  ExplicitWidth = 801
  ExplicitHeight = 593
  TextHeight = 21
  object Splitter1: TSplitter
    Left = 0
    Top = 225
    Width = 801
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 368
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 470
    Width = 801
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 228
    ExplicitWidth = 245
  end
  object Customers: TDBGrid
    Left = 0
    Top = 0
    Width = 801
    Height = 225
    Align = alTop
    DataSource = sourceCustomers
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Categories: TDBGrid
    Left = 0
    Top = 473
    Width = 801
    Height = 120
    Align = alBottom
    DataSource = sourceCategories
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Invoices: TDBGrid
    Left = 0
    Top = 228
    Width = 801
    Height = 242
    Align = alClient
    DataSource = sourceInvoices
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object sourceCustomers: TDataSource
    Left = 120
    Top = 80
  end
  object sourceInvoices: TDataSource
    Left = 120
    Top = 328
  end
  object sourceCategories: TDataSource
    Left = 152
    Top = 504
  end
end
