unit UDictionary;

interface

uses
  Aurelius.Dictionary.Classes, 
  Aurelius.Linq;

type
  TCustomerDictionary = class;
  TDocumentDictionary = class;
  TInvoiceDictionary = class;
  TInvoiceItemDictionary = class;
  TInvoicePaymentDictionary = class;
  TQuickItemDictionary = class;
  TTransactionDictionary = class;
  
  ICustomerDictionary = interface;
  
  IDocumentDictionary = interface;
  
  IInvoiceDictionary = interface;
  
  IInvoiceItemDictionary = interface;
  
  IInvoicePaymentDictionary = interface;
  
  IQuickItemDictionary = interface;
  
  ITransactionDictionary = interface;
  
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
