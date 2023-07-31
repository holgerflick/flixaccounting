unit UDictionary;

interface

uses
  Aurelius.Dictionary.Classes, 
  Aurelius.Linq;

type
  TApiUserDictionary = class;
  TCSAdvStringGridDictionary = class;
  TCSControlDictionary = class;
  TCSDBGridColumnDictionary = class;
  TCSDBGridControlDictionary = class;
  TCustomerDictionary = class;
  TDocumentDictionary = class;
  TInvoiceDictionary = class;
  TInvoiceItemDictionary = class;
  TInvoicePaymentDictionary = class;
  TQuickItemDictionary = class;
  TTransactionDictionary = class;
  
  IApiUserDictionary = interface;
  
  ICSAdvStringGridDictionary = interface;
  
  ICSControlDictionary = interface;
  
  ICSDBGridColumnDictionary = interface;
  
  ICSDBGridControlDictionary = interface;
  
  ICustomerDictionary = interface;
  
  IDocumentDictionary = interface;
  
  IInvoiceDictionary = interface;
  
  IInvoiceItemDictionary = interface;
  
  IInvoicePaymentDictionary = interface;
  
  IQuickItemDictionary = interface;
  
  ITransactionDictionary = interface;
  
  IApiUserDictionary = interface(IAureliusEntityDictionary)
    function Name: TLinqProjection;
    function Id: TLinqProjection;
    function Email: TLinqProjection;
    function Token: TLinqProjection;
    function ExpiresOn: TLinqProjection;
  end;
  
  ICSAdvStringGridDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function ColumnDefinition: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
  end;
  
  ICSControlDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
  end;
  
  ICSDBGridColumnDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Width: TLinqProjection;
    function Idx: TLinqProjection;
    function Visible: TLinqProjection;
    function FieldName: TLinqProjection;
    function Grid: ICSDBGridControlDictionary;
  end;
  
  ICSDBGridControlDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
    function Columns: ICSDBGridColumnDictionary;
  end;
  
  ICustomerDictionary = interface(IAureliusEntityDictionary)
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function Id: TLinqProjection;
    function Name: TLinqProjection;
    function Contact: TLinqProjection;
  end;
  
  IDocumentDictionary = interface(IAureliusEntityDictionary)
    function Document: TLinqProjection;
    function Id: TLinqProjection;
    function OriginalFilename: TLinqProjection;
  end;
  
  IInvoiceDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Number: TLinqProjection;
    function IssuedOn: TLinqProjection;
    function DueOn: TLinqProjection;
    function ProcessedCopy: TLinqProjection;
    function Items: IInvoiceItemDictionary;
    function Payments: IInvoicePaymentDictionary;
    function Transactions: ITransactionDictionary;
    function Customer: ICustomerDictionary;
  end;
  
  IInvoiceItemDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Idx: TLinqProjection;
    function Title: TLinqProjection;
    function Quantity: TLinqProjection;
    function Value: TLinqProjection;
    function Category: TLinqProjection;
    function Invoice: IInvoiceDictionary;
  end;
  
  IInvoicePaymentDictionary = interface(IAureliusEntityDictionary)
    function PaidOn: TLinqProjection;
    function Amount: TLinqProjection;
    function Id: TLinqProjection;
    function Invoice: IInvoiceDictionary;
  end;
  
  IQuickItemDictionary = interface(IAureliusEntityDictionary)
    function Category: TLinqProjection;
    function Name: TLinqProjection;
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function Value: TLinqProjection;
    function Description: TLinqProjection;
  end;
  
  ITransactionDictionary = interface(IAureliusEntityDictionary)
    function Title: TLinqProjection;
    function Id: TLinqProjection;
    function Amount: TLinqProjection;
    function Category: TLinqProjection;
    function PaidOn: TLinqProjection;
    function Kind: TLinqProjection;
    function IsMonthly: TLinqProjection;
    function Document: IDocumentDictionary;
  end;
  
  TApiUserDictionary = class(TAureliusEntityDictionary, IApiUserDictionary)
  public
    function Name: TLinqProjection;
    function Id: TLinqProjection;
    function Email: TLinqProjection;
    function Token: TLinqProjection;
    function ExpiresOn: TLinqProjection;
  end;
  
  TCSAdvStringGridDictionary = class(TAureliusEntityDictionary, ICSAdvStringGridDictionary)
  public
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function ColumnDefinition: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
  end;
  
  TCSControlDictionary = class(TAureliusEntityDictionary, ICSControlDictionary)
  public
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
  end;
  
  TCSDBGridColumnDictionary = class(TAureliusEntityDictionary, ICSDBGridColumnDictionary)
  public
    function Id: TLinqProjection;
    function Width: TLinqProjection;
    function Idx: TLinqProjection;
    function Visible: TLinqProjection;
    function FieldName: TLinqProjection;
    function Grid: ICSDBGridControlDictionary;
  end;
  
  TCSDBGridControlDictionary = class(TAureliusEntityDictionary, ICSDBGridControlDictionary)
  public
    function Id: TLinqProjection;
    function Top: TLinqProjection;
    function Left: TLinqProjection;
    function Width: TLinqProjection;
    function Height: TLinqProjection;
    function Name: TLinqProjection;
    function Owner: ICSControlDictionary;
    function Children: ICSControlDictionary;
    function Columns: ICSDBGridColumnDictionary;
  end;
  
  TCustomerDictionary = class(TAureliusEntityDictionary, ICustomerDictionary)
  public
    function Address: TLinqProjection;
    function Email: TLinqProjection;
    function Id: TLinqProjection;
    function Name: TLinqProjection;
    function Contact: TLinqProjection;
  end;
  
  TDocumentDictionary = class(TAureliusEntityDictionary, IDocumentDictionary)
  public
    function Document: TLinqProjection;
    function Id: TLinqProjection;
    function OriginalFilename: TLinqProjection;
  end;
  
  TInvoiceDictionary = class(TAureliusEntityDictionary, IInvoiceDictionary)
  public
    function Id: TLinqProjection;
    function Number: TLinqProjection;
    function IssuedOn: TLinqProjection;
    function DueOn: TLinqProjection;
    function ProcessedCopy: TLinqProjection;
    function Items: IInvoiceItemDictionary;
    function Payments: IInvoicePaymentDictionary;
    function Transactions: ITransactionDictionary;
    function Customer: ICustomerDictionary;
  end;
  
  TInvoiceItemDictionary = class(TAureliusEntityDictionary, IInvoiceItemDictionary)
  public
    function Id: TLinqProjection;
    function Idx: TLinqProjection;
    function Title: TLinqProjection;
    function Quantity: TLinqProjection;
    function Value: TLinqProjection;
    function Category: TLinqProjection;
    function Invoice: IInvoiceDictionary;
  end;
  
  TInvoicePaymentDictionary = class(TAureliusEntityDictionary, IInvoicePaymentDictionary)
  public
    function PaidOn: TLinqProjection;
    function Amount: TLinqProjection;
    function Id: TLinqProjection;
    function Invoice: IInvoiceDictionary;
  end;
  
  TQuickItemDictionary = class(TAureliusEntityDictionary, IQuickItemDictionary)
  public
    function Category: TLinqProjection;
    function Name: TLinqProjection;
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function Value: TLinqProjection;
    function Description: TLinqProjection;
  end;
  
  TTransactionDictionary = class(TAureliusEntityDictionary, ITransactionDictionary)
  public
    function Title: TLinqProjection;
    function Id: TLinqProjection;
    function Amount: TLinqProjection;
    function Category: TLinqProjection;
    function PaidOn: TLinqProjection;
    function Kind: TLinqProjection;
    function IsMonthly: TLinqProjection;
    function Document: IDocumentDictionary;
  end;
  
  IDefaultDictionary = interface(IAureliusDictionary)
    function ApiUser: IApiUserDictionary;
    function CSAdvStringGrid: ICSAdvStringGridDictionary;
    function CSControl: ICSControlDictionary;
    function CSDBGridColumn: ICSDBGridColumnDictionary;
    function CSDBGridControl: ICSDBGridControlDictionary;
    function Customer: ICustomerDictionary;
    function Document: IDocumentDictionary;
    function Invoice: IInvoiceDictionary;
    function InvoiceItem: IInvoiceItemDictionary;
    function InvoicePayment: IInvoicePaymentDictionary;
    function QuickItem: IQuickItemDictionary;
    function Transaction: ITransactionDictionary;
  end;
  
  TDefaultDictionary = class(TAureliusDictionary, IDefaultDictionary)
  public
    function ApiUser: IApiUserDictionary;
    function CSAdvStringGrid: ICSAdvStringGridDictionary;
    function CSControl: ICSControlDictionary;
    function CSDBGridColumn: ICSDBGridColumnDictionary;
    function CSDBGridControl: ICSDBGridControlDictionary;
    function Customer: ICustomerDictionary;
    function Document: IDocumentDictionary;
    function Invoice: IInvoiceDictionary;
    function InvoiceItem: IInvoiceItemDictionary;
    function InvoicePayment: IInvoicePaymentDictionary;
    function QuickItem: IQuickItemDictionary;
    function Transaction: ITransactionDictionary;
  end;
  
