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
    procedure SetHostControl( AControl: TWinControl );

    function GetName: String;
    function CanExport: Boolean;
    function CanPreview: Boolean;

    procedure Display;
    procedure Preview;

    procedure SaveToFile( AFilename: String );
  end;

implementation

end.
