unit uFlxDBLookupComboBoxReg;

interface

uses
  System.Classes
  ;

procedure Register;

implementation
uses
  uFlxDBLookupComboBox
  ;

procedure Register;
begin
  RegisterComponents( 'FlixEngineering', [ TFlxDBLookupCombobox ] );
end;
end.
