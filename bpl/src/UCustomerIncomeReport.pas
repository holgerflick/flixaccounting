unit UCustomerIncomeReport;

interface
uses
    Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Types.Proxy
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections

  , UCustomer
  , UInvoice
  ;

type
  [Automapping, Entity]
  [Model('Temporary')]
  TCustomerIncomeItem = class
  public

  end;

  TCustomerIncomeReport = class
  private
    FCustomers: TCustomerIncomeItem;

  public
    property Customers: TCustomerIncomeItem read FCustomers write FCustomers;
  end;


implementation

end.
