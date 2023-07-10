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
    Editor: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute(AParentForm: TForm; AField: TField; AOrigin: TPoint;
        AWidth: Integer);

  end;

var
  FrmEditMemoField: TFrmEditMemoField;

implementation

{$R *.dfm}

{ TFrmEditMemoField }

class procedure TFrmEditMemoField.Execute(AParentForm: TForm; AField: TField; AOrigin: TPoint; AWidth: Integer);
begin
  var LFrm := TFrmEditMemoField.Create(AParentForm);
  try
    if Assigned( AParentForm ) then
    begin
      LFrm.Editor.Font := AParentForm.Font;
    end;



    LFrm.Editor.Lines.Text := AField.AsString;

    LFrm.Left := AOrigin.X;
    LFrm.Top := AOrigin.Y;
    LFrm.Width := AWidth * 2;
    LFrm.Height := 400;
    LFrm.Caption := AField.DisplayName;

    LFrm.ShowModal;

    if not (AField.DataSet.State in [dsInsert, dsEdit]) then
    begin
      AField.DataSet.Edit;
    end;

    AField.AsString := LFrm.Editor.Lines.Text;
  finally
    LFrm.Free;
  end;
end;

end.
