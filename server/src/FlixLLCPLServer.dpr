program FlixLLCPLServer;

uses
  Vcl.Forms,
  UServerContainer in 'UServerContainer.pas' {ServerContainer: TDataModule},
  UFrmMain in 'UFrmMain.pas' {MainForm},
  UAppSettings in '..\..\vcl\src\globals\UAppSettings.pas',
  UReportService in 'UReportService.pas',
  UReportServiceImpl in 'UReportServiceImpl.pas',
  UReportServiceManager in 'UReportServiceManager.pas',
  UReportManager in '..\..\vcl\src\UReportManager.pas' {ReportManager: TDataModule},
  UServerTypes in 'UServerTypes.pas',
  UTokenAuthentication in 'UTokenAuthentication.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
