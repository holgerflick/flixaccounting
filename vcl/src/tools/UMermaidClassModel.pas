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
  TMermaidClassModel = class
  strict private
  private
    FClassNames: TStringList;
    FMarkdown: TStringlist;

    function GenericSafe(AText: String): String;
    procedure AddIfNew( AName: String; AList: TStringlist );
  public
    constructor Create;
    destructor Destroy; override;


    procedure Process;

    property ClassNames: TStringList read FClassNames;
    property Markdown: TStringList read FMarkdown;
  end;

implementation

uses
    Aurelius.Mapping.Attributes
  ;

{ TMermaidClassModel }

procedure TMermaidClassModel.AddIfNew(AName: String; AList: TStringlist);
begin
  if FClassNames.IndexOf(AName) = -1 then
  begin
    AList.Add(AName);
    FClassNames.Add(AName);
  end;
end;

constructor TMermaidClassModel.Create;
begin
  inherited;

  FClassNames := TStringList.Create;
  FClassNames.Duplicates := dupIgnore;

  FMarkdown := TStringlist.Create;
end;

destructor TMermaidClassModel.Destroy;
begin
  FMarkdown.Free;
  FClassNames.Free;

  inherited;
end;

function TMermaidClassModel.GenericSafe(AText: String): String;
begin
  Result := AText.Replace('<', '~');
  Result := Result.Replace('>', '~');
  Result := Result.Replace('.', '');
  Result := Result;
end;

procedure TMermaidClassModel.Process;
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

      if LClassName.Contains('<') then
      begin
        continue;
      end;

      var LType := LRtti.FindType(LClassName);
      if Assigned(LType) then
      begin
        // init refs, methods, properties for this class
        LRefs.Clear;

        // check that base class is TObject or part of the model, otherwise skip
        var LBaseClass := LType.BaseType;

        if Assigned( LBaseClass ) then
        begin
          // find out of the class is a list, i.e. it just refers to the type it contains
          if LBaseClass.Name.Contains('List<') then
          begin
            var LMethod := LBaseClass.GetMethod('First');
            if Assigned(LMethod) then
            begin
              AddIfNew( LMethod.ReturnType.QualifiedName, LCopy );

              LRefs.Add( LMethod.ReturnType.Name );
            end;
          end
          else
          begin
            (* find referenced objects  ... *)

            var LFields := LType.GetFields;

            for var LField in LFields do
            begin
              var LFieldType := LField.FieldType;

              // reference to another class
              if LFieldType.IsInstance then
              begin
                AddIfNew(LFieldType.QualifiedName, LCopy);
                LRefs.Add(LFieldType.Name);
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
                      // it can still be a list or the actual class...
                      if LValue.QualifiedName.Contains('List<') then
                      begin
                        // we have a list and need the wrapped class of that
                        var LFirstMethod := LValue.GetMethod('First');

                        // here we have the referenced class
                        if LFirstMethod.ReturnType.IsInstance then
                        begin
                          AddIfNew(LFirstMethod.ReturnType.QualifiedName, LCopy);
                          LRefs.Add(LFirstMethod.ReturnType.Name);
                        end;
                      end
                      else
                      begin
                        // proxy references the class and not a list
                        AddIfNew(LValue.QualifiedName, LCopy);
                        LRefs.Add(LValue.Name);
                      end;
                    end;
                  end;
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
              LReturn := ' : ' + LMethod.ReturnType.Name;
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

            FMarkdown.Add(LIndent + LMethod.Name + '(' + LParamBuf + ')' + LReturn );
          end;
        end;

        // properties
        var LProps := LType.GetProperties;
        for var LProp in LProps do
        begin
          if LProp.Parent = LType then
          begin
            FMarkdown.Add( LIndent + LProp.Name + ': ' + LProp.PropertyType.Name );
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
