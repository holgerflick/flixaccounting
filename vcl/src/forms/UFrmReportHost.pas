{*******************************************************************************}
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
unit UFrmReportHost;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, Vcl.ExtCtrls, 
  Vcl.StdCtrls, System.Actions, Vcl.ActnList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  UReportInterfaces;

type
  TFrmReportHost = class(TFrmBase)
    panTop: TPanel;
    panHost: TPanel;
    btnCustomers: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    actCustomerProfits: TAction;
    actProfitLoss: TAction;
    Images: TVirtualImageList;
    Collection: TImageCollection;
    cbFilterYear: TComboBox;
    Button2: TButton;
    Button3: TButton;
    actPrint: TAction;
    actExport: TAction;
    DlgSave: TFileSaveDialog;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actCustomerProfitsExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actExportUpdate(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actPrintUpdate(Sender: TObject);
    procedure actProfitLossExecute(Sender: TObject);
    procedure cbFilterYearChange(Sender: TObject);
  private
    { Private declarations }
    FHosting: IReport;

    function GetSelectedYear: Integer;

    procedure UpdateFilter;
    procedure Display( AReport: IReport );
    procedure UpdateReport;
  public
    { Public declarations }
  end;

var
  FrmReportHost: TFrmReportHost;

implementation

uses
    System.DateUtils
  , UDictionary
  , UTransaction
  , UFrmReportCustomers
  , UFrmReportProfitLoss
  ;

const
  CCaptionStart = 'Report: ';

{$R *.dfm}

procedure TFrmReportHost.FormDestroy(Sender: TObject);
begin
  FHosting := nil;

  inherited;
end;

function TFrmReportHost.GetSelectedYear: Integer;
begin
  Result := TDateTime.Today.Year;

  if cbFilterYear.ItemIndex > -1 then
  begin
    Result := Integer( cbFilterYear.Items.Objects[ cbFilterYear.ItemIndex ] );
  end;
end;

procedure TFrmReportHost.FormCreate(Sender: TObject);
begin
  inherited;

  FHosting := nil;

  UpdateFilter;
end;

procedure TFrmReportHost.actCustomerProfitsExecute(Sender: TObject);
var
  LReport: IReport;

begin
  FHosting := nil;

  LReport := TFrmReportCustomers.Create(nil);

  Display( LReport );
end;

procedure TFrmReportHost.actExportExecute(Sender: TObject);
begin
  if Assigned( FHosting ) then
  begin
    if DlgSave.Execute then
    begin
      FHosting.SaveToFile(DlgSave.FileName);
    end;
  end;
end;

procedure TFrmReportHost.actExportUpdate(Sender: TObject);
begin
  var LEnabled := FHosting <> nil;
  if LEnabled then
  begin
    LEnabled := FHosting.CanExport;
  end;
  (Sender as TAction).Enabled := LEnabled;
end;

procedure TFrmReportHost.actPrintExecute(Sender: TObject);
begin
  if Assigned( FHosting ) then
  begin
    FHosting.Print;
  end;
end;

procedure TFrmReportHost.actPrintUpdate(Sender: TObject);
begin
  var LEnabled := FHosting <> nil;
  if LEnabled then
  begin
    LEnabled := FHosting.CanPrint;
  end;
  (Sender as TAction).Enabled := LEnabled;
end;

procedure TFrmReportHost.actProfitLossExecute(Sender: TObject);
var
  LReport: IReport;

begin
  FHosting := nil;

  LReport := TFrmReportProfitLoss.Create(nil);

  Display( LReport );
end;

procedure TFrmReportHost.cbFilterYearChange(Sender: TObject);
begin
  UpdateReport;
end;

procedure TFrmReportHost.Display(AReport: IReport);
begin
  // tell report where to display...
  AReport.SetHostControl( self.panHost );

  // remember what this form is hosting
  FHosting := AReport;

  UpdateReport;
end;

procedure TFrmReportHost.UpdateFilter;
begin
  var LYears := ObjectManager.Find<TTransaction>
    .Select( Dic.Transaction.PaidOn.Year.Group.As_('Year') )
    .OrderBy( Dic.Transaction.PaidOn.Year, False )
    .ListValues;

  cbFilterYear.Items.Clear;

  var LCurrent := TDateTime.Today.Year;

  try
    for var LItem in LYears do
    begin
      var LFormat := '%d';
      var LYear:Integer := LItem.Values['Year'];
      if LYear = LCurrent then
      begin
        LFormat := 'Current Year (%d)';
      end;
      if LYear = LCurrent - 1 then
      begin
        LFormat := 'Last Year (%d)';
      end;

      cbFilterYear.Items.AddObject( Format( LFormat, [ LYear ] ), TObject(LYear) );
    end;
  finally
    LYears.Free;
  end;

  if cbFilterYear.Items.Count > 0 then
  begin
    cbFilterYear.ItemIndex := 0;
  end;
end;

procedure TFrmReportHost.UpdateReport;
begin
  if Assigned( FHosting ) then
  begin
    var LYear := GetSelectedYear;
    FHosting.SetRangeStart( StartOfAYear( LYear ) );
    FHosting.SetRangeEnd( EndOfAYear( LYear ) );
    FHosting.Display;

    self.Caption := CCaptionStart + FHosting.GetName +
      ' (created on ' + DateTimeToStr( TDateTime.Now ) + ')';
  end;
end;

end.
