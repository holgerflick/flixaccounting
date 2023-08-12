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
unit UMermaidClassModel;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Rtti
  , System.TypInfo
  , System.Generics.Collections
  ;

type
  TReferenceDictionary = class( TDictionary< string, TStringlist > )
  public
    procedure AddReference( AKey, AReference: TRttiType );
  end;


  TMermaidClassModelGenerator = class
  strict private
  private
    FClassNames: TStringlist;
    FMarkdown: TStringlist;

    procedure AddReference(ARoot: TRttiType; AType: TRttiType; AList: TStringlist;
        ARefs: TReferenceDictionary);
    function GenericSafe(AText: String): String;
    procedure AddIfNew( AName: String; AList: TStringlist );
  public
    constructor Create;
    destructor Destroy; override;

    procedure Process;

    procedure GetEntityClasses(AList: TStrings);

    property ClassNames: TStringList read FClassNames;
    property Markdown: TStringList read FMarkdown;
  end;



implementation

uses
    Aurelius.Mapping.Attributes
  ;

{ TMermaidClassModel }

procedure TMermaidClassModelGenerator.AddIfNew(AName: String; AList: TStringlist);
begin
  if FClassNames.IndexOf(AName) = -1 then
  begin
    AList.Add(AName);
    FClassNames.Add(AName);
  end;
end;

procedure TMermaidClassModelGenerator.AddReference(
  ARoot: TRttiType;
  AType: TRttiType;
  AList: TStringlist;
  ARefs: TReferenceDictionary);


begin
  // I have tried several approaches to determine if a class is a list
  // The only thing I have found that works reliably is to check for First
  // and Last as characterist of a descendant of TList or TList<> or
  // its Object-variations.
  //
  // Especially for constructs like TPayments = TList<TPayment> this works.
  //
  var LMethodFirst := AType.GetMethod('First');
  var LMethodLast := AType.GetMethod('Last');

  if Assigned(LMethodFirst) AND Assigned(LMethodLast) then
  begin
    // we need another check if the list class is one bundled with
    // Delphi or if it is one that the user has made part of the model
    // with certain additions.
    if not AType.Name.Contains('List<') then
    begin
      // the non-built-in class should appear in the diagram as well
      AddIfNew(AType.QualifiedName, AList);
      AddIfNew(LMethodFirst.ReturnType.Name, AList);

      // add references
      ARefs.AddReference( ARoot, AType );
      ARefs.AddReference( AType, LMethodFirst.ReturnType );
    end
    else
    begin
      ARefs.AddReference( ARoot, LMethodFirst.ReturnType);
    end;

    AddIfNew( LMethodFirst.ReturnType.QualifiedName, AList );
  end
  else
  begin
    // no list, we can add it
    AddIfNew(AType.QualifiedName, AList);
    ARefs.AddReference(ARoot, AType);
  end;
end;

constructor TMermaidClassModelGenerator.Create;
begin
  inherited;

  FClassNames := TStringList.Create;
  FClassNames.Duplicates := dupIgnore;

  FMarkdown := TStringlist.Create;
end;

destructor TMermaidClassModelGenerator.Destroy;
begin
  FMarkdown.Free;
  FClassNames.Free;

  inherited;
end;

function TMermaidClassModelGenerator.GenericSafe(AText: String): String;
begin
  Result := AText.Replace('<', '~');
  Result := Result.Replace('>', '~');
  Result := Result;
end;

procedure TMermaidClassModelGenerator.GetEntityClasses(AList: TStrings);
begin
  var LRtti := TRttiContext.Create;
  try
    var LAllTypes := LRtti.GetTypes;

    AList.Clear;

    for var LType in LAllTypes do
    begin
      if LType.HasAttribute(Entity) then
      begin
        AList.Add(LType.QualifiedName);
      end;
    end;
  finally
    LRtti.Free;
  end;
end;

