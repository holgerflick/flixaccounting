unit UFrmEditMemoField;

interface

uses
    Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  ;

type
  TFrmEditMemoField = class(TForm)
    Editor: TDBMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute(AParentForm: TForm; ADataSource: TDataSource;
        AFieldName: String; AOrigin: TPoint; AWidth: Integer);

  end;

var
  FrmEditMemoField: TFrmEditMemoField;

implementation

{$R *.dfm}

{ TFrmEditMemoField }

class procedure TFrmEditMemoField.Execute(AParentForm: TForm; ADataSource:
    TDataSource; AFieldName: String; AOrigin: TPoint; AWidth: Integer);
begin
  var LFrm := TFrmEditMemoField.Create(AParentForm);
  if Assigned( AParentForm ) then
  begin
    LFrm.Editor.Font := AParentForm.Font;
  end;

  LFrm.Editor.DataField := AFieldName;
  LFrm.Editor.DataSource := ADataSource;

  LFrm.Left := AOrigin.X;
  LFrm.Top := AOrigin.Y;
  LFrm.Width := AWidth * 2;
  LFrm.Height := 400;

  LFrm.ShowModal;
end;

procedure TFrmEditMemoField.FormShow(Sender: TObject);
begin
  Caption := Editor.Field.DisplayName;
end;

end.
