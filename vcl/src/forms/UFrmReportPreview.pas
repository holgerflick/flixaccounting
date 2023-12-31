﻿{*******************************************************************************}
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
unit UFrmReportPreview;

interface

uses
    AdvGlowButton
  , AdvToolBar

  , FlexCel.Preview
  , FlexCel.Render
  , FlexCel.XlsAdapter

  , System.Actions
  , System.Classes
  , System.ImageList
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.BaseImageCollection
  , Vcl.Controls
  , Vcl.Dialogs

  , VCL.FlexCel.Core

  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.ImageCollection
  , Vcl.ImgList
  , Vcl.StdCtrls
  , Vcl.VirtualImageList

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase, FlexCel.VCLSupport, FlexCel.Core
  ;


type
  TFrmReportPreview = class(TFrmBase)
    Preview: TFlexCelPreviewer;
    DlgFileSave: TFileSaveDialog;
    Images: TVirtualImageList;
    Collection: TImageCollection;
    Button1: TButton;
    Button2: TButton;
    Actions: TActionList;
    actExport: TAction;
    actMail: TAction;
    procedure actExportExecute(Sender: TObject);
    procedure actMailExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FImgReport: TFlexCelImgExport;
    FXlsFile: TXlsFile;

    procedure LoadReport;
    procedure SaveReport;

    procedure SaveAsExcel(AFilename:String);
    procedure SaveAsPdf(AFilename:String);
  public
    { Public declarations }
    constructor Create(AXlsFile: TXlsFile); reintroduce;
    destructor Destroy; override;

    class procedure Execute(AXlsStream: TStream);
  end;

var
  FrmReportPreview: TFrmReportPreview;

implementation

{$R *.dfm}

constructor TFrmReportPreview.Create(AXlsFile: TXlsFile);
begin
  inherited Create(nil);

  FImgReport := nil;
  FXlsFile := AXlsFile;

  LoadReport;
end;

destructor TFrmReportPreview.Destroy;
begin
  FImgReport.Free;

  inherited;
end;

procedure TFrmReportPreview.actExportExecute(Sender: TObject);
begin
  SaveReport;
end;

procedure TFrmReportPreview.actMailExecute(Sender: TObject);
begin
  //
end;


class procedure TFrmReportPreview.Execute(AXlsStream: TStream);
var
  LFrm: TFrmReportPreview;
  LXlsFile: TXlsFile;

begin
  LFrm := nil;
  LXlsFile := TXlsFile.Create( AXlsStream, True );
  try
    LFrm := TFrmReportPreview.Create(LXlsFile);
    LFrm.ShowModal;
  finally
    LXlsFile.Free;
    LFrm.Free;
  end;
end;

procedure TFrmReportPreview.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Preview';
end;

procedure TFrmReportPreview.LoadReport;
begin
  FImgReport.Free;

  FImgReport := TFlexCelImgExport.Create(FXlsFile);
  Preview.Document := FImgReport;
  Preview.InvalidatePreview;
end;

procedure TFrmReportPreview.SaveAsExcel(AFilename: String);
begin
  FXlsFile.Save(AFilename, TFileFormats.Xlsx);
end;

procedure TFrmReportPreview.SaveAsPdf(AFilename: String);
var
  LExporter: TFlexCelPdfExport;

begin
  LExporter := TFlexCelPdfExport.Create(FXlsFile, True);
  try
    LExporter.Export(AFilename);
  finally
    LExporter.Free;
  end;
end;

procedure TFrmReportPreview.SaveReport;
begin
  if DlgFileSave.Execute then
  begin
    if ExtractFileExt(DlgFileSave.FileName) = '.pdf' then
    begin
      SaveAsPdf(DlgFileSave.FileName);
    end;
    if ExtractFileExt(DlgFileSave.FileName) = '.xlsx' then
    begin
      SaveAsExcel(DlgFileSave.FileName);
    end;
  end;
end;

end.
