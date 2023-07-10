inherited FrmPayments: TFrmPayments
  Caption = 'FrmPayments'
  ClientHeight = 410
  ClientWidth = 704
  ExplicitWidth = 720
  ExplicitHeight = 449
  TextHeight = 21
  object txtDue: TLabel
    Left = 456
    Top = 8
    Width = 240
    Height = 35
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'txtDue'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GridPayments: TDBGrid
    Left = 8
    Top = 80
    Width = 688
    Height = 322
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = sourcePayments
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
        Width = 119
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Amount'
        Width = 142
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 49
    Width = 688
    Height = 25
    DataSource = sourcePayments
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object btnPayOff: TButton
    Left = 8
    Top = 8
    Width = 177
    Height = 35
    Caption = 'Pay off'
    TabOrder = 2
    OnClick = btnPayOffClick
  end
  object Payments: TAureliusDataset
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
        Name = 'Invoice'
        DataType = ftVariant
      end
      item
        Name = 'PaidOn'
        Attributes = [faRequired]
        DataType = ftDate
      end
      item
        Name = 'Amount'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    CreateSelfField = False
    Left = 48
    Top = 344
    DesignClass = 'UInvoice.TInvoicePayment'
    object PaymentsId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
      Required = True
    end
    object PaymentsInvoice: TAureliusEntityField
      FieldName = 'Invoice'
    end
    object PaymentsPaidOn: TDateField
      FieldName = 'PaidOn'
      Required = True
      EditMask = '!99/99/00;1;_'
    end
    object PaymentsAmount: TFloatField
      FieldName = 'Amount'
      Required = True
      DisplayFormat = '0,.00'
    end
    object PaymentsInvoiceNumber: TIntegerField
      FieldName = 'Invoice.Number'
    end
  end
  object sourcePayments: TDataSource
    DataSet = Payments
    OnStateChange = sourcePaymentsStateChange
    Left = 128
    Top = 344
  end
  object Invoice: TAureliusDataset
    FieldDefs = <>
    Left = 248
    Top = 344
  end
  object sourceInvoice: TDataSource
    DataSet = Invoice
    Left = 320
    Top = 344
  end
end
