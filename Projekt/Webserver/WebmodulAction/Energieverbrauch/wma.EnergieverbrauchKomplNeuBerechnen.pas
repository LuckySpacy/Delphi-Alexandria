unit wma.EnergieverbrauchKomplNeuBerechnen;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError;

type
  TwmaEnergieverbrauchKomplNeuBerechnen = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchKomplNeuBerechnen }

uses
  Payload.EnergieverbrauchCalc, Objekt.EnergieverbrauchCalc;


constructor TwmaEnergieverbrauchKomplNeuBerechnen.Create;
begin
  inherited;
end;

destructor TwmaEnergieverbrauchKomplNeuBerechnen.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchKomplNeuBerechnen.DoIt(
  aRequest: TWebRequest; aResponse: TWebResponse);
var
  PEnergieverbrauchCalc: TPEnergieverbrauchCalc;
  //DatumVon: TDateTime;
  //DatumBis: TDateTime;
  EnergieverbrauchCalc: TEnergieverbrauchCalc;
begin
  inherited;
  PEnergieverbrauchCalc := TPEnergieverbrauchCalc.Create;
  EnergieverbrauchCalc  := TEnergieverbrauchCalc.Create(fTrans);
  try
    PEnergieverbrauchCalc.JsonString := aRequest.Content;
    if (PEnergieverbrauchCalc.FieldByName('ZS_ZA_ID').AsString = '') or (PEnergieverbrauchCalc.FieldByName('ZS_ZA_ID').AsInteger = 0) then
      JErrorList.setError('Wert für ZS_ZA_ID ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
      {
    if (PEnergieverbrauchCalc.FieldByName('DATUMVON').AsString = '') then
      JErrorList.setError('Wert für DATUMVON ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if (PEnergieverbrauchCalc.FieldByName('DATUMBIS').AsString = '') then
      JErrorList.setError('Wert für DATUMBIS ist leer', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToDate(PEnergieverbrauchCalc.FieldByName('DATUMVON').AsString, DatumVon) then
      JErrorList.setError('DATUMVON ist kein Datumwert', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToDate(PEnergieverbrauchCalc.FieldByName('DATUMBIS').AsString, DatumBis) then
      JErrorList.setError('DATUMBIS ist kein Datumwert', c.JsonError.cJIdPayloadNichtKorrekt);
      }

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    EnergieverbrauchCalc.VerbrauchKomplettNeuBerechnen(PEnergieverbrauchCalc.FieldByName('ZS_ZA_ID').AsInteger);

    //aResponse.Content := JZaehlerstandList.JsonString;
    aResponse.Content := '';


  finally
    FreeAndNil(PEnergieverbrauchCalc);
    FreeAndNil(EnergieverbrauchCalc);
  end;

end;

end.
