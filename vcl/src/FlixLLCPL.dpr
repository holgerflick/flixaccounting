program FlixLLCPL;

uses
  Vcl.Forms,
  UFrmMain in 'forms\UFrmMain.pas' {FrmMain},
  UAppGlobals in 'globals\UAppGlobals.pas',
  UDataManager in 'db\UDataManager.pas' {DataManager: TDataModule},
  UDataImportManager in 'db\UDataImportManager.pas',
  UFrmBase in 'forms\UFrmBase.pas' {FrmBase},
  UFrmExpenses in 'forms\UFrmExpenses.pas' {FrmExpenses},
  UFrmReportImport in 'forms\UFrmReportImport.pas' {FrmReportImport};

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
