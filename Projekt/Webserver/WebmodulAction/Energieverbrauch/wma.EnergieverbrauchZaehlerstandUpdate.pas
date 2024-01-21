unit wma.EnergieverbrauchZaehlerstandUpdate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehlerstand;

type
  TwmaEnergieverbrauchZaehlerstandUpdate = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandUpdate }

uses
  Payload.EnergieverbrauchZaehlerstandUpdate;

constructor TwmaEnergieverbrauchZaehlerstandUpdate.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchZaehlerstandUpdate.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerstandUpdate.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  PZaehlerstandUpdate: TPEnergieverbrauchZaehlerstandUpdate;
  DBZaehlerstand: TDBEnergieverbrauchZaehlerstand;
  Stand: Extended;
  Datum: TDateTime;
  ZaId: Integer;
begin
  inherited;
  PZaehlerstandUpdate := TPEnergieverbrauchZaehlerstandUpdate.Create;
  DBZaehlerstand      := TDBEnergieverbrauchZaehlerstand.Create(nil);
  try
    DBZaehlerstand.Trans := fTrans;
    PZaehlerstandUpdate.JsonString := aRequest.content;
    if PZaehlerstandUpdate.FieldByName('ZS_ZA_ID').AsString = '' then
      JErrorList.setError('Wert für ZS_ZA_ID ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if PZaehlerstandUpdate.FieldByName('ZS_WERT').AsString = '' then
      JErrorList.setError('Wert für ZS_WERT ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if PZaehlerstandUpdate.FieldByName('ZS_DATUM').AsString = '' then
      JErrorList.setError('Wert für ZS_DATUM ist leer', c.JsonError.cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    if not TryStrToInt(PZaehlerstandUpdate.FieldByName('ZS_ZA_ID').AsString, ZaId) then
      JErrorList.setError('ZS_ZA_ID ist nicht numerisch', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToFloat(PZaehlerstandUpdate.FieldByName('ZS_WERT').AsString, Stand) then
      JErrorList.setError('ZS_WERT ist nicht numerisch', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToDate(PZaehlerstandUpdate.FieldByName('ZS_DATUM').AsString, Datum) then
      JErrorList.setError('ZS_DATUM ist kein Datum', c.JsonError.cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    if PZaehlerstandUpdate.FieldByName('ZS_ID').AsInteger > 0 then
    begin
      DBZaehlerstand.Read(PZaehlerstandUpdate.FieldByName('ZS_ID').AsInteger);
      if PZaehlerstandUpdate.FieldByName('ZS_ID').AsInteger <> DBZaehlerstand.Id then
      begin
        JErrorList.setError('ZS_ID nicht in Datenbank gefunden', c.JsonError.cJIdPayloadNichtKorrekt);
        aResponse.Content := JErrorList.JsonString;
        exit;
      end;
    end;

    DBZaehlerstand.ZaId := ZaId;
    DBZaehlerstand.Wert := Stand;
    DBZaehlerstand.Datum := Datum;
    DBZaehlerstand.SaveToDB;

    aResponse.Content := '{"Ok":"true"}';


  finally
    FreeAndNil(PZaehlerstandUpdate);
    FreeAndNil(DBZaehlerstand);
  end;

end;

end.