function Dic: IDefaultDictionary;

implementation

var
  __Dic: IDefaultDictionary;

function Dic: IDefaultDictionary;
begin
  if __Dic = nil then __Dic := TDefaultDictionary.Create;
  result := __Dic;
end;

{ TApiUserDictionary }

function TApiUserDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TApiUserDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TApiUserDictionary.Email: TLinqProjection;
begin
  Result := Prop('Email');
end;

function TApiUserDictionary.Token: TLinqProjection;
begin
  Result := Prop('Token');
end;

function TApiUserDictionary.ExpiresOn: TLinqProjection;
begin
  Result := Prop('ExpiresOn');
end;

{ TCSAdvStringGridDictionary }

function TCSAdvStringGridDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TCSAdvStringGridDictionary.Top: TLinqProjection;
begin
  Result := Prop('Top');
end;

function TCSAdvStringGridDictionary.Left: TLinqProjection;
begin
  Result := Prop('Left');
end;

function TCSAdvStringGridDictionary.Width: TLinqProjection;
begin
  Result := Prop('Width');
end;

function TCSAdvStringGridDictionary.Height: TLinqProjection;
begin
  Result := Prop('Height');
end;

function TCSAdvStringGridDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TCSAdvStringGridDictionary.ColumnDefinition: TLinqProjection;
begin
  Result := Prop('ColumnDefinition');
