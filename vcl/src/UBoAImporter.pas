unit UBoAImporter;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Generics.Collections

  , Data.DB

  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer
  , Aurelius.Engine.ObjectManager

  ;

type
  // creates invoice items from statement file
  TBoAImporter = class
  public
    procedure Execute(ADataset: TDataset; AFilename: String; AUseHourlyBase:
        Boolean = false; ARateHourly: Double = 210);
  end;

implementation

{ TBoAImporter }

procedure TBoAImporter.Execute(ADataset: TDataset; AFilename: String; AUseHourlyBase: Boolean = false; ARateHourly: Double = 210);
var
  LLines: TStringlist;
begin
  if ADataset.State in dsEditModes then
  begin
    ADataset.Post;
  end;

  ADataset.DisableControls;
  LLines := TStringlist.Create;
  try
    LLines.LoadFromFile(AFilename);

    for var i := 0 to LLines.Count-1 do
    begin
      var LLine := LLines[i].Replace('"','');
      var Splits := LLine.Split([#9]);

      if Length(Splits) = 4 then      // ignore any additional lines
      begin
        try
          var LConversionCheck := StrToDate( Splits[0] );
          var LAmount := StrToFloat( Splits[2] );

          var LDate := Splits[0] + ': ';
          var LText := Splits[1];

          ADataSet.Append;
          ADataSet.FieldByName('Idx').AsInteger := i + 1;
          ADataSet.FieldByName('Category').AsString := 'Consulting';
          ADataSet.FieldByName('Title').AsString := LDate + LText;
          if not AUseHourlyBase then
          begin
            ADataSet.FieldByName('Quantity').AsFloat := 1;
            ADataSet.FieldByName('Value').AsFloat := LAmount;
          end
          else
          begin
            ADataSet.FieldByName('Quantity').AsFloat := LAmount / ARateHourly;
            ADataSet.FieldByName('Value').AsFloat := ARateHourly;
          end;
          ADataSet.Post;
        except
          on E: EConvertError do
          begin
            // nothing really - just read the next line
          end;
        end;
      end;
    end;
  finally
    LLines.Free;
    ADataset.EnableControls;
  end;
end;

end.
