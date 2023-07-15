unit UReportInterfaces;

interface

uses
  Vcl.Controls
  ;

type
  IReportConfiguration = interface
  ['{3A93FF56-1B56-4FA7-B995-2F8ED67509B7}']

    procedure SetRangeStart( ADate: TDate );
    procedure SetRangeEnd( ADate: TDate );
    procedure SetParent( AComponent: TWinControl );

    function GetName: String;
    function CanExport: Boolean;
    function CanPreview: Boolean;

    procedure Display;
    procedure Preview;

    procedure SaveToFile( AFilename: String );
  end;

implementation

end.
