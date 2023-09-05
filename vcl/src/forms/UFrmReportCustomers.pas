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
unit UFrmReportCustomers;

interface

uses
    Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  , UReportInterfaces
  , UReportManager, System.Actions, Vcl.ActnList
  ;

type
  TFrmReportCustomers = class(TFrmBase, IReportConfiguration)
    Customers: TDBGrid;
    Splitter1: TSplitter;
    Categories: TDBGrid;
    Splitter2: TSplitter;
    Invoices: TDBGrid;
    sourceCustomers: TDataSource;
    sourceInvoices: TDataSource;
    sourceCategories: TDataSource;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FReportManager: TReportManager;

    FRangeStart: TDate;
    FRangeEnd: TDate;

  public
    procedure Display;
    procedure Preview;

    procedure SaveToFile(AFilename: String);
    procedure SetRangeEnd(ADate: TDate);
    procedure SetRangeStart(ADate: TDate);
    procedure SetHostControl(AControl: TWinControl);

    function CanPreview: Boolean;
    function CanExport: Boolean;

    function GetName: String;
    { Public declarations }
  end;

var
  FrmReportCustomers: TFrmReportCustomers;

implementation

uses
  UGridUtils
  ;

{$R *.dfm}

procedure TFrmReportCustomers.FormDestroy(Sender: TObject);
begin
  FReportManager.Free;

  inherited;
end;

function TFrmReportCustomers.GetName: String;
begin
  Result := 'Income per Customer';
end;

procedure TFrmReportCustomers.Preview;
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportCustomers.FormCreate(Sender: TObject);
begin
  inherited;

  FReportManager := TReportManager.Create(ObjectManager);
  sourceCustomers.DataSet := FReportManager.CustomerReport;
  sourceInvoices.DataSet := FReportManager.CRInvoiceTotals;
  sourceCategories.DataSet := FReportManager.CRCategoryTotals;
end;

function TFrmReportCustomers.CanExport: Boolean;
begin
  Result := False;
end;

function TFrmReportCustomers.CanPreview: Boolean;
begin
  Result := False;
end;

procedure TFrmReportCustomers.Display;
begin
  FReportManager.RangeStart := FRangeStart;
  FReportManager.RangeEnd := FRangeEnd;

  FReportManager.BuildProfitsCustomer;
  self.Visible := True;
end;

procedure TFrmReportCustomers.SaveToFile(AFilename: String);
begin
  raise ENotImplemented.Create('Still to come.');
end;

procedure TFrmReportCustomers.SetHostControl(AControl: TWinControl);
begin
  self.Parent := AControl;
end;

procedure TFrmReportCustomers.SetRangeEnd(ADate: TDate);
begin
  FRangeEnd := ADate;
end;

procedure TFrmReportCustomers.SetRangeStart(ADate: TDate);
begin
  FRangeStart := ADate;
end;

end.
