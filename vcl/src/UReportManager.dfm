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
  object PLTransactions: TFDMemTable
    DataSetField = ProfitLossTransactions
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
    Left = 408
    Top = 184
    object PLTransactionsPaidOn: TDateField
      FieldName = 'PaidOn'
    end
    object PLTransactionsTitle: TStringField
      FieldName = 'Title'
      Size = 500
    end
    object PLTransactionsAmount: TFloatField
      FieldName = 'Amount'
      DisplayFormat = '0,.00'
    end
    object PLTransactionsTxId: TIntegerField
      FieldName = 'TxId'
    end
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 304
    Top = 256
  end
  object ProfitLoss: TFDMemTable
    IndexesActive = False
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 120
    object ProfitLossCategory: TStringField
      FieldName = 'Category'
      Size = 500
    end
    object ProfitLossTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '0,.00'
    end
    object ProfitLossTransactions: TDataSetField
      FieldName = 'Transactions'
    end
    object ProfitLossTxCount: TIntegerField
      FieldName = 'TxCount'
    end
    object ProfitLossIsLoss: TBooleanField
      FieldName = 'IsLoss'
    end
    object ProfitLossSumTotal: TAggregateField
      FieldName = 'SumTotal'
      DisplayName = ''
      DisplayFormat = '0,.00'
      Expression = 'SUM(Total)'
    end
  end
end
