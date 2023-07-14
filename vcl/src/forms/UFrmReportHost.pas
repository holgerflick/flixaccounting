unit UFrmReportHost;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, Vcl.ExtCtrls, uFlxPanel,
  Vcl.StdCtrls, System.Actions, Vcl.ActnList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  UReportInterfaces;

type
  TFrmReportHost = class(TFrmBase)
    panTop: TFlxPanel;
    panHost: TFlxPanel;
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
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actCustomerProfitsExecute(Sender: TObject);
  private
    { Private declarations }
    FHosting: IReportConfiguration;

    function GetSelectedYear: Integer;

    procedure UpdateFilter;
    procedure HostForm( AForm: IReportConfiguration );
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
  LFrm: IReportConfiguration;

begin
  LFrm := TFrmReportCustomers.Create(nil);

  HostForm( LFrm );
end;

procedure TFrmReportHost.HostForm(AForm: IReportConfiguration);
begin
  AForm.SetParent( self.panHost );
  FHosting := AForm;

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
  var LYear := GetSelectedYear;
  FHosting.SetRangeStart( StartOfAYear( LYear ) );
  FHosting.SetRangeEnd( EndOfAYear( LYear ) );
  FHosting.BuildReport;

  self.Caption := CCaptionStart + FHosting.GetName +
    ' (created on ' + DateTimeToStr( TDateTime.Now ) + ')';

  FHosting.SetVisible(True);
end;

end.
