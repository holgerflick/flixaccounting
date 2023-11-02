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
unit UFrmMain;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UServerContainer
  ;

type
  TMainForm = class(TForm)
    mmInfo: TMemo;
    btStart: TButton;
    btStop: TButton;
    btnSwaggerUi: TButton;
    procedure btnSwaggerUiClick(Sender: TObject);
    procedure btStartClick(ASender: TObject);
    procedure btStopClick(ASender: TObject);
    procedure FormCreate(ASender: TObject);
  strict private
    procedure UpdateGUI;
  end;

var
  MainForm: TMainForm;

implementation

uses
    Winapi.ShellAPI
  ;

{$R *.dfm}

resourcestring
  SServerStopped = 'Server stopped';
  SServerStartedAt = 'Server started at ';

procedure TMainForm.btnSwaggerUiClick(Sender: TObject);
begin
  ShellExecute(0, 'open'
    , pChar(ServerContainer.ReadableBaseUrl + 'swaggerui')
    , '', '', SW_SHOWNORMAL);
end;

{ TMainForm }

procedure TMainForm.btStartClick(ASender: TObject);
begin
  ServerContainer.SparkleHttpSysDispatcher.Start;
  UpdateGUI;
end;

procedure TMainForm.btStopClick(ASender: TObject);
begin
  ServerContainer.SparkleHttpSysDispatcher.Stop;
  UpdateGUI;
end;

procedure TMainForm.FormCreate(ASender: TObject);
begin
  UpdateGUI;
end;

procedure TMainForm.UpdateGUI;
begin
  btStart.Enabled := not ServerContainer.SparkleHttpSysDispatcher.Active;
  btStop.Enabled := not btStart.Enabled;
  btnSwaggerUI.Enabled := not btStart.Enabled;
  if ServerContainer.SparkleHttpSysDispatcher.Active then
    mmInfo.Lines.Add(SServerStartedAt + ServerContainer.ReadableBaseUrl)
  else
    mmInfo.Lines.Add(SServerStopped);
end;

end.
