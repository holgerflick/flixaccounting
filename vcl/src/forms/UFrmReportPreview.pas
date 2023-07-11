unit UFrmReportPreview;

interface

uses
    AdvGlowButton
  , AdvToolBar

  , FlexCel.Preview
  , FlexCel.Render
  , FlexCel.XlsAdapter

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.Dialogs

  , VCL.FlexCel.Core

  , Vcl.Forms
  , Vcl.Graphics

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  ;

type
  TFrmReportPreview = class(TFrmBase)
    AdvDockPanel1: TAdvDockPanel;
    Toolbar: TAdvToolBar;
    btnSave: TAdvGlowButton;
    Preview: TFlexCelPreviewer;
    DlgFileSave: TFileSaveDialog;
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
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

    class procedure Execute(AXlsFile: TXlsFile);
  end;

var
  FrmReportPreview: TFrmReportPreview;

implementation

uses
  UAppSettings
  ;

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

procedure TFrmReportPreview.FormDestroy(Sender: TObject);
begin
  TAppSettings.Shared.StoreFileSaveDialog(DlgFileSave);
  TAppSettings.Shared.StoreControl(self);

  inherited;
end;

procedure TFrmReportPreview.btnSaveClick(Sender: TObject);
begin
  SaveReport;
end;

class procedure TFrmReportPreview.Execute(AXlsFile: TXlsFile);
var
  LFrm: TFrmReportPreview;

begin
  LFrm := TFrmReportPreview.Create(AXlsFile);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmReportPreview.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Preview';
  TAppSettings.Shared.RestoreFileSaveDialog(DlgFileSave);
  TAppSettings.Shared.RestoreControl(self);
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
