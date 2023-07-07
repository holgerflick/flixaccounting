unit UFrmInvoice;

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

  , Aurelius.Engine.ObjectManager

  , UFrmBase
  ;

type
  TFrmInvoice = class(TFrmBase)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AOwner: TComponent; AObjManager: TObjectManager ); reintroduce;
  end;

var
  FrmInvoice: TFrmInvoice;

implementation

{$R *.dfm}

{ TFrmInvoice }

constructor TFrmInvoice.Create(AOwner: TComponent; AObjManager: TObjectManager);
begin
  inherited Create( AOwner );

  FObjectManager := AObjManager;
end;

end.
