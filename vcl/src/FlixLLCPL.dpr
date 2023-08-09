program FlixLLCPL;

{$R 'resources.res' 'resources.rc'}

uses
  Vcl.Forms,
  Vcl.Dialogs,
  VCL.FlexCel.Core,
  System.UITypes,
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
  UInvoicePrinter in 'UInvoicePrinter.pas',
  UFrmEditMemoField in 'forms\UFrmEditMemoField.pas' {FrmEditMemoField},
  UFrmReportPreview in 'forms\UFrmReportPreview.pas' {FrmReportPreview},
  UFrmPayments in 'forms\UFrmPayments.pas' {FrmPayments},
  UAppSettings in 'globals\UAppSettings.pas',
  UInvoiceProcessor in 'UInvoiceProcessor.pas',
  UFrmQuickItems in 'forms\UFrmQuickItems.pas' {FrmQuickItems},
  UBoAImporter in 'UBoAImporter.pas',
  UFrmReportHost in 'forms\UFrmReportHost.pas' {FrmReportHost},
  UReportInterfaces in 'globals\UReportInterfaces.pas',
  UFrmReportCustomers in 'forms\UFrmReportCustomers.pas' {FrmReportCustomers},
  UFrmReportProfitLoss in 'forms\UFrmReportProfitLoss.pas' {FrmReportProfitLoss},
  UFrmApiUsers in 'forms\UFrmApiUsers.pas' {FrmApiUsers},
  UGridUtils in 'globals\UGridUtils.pas',
  UFrmApiToken in 'forms\UFrmApiToken.pas' {FrmApiToken},
  UControlStorage in 'tools\UControlStorage.pas',
  UMermaidClassModel in 'tools\UMermaidClassModel.pas',
  UFrmMermaidModel in 'forms\UFrmMermaidModel.pas' {FrmMermaidModel};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  if TAppSettings.Shared.IsLaunchPossible then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TFrmMain, FrmMain);
    Application.Run;
  end
  else
  begin
    MessageDlg('Cannot launch application. Please check that database configuration ' +
     'exists in settings.ini.', mtError, [mbOK], 0);
  end;
end.
