program FlixLLCPLServer;

uses
  Vcl.Forms,
  UServerContainer in 'UServerContainer.pas' {ServerContainer: TDataModule},
  UFrmMain in 'UFrmMain.pas' {MainForm},
  UAppSettings in '..\..\vcl\src\globals\UAppSettings.pas',
  UReportService in 'UReportService.pas',
  UReportServiceImpl in 'UReportServiceImpl.pas',
  UCustomer in '..\..\bpl\src\UCustomer.pas',
  UCustomerIncomeReport in '..\..\bpl\src\UCustomerIncomeReport.pas',
  UDictionary in '..\..\bpl\src\UDictionary.pas',
  UDictionaryTemporary in '..\..\bpl\src\UDictionaryTemporary.pas',
  UDocument in '..\..\bpl\src\UDocument.pas',
  UExceptions in '..\..\bpl\src\UExceptions.pas',
  UInvoice in '..\..\bpl\src\UInvoice.pas',
  UProfitLoss in '..\..\bpl\src\UProfitLoss.pas',
  UTransaction in '..\..\bpl\src\UTransaction.pas',
  UReportServiceManager in 'UReportServiceManager.pas',
  UReportManager in '..\..\vcl\src\UReportManager.pas' {ReportManager: TDataModule},
  UServerTypes in 'UServerTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