end;

function TCSAdvStringGridDictionary.Owner: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Owner'));
end;

function TCSAdvStringGridDictionary.Children: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Children'));
end;

{ TCSControlDictionary }

function TCSControlDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TCSControlDictionary.Top: TLinqProjection;
begin
  Result := Prop('Top');
end;

function TCSControlDictionary.Left: TLinqProjection;
begin
  Result := Prop('Left');
end;

function TCSControlDictionary.Width: TLinqProjection;
begin
  Result := Prop('Width');
end;

function TCSControlDictionary.Height: TLinqProjection;
begin
  Result := Prop('Height');
end;

function TCSControlDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TCSControlDictionary.Owner: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Owner'));
end;

function TCSControlDictionary.Children: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Children'));
end;

{ TCSDBGridColumnDictionary }

function TCSDBGridColumnDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TCSDBGridColumnDictionary.Width: TLinqProjection;
begin
  Result := Prop('Width');
end;

function TCSDBGridColumnDictionary.Idx: TLinqProjection;
begin
  Result := Prop('Idx');
end;

function TCSDBGridColumnDictionary.Visible: TLinqProjection;
begin
  Result := Prop('Visible');
end;

function TCSDBGridColumnDictionary.FieldName: TLinqProjection;
begin
  Result := Prop('FieldName');
