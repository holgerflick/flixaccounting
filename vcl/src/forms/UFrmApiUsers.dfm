inherited FrmApiUsers: TFrmApiUsers
  Caption = 'API Access'
  ClientHeight = 507
  ClientWidth = 946
  OnClose = FormClose
  ExplicitWidth = 962
  ExplicitHeight = 546
  TextHeight = 21
  object Grid: TDBGrid [0]
    Left = 8
    Top = 40
    Width = 930
    Height = 459
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = SourceApiUser
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnEditButtonClick = GridEditButtonClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Width = 210
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Width = 196
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ExpiresOn'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'Token'
        Font.Charset = ANSI_CHARSET
        Font.Color = cl3DLight
        Font.Height = -12
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        ReadOnly = True
        Width = 325
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator [1]
    Left = 8
    Top = 8
    Width = 920
    Height = 25
    DataSource = SourceApiUser
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 790
  end
  object ApiUsers: TAureliusDataset [2]
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
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Email'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Token'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'ExpiresOn'
        Attributes = [faRequired]
        DataType = ftDateTime
      end>
    Left = 248
    Top = 208
    DesignClass = 'UApi.TApiUser'
    object ApiUsersName: TStringField
      FieldName = 'Name'
      Required = True
      Size = 255
    end
    object ApiUsersEmail: TStringField
      FieldName = 'Email'
      Required = True
      Size = 255
    end
    object ApiUsersToken: TStringField
      FieldName = 'Token'
      Required = True
      Size = 255
    end
    object ApiUsersExpiresOn: TDateTimeField
      FieldName = 'ExpiresOn'
      Required = True
    end
  end
  object SourceApiUser: TDataSource [3]
    DataSet = ApiUsers
    Left = 248
    Top = 136
  end
end
