program FlixLLCPL;

{$R 'resources.res' 'resources.rc'}

uses
  Vcl.Forms,
  VCL.FlexCel.Core,
  UFrmMain in 'forms\UFrmMain.pas' {FrmMain},
  UAppGlobals in 'globals\UAppGlobals.pas',
  UDataManager in 'db\UDataManager.pas' {DataManager: TDataModule},
  UDataImportManager in 'db\UDataImportManager.pas',
  UFrmBase in 'forms\UFrmBase.pas' {FrmBase},
  UFrmTransactions in 'forms\UFrmTransactions.pas' {FrmTransactions},
  UFrmReportImport in 'forms\UFrmReportImport.pas' {FrmReportImport},
  UReportManager in 'UReportManager.pas' {ReportManager: TDataModule},
  UFrmCustomer in 'forms\UFrmCustomer.pas' {FrmCustomer},
  UFrmInvoices in 'forms\UFrmInvoices.pas' {FrmInvoices},
  UFrmInvoice in 'forms\UFrmInvoice.pas' {FrmInvoice},
  UFrmInvoiceGrid in 'recycle\UFrmInvoiceGrid.pas' {FrmBase1},
  UInvoicePrinter in 'UInvoicePrinter.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