end;

function TCSDBGridColumnDictionary.Grid: ICSDBGridControlDictionary;
begin
  Result := TCSDBGridControlDictionary.Create(PropName('Grid'));
end;

{ TCSDBGridControlDictionary }

function TCSDBGridControlDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TCSDBGridControlDictionary.Top: TLinqProjection;
begin
  Result := Prop('Top');
end;

function TCSDBGridControlDictionary.Left: TLinqProjection;
begin
  Result := Prop('Left');
end;

function TCSDBGridControlDictionary.Width: TLinqProjection;
begin
  Result := Prop('Width');
end;

function TCSDBGridControlDictionary.Height: TLinqProjection;
begin
  Result := Prop('Height');
end;

function TCSDBGridControlDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TCSDBGridControlDictionary.Owner: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Owner'));
end;

function TCSDBGridControlDictionary.Children: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create(PropName('Children'));
end;

function TCSDBGridControlDictionary.Columns: ICSDBGridColumnDictionary;
begin
  Result := TCSDBGridColumnDictionary.Create(PropName('Columns'));
end;

{ TCustomerDictionary }

function TCustomerDictionary.Address: TLinqProjection;
begin
  Result := Prop('Address');
end;

function TCustomerDictionary.Email: TLinqProjection;
begin
  Result := Prop('Email');
end;

function TCustomerDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TCustomerDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TCustomerDictionary.Contact: TLinqProjection;
begin
  Result := Prop('Contact');
end;

{ TDocumentDictionary }

function TDocumentDictionary.Document: TLinqProjection;
begin
  Result := Prop('Document');
end;

function TDocumentDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TDocumentDictionary.OriginalFilename: TLinqProjection;
begin
  Result := Prop('OriginalFilename');
end;

{ TInvoiceDictionary }

function TInvoiceDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TInvoiceDictionary.Number: TLinqProjection;
begin
  Result := Prop('Number');
end;

function TInvoiceDictionary.IssuedOn: TLinqProjection;
begin
  Result := Prop('IssuedOn');
end;

function TInvoiceDictionary.DueOn: TLinqProjection;
begin
  Result := Prop('DueOn');
end;

function TInvoiceDictionary.ProcessedCopy: TLinqProjection;
begin
  Result := Prop('ProcessedCopy');
end;

function TInvoiceDictionary.Items: IInvoiceItemDictionary;
begin
  Result := TInvoiceItemDictionary.Create(PropName('Items'));
end;

function TInvoiceDictionary.Payments: IInvoicePaymentDictionary;
begin
  Result := TInvoicePaymentDictionary.Create(PropName('Payments'));
end;

function TInvoiceDictionary.Transactions: ITransactionDictionary;
begin
  Result := TTransactionDictionary.Create(PropName('Transactions'));
end;

function TInvoiceDictionary.Customer: ICustomerDictionary;
begin
  Result := TCustomerDictionary.Create(PropName('Customer'));
end;

{ TInvoiceItemDictionary }

function TInvoiceItemDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TInvoiceItemDictionary.Idx: TLinqProjection;
begin
  Result := Prop('Idx');
end;

function TInvoiceItemDictionary.Title: TLinqProjection;
begin
  Result := Prop('Title');
end;

function TInvoiceItemDictionary.Quantity: TLinqProjection;
begin
  Result := Prop('Quantity');
end;

function TInvoiceItemDictionary.Value: TLinqProjection;
begin
  Result := Prop('Value');
end;

function TInvoiceItemDictionary.Category: TLinqProjection;
begin
  Result := Prop('Category');
