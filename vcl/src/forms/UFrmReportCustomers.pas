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
  , UReportManager
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
    procedure BuildReport;
    procedure SaveToFile(AFilename: String);
    procedure SetRangeEnd(ADate: TDate);
    procedure SetRangeStart(ADate: TDate);
    procedure SetParent(AParent: TWinControl);
    procedure SetVisible( AVisible: Boolean );

    function GetName: String;
    { Public declarations }
  end;

var
  FrmReportCustomers: TFrmReportCustomers;

implementation

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

procedure TFrmReportCustomers.FormCreate(Sender: TObject);
begin
  inherited;

  FReportManager := TReportManager.Create(ObjectManager);
  sourceCustomers.DataSet := FReportManager.CustomerReport;
  sourceInvoices.DataSet := FReportManager.CRInvoiceTotals;
  sourceCategories.DataSet := FReportManager.CRCategoryTotals;
end;

procedure TFrmReportCustomers.BuildReport;
begin
  FReportManager.RangeStart := FRangeStart;
  FReportManager.RangeEnd := FRangeEnd;

  FReportManager.BuildProfitsCustomer;
end;

procedure TFrmReportCustomers.SaveToFile(AFilename: String);
begin
  // TODO
end;

procedure TFrmReportCustomers.SetParent(AParent: TWinControl);
begin
  self.Parent := AParent;
end;

procedure TFrmReportCustomers.SetRangeEnd(ADate: TDate);
begin
  FRangeEnd := ADate;
end;

procedure TFrmReportCustomers.SetRangeStart(ADate: TDate);
begin
  FRangeStart := ADate;
end;

procedure TFrmReportCustomers.SetVisible(AVisible: Boolean);
begin
  self.Visible := AVisible;
end;

end.