procedure TMermaidClassModelGenerator.Process;
var
  LCopy: TStringList;
  LRtti: TRttiContext;
  LRefs: TReferenceDictionary;

begin
  var LIndent := '    ';

  LCopy := nil;
  LRefs := nil;

  FMarkdown.Clear;
  FMarkdown.Add('classDiagram');

  LRtti := TRttiContext.Create;
  try
    LRefs := TReferenceDictionary.Create;

    LCopy := TStringlist.Create;
    LCopy.Assign(FClassNames);

    while LCopy.Count > 0 do
    begin
      var LClassName := LCopy[0];
      LCopy.Delete(0);

      var LType := LRtti.FindType(LClassName);
      if Assigned(LType) then
      begin
        (* find referenced objects  ... *)

        var LFields := LType.GetFields;

        for var LField in LFields do
        begin
          var LFieldType := LField.FieldType;

          // reference to another class
          if LFieldType.IsInstance then
          begin
            if LFieldType.Name <> 'TObject' then
            begin
              AddReference( LType, LFieldType, LCopy, LRefs );
            end;
          end;

          // Proxy!
          if LFieldType.IsRecord then
          begin
            if LFieldType.QualifiedName.Contains('.Proxy<') then
            begin
              // proxy has a value with the type of the reference
              var LMethod := LFieldType.GetMethod('SetInitialValue');

              // first parameter contains what we need
              var LValue := LMethod.GetParameters[0].ParamType;

              if Assigned(LValue) then
              begin
                if LValue.IsInstance then
                begin
                  // proxy references the class and not a list
                  AddReference( LType, LValue, LCopy, LRefs );
                end;
              end;
            end;
          end;
        end;

        FMarkdown.Add('class ' + LType.Name + ' {' );

        // methods
        var LMethodTypes := LType.GetMethods;
        for var LMethod in LMethodTypes do
        begin
          if LMethod.Parent = LType then
          begin
            var LReturn := '';
            if LMethod.MethodKind = TMethodKind.mkFunction then
            begin
              LReturn := ' : ' + GenericSafe(LMethod.ReturnType.Name);
            end;

            var LParamBuf := '';

            var LParams := LMethod.GetParameters;
            for var LParam in LParams do
            begin
              if not LParamBuf.IsEmpty then
              begin
                LParamBuf := LParamBuf + ', ';
              end;

              var LParamType := '';
              if Assigned( LParam.ParamType ) then
              begin
                LParamType := ': ' + LParam.ParamType.Name;
              end;

              LParamBuf := LParamBuf +
                LParam.Name + LParamType;
            end;

            FMarkdown.Add(LIndent + LMethod.Name + '(' + GenericSafe(LParamBuf) + ')' + LReturn );
          end;
        end;

        // properties
        var LProps := LType.GetProperties;
        for var LProp in LProps do
        begin
          if LProp.Parent = LType then
          begin
            FMarkdown.Add(
              LIndent + LProp.Name + ': ' +
              GenericSafe(LProp.PropertyType.Name) );
          end;
        end;

        FMarkdown.Add('}');
      end;
    end;

    // add all references
    for var LKey in LRefs.Keys do
    begin
      var LList := LRefs[LKey];

      for var i := 0 to LList.Count -1 do
      begin
        FMarkdown.Add( GenericSafe(LKey) + ' --> ' + GenericSafe(LList[i]) );
      end;
    end;

  finally
    LRtti.Free;
    LCopy.Free;
    for var LKey in LRefs.Keys do
    begin
      LRefs[LKey].Free;
    end;

    LRefs.Free;
  end;
end;


{ TReferenceDictionary }

procedure TReferenceDictionary.AddReference(AKey, AReference: TRttiType);
begin
  if not self.ContainsKey(AKey.Name) then
  begin
    self.Add(AKey.Name, TStringList.Create );
  end;

  self[AKey.Name].Add(AReference.Name);
end;

end.
