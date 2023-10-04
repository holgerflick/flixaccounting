{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
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

class procedure TFrmEditMemoField.Execute(
  AParentForm: TForm;
  AField: TField;
  AOrigin: TPoint;
  AWidth: Integer);
begin
  var LFrm := TFrmEditMemoField.Create(AParentForm);
  try
    // use font from parent
    if Assigned( AParentForm ) then
    begin
      LFrm.Editor.Font := AParentForm.Font;
    end;

    // assign data from field
    LFrm.Editor.Lines.Text := AField.AsString;

    // position form
    LFrm.Left := AOrigin.X;
    LFrm.Top := AOrigin.Y;
    LFrm.Width := AWidth * 2;
    LFrm.Height := 400;
    LFrm.Caption := AField.DisplayName;

    // show form
    LFrm.ShowModal;

    // update value
    var LNeedPost := False;
    if not (AField.DataSet.State in [dsInsert, dsEdit]) then
    begin
      LNeedPost := True;
      AField.DataSet.Edit;
    end;

    // assign value to field
    AField.AsString := LFrm.Editor.Lines.Text;

    // post if edit state was enabled here to return with
    // same state as before
    if LNeedPost then
    begin
      AField.DataSet.Post;
    end;
  finally
    LFrm.Free;
  end;
end;

end.
