program FlixLLCPL;

uses
  Vcl.Forms,
  UFrmMain in 'forms\UFrmMain.pas' {FrmMain},
  UAppGlobals in 'globals\UAppGlobals.pas',
  UDataManager in 'db\UDataManager.pas' {DataManager: TDataModule},
  UDataImportManager in 'db\UDataImportManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
