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
    procedure btnCopyClick(Sender: TObject);
  private
    FApiToken: TApiToken;
    function GetApiToken: TApiToken;
    procedure SetApiToken(const Value: TApiToken);
    { Private declarations }
  public
    { Public declarations }
    procedure EditToken(ACaption: String; AToken: TApiToken);

    property ApiToken: TApiToken read GetApiToken write SetApiToken;
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
  FApiToken.ExpiresOn := dtExpiresOn.DateTime;

  Result := FApiToken;
end;

procedure TFrmApiToken.SetApiToken(const Value: TApiToken);
begin
  FApiToken := Value;

  txtToken.Text := FApiToken.Token;
  dtExpiresOn.DateTime := FApiToken.ExpiresOn;
end;

end.
