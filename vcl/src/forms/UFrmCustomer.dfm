inherited FrmCustomer: TFrmCustomer
  BorderIcons = [biSystemMenu]
  Caption = 'FrmCustomer'
  ClientHeight = 239
  ClientWidth = 842
  ExplicitWidth = 858
  ExplicitHeight = 278
  TextHeight = 21
  object Grid: TDBGrid [0]
    Left = 8
    Top = 40
    Width = 535
    Height = 191
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
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Contact'
        Width = 124
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Width = 140
        Visible = True
      end>
  end
  object txtAddress: TDBMemo [1]
    Left = 549
    Top = 40
    Width = 285
    Height = 191
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
    ExplicitLeft = 827
    ExplicitHeight = 463
  end
  object DBNavigator1: TDBNavigator [2]
    Left = 8
    Top = 9
    Width = 820
    Height = 25
    DataSource = sourceCustomers
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 1100
  end
  inherited actFrmBase: TActionList
    Left = 48
    Top = 128
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
    Left = 280
    Top = 128
    DesignClass = 'UCustomer.TCustomer'
    object CustomersName: TStringField
      FieldName = 'Name'
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
    object CustomersAddress: TStringField
      FieldName = 'Address'
      Required = True
      Size = 2000
    end
  end
  object sourceCustomers: TDataSource
    DataSet = Customers
    Left = 160
    Top = 128
  end
end
