﻿{*******************************************************************************}
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

  , System.Types
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
  , UFrmBase
  , UInvoice, System.Actions, Vcl.ActnList, Vcl.Buttons
  ;

type
  TFrmInvoice = class(TFrmBase)
    Items: TAureliusDataset;
    ItemsSelf: TAureliusEntityField;
    ItemsId: TIntegerField;
    ItemsIdx: TIntegerField;
    ItemsCategory: TStringField;
    ItemsDescription: TStringField;
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
    btnOK: TButton;
    btnCancel: TButton;
    DBNavigator1: TDBNavigator;
    GridItems: TDBGrid;
    btnQuickItem: TButton;
    btnBoA: TButton;
    DlgOpen: TFileOpenDialog;
    cbCustomer: TDBLookupComboBox;
    procedure btnBoAClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnQuickItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridItemsEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FInvoices: TAureliusDataset;

    procedure OpenDatasets;

    procedure Post;
    procedure Cancel;
    procedure InitGrid;

    procedure QuickItems;

    function NextItemIndex: Integer;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AObjManager: TObjectManager;
        ADataSource: TDataSource); reintroduce;

  end;

implementation
uses
    System.Math
  , UFrmQuickItems
  , UFrmEditMemoField
  , UDictionary
  , UBoAImporter
  , UGridUtils
  ;

{$R *.dfm}

type
  THackDBGrid = class(TDBGrid);


{ TFrmInvoice }

procedure TFrmInvoice.Cancel;
begin
  if Items.State in dsEditModes then
  begin
    Items.Cancel;
  end;

  if FInvoices.State in dsEditModes then
  begin
    FInvoices.Cancel;
  end;
end;

constructor TFrmInvoice.Create(
  AOwner: TComponent;
  AObjManager: TObjectManager;
  ADataSource: TDataSource
  );
begin
  inherited Create( AOwner );

  ObjectManager := AObjManager;
  FInvoices := ADataSource.DataSet as TAureliusDataSet;

  cbCustomer.DataSource := ADataSource;
  txtNumber.DataSource := ADataSource;
  dateIssued.DataSource := ADataSource;
  dateDueOn.DataSource := ADataSource;

  InitGrid;

  OpenDatasets;
end;

procedure TFrmInvoice.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Edit Invoice';
end;

procedure TFrmInvoice.btnBoAClick(Sender: TObject);
begin
  if DlgOpen.Execute then
  begin
    var LImporter := TBoAImporter.Create;
    try
      LImporter.Execute(Items, DlgOpen.FileName, True);
    finally
      LImporter.Free;
    end;
  end;
end;

procedure TFrmInvoice.btnOKClick(Sender: TObject);
begin
  Post;
end;

procedure TFrmInvoice.btnQuickItemClick(Sender: TObject);
begin
  QuickItems;
end;

procedure TFrmInvoice.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Cancel;

  inherited;
end;

procedure TFrmInvoice.GridItemsEditButtonClick(Sender: TObject);
begin
  if GridItems.SelectedField = ItemsDescription then
  begin
    var LCurRow := THackDBGrid(GridItems).Row;

    var LRect := THackDBGrid(GridItems).CellRect(3, LCurRow);
    LRect := GridItems.ClientToScreen(LRect);

    TFrmEditMemoField.Execute(
        self,
        ItemsDescription,
        Point( LRect.Left, LRect.Top ),
        LRect.Right - LRect.Left
        );
  end;
end;

procedure TFrmInvoice.InitGrid;
begin
  for var c := 3 to 5 do
  begin
    TGridUtils.UseMonospaceFont( GridItems.Columns[c] );
  end;
end;

function TFrmInvoice.NextItemIndex: Integer;
var
  LBookmark: TBookmark;

begin
  // init
  Result := 0;

  // remember cursor position
  LBookmark := Items.GetBookmark;

  // disable controls - no flicker
  Items.DisableControls;
  try
    // move to first
    Items.First;
    while not Items.Eof do
    begin
      // adjust max
      Result := max( Items.FieldByName('Idx').AsInteger, Result );

      Items.Next;
    end;

    // move back to prev position
    Items.GotoBookmark(LBookmark);

    // next is max + 1
    Result := Result + 1;
  finally
    // release bookmark
    Items.FreeBookmark(LBookmark);

    // enable controls
    Items.EnableControls;
  end;
end;

procedure TFrmInvoice.OpenDatasets;
begin
  // line items of the current invoice
  Items.Close;
  Items.Manager := ObjectManager;
  Items.DatasetField := FInvoices.FieldByName('Items') as TDatasetField;
  Items.Open;

  // list of all customers ordered by name
  Customers.Close;
  Customers.SetSourceList(
    ObjectManager
      .Find<TCustomer>
      .OrderBy(Dic.Customer.Name)
      .List,
    True );
  Customers.Open;
end;

procedure TFrmInvoice.Post;
begin
  if Items.State in dsEditModes then
  begin
    Items.Post;
  end;

  if FInvoices.State in dsEditModes then
  begin
    FInvoices.Post;
  end;
end;

procedure TFrmInvoice.QuickItems;
var
  LFrm: TFrmQuickItems;

begin
  if not (Items.State in dsEditModes) then
  begin
    Items.Cancel;
  end;

  LFrm := TFrmQuickItems.Create(ObjectManager);
  try
    var LQuickItem := LFrm.Execute;
    if Assigned( LQuickItem ) then
    begin
      // determine next number
      // this has to be done on the dataset
      var LNext := NextItemIndex;

      Items.Append;
      Items.FieldByName('Idx').AsInteger := LNext;
      ItemsDescription.AsString := LQuickItem.Description;
      ItemsCategory.AsString := LQuickItem.Category;
      ItemsQuantity.AsFloat := LQuickItem.Quantity;
      ItemsValue.AsFloat := LQuickItem.Value;
      Items.Post;
    end;
  finally
    LFrm.Free;
  end;
end;

end.
