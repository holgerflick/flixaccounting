unit UFrmCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TFrmCustomer = class(TFrmBase)
    Grid: TDBGrid;
    DBEdit1: TDBEdit;
    Customers: TAureliusDataset;
    CustomersSelf: TAureliusEntityField;
    CustomersId: TIntegerField;
    CustomersLookupName: TStringField;
    CustomersName: TStringField;
    CustomersAddress: TStringField;
    CustomersEmail: TStringField;
    sourceCustomers: TDataSource;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    DBEdit3: TDBEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmCustomer.FormCreate(Sender: TObject);
begin
  inherited;

  self.Caption := 'Customers';
end;

end.
