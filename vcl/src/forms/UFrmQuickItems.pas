unit UFrmQuickItems;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq
  , Aurelius.Engine.ObjectManager

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
  , UDictionary
  , UInvoice
  ;


type
  TFrmQuickItems = class(TFrmBase)
    Items: TAureliusDataset;
    DBGrid1: TDBGrid;
    ItemsId: TIntegerField;
    ItemsName: TStringField;
    ItemsCategory: TStringField;
    ItemsQuantity: TFloatField;
    ItemsValue: TFloatField;
    sourceItems: TDataSource;
    ItemsDescription: TStringField;
    DBMemo1: TDBMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    btnUse: TButton;
    procedure btnUseClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AObjectManager: TObjectManager ); reintroduce;

    function Execute: TQuickItem;
  end;

implementation


{$R *.dfm}

{ TFrmQuickItems }

procedure TFrmQuickItems.FormCreate(Sender: TObject);
begin
  inherited;

  Items.Close;
  Items.Manager := ObjectManager;
  Items.SetSourceList(
    ObjectManager.Find<TQuickItem>
      .OrderBy(Dic.QuickItem.Name)
      .List,
    True
  );

  Items.Open;
end;

constructor TFrmQuickItems.Create(AObjectManager: TObjectManager);
begin
  inherited Create(nil);

  ObjectManager := AObjectManager;
end;

procedure TFrmQuickItems.btnUseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFrmQuickItems.DBGrid1DblClick(Sender: TObject);
begin
  Items.Cancel;
  ModalResult := mrOK;
end;

function TFrmQuickItems.Execute: TQuickItem;
begin
  Result := nil;
  if self.ShowModal = mrOK then
  begin
    if Items.State in dsEditModes then
    begin
      Items.Post;
    end;

    Result := Items.Current<TQuickItem>;
  end;
end;

end.