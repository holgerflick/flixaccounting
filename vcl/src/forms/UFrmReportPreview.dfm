inherited FrmReportPreview: TFrmReportPreview
  Caption = 'FrmReportPreview'
  TextHeight = 21
  object AdvDockPanel1: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 711
    Height = 64
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    UseRunTimeHeight = False
    Version = '6.8.3.9'
    object Toolbar: TAdvToolBar
      Left = 3
      Top = 1
      Width = 705
      Height = 49
      UIStyle = tsOffice2019White
      AllowFloating = False
      Caption = 'Untitled'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -12
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      FullSize = True
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ParentOptionPicture = True
      ToolBarIndex = -1
      object btnSave: TAdvGlowButton
        Left = 9
        Top = 2
        Width = 45
        Height = 45
        Caption = 'Save'
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        Rounded = True
        TabOrder = 0
        OnClick = btnSaveClick
        Appearance.Color = clWhite
        Appearance.ColorTo = clWhite
        Appearance.ColorChecked = 16111818
        Appearance.ColorCheckedTo = 16367008
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 16111818
        Appearance.ColorDownTo = 16367008
        Appearance.ColorHot = 16117985
        Appearance.ColorHotTo = 16372402
        Appearance.ColorMirror = clSilver
        Appearance.ColorMirrorTo = clWhite
        Appearance.ColorMirrorHot = 16107693
        Appearance.ColorMirrorHotTo = 16775412
        Appearance.ColorMirrorDown = 16102556
        Appearance.ColorMirrorDownTo = 16768988
        Appearance.ColorMirrorChecked = 16102556
        Appearance.ColorMirrorCheckedTo = 16768988
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
      end
    end
  end
  object Preview: TFlexCelPreviewer
    Left = 0
    Top = 64
    Width = 711
    Height = 407
    HorzScrollBar.Range = 20
    HorzScrollBar.Tracking = True
    VertScrollBar.Range = 417
    VertScrollBar.Tracking = True
    Zoom = 1.000000000000000000
    Align = alClient
    TabOrder = 1
  end
  object DlgFileSave: TFileSaveDialog
    DefaultExtension = 'pdf'
    FavoriteLinks = <>
    FileName = 'C:\dev\FlixLLCPL\vcl\src\forms'
    FileTypes = <
      item
        DisplayName = 'Adobe PDF Document (*.pdf)'
        FileMask = '*.pdf'
      end
      item
        DisplayName = 'Microsoft Excel (*.xlsx)'
        FileMask = '*.xlsx'
      end>
    OkButtonLabel = 'Save'
    Options = [fdoOverWritePrompt, fdoPathMustExist]
    Title = 'Save report to disk'
    Left = 168
    Top = 64
  end
end
