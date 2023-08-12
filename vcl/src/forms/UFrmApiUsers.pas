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
  , System.UITypes

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
    btnCopyToken: TButton;
    ApiUsersApiTokenToken: TAureliusEntityField;
    ApiUsersApiToken: TAureliusEntityField;
    ApiUsersApiTokenExpiresOn: TDateTimeField;
    procedure ApiUsersAfterInsert(DataSet: TDataSet);
    procedure btnCopyTokenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GridEditButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure AssignNewToken;
    procedure NewToken;
  public
    { Public declarations }
  end;

var
  FrmApiUsers: TFrmApiUsers;

implementation
uses
    Vcl.Clipbrd
  , UDictionary
  , UApi
  ;

{$R *.dfm}

procedure TFrmApiUsers.ApiUsersAfterInsert(DataSet: TDataSet);
begin
  AssignNewToken;
end;

procedure TFrmApiUsers.AssignNewToken;
begin
  ApiUsers.DisableControls;
  try
    if not (ApiUsers.State in dsEditModes) then
    begin
      ApiUsers.Edit;
    end;

    var LOldToken := ApiUsersApiToken.AsEntity<TApiToken>;

    var LApiToken := TApiToken.Create;
    LApiToken.Kind := TApiTokenKind.User;
    ApiUsersApiToken.AsObject := LApiToken;
    ApiUsers.Post;

    // remove old token
    if Assigned(LOldToken) then
    begin
      ObjectManager.Remove(LOldToken);
    end;

  finally
    ApiUsers.EnableControls;
  end;
end;

procedure TFrmApiUsers.btnCopyTokenClick(Sender: TObject);
begin
  Clipboard.AsText := ApiUsersApiTokenToken.AsString;
end;

procedure TFrmApiUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ApiUsers.Close;

  inherited;
end;

procedure TFrmApiUsers.FormCreate(Sender: TObject);
begin
  inherited;

  var LUsers := ObjectManager.Find<TApiUser>
    .OrderBy(Dic.ApiUser.ApiToken.ExpiresOn, False )
    ;

  ApiUsers.DefaultsFromObject := True;
  ApiUsers.Manager := ObjectManager;
  ApiUsers.SetSourceCriteria(LUsers);
  ApiUsers.Open;
end;

procedure TFrmApiUsers.GridEditButtonClick(Sender: TObject);
begin
  if Grid.SelectedField = ApiUsersApiTokenToken then
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
      AssignNewToken;
    end;
  end;
end;

end.
