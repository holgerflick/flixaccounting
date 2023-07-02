unit UIncome;

interface
uses
  Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections

  , UDocument

  ;

type

  TInvoice = class;

  [Entity]
  [Automapping]
  TIncome = class
  private
    FId: Integer;
    FDateReceived: TDateTime;
    FCategory: String;
    FTitle: String;
    FAmount: Double;
    FOriginalFilename: String;

    [Association([], CascadeTypeAllButRemove)]
    FDocument: TDocument;

  protected
    function GetTotalAmount: Double; virtual;

  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property DateReceived: TDateTime read FDateReceived write FDateReceived;
    property Category: String read FCategory write FCategory;
    property Title: String read FTitle write FTitle;
    property Amount: Double read FAmount write FAmount;

    property Document: TDocument read FDocument;

    property TotalAmount: Double read GetTotalAmount;

  end;

  [Entity]
  [Automapping]
  TInvoiceItem = class
  private
    FId: Integer;

    [Association([], CascadeTypeAllButRemove)]
    FInvoice: TInvoice;
    FIdx: Integer;
    FTitle: String;
    FQuantity: Double;
    FValue: Double;
    function GetTotalValue: Double;

  public
    property Id: Integer read FId write FId;
    property Idx: Integer read FIdx write FIdx;
    property Title: String read FTitle write FTitle;
    property Quantity: Double read FQuantity write FQuantity;
    property Value: Double read FValue write FValue;

    property TotalValue: Double read GetTotalValue;
  end;

  TInvoiceItems = TList<TInvoiceItem>;

  [Entity]
  [Automapping]
  TInvoice = class(TIncome)

  private
    [ManyValuedAssociation([], CascadeTypeAll, 'FInvoice')]
    FItems: TInvoiceItems;

  protected
    function GetTotalAmount: Double; override;

  public
    constructor Create;
    destructor  Destroy; override;

    property Items: TInvoiceItems read FItems;

  end;


implementation

{ TIncome }

constructor TIncome.Create;
begin

end;

destructor TIncome.Destroy;
begin

end;

function TIncome.GetTotalAmount: Double;
begin
  Result := Amount;
end;

{ TInvoiceItem }

function TInvoiceItem.GetTotalValue: Double;
begin
  Result := Quantity * Value;
end;

{ TInvoice }

constructor TInvoice.Create;
begin
  FItems := TInvoiceItems.Create;
end;

destructor TInvoice.Destroy;
begin
  FItems.Free;

  inherited;
end;

function TInvoice.GetTotalAmount: Double;
begin
  Result := 0;
  for var LItem in Items do
  begin
    Result := Result + LItem.TotalValue;
  end;
end;

initialization
  RegisterEntity(TIncome);
  RegisterEntity(TInvoiceItem);
  RegisterEntity(TInvoice);

end.
