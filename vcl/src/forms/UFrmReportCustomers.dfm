inherited FrmReportCustomers: TFrmReportCustomers
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Customer Report'
  ClientHeight = 443
  ClientWidth = 631
  ExplicitWidth = 631
  ExplicitHeight = 443
  TextHeight = 21
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 225
    Width = 631
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 368
  end
  object Splitter2: TSplitter [1]
    Left = 0
    Top = 320
    Width = 631
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 228
    ExplicitWidth = 245
  end
  object Customers: TDBGrid [2]
    Left = 0
    Top = 0
    Width = 631
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
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Width = 500
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Total'
        Visible = True
      end>
  end
  object Categories: TDBGrid [3]
    Left = 0
    Top = 323
    Width = 631
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
    Columns = <
      item
        Expanded = False
        FieldName = 'Category'
        Width = 500
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Total'
        Visible = True
      end>
  end
  object Invoices: TDBGrid [4]
    Left = 0
    Top = 228
    Width = 631
    Height = 92
    Align = alClient
    DataSource = sourceInvoices
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Number'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Issued'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Paid'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Total'
        Visible = True
      end>
  end
  inherited actFrmBase: TActionList
    Left = 72
    Top = 72
  end
  object sourceCustomers: TDataSource
    DataSet = ReportManager.CustomerReport
    Left = 312
    Top = 72
  end
  object sourceInvoices: TDataSource
    DataSet = ReportManager.CRInvoiceTotals
    Left = 208
    Top = 72
  end
  object sourceCategories: TDataSource
    DataSet = ReportManager.CRCategoryTotals
    Left = 424
    Top = 72
  end
end
