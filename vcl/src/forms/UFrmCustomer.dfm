inherited FrmCustomer: TFrmCustomer
  BorderIcons = [biSystemMenu]
  Caption = 'FrmCustomer'
  ClientHeight = 511
  ClientWidth = 1120
  ExplicitWidth = 1136
  ExplicitHeight = 550
  TextHeight = 21
  object Grid: TDBGrid [0]
    Left = 8
    Top = 40
    Width = 813
    Height = 463
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = sourceCustomers
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Width = 286
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Contact'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Width = 268
        Visible = True
      end>
  end
  object txtAddress: TDBMemo [1]
    Left = 827
    Top = 40
    Width = 285
    Height = 463
    Anchors = [akTop, akRight, akBottom]
    Color = clWhite
    DataField = 'Address'
    DataSource = sourceCustomers
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Noto Sans'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object DBNavigator1: TDBNavigator [2]
    Left = 8
    Top = 9
    Width = 1100
    Height = 25
    DataSource = sourceCustomers
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
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
        Name = 'Name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Contact'
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
    BeforePost = CustomersBeforePost
    Left = 200
    Top = 296
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
      Size = 255
    end
    object CustomersContact: TStringField
      FieldName = 'Contact'
      Required = True
      Size = 255
    end
  end
  object sourceCustomers: TDataSource
    DataSet = Customers
    Left = 80
    Top = 288
  end
end
