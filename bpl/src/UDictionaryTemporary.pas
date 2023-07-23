unit UDictionaryTemporary;

interface

uses
  Aurelius.Dictionary.Classes, 
  Aurelius.Linq;

type
  TPLCategoryDictionary = class;
  TPLTransactionDictionary = class;
  TProfitLossDictionary = class;
  
  IPLCategoryDictionary = interface;
  
  IPLTransactionDictionary = interface;
  
  IProfitLossDictionary = interface;
  
  IPLCategoryDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Category: TLinqProjection;
    function Section: TLinqProjection;
    function Transactions: IPLTransactionDictionary;
    function ProfitLoss: IProfitLossDictionary;
  end;
  
  IPLTransactionDictionary = interface(IAureliusEntityDictionary)
    function Title: TLinqProjection;
    function Id: TLinqProjection;
    function Amount: TLinqProjection;
    function PaidOn: TLinqProjection;
  end;
  
  IProfitLossDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Categories: IPLCategoryDictionary;
  end;
  
  TPLCategoryDictionary = class(TAureliusEntityDictionary, IPLCategoryDictionary)
  public
    function Id: TLinqProjection;
    function Category: TLinqProjection;
    function Section: TLinqProjection;
    function Transactions: IPLTransactionDictionary;
    function ProfitLoss: IProfitLossDictionary;
  end;
  
  TPLTransactionDictionary = class(TAureliusEntityDictionary, IPLTransactionDictionary)
  public
    function Title: TLinqProjection;
    function Id: TLinqProjection;
    function Amount: TLinqProjection;
    function PaidOn: TLinqProjection;
  end;
  
  TProfitLossDictionary = class(TAureliusEntityDictionary, IProfitLossDictionary)
  public
    function Id: TLinqProjection;
    function Categories: IPLCategoryDictionary;
  end;
  
  ITemporaryDictionary = interface(IAureliusDictionary)
    function PLCategory: IPLCategoryDictionary;
    function PLTransaction: IPLTransactionDictionary;
    function ProfitLoss: IProfitLossDictionary;
  end;
  
  TTemporaryDictionary = class(TAureliusDictionary, ITemporaryDictionary)
  public
    function PLCategory: IPLCategoryDictionary;
    function PLTransaction: IPLTransactionDictionary;
    function ProfitLoss: IProfitLossDictionary;
  end;
  
function DicTemp: ITemporaryDictionary;

implementation

var
  __DicTemp: ITemporaryDictionary;

function DicTemp: ITemporaryDictionary;
begin
  if __DicTemp = nil then __DicTemp := TTemporaryDictionary.Create;
  result := __DicTemp;
end;

{ TPLCategoryDictionary }

function TPLCategoryDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TPLCategoryDictionary.Category: TLinqProjection;
begin
  Result := Prop('Category');
end;

function TPLCategoryDictionary.Section: TLinqProjection;
begin
  Result := Prop('Section');
end;

function TPLCategoryDictionary.Transactions: IPLTransactionDictionary;
begin
  Result := TPLTransactionDictionary.Create(PropName('Transactions'));
end;

function TPLCategoryDictionary.ProfitLoss: IProfitLossDictionary;
begin
  Result := TProfitLossDictionary.Create(PropName('ProfitLoss'));
end;

{ TPLTransactionDictionary }

function TPLTransactionDictionary.Title: TLinqProjection;
begin
  Result := Prop('Title');
end;

function TPLTransactionDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TPLTransactionDictionary.Amount: TLinqProjection;
begin
  Result := Prop('Amount');
end;

function TPLTransactionDictionary.PaidOn: TLinqProjection;
begin
  Result := Prop('PaidOn');
end;

{ TProfitLossDictionary }

function TProfitLossDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TProfitLossDictionary.Categories: IPLCategoryDictionary;
begin
  Result := TPLCategoryDictionary.Create(PropName('Categories'));
end;

{ TTemporaryDictionary }

function TTemporaryDictionary.PLCategory: IPLCategoryDictionary;
begin
  Result := TPLCategoryDictionary.Create;
end;

function TTemporaryDictionary.PLTransaction: IPLTransactionDictionary;
begin
  Result := TPLTransactionDictionary.Create;
end;

function TTemporaryDictionary.ProfitLoss: IProfitLossDictionary;
begin
  Result := TProfitLossDictionary.Create;
end;

end.
