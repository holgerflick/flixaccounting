{*******************************************************************************}
{                                                                               }
{  FlixAccounting Example                                                       }
{  ----------------------                                                       }
{                                                                               }
{  Copyright (c) 2023 by Dr. Holger Flick, FlixEngineering, LLC.                }
{                                                                               }
{  DISCLAIMER:                                                                  }
{  This source code is provided as an example for educational and illustrative  }
{  purposes only. It is not intended for production use or any specific purpose.}
{  The author and the company disclaim all liabilities for any damages or       }
{  losses arising from the use or misuse of this code. Use at your own risk.    }
{                                                                               }
{*******************************************************************************}
unit UFrmPayments;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Projections
  , Aurelius.Engine.ObjectManager
  , Aurelius.Types.Blob
  , Aurelius.Types.Proxy

  , Data.DB

  , System.Classes
  , System.ImageList
  , System.SysUtils
  , System.Variants
  , System.Actions

  , Vcl.ActnList
  , Vcl.BaseImageCollection
  , Vcl.Controls
  , Vcl.DBCtrls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.ExtCtrls
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids
  , Vcl.ImageCollection
  , Vcl.ImgList
  , Vcl.StdCtrls
  , Vcl.VirtualImageList

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase, Vcl.Buttons
  ;

type
  TFrmPayments = class(TFrmBase)
    Payments: TAureliusDataset;
    GridPayments: TDBGrid;
    PaymentsId: TIntegerField;
    PaymentsInvoice: TAureliusEntityField;
    PaymentsPaidOn: TDateField;
    PaymentsAmount: TFloatField;
    sourcePayments: TDataSource;
    DBNavigator1: TDBNavigator;
    PaymentsInvoiceNumber: TIntegerField;
    Invoice: TAureliusDataset;
    sourceInvoice: TDataSource;
    btnPayFull: TButton;
    txtDue: TLabel;
    Collection: TImageCollection;
    Images: TVirtualImageList;
    procedure btnPayFullClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sourcePaymentsDataChange(Sender: TObject; Field: TField);
    procedure sourcePaymentsStateChange(Sender: TObject);
  private
    { Private declarations }
    FDataSet: TAureliusDataset;
    FDataSource: TDataSource;

    procedure UpdateAmountDue;
  public
    { Public declarations }
    constructor Create(
      AObjManager: TObjectManager;
      ADataSource: TDataSource
      ); reintroduce;

  end;


implementation

uses
  System.DateUtils
  , UInvoice
  , UGridUtils
  ;

{$R *.dfm}

{ TFrmPayments }

constructor TFrmPayments.Create(AObjManager: TObjectManager;
  ADataSource: TDataSource);
begin
  inherited Create( nil );

  FDataset := ADataSource.DataSet as TAureliusDataset;
  FDataSource := ADataSource;

  TGridUtils.UseMonospaceFont(GridPayments.Columns);

  Payments.Close;
  Payments.DatasetField := FDataSet.FieldByName('Payments') as TDatasetField;
  Payments.DefaultsFromObject := True;
  Payments.Open;

  Caption := Format(
    'Invoice %d - Payments', [ FDataSet.FieldByName('Number').AsInteger ]
    );

  UpdateAmountDue;
end;

procedure TFrmPayments.btnPayFullClick(Sender: TObject);
begin
  // cancel editing
  if Payments.State in dsEditModes then
  begin
    Payments.Cancel;
  end;

  // get selected invoice
  var LCurrentInvoice := FDataSet.Current<TInvoice>;

  // add new payment with amount due
  // with current date
  Payments.Append;
  PaymentsPaidOn.AsDateTime := TDateTime.Today;
  PaymentsAmount.AsFloat := LCurrentInvoice.AmountDue;
  Payments.Post;
end;

procedure TFrmPayments.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // post all changes
  if Payments.State in dsEditModes then
  begin
    Payments.Post;
  end;

  if FDataset.State in dsEditModes then
  begin
    FDataset.Post;
  end;
end;

procedure TFrmPayments.sourcePaymentsDataChange(Sender: TObject; Field: TField);
begin
  UpdateAmountDue;
end;

procedure TFrmPayments.sourcePaymentsStateChange(Sender: TObject);
begin
 UpdateAmountDue;
end;

procedure TFrmPayments.UpdateAmountDue;
begin
  // get current invoice
  var LInvoice := FDataSet.Current<TInvoice>;

  // get amount due value
  var LAmountDue := LInvoice.AmountDue;
  txtDue.Caption := Format( '%m', [LAmountDue]);

  txtDue.Visible := LAmountDue <> 0;

  // red => amount due
  // green => overpaid
  if LAmountDue > 0 then
  begin
    txtDue.Font.Color := clRed;
  end
  else
  begin
    if LAmountDue < 0 then
    begin
      txtDue.Font.Color := clGreen;
    end;
  end;
end;

end.
