inherited FrmApiUsers: TFrmApiUsers
  Caption = 'API Access'
  ClientHeight = 507
  ClientWidth = 1208
  OnClose = FormClose
  ExplicitWidth = 1224
  ExplicitHeight = 546
  TextHeight = 21
  object Grid: TDBGrid [0]
    Left = 8
    Top = 56
    Width = 1192
    Height = 443
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = SourceApiUser
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
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
        Width = 216
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ApiToken.ExpiresOn'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        Title.Caption = 'Expires on'
        Width = 191
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'ApiToken.Token'
        Font.Charset = ANSI_CHARSET
        Font.Color = cl3DLight
        Font.Height = -12
        Font.Name = 'JetBrains Mono'
        Font.Style = []
        ReadOnly = True
        Title.Caption = 'Token'
        Width = 438
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator [1]
    Left = 8
    Top = 8
    Width = 1056
    Height = 42
    DataSource = SourceApiUser
    VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object btnCopyToken: TButton [2]
    Left = 1078
    Top = 8
    Width = 122
    Height = 42
    Anchors = [akTop, akRight]
    Caption = 'Copy Token'
    TabOrder = 2
    OnClick = btnCopyTokenClick
  end
  object ApiUsers: TAureliusDataset [3]
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
        Name = 'ApiToken'
        DataType = ftVariant
      end
      item
        Name = 'ExpiresOn'
        Attributes = [faRequired]
        DataType = ftDateTime
      end>
    AfterInsert = ApiUsersAfterInsert
    Left = 176
    Top = 304
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
    object ApiUsersApiTokenToken: TAureliusEntityField
      FieldName = 'ApiToken.Token'
    end
    object ApiUsersApiTokenExpiresOn: TDateTimeField
      FieldName = 'ApiToken.ExpiresOn'
    end
    object ApiUsersApiToken: TAureliusEntityField
      FieldName = 'ApiToken'
    end
  end
  object SourceApiUser: TDataSource [4]
    DataSet = ApiUsers
    Left = 248
    Top = 136
  end
end
