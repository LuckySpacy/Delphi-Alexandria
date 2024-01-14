unit wai.ZaehlerstandReadZeitraum;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, wai.base;

type
  Twai_ZaehlerstandReadZeitraum = class(Twm_Base)
  private
  protected
  public
    constructor Create(aRequest: TWebRequest; aResponse: TWebResponse); override;
    destructor Destroy; override;
    procedure DoIt;
  end;


implementation

{ Twai_ZaehlerstandReadZeitraum }

uses
  Datenmodul.Database, Objekt.JZaehlerstand;

constructor Twai_ZaehlerstandReadZeitraum.Create(aRequest: TWebRequest;
  aResponse: TWebResponse);
begin
  inherited;

end;

destructor Twai_ZaehlerstandReadZeitraum.Destroy;
begin

  inherited;
end;

procedure Twai_ZaehlerstandReadZeitraum.DoIt;
var
  fDatumVon: TDateTime;
  fDatumBis: TDateTime;
  JZaehlerstand: TJZaehlerstand;
  i1: Integer;
  WertAkt: Extended;
  WertVorher: Extended;
  Verbrauch: Extended;
begin
  try
    JZaehlerstand := fJZaehlerstandList.Add;
    JZaehlerstand.setErrorList(fJErrorList);
    JZaehlerstand.JsonString := fRequest.Content;
    if fJErrorList.Count > 0 then
    begin
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    if Trim(JZaehlerstand.FieldByName('DATUMVON').AsString) = '' then
    begin
      fJErrorList.setError('Feld DATUMVON ist leer', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    if Trim(JZaehlerstand.FieldByName('DATUMBIS').AsString) = '' then
    begin
      fJErrorList.setError('Feld DATUMBIS ist leer', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    if not TryStrToDate(JZaehlerstand.FieldByName('DATUMBIS').AsString, fDatumBis) then
    begin
      fJErrorList.setError('Feld DATUMBIS ist kein gültiges Datumformat', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    if not TryStrToDate(JZaehlerstand.FieldByName('DATUMVON').AsString, fDatumVon) then
    begin
      fJErrorList.setError('Feld DATUMVON ist kein gültiges Datumformat', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;


    if JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger <= 0 then
    begin
      fJErrorList.setError('ZS_ZA_ID entweder nicht übergeben oder nicht numerisch', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    fDBZaehler.Trans := dm.Trans;
    fDBZaehler.Read(JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger);
    if JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger <> fDBZaehler.Id then
    begin
      fJErrorList.setError('Zähler zur ZS_ZA_ID nicht gefunden', '1');
      fResponse.Content := fJErrorList.JsonString;
      exit;
    end;

    fDBZaehlerstandList.Trans := dm.Trans;
    //fDBZaehlerstandList.ReadAllByZaIdAndZeitraum(JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger,
    //                                             fDatumVon, fDatumBis);
    fDBZaehlerstandList.ReadAllByZaId(JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger);
    fJZaehlerstandList.Clear;
    if fDBZaehlerstandList.Count = 0 then
    begin
      JZaehlerstand := fJZaehlerstandList.Add;
      JZaehlerstand.FieldByName('ZS_ID').AsString := '0';
    end;

    for i1 := 0 to fDBZaehlerstandList.Count -1 do
    begin
      WertVorher := 0;
      WertAkt := fDBZaehlerstandList.Item[i1].Wert;
      if i1 + 1 < fDBZaehlerstandList.Count then
        WertVorher := fDBZaehlerstandList.Item[i1+1].Wert;
      Verbrauch := WertAkt - WertVorher;
      if Verbrauch <= 0 then // Zählerwechsel
        Verbrauch := WertAkt;
      if  (trunc(fDBZaehlerstandList.Item[i1].Datum) >= fDatumVon)
      and (trunc(fDBZaehlerstandList.Item[i1].Datum) <= fDatumBis) then
      begin
        JZaehlerstand := fJZaehlerstandList.Add;
        JZaehlerstand.FieldByName('VERBRAUCH').AsFloat := Verbrauch;
        fDBZaehlerstandList.Item[i1].LoadToJsonObjekt(JZaehlerstand);
      end;
    end;

    fResponse.Content := fJZaehlerstandList.JsonString;

  except
    on E: Exception do
    begin
      fResponse.content := E.Message;
    end;
  end;
end;

end.
