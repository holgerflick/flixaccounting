unit UFrmInvoiceGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrmBase, AdvUtil, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid;

type
  TFrmBase1 = class(TFrmBase)
    Expenses: TDBAdvGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBase1: TFrmBase1;

implementation

{$R *.dfm}

end.
