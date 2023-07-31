object ReportManager: TReportManager
  OnCreate = DataModuleCreate
  Height = 403
  Width = 579
  object CustomerReport: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StoreItems = [siData]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 72
    Top = 96
    object CustomerReportCustomerId: TIntegerField
      FieldName = 'CustomerId'
    end
    object CustomerReportName: TStringField
      FieldName = 'Name'
      Size = 500
    end
    object CustomerReportTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
    object CustomerReportInvoices: TDataSetField
      FieldName = 'Invoices'
    end
  end
  object CRInvoiceTotals: TFDMemTable
    DataSetField = CustomerReportInvoices
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StoreItems = [siData]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 72
    Top = 160
    object CRInvoiceTotalsInvoiceId: TIntegerField
      FieldName = 'InvoiceId'
    end
    object CRInvoiceTotalsNumber: TIntegerField
      FieldName = 'Number'
    end
    object CRInvoiceTotalsIssued: TDateField
      FieldName = 'Issued'
      DisplayFormat = 'mm/dd/yyyy'
    end
    object CRInvoiceTotalsPaid: TDateField
      FieldName = 'Paid'
      DisplayFormat = 'mm/dd/yyyy'
    end
    object CRInvoiceTotalsTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
    object CRInvoiceTotalsCategories: TDataSetField
      FieldName = 'Categories'
    end
  end
  object CRCategoryTotals: TFDMemTable
    DataSetField = CRInvoiceTotalsCategories
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode, rvStorePrettyPrint]
    ResourceOptions.StoreItems = [siData]
    ResourceOptions.StorePrettyPrint = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 72
    Top = 232
    object CRCategoryTotalsCategory: TStringField
      FieldName = 'Category'
      Size = 500
    end
    object CRCategoryTotalsTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
  end
end
