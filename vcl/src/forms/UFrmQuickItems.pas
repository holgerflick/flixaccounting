unit UFrmQuickItems;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq

  , Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

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

  , UFrmBase
  ;

type
  TFrmQuickItems = class(TFrmBase)
    Items: TAureliusDataset;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ItemsId: TIntegerField;
    ItemsName: TStringField;
    ItemsCategory: TStringField;
    ItemsQuantity: TFloatField;
    ItemsValue: TFloatField;
    sourceItems: TDataSource;
    ItemsDescription: TStringField;
    DBMemo1: TDBMemo;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create; reintroduce;
  end;

var
  FrmQuickItems: TFrmQuickItems;

implementation
uses
    UDictionary
  , UInvoice
  ;


{$R *.dfm}

{ TFrmQuickItems }

constructor TFrmQuickItems.Create;
begin
  inherited Create(nil);

//  Items.Close;
//  Items.SetSourceList(
//    ObjectManager.Find<TQuickItem>
//      .OrderBy(Dic.
//  );


end;

procedure TFrmQuickItems.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Items.Close;
end;

end.
