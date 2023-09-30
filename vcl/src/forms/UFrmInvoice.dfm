inherited FrmInvoice: TFrmInvoice
  Caption = 'FrmInvoice'
  ClientHeight = 504
  ClientWidth = 738
  OnClose = FormClose
  ExplicitWidth = 754
  ExplicitHeight = 543
  TextHeight = 21
  object txtNumber: TDBAdvEdit [0]
    Left = 339
    Top = 32
    Width = 121
    Height = 29
    EditType = etNumeric
    EmptyTextStyle = []
    FlatLineColor = 11250603
    FocusColor = clWindow
    FocusFontColor = 3881787
    LabelCaption = 'Number'
    LabelPosition = lpTopLeft
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -16
    LabelFont.Name = 'Segoe UI'
    LabelFont.Style = [fsBold]
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Segoe UI'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Anchors = [akTop, akRight]
    Color = clWindow
    TabOrder = 1
    Text = '0'
    Visible = True
    Version = '4.0.4.3'
    DataField = 'Number'
  end
  object GridItems: TDBGrid [1]
    Left = 8
    Top = 99
    Width = 722
    Height = 359
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = sourceItems
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnEditButtonClick = GridItemsEditButtonClick
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Idx'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Title.Caption = '#'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Category'
        PickList.Strings = (
          'Internet'
          'Hardware'
          'Office')
        Width = 150
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'Description'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantity'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Value'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Title.Caption = 'Rate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TotalValue'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Title.Caption = 'Total'
        Visible = True
      end>
  end
  object btnBoA: TButton [2]
    Left = 143
    Top = 550
    Width = 145
    Height = 32
    Anchors = [akLeft, akBottom]
    Caption = 'Import BoA...'
    TabOrder = 7
    Visible = False
    OnClick = btnBoAClick
  end
  object cbCustomer: TDBLookupComboBox [3]
    Left = 8
    Top = 32
    Width = 325
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    DataField = 'Customer'
    KeyField = 'Self'
    ListField = 'Name'
    ListSource = sourceCustomers
    TabOrder = 0
  end
  object DBNavigator1: TDBNavigator [4]
    Left = 8
    Top = 67
    Width = 720
    Height = 26
    DataSource = sourceItems
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object dateIssued: TAdvDBDateTimePicker [5]
    Left = 466
    Top = 32
    Width = 129
    Height = 29
    Anchors = [akTop, akRight]
    Date = 45114.000000000000000000
    Format = ''
    Time = 0.555729166670062100
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = dkDate
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 2
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 45114.555729166670000000
    Version = '1.3.6.6'
    LabelCaption = 'Date'
    LabelPosition = lpTopLeft
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -16
    LabelFont.Name = 'Segoe UI'
    LabelFont.Style = [fsBold]
    DataField = 'IssuedOn'
  end
  object btnCancel: TButton [6]
    Left = 494
    Top = 464
    Width = 115
    Height = 33
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object btnQuickItem: TButton [7]
    Left = 8
    Top = 464
    Width = 129
    Height = 33
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Quick Item...'
    TabOrder = 6
    OnClick = btnQuickItemClick
  end
  object dateDueOn: TAdvDBDateTimePicker [8]
    Left = 601
    Top = 32
    Width = 129
    Height = 29
    Anchors = [akTop, akRight]
    Date = 45114.000000000000000000
    Format = ''
    Time = 0.555729166670062100
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = dkDate
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 3
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 45114.555729166670000000
    Version = '1.3.6.6'
    LabelCaption = 'Due on'
    LabelPosition = lpTopLeft
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -16
    LabelFont.Name = 'Segoe UI'
    LabelFont.Style = [fsBold]
    DataField = 'DueOn'
  end
  object btnOK: TButton [9]
    Left = 615
    Top = 464
    Width = 115
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 8
    OnClick = btnOKClick
  end
  object Items: TAureliusDataset
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
        Name = 'Idx'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Category'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Title'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Quantity'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'Value'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'TotalValue'
        Attributes = [faReadonly, faRequired]
        DataType = ftFloat
      end>
    RecordCountMode = FetchAll
    Left = 88
    Top = 264
    DesignClass = 'UInvoice.TInvoiceItem'
    object ItemsSelf: TAureliusEntityField
      FieldName = 'Self'
      ReadOnly = True
    end
    object ItemsId: TIntegerField
      FieldName = 'Id'
      ReadOnly = True
      Required = True
    end
    object ItemsIdx: TIntegerField
      FieldName = 'Idx'
      Required = True
      DisplayFormat = '0'
    end
    object ItemsCategory: TStringField
      FieldName = 'Category'
      Required = True
      Size = 255
    end
    object ItemsDescription: TStringField
      FieldName = 'Description'
      Required = True
      Size = 5000
    end
    object ItemsQuantity: TFloatField
      FieldName = 'Quantity'
      Required = True
      DisplayFormat = '0.##'
    end
    object ItemsValue: TFloatField
      FieldName = 'Value'
      Required = True
      DisplayFormat = '0,.00'
    end
    object ItemsTotalValue: TFloatField
      FieldName = 'TotalValue'
      ReadOnly = True
      Required = True
      DisplayFormat = '0,.00'
    end
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
    Left = 240
    Top = 264
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
      Size = 255
    end
    object CustomersEmail: TStringField
      FieldName = 'Email'
      Required = True
      Size = 255
    end
  end
  object sourceItems: TDataSource
    DataSet = Items
    Left = 88
    Top = 320
  end
  object sourceCustomers: TDataSource
    DataSet = Customers
    Left = 240
    Top = 320
  end
  object DlgOpen: TFileOpenDialog
    DefaultExtension = 'csv'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Bank of America Statements (*.csv)'
        FileMask = '*.csv'
      end>
    OkButtonLabel = 'Import'
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Import Bank of America statement file'
    Left = 240
    Top = 192
  end
end
