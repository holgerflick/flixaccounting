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
unit UFrmApiToken;

interface

uses
    System.Actions
  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.ComCtrls
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UApi
  , UFrmBase
  ;

type
  TFrmApiToken = class(TFrmBase)
    txtToken: TEdit;
    dtExpiresOn: TDateTimePicker;
    btnCopy: TButton;
    txtLink: TEdit;
    procedure btnCopyClick(Sender: TObject);
    procedure dtExpiresOnChange(Sender: TObject);
  private
    FApiToken: TApiToken;
    function GetApiToken: TApiToken;
    procedure SetApiToken(const Value: TApiToken);
    function GetLink: String;
    procedure UpdateUI;
    { Private declarations }
  public
    { Public declarations }
    procedure EditToken(ACaption: String; AToken: TApiToken);

    property ApiToken: TApiToken read GetApiToken write SetApiToken;
    property Link: String read GetLink;
  end;

var
  FrmApiToken: TFrmApiToken;

implementation

uses
  Vcl.Clipbrd
  ;

{$R *.dfm}

procedure TFrmApiToken.btnCopyClick(Sender: TObject);
begin
  Clipboard.AsText := TApiUrls.UrlForToken(ApiToken);
  MessageDlg('Link has been copied to clipboard.', mtInformation, [mbOK], 0 );
end;

procedure TFrmApiToken.dtExpiresOnChange(Sender: TObject);
begin
  FApiToken.ExpiresOn := dtExpiresOn.DateTime;

  UpdateUI;
end;

procedure TFrmApiToken.EditToken(ACaption: String; AToken: TApiToken);
var
  LFrm: TFrmApiToken;

begin
  LFrm := TFrmApiToken.Create(nil);
  try
    LFrm.Caption := ACaption;
    LFrm.ApiToken := AToken;
    LFrm.ShowModal;
    AToken := LFrm.ApiToken;
  finally
    LFrm.Free;
  end;
end;

function TFrmApiToken.GetApiToken: TApiToken;
begin
  Result := FApiToken;
end;

function TFrmApiToken.GetLink: String;
begin
  Result := TApiUrls.UrlForToken(ApiToken);
end;

procedure TFrmApiToken.SetApiToken(const Value: TApiToken);
begin
  FApiToken := Value;

  UpdateUI;
end;

procedure TFrmApiToken.UpdateUI;
begin
  txtToken.Text := FApiToken.Token;
  dtExpiresOn.DateTime := FApiToken.ExpiresOn;
  txtLink.Text := Link;
end;

end.
