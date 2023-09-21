unit UFrmCompany;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset

  , Data.DB

  , System.Actions
  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.ActnList
  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Imaging.GIFImg
  , Vcl.Imaging.jpeg
  , Vcl.Imaging.pngimage
  , Vcl.Mask
  , Vcl.StdCtrls

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection
  ;


type
  TFrmCompany = class(TFrmBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    txtName: TDBEdit;
    txtAddressLine: TDBEdit;
    txtCityZipLine: TDBEdit;
    imgLogo: TDBImage;
    Company: TAureliusDataset;
    sourceCompany: TDataSource;
    CompanyId: TIntegerField;
    CompanyName: TStringField;
    CompanyAddressLine: TStringField;
    CompanyCityZipLine: TStringField;
    CompanyLogo: TBlobField;
    btnLoadLogo: TButton;
    Collection: TImageCollection;
    Images: TVirtualImageList;
    DlgOpenImage: TFileOpenDialog;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadLogoClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    function CheckReplaceLogo: Boolean;
    procedure ReplaceLogo;
  public

  end;

var
  FrmCompany: TFrmCompany;

implementation

uses
  UCompany
  ;


{$R *.dfm}

procedure TFrmCompany.FormDestroy(Sender: TObject);
begin
  Company.Close;

  inherited;
end;

procedure TFrmCompany.ReplaceLogo;
begin
  if DlgOpenImage.Execute then
  begin
    CompanyLogo.LoadFromFile(DlgOpenImage.FileName);
  end;
end;

procedure TFrmCompany.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Edit Company Information';

  Company.Manager := ObjectManager;
  Company.SetSourceCriteria(
    ObjectManager.Find<TCompany>
  );
  Company.Open;
  Company.Edit;
end;

procedure TFrmCompany.btnCancelClick(Sender: TObject);
begin
  if Company.State in dsEditModes then
  begin
    Company.Cancel;
  end;
end;

procedure TFrmCompany.btnLoadLogoClick(Sender: TObject);
begin
  if CheckReplaceLogo then
  begin
    ReplaceLogo;
  end;
end;

procedure TFrmCompany.btnOKClick(Sender: TObject);
begin
  if Company.State in dsEditModes then
  begin
    Company.Post;
  end;
end;

function TFrmCompany.CheckReplaceLogo: Boolean;
begin
  Result := True;

  if not CompanyLogo.IsNull then
  begin
    Result := TaskMessageDlg('Replace logo image',
       'A logo is already stored in the company information. Do you ' +
       'really want to replace it?',
       mtConfirmation, [mbYes, mbNo], 0 ) = mrYes;
  end;
end;

end.
