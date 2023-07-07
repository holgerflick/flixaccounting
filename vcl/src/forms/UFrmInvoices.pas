unit UFrmInvoices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase;

type
  TFrmInvoices = class(TFrmBase)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure OpenDataset;
  public
    { Public declarations }
  end;

var
  FrmInvoices: TFrmInvoices;

implementation

uses
  UDictionary
  ;

{$R *.dfm}

procedure TFrmInvoices.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Invoices';

  OpenDataset;
end;

procedure TFrmInvoices.OpenDataset;
begin
  var LInvoices := ObjectManager.Find<TInvoice>
    .OrderBy

end;

end.
