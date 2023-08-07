program FlixLLCPLServer;

{$R 'resources.res' 'resources.rc'}

uses
  VCL.FlexCel.Core,
  Vcl.Forms,
  UServerContainer in 'UServerContainer.pas' {ServerContainer: TDataModule},
  UFrmMain in 'UFrmMain.pas' {MainForm},
  UAppSettings in '..\..\vcl\src\globals\UAppSettings.pas',
  UReportService in 'UReportService.pas',
  UReportServiceImpl in 'UReportServiceImpl.pas',
  UReportServiceManager in 'UReportServiceManager.pas',
  UReportManager in '..\..\vcl\src\UReportManager.pas' {ReportManager: TDataModule},
  UServerTypes in 'UServerTypes.pas',
  UTokenValidator in 'UTokenValidator.pas',
  UDownloadService in 'UDownloadService.pas',
  UDownloadServiceImpl in 'UDownloadServiceImpl.pas',
  UDownloadManager in 'UDownloadManager.pas',
  UInvoicePrinter in '..\..\vcl\src\UInvoicePrinter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
