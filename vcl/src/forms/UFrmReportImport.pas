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
unit UFrmReportImport;

interface

uses
    UFrmBase

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset

  , Winapi.Windows
  , Winapi.Messages

  , System.SysUtils
  , System.Variants
  , System.Classes
  , System.Actions

  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.Grids
  , Vcl.DBGrids
  , Vcl.StdCtrls
  , Vcl.ExtCtrls
  , Vcl.ActnList

  , Data.DB

  , UDataImportManager
  ;


type
  TFrmReportImport = class(TFrmBase)
    Splitter1: TSplitter;
    dbErrors: TAureliusDataset;
    sourceErrors: TDataSource;
    panDuplicates: TPanel;
    Label2: TLabel;
    Duplicates: TListBox;
    dbErrorsDescription: TStringField;
    dbErrorsFileName: TStringField;
    Panel2: TPanel;
    btnClose: TButton;
    panErrors: TPanel;
    Errors: TDBGrid;
    Label1: TLabel;
  private
    FManager : TDataImportManager;
    procedure SetManager(const Value: TDataImportManager);

    procedure UpdateInterface;

  public
    constructor Create(AOwner: TComponent; AManager: TDataImportManager); reintroduce;

    property Manager: TDataImportManager read FManager write SetManager;
  end;


implementation

{$R *.dfm}

{ TFrmReportImport }

constructor TFrmReportImport.Create(AOwner: TComponent;
  AManager: TDataImportManager);
begin
  inherited Create(AOwner);

  Manager := AManager;
end;

procedure TFrmReportImport.SetManager(const Value: TDataImportManager);
begin
  FManager := Value;

  UpdateInterface;
end;

procedure TFrmReportImport.UpdateInterface;
begin
  dbErrors.Close;
  dbErrors.SetSourceList( Manager.ImportErrors, False );
  dbErrors.Open;

  Duplicates.Items.Assign( Manager.Duplicates );
end;

end.
