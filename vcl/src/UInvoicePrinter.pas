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
unit UInvoicePrinter;

interface

uses
    System.SysUtils
  , System.Classes
  , System.Generics.Collections

  , Aurelius.Mapping.Automapping
  , Aurelius.Mapping.Attributes
  , Aurelius.Mapping.Metadata
  , Aurelius.Types.Blob
  , Aurelius.Mapping.Explorer
  , Aurelius.Engine.ObjectManager
  , Aurelius.Criteria.Projections
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Expression

  , FlexCel.Core
  , FlexCel.Pdf
  , FlexCel.Render
  , FlexCel.XlsAdapter
  , FlexCel.Report

  , Bcl.Types.Nullable

  , UTransaction
  , UInvoice
  , UCompany

  ;

type
  TInvoicePrinter = class
  private
    FObjManager: TObjectManager;

    function GetCompany: TCompany;
    procedure LoadTemplateIntoStream(ATemplate: TStream);
  public
    constructor Create(AObjManager: TObjectManager);

    procedure Print(AInvoice: TInvoice; AReport: TStream);

  end;

implementation

uses
    Winapi.Windows
  ;


constructor TInvoicePrinter.Create(AObjManager: TObjectManager);
begin
  inherited Create;

  FObjManager := AObjManager;
end;

function TInvoicePrinter.GetCompany: TCompany;
begin
  Assert( Assigned( FObjManager ) );

  var LCompany := FObjManager.Find<TCompany>
    .UniqueResult
    ;

  if not Assigned(LCompany) then
  begin
    raise Exception.Create('Company info must be added '  +
        'before invoices can be created.');
  end;

  Result := LCompany;
end;

procedure TInvoicePrinter.LoadTemplateIntoStream(ATemplate: TStream);
begin
  Assert( Assigned( ATemplate ), 'template cannot be nil' );

  var LResource := TResourceStream.Create( HInstance, 'INVOICE', RT_RCDATA );
  try
    ATemplate.CopyFrom( LResource );
    ATemplate.Position := 0;
  finally
    LResource.Free;
  end;
end;

procedure TInvoicePrinter.Print(AInvoice: TInvoice; AReport: TStream);
var
  LTemplate: TMemoryStream;
  LTemplateMod: TMemoryStream;
  LTemplateXls: TXlsFile;

  LReport: TFlexCelReport;
  LOutput: TMemoryStream;
  LPdfExport: TFlexCelPdfExport;
  LXlsFile: TXlsFile;

begin
  (*
    This method will always return an invoice in `AReport`.

    Make sure to use ProcessedCopy if the invoice
    has already been processed.

    *)

  Assert( Assigned( AReport ) );

  if not Assigned(AInvoice) then
  begin
    raise EArgumentNilException.Create('Invoice cannot be nil.');
  end;

  if not AInvoice.ProcessedCopy.IsNull then
  begin
    raise EArgumentException.Create('Invoice has already been processed.' +
     ' Printing aborted.');
  end;

  LTemplate := TMemoryStream.Create;
  LTemplateMod := nil;
  LTemplateXls := nil;
  LReport := nil;
  LOutput := nil;
  LPdfExport := nil;
  LXlsFile := nil;
  try
    LoadTemplateIntoStream( LTemplate );

    LTemplateXls := TXlsFile.Create(LTemplate, True);

    (* Example to add another currency symbol for formatting
      --> right now we are just loading and copying without change ...
    *)

    (*
    var LCellAddr := TCellAddress.Create('AF15');
    var LFormat := LTemplateXls.GetCellVisibleFormatDef( LCellAddr.Row, LCellAddr.Col );
    LFormat.Format := '#,##0.00 [$€-x-euro1]_);(#,##0.00 [$€-x-euro1])';
    LTemplateXls.SetCellFormat(LCellAddr.Row, LCellAddr.Col, LTemplateXls.AddFormat(LFormat) );
    *)

    LTemplateMod := TMemoryStream.Create;
    LTemplateXls.Save(LTemplateMod);
    LTemplateMod.Position := 0;

    LReport := TFlexCelReport.Create(True);

    LReport.SetValue('BillTo', AInvoice.Customer.AddressExcel);
    LReport.SetValue('IssuedOn', TDateTime( AInvoice.IssuedOn ) );
    LReport.SetValue('Number', AInvoice.Number );
    LReport.SetValue('DueOn', TDateTime( AInvoice.DueOn ) );
    LReport.SetValue('TotalAmount', AInvoice.TotalAmount );

    // company info
    var LCompanyInfo := GetCompany;

    LReport.SetValue('CompanyName', LCompanyInfo.Name);
    LReport.SetValue('CompanyAddressLine', LCompanyInfo.AddressLine);
    LReport.SetValue('CompanyCityZipLine', LCompanyInfo.CityZipLine);
    LReport.SetValue('CompanyLogo', LCompanyInfo.Logo.AsBytes );

    LReport.AddTable<TInvoiceItem>('I', AInvoice.Items );

    LOutput := TMemoryStream.Create;
    LReport.Run(LTemplateMod, LOutput );
    LOutput.Position := 0;

    LXlsFile := TXlsFile.Create(LOutput, True);
    LXlsFile.Save(AReport, TFileFormats.Xlsx );
    AReport.Position := 0;
  finally
    LXlsFile.Free;
    LPdfExport.Free;
    LOutput.Free;
    LReport.Free;
    LTemplate.Free;
    LTemplateMod.Free;
    LTemplateXls.Free;
  end;
end;

end.
