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
  TMermaidClassModelGenerator = class
  strict private
  private
    FClassNames: TStringlist;
    FMarkdown: TStringlist;

    procedure AddReference( AType: TRttiType; AList: TStringlist; ARefs: TStringlist);
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

procedure TMermaidClassModelGenerator.AddReference(AType: TRttiType; AList,
  ARefs: TStringlist);
begin
  if AType.Name.Contains('List<') then
  begin
    var LMethod := AType.GetMethod('First');
    AddReference( LMethod.ReturnType, AList, ARefs );
  end
  else
  begin
    AddIfNew(AType.QualifiedName, AList);
    ARefs.Add(AType.Name);
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
  LRefs: TStringList;


begin
  var LIndent := '    ';

  LCopy := nil;
  LRefs := nil;


  FMarkdown.Clear;
  FMarkdown.Add('classDiagram');

  LRtti := TRttiContext.Create;
  try
    LRefs := TStringlist.Create;

    LCopy := TStringlist.Create;
    LCopy.Assign(FClassNames);

    while LCopy.Count > 0 do
    begin
      var LClassName := LCopy[0];
      LCopy.Delete(0);

      var LType := LRtti.FindType(LClassName);
      if Assigned(LType) then
      begin
        // init refs, methods, properties for this class
        LRefs.Clear;

        (* find referenced objects  ... *)

        var LFields := LType.GetFields;

        for var LField in LFields do
        begin
          var LFieldType := LField.FieldType;

          // reference to another class
          if LFieldType.IsInstance then
          begin
            AddReference( LFieldType, LCopy, LRefs );
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
                  AddReference( LValue, LCopy, LRefs );
                end;
              end;
            end;
          end;
        end;


        // generate markdown
        for var i := 0 to LRefs.Count-1 do
        begin
          if ( not LRefs[i].Contains('<')) and (not LRefs[i].Contains('.')) then
          begin
              FMarkdown.Add( LIndent + LType.Name + ' --> ' + LRefs[i]);
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

              LParamBuf := LParamBuf +
                LParam.Name + ': ' + LParam.ParamType.Name;
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

        FMarkDown.Add('}');

      end;
    end;
  finally
    LRtti.Free;
    LCopy.Free;
    LRefs.Free;
  end;
end;


end.
