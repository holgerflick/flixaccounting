unit UIncome;

interface
uses
  Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Proxy
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer

  , Bcl.Types.Nullable

  , System.SysUtils
  , System.Generics.Collections

  , UTransaction
  , UDocument

  ;

type


  [Entity]
  [Automapping]
  TIncome = class(TTransaction)
  private
    FDateReceived: TDateTime;
    FOriginalFilename: String;

    [Association([TAssociationProp.Lazy], CascadeTypeAll)]
    FDocument: Proxy<TDocument>;

    function GetDocument: TDocument;
    procedure SetDocument(const Value: TDocument);

  public
    property Document: TDocument read GetDocument write SetDocument;

  end;

  TIncomes = TList<TIncome>;      // stupid name, but no better alternative


implementation

{ TIncome }

function TIncome.GetDocument: TDocument;
begin
  Result := FDocument.Value;
end;

procedure TIncome.SetDocument(const Value: TDocument);
begin
  FDocument.Value := Value;
end;

initialization
  RegisterEntity(TIncome);

end.
