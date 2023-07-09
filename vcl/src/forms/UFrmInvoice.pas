unit UFrmInvoice;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Engine.ObjectManager

  , Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics

  , Winapi.Messages
  , Winapi.Windows

  , uFlxDBLookupComboBox
  , UFrmBase
  , UInvoice
  , UCustomer, Vcl.StdCtrls, AdvEdit, DBAdvEd, Vcl.ComCtrls, AdvDateTimePicker,
  AdvDBDateTimePicker, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  Vcl.ExtCtrls, Vcl.DBGrids
  ;



type
  TFrmInvoice = class(TFrmBase)
    cbCustomer: TFlxDBLookupCombobox;
    Items: TAureliusDataset;
    ItemsSelf: TAureliusEntityField;
    ItemsId: TIntegerField;
    ItemsIdx: TIntegerField;
    ItemsCategory: TStringField;
    ItemsTitle: TStringField;
    ItemsQuantity: TFloatField;
    ItemsValue: TFloatField;
    ItemsTotalValue: TFloatField;
    Customers: TAureliusDataset;
    sourceItems: TDataSource;
    sourceCustomers: TDataSource;
    CustomersSelf: TAureliusEntityField;
    CustomersId: TIntegerField;
    CustomersName: TStringField;
    CustomersContact: TStringField;
    CustomersAddress: TStringField;
    CustomersEmail: TStringField;
    dateDueOn: TAdvDBDateTimePicker;
    txtNumber: TDBAdvEdit;
    dateIssued: TAdvDBDateTimePicker;
    sourceInvoices: TDataSource;
    btnOK: TButton;
    btnCancel: TButton;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FInvoices: TAureliusDataset;

    procedure OpenDatasets;

    procedure Post;
    procedure Cancel;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AObjManager: TObjectManager;
        ADataSource: TDataSource); reintroduce;

  end;

var
  FrmInvoice: TFrmInvoice;

implementation
uses
  UDictionary
  ;

{$R *.dfm}

{ TFrmInvoice }

procedure TFrmInvoice.Cancel;
begin
  FInvoices.Cancel;
end;

constructor TFrmInvoice.Create(AOwner: TComponent; AObjManager: TObjectManager;
    ADataSource: TDataSource);
begin
  inherited Create( AOwner );

  FObjectManager := AObjManager;
  FInvoices := ADataSource.DataSet as TAureliusDataSet;

  cbCustomer.DataSource := ADataSource;
  txtNumber.DataSource := ADataSource;
  dateIssued.DataSource := ADataSource;
  dateDueOn.DataSource := ADataSource;

  OpenDatasets;
end;

procedure TFrmInvoice.btnCancelClick(Sender: TObject);
begin
  Cancel;
end;

procedure TFrmInvoice.btnOKClick(Sender: TObject);
begin
  Post;
end;

procedure TFrmInvoice.OpenDatasets;
begin
  Items.Close;
  Items.Manager := ObjectManager;
  Items.DatasetField := FInvoices.FieldByName('Items') as TDatasetField;
  Items.Open;

  Customers.Close;
  Customers.SetSourceList(
    ObjectManager.Find<TCustomer>.OrderBy(Dic.Customer.Name).List,
    True );
  Customers.Open;

end;

procedure TFrmInvoice.Post;
begin
  FInvoices.Post;
end;

end.