end;

function TInvoiceItemDictionary.Invoice: IInvoiceDictionary;
begin
  Result := TInvoiceDictionary.Create(PropName('Invoice'));
end;

{ TInvoicePaymentDictionary }

function TInvoicePaymentDictionary.PaidOn: TLinqProjection;
begin
  Result := Prop('PaidOn');
end;

function TInvoicePaymentDictionary.Amount: TLinqProjection;
begin
  Result := Prop('Amount');
end;

function TInvoicePaymentDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TInvoicePaymentDictionary.Invoice: IInvoiceDictionary;
begin
  Result := TInvoiceDictionary.Create(PropName('Invoice'));
end;

{ TQuickItemDictionary }

function TQuickItemDictionary.Category: TLinqProjection;
begin
  Result := Prop('Category');
end;

function TQuickItemDictionary.Name: TLinqProjection;
begin
  Result := Prop('Name');
end;

function TQuickItemDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TQuickItemDictionary.Quantity: TLinqProjection;
begin
  Result := Prop('Quantity');
end;

function TQuickItemDictionary.Value: TLinqProjection;
begin
  Result := Prop('Value');
end;

function TQuickItemDictionary.Description: TLinqProjection;
begin
  Result := Prop('Description');
end;

{ TTransactionDictionary }

function TTransactionDictionary.Title: TLinqProjection;
begin
  Result := Prop('Title');
end;

function TTransactionDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TTransactionDictionary.Amount: TLinqProjection;
begin
  Result := Prop('Amount');
end;

function TTransactionDictionary.Category: TLinqProjection;
begin
  Result := Prop('Category');
end;

function TTransactionDictionary.PaidOn: TLinqProjection;
begin
  Result := Prop('PaidOn');
end;

function TTransactionDictionary.Kind: TLinqProjection;
begin
  Result := Prop('Kind');
end;

function TTransactionDictionary.IsMonthly: TLinqProjection;
begin
  Result := Prop('IsMonthly');
end;

function TTransactionDictionary.Document: IDocumentDictionary;
begin
  Result := TDocumentDictionary.Create(PropName('Document'));
end;

{ TDefaultDictionary }

function TDefaultDictionary.ApiUser: IApiUserDictionary;
begin
  Result := TApiUserDictionary.Create;
end;

function TDefaultDictionary.CSAdvStringGrid: ICSAdvStringGridDictionary;
begin
  Result := TCSAdvStringGridDictionary.Create;
end;

function TDefaultDictionary.CSControl: ICSControlDictionary;
begin
  Result := TCSControlDictionary.Create;
end;

function TDefaultDictionary.CSDBGridColumn: ICSDBGridColumnDictionary;
begin
  Result := TCSDBGridColumnDictionary.Create;
end;

function TDefaultDictionary.CSDBGridControl: ICSDBGridControlDictionary;
begin
  Result := TCSDBGridControlDictionary.Create;
end;

function TDefaultDictionary.Customer: ICustomerDictionary;
begin
  Result := TCustomerDictionary.Create;
end;

function TDefaultDictionary.Document: IDocumentDictionary;
begin
  Result := TDocumentDictionary.Create;
end;

function TDefaultDictionary.Invoice: IInvoiceDictionary;
begin
  Result := TInvoiceDictionary.Create;
end;

function TDefaultDictionary.InvoiceItem: IInvoiceItemDictionary;
begin
  Result := TInvoiceItemDictionary.Create;
end;

function TDefaultDictionary.InvoicePayment: IInvoicePaymentDictionary;
begin
  Result := TInvoicePaymentDictionary.Create;
end;

function TDefaultDictionary.QuickItem: IQuickItemDictionary;
begin
  Result := TQuickItemDictionary.Create;
end;

function TDefaultDictionary.Transaction: ITransactionDictionary;
begin
  Result := TTransactionDictionary.Create;
end;

end.
