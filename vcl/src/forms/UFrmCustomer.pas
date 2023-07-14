unit UFrmCustomer;

interface

uses
    Winapi.Windows
  , Winapi.Messages

  , System.SysUtils
  , System.Variants
  , System.Classes

  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.StdCtrls
  , Vcl.Mask
  , Vcl.ExtCtrls
  , Vcl.DBCtrls
  , Vcl.Grids
  , Vcl.DBGrids
  , Vcl.Imaging.pngimage

  , UFrmBase

  , Data.DB

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Expression
  , Aurelius.Criteria.Projections

  ;

type
  TFrmCustomer = class(TFrmBase)
    Grid: TDBGrid;
    Customers: TAureliusDataset;
    CustomersSelf: TAureliusEntityField;
    CustomersId: TIntegerField;
    CustomersName: TStringField;
    CustomersAddress: TStringField;
    CustomersEmail: TStringField;
    sourceCustomers: TDataSource;
    txtAddress: TDBMemo;
    CustomersContact: TStringField;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure CustomersBeforePost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    procedure OpenDataset;

  public

  end;

implementation

{$R *.dfm}

uses
    UCustomer
  , UDictionary
  , UReportManager
  ;

procedure TFrmCustomer.Button1Click(Sender: TObject);

begin
  var LReport := TReportManager.Create(ObjectManager);
  try
    LReport.CreateCustomerReport;
  finally
    LReport.Free;
  end;
end;

procedure TFrmCustomer.CustomersBeforePost(DataSet: TDataSet);
begin
  if CustomersAddress.AsString.IsEmpty then
  begin
    var LBuffer := TStringList.Create;
    try
      if CustomersName.AsString.IsEmpty = False then
      begin
        LBuffer.Add( CustomersName.AsString );
      end;

      if CustomersContact.AsString.IsEmpty = False then
      begin
        LBuffer.Add( 'c/o ' + CustomersContact.AsString );
      end;

      CustomersAddress.AsString := LBuffer.Text;
    finally
      LBuffer.Free;
    end;
  end;
end;

procedure TFrmCustomer.FormCreate(Sender: TObject);
begin
  inherited;

  self.Caption := 'Customers';

  OpenDataset;
end;

procedure TFrmCustomer.OpenDataset;
begin
  Customers.Close;
  Customers.DefaultsFromObject := True;
  Customers.Manager := self.ObjectManager;

  Customers.SetSourceList(
    self.ObjectManager.Find<TCustomer>
      .OrderBy(Dic.Customer.Name, True ).List, True );

  Customers.Active := True;
end;

end.
