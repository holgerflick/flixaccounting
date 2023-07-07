unit uFlxDBLookupComboBox;

interface

uses
  System.Classes,

  Vcl.DBCtrls
  ;

type
  TFlxDBLookupCombobox = class( TDBLookupComboBox )
  private
    FOnChange: TNotifyEvent;
  protected
    procedure KeyValueChanged; override;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TFlxDBLookupCombobox }

procedure TFlxDBLookupCombobox.KeyValueChanged;
begin
  inherited;

  if Assigned( FOnChange ) then
  begin
    FOnChange( self );
  end;
end;



end.
