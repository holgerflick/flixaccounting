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
unit UFrmBase;

interface

uses
    Aurelius.Engine.ObjectManager

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ComCtrls
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UDataManager, System.Actions, Vcl.ActnList
  ;


type
  TFrmBase = class(TForm)
    actFrmBase: TActionList;
    actFrmBaseRemoveStorage: TAction;
    procedure actFrmBaseRemoveStorageExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FOwnsObjectManager: Boolean;
    FStoreControls: Boolean;

  protected
    FObjectManager: TObjectManager;
    FDataManager: TDataManager;

    function GetObjectManager: TObjectManager;
    procedure SetObjectManager(const Value: TObjectManager);

  public
    property ObjectManager: TObjectManager
      read GetObjectManager write SetObjectManager;

    property DataManager: TDataManager
      read FDataManager write FDataManager;

    property OwnsObjectManager: Boolean read FOwnsObjectManager;

    property StoreControls: Boolean read FStoreControls write FStoreControls;
  end;

var
  FrmBase: TFrmBase;

implementation

uses
    UAppGlobals
  , UAppSettings
  , UControlStorage
  , UGridUtils
  ;

{$R *.dfm}



procedure TFrmBase.actFrmBaseRemoveStorageExecute(Sender: TObject);
begin
  if MessageDlg('Remove form dimensions and its controls from storage and close?',
    mtConfirmation, [mbYes,mbNo], 0 ) = mrYes then
  begin
    TFormStorageManager.Shared.RemoveAndCloseForm(self);
  end;
end;

procedure TFrmBase.FormCreate(Sender: TObject);
begin
  FStoreControls := True;

  inherited;

  TGridUtils.UseDefaultFonts(self);

  TFormStorageManager.Shared.RestoreForm(self);

  if self.Caption = '' then
  begin
    Caption := TAppGlobals.AppFullName;
  end;

  FDataManager := TDataManager.Shared;
  FObjectManager := nil;

  FOwnsObjectManager := False;
end;

procedure TFrmBase.FormDestroy(Sender: TObject);
begin
  if FStoreControls then
  begin
    TFormStorageManager.Shared.StoreForm(self);
  end;

  if FOwnsObjectManager then
  begin
    FObjectManager.Free;
  end;

  inherited;
end;

function TFrmBase.GetObjectManager: TObjectManager;
begin
  if not Assigned( FObjectManager ) then
  begin
    FObjectManager := DataManager.ObjectManager;
    FOwnsObjectManager := True;
  end;

  Result := FObjectManager;
end;

procedure TFrmBase.SetObjectManager(const Value: TObjectManager);
begin
  if Assigned(Value) then
  begin
    FObjectManager.Free;
    FObjectManager := Value;
    FOwnsObjectManager := False;
  end;
end;

end.
