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
    procedure SetVisible( AVisible: Boolean );

    function GetName: String;

    procedure BuildReport;

    procedure SaveToFile( AFilename: String );
  end;

implementation

end.
