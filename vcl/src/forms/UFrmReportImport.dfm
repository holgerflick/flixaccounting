inherited FrmReportImport: TFrmReportImport
  BorderStyle = bsSizeToolWin
  Caption = 'Report of Import'
  ClientHeight = 648
  ClientWidth = 889
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 911
  ExplicitHeight = 704
  TextHeight = 21
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 162
    Width = 797
    Height = 6
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 204
    ExplicitWidth = 889
  end
  object panDuplicates: TPanel [1]
    Left = 0
    Top = 168
    Width = 797
    Height = 142
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 791
      Height = 21
      Align = alTop
      Caption = 'Ignored files (previously imported)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 267
    end
    object Duplicates: TListBox
      Left = 0
      Top = 27
      Width = 797
      Height = 115
      Align = alClient
      ItemHeight = 21
      TabOrder = 0
      ExplicitWidth = 889
      ExplicitHeight = 237
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 310
    Width = 797
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 592
    ExplicitWidth = 889
    DesignSize = (
      797
      56)
    object btnClose: TButton
      Left = 641
      Top = 8
      Width = 153
      Height = 41
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      ModalResult = 8
      TabOrder = 0
      ExplicitLeft = 733
    end
  end
  object panErrors: TPanel [3]
    Left = 0
    Top = 0
    Width = 797
    Height = 162
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 889
    ExplicitHeight = 322
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 791
      Height = 21
      Align = alTop
      Caption = 'Errors'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 44
    end
    object Errors: TDBGrid
      AlignWithMargins = True
      Left = 3
      Top = 30
      Width = 791
      Height = 129
      Align = alClient
      DataSource = sourceErrors
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
          FieldName = 'FileName'
          Width = 362
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Description'
          Width = 468
          Visible = True
        end>
    end
  end
  inherited actFrmBase: TActionList
    Left = 32
    Top = 72
  end
  object dbErrors: TAureliusDataset
    FieldDefs = <>
    CreateSelfField = False
    Left = 144
    Top = 72
    object dbErrorsDescription: TStringField
      FieldName = 'Description'
      Size = 500
    end
    object dbErrorsFileName: TStringField
      FieldName = 'FileName'
      Size = 200
    end
  end
  object sourceErrors: TDataSource
    DataSet = dbErrors
    Left = 224
    Top = 72
  end
end
