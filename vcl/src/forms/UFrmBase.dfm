object FrmBase: TFrmBase
  Left = 0
  Top = 0
  ClientHeight = 454
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object actFrmBase: TActionList
    Left = 88
    Top = 184
    object actFrmBaseRemoveStorage: TAction
      Caption = 'actFrmBaseRemoveStorage'
      ShortCut = 24699
      OnExecute = actFrmBaseRemoveStorageExecute
    end
  end
end
