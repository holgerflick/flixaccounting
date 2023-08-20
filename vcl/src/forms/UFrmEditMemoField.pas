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
