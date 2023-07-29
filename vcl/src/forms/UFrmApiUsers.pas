unit UFrmApiUsers;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq

  , Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase, System.Actions, Vcl.ActnList, Vcl.StdCtrls
  ;


type
  TFrmApiUsers = class(TFrmBase)
    Grid: TDBGrid;
    DBNavigator1: TDBNavigator;
    ApiUsers: TAureliusDataset;
    SourceApiUser: TDataSource;
    ApiUsersName: TStringField;
    ApiUsersEmail: TStringField;
    ApiUsersToken: TStringField;
    ApiUsersExpiresOn: TDateTimeField;
    btnCopyToken: TButton;
    procedure btnCopyTokenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GridEditButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure NewToken;
  public
    { Public declarations }
  end;

var
  FrmApiUsers: TFrmApiUsers;

implementation
uses
    Vcl.Clipbrd
  , UApi
  ;

{$R *.dfm}

procedure TFrmApiUsers.btnCopyTokenClick(Sender: TObject);
begin
  Clipboard.AsText := ApiUsersToken.AsString;
end;

procedure TFrmApiUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  ApiUsers.Close;
end;

procedure TFrmApiUsers.FormCreate(Sender: TObject);
begin
  inherited;

  StoreControls := False;

  var LUsers := ObjectManager.Find<TApiUser>
    .OrderBy(Linq['ExpiresOn'], False )
    .List
    ;

  ApiUsers.DefaultsFromObject := True;
  ApiUsers.Manager := ObjectManager;
  ApiUsers.SetSourceList(LUsers, True);
  ApiUsers.Open;
end;

procedure TFrmApiUsers.GridEditButtonClick(Sender: TObject);
begin
  if Grid.SelectedField = ApiUsersToken then
  begin
    NewToken;
  end;
end;

procedure TFrmApiUsers.NewToken;
var
  LUser: TApiUser;

begin
  LUser := ApiUsers.Current<TApiUser>;

  if Assigned(LUser) then
  begin
    if MessageDlg('Are you sure you want to generate a new token?',
      mtConfirmation, [mbYes,mbNo], 0) = mrYes then
    begin
      if not (ApiUsers.State in dsEditModes) then
      begin
        ApiUsers.Edit;
      end;

      ApiUsersToken.AsString := TApiUser.NewToken;
    end;
  end;
end;

end.
