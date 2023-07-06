inherited FrmCustomer: TFrmCustomer
  Caption = 'FrmCustomer'
  ClientHeight = 489
  ClientWidth = 801
  ExplicitWidth = 817
  ExplicitHeight = 528
  TextHeight = 21
  object Grid: TDBGrid
    Left = 8
    Top = 8
    Width = 785
    Height = 230
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = sourceCustomers
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'LookupName'
        Title.Caption = 'Name'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Title.Caption = 'Legal Name'
        Width = 286
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Width = 268
        Visible = True
      end>
  end
  object DBEdit1: TDBEdit
    Left = 8
    Top = 277
    Width = 241
    Height = 29
    Anchors = [akLeft, akBottom]
    DataField = 'LookupName'
    DataSource = sourceCustomers
    TabOrder = 1
    ExplicitTop = 336
  end
  object DBEdit2: TDBEdit
    Left = 255
    Top = 277
    Width = 538
    Height = 29
    Anchors = [akLeft, akRight, akBottom]
    DataField = 'Name'
    DataSource = sourceCustomers
    TabOrder = 2
    ExplicitTop = 336
    ExplicitWidth = 541
  end
  object DBMemo1: TDBMemo
    Left = 255
    Top = 333
    Width = 538
    Height = 148
    Anchors = [akLeft, akRight, akBottom]
    DataField = 'Address'
    DataSource = sourceCustomers
    TabOrder = 3
    ExplicitTop = 392
    ExplicitWidth = 541
  end
  object DBEdit3: TDBEdit
    Left = 8
    Top = 333
    Width = 241
    Height = 29
    Anchors = [akLeft, akBottom]
    DataField = 'Email'
    DataSource = sourceCustomers
    TabOrder = 4
    ExplicitTop = 392
  end
  object Customers: TAureliusDataset
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
        Name = 'LookupName'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Name'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Address'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Email'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end>
    Left = 72
    Top = 424
    DesignClass = 'UCustomer.TCustomer'
    object CustomersSelf: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object CustomersId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
      Required = True
    end
    object CustomersLookupName: TStringField
      FieldName = 'LookupName'
      Size = 255
    end
    object CustomersName: TStringField
      FieldName = 'Name'
      Required = True
      Size = 255
    end
    object CustomersAddress: TStringField
      FieldName = 'Address'
      Required = True
      Size = 255
    end
    object CustomersEmail: TStringField
      FieldName = 'Email'
      Required = True
      Size = 255
    end
  end
  object sourceCustomers: TDataSource
    DataSet = Customers
    Left = 160
    Top = 424
  end
end
