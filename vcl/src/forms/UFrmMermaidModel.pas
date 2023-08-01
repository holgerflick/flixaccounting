unit UFrmMermaidModel;

interface

uses
    System.Actions
  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.Clipbrd
  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase
  , UMermaidClassModel
  ;

type
  TFrmMermaidModel = class(TFrmBase)
    txtDiagram: TMemo;
    cbEntities: TComboBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure cbEntitiesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FModelGen: TMermaidClassModelGenerator;

    procedure UpdateDiagram;
  public
    { Public declarations }
  end;

var
  FrmMermaidModel: TFrmMermaidModel;

implementation

{$R *.dfm}

procedure TFrmMermaidModel.Button1Click(Sender: TObject);
begin
  Clipboard.AsText := txtDiagram.Lines.Text;
end;

procedure TFrmMermaidModel.cbEntitiesChange(Sender: TObject);
begin
  UpdateDiagram;
end;

procedure TFrmMermaidModel.FormDestroy(Sender: TObject);
begin
  FModelGen.Free;

  inherited;
end;

procedure TFrmMermaidModel.UpdateDiagram;
begin
  if cbEntities.ItemIndex <> -1 then
  begin
    FModelGen.ClassNames.Clear;
    FModelGen.ClassNames.Add( cbEntities.Items[ cbEntities.ItemIndex ] );
    FModelGen.Process;

    txtDiagram.Lines.Assign( FModelGen.Markdown );
  end;
end;

procedure TFrmMermaidModel.FormCreate(Sender: TObject);
begin
  inherited;

  txtDiagram.Lines.Clear;

  FModelGen := TMermaidClassModelGenerator.Create;
  FModelGen.GetEntityClasses( cbEntities.Items );

  if cbEntities.Items.Count>0 then
  begin
    cbEntities.ItemIndex := 0;
    UpdateDiagram;
  end;
end;

end.
