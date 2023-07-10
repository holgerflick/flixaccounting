unit UFrmInvoice;

interface

uses
    AdvDateTimePicker
  , AdvDBDateTimePicker
  , AdvEdit
  , AdvGrid
  , AdvObj
  , AdvUtil

  , Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Engine.ObjectManager

  , BaseGrid

  , Data.DB

  , DBAdvEd
  , DBAdvGrid

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ComCtrls
  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UCustomer
  , uFlxDBLookupComboBox
  , UFrmBase
  , UInvoice
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
    GridItems: TDBGrid;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure GridItemsEditButtonClick(Sender: TObject);
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

implementation
uses
  UFrmEditMemoField,
  UDictionary
  ;

{$R *.dfm}

type
  THackDBGrid = class(TDBGrid);


{ TFrmInvoice }

procedure TFrmInvoice.Cancel;
begin
  if FInvoices.State in dsEditModes then
  begin
    FInvoices.Cancel;
  end;
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

procedure TFrmInvoice.GridItemsEditButtonClick(Sender: TObject);
begin
  if GridItems.SelectedField = ItemsTitle then
  begin
    var LCurRow := THackDBGrid(GridItems).Row;


    var LRect := THackDBGrid(GridItems).CellRect(3, LCurRow);

    LRect := GridItems.ClientToScreen(LRect);


    TFrmEditMemoField.Execute(
        self,
        ItemsTitle,
        Point( LRect.Left, LRect.Top ),
        LRect.Right - LRect.Left
        );
  end;
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
  if FInvoices.State in dsEditModes then
  begin
    FInvoices.Post;
  end;
end;

end.
