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
    btnPdf: TAdvGlowButton;
    btnXLS: TAdvGlowButton;
    Preview: TFlexCelPreviewer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FImgReport: TFlexCelImgExport;
    FXlsFile: TXlsFile;

    procedure LoadReport;
  public
    { Public declarations }
    constructor Create(AXlsFile: TXlsFile); reintroduce;
    destructor Destroy; override;

    class procedure Execute(AXlsFile: TXlsFile);
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
end;

procedure TFrmReportPreview.LoadReport;
begin
  FImgReport.Free;

  FImgReport := TFlexCelImgExport.Create(FXlsFile);
  Preview.Document := FImgReport;
  Preview.InvalidatePreview;
end;

end.
