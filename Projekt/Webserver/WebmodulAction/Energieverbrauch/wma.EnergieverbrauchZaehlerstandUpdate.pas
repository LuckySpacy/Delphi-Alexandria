unit wma.EnergieverbrauchZaehlerstandUpdate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehlerstand, DB.EnergieverbrauchVerbrauchMonat,
  DB.EnergieverbrauchVerbrauch, Objekt.EnergieverbrauchCalc;

type
  TwmaEnergieverbrauchZaehlerstandUpdate = class(TwmaBaseEnergieverbrauch)
  private
    //procedure CalcVerbrauch(aZaId: Integer; aDatum: TDateTime);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
    //procedure VerbrauchKomplettNeuBerechnen(aZaId: Integer);
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandUpdate }

uses
  Payload.EnergieverbrauchZaehlerstandUpdate, DateUtils, DB.EnergieverbrauchZaehlerstandList;


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
  EnergieverbrauchCalc: TEnergieverbrauchCalc;
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

    EnergieverbrauchCalc := TEnergieverbrauchCalc.Create(fTrans);
    try
      EnergieverbrauchCalc.CalcVerbrauch(ZaId, Datum);
    finally
      FreeAndNil(EnergieverbrauchCalc);
    end;


    aResponse.Content := '{"Ok":"true"}';


  finally
    FreeAndNil(PZaehlerstandUpdate);
    FreeAndNil(DBZaehlerstand);
  end;

end;


{

procedure TwmaEnergieverbrauchZaehlerstandUpdate.CalcVerbrauch(aZaId: Integer; aDatum: TDateTime);
type
  REndpunkt = record
    Datum: TDateTime;
    Wert: Extended;
  end;
var
  DBVerbrauch: TDBEnergieverbrauchVerbrauch;
  DBZaehlerstand: TDBEnergieverbrauchZaehlerstand;
  LetzterEndpunkt: REndpunkt;
  NaechsterEndpunkt: REndpunkt;
  BasisEndpunkt: REndpunkt;
  Tage: Integer;
  VerbrauchGesamt: Currency;
  VerbrauchProTag: Currency;
  Enddatum: TDateTime;
  Startdatum: TDateTime;
  Datum: TDateTime;
begin
  DBZaehlerstand := TDBEnergieverbrauchZaehlerstand.Create(nil);
  DBVerbrauch    := TDBEnergieverbrauchVerbrauch.Create(nil);
  try
    DBZaehlerstand.Trans := fTrans;
    DBVerbrauch.Trans    := fTrans;
    BasisEndpunkt.Datum     := trunc(aDatum);
    LetzterEndpunkt.Datum   := DBZaehlerstand.getLetzterEndpunkt(aZaId, aDatum);
    NaechsterEndpunkt.Datum := DBZaehlerstand.getNaechsterEndpunkt(aZaId, aDatum);
    LetzterEndpunkt.Wert    := DBZaehlerstand.getEndpunktWert(aZaId, LetzterEndpunkt.Datum);
    NaechsterEndpunkt.Wert  := DBZaehlerstand.getEndpunktWert(aZaId, NaechsterEndpunkt.Datum);
    BasisEndpunkt.Wert      := DBZaehlerstand.getEndpunktWert(aZaId, BasisEndpunkt.Datum);

    if NaechsterEndpunkt.Datum < StrToDate('01.01.1900') then // Es gibt kein nächster Endpunkt
      NaechsterEndpunkt.Datum := BasisEndpunkt.Datum;


    DBVerbrauch.DeleteBereich(aZaId, LetzterEndpunkt.Datum, NaechsterEndpunkt.Datum);

    if LetzterEndpunkt.Datum < StrToDate('01.01.1900') then
      exit; // Wenn es noch keine früheren Endpunkt gibt, dann habe ich noch kein Verbrauch. Verbrauch kann erst zwischen zwei Endpunkten ermittelt werden.

    Tage := DaysBetween(LetzterEndpunkt.Datum, BasisEndpunkt.Datum);
    VerbrauchGesamt := BasisEndpunkt.Wert - LetzterEndpunkt.Wert;
    VerbrauchProTag := VerbrauchGesamt / Tage;

    if VerbrauchProTag < 0 then
      VerbrauchProTag := DBVerbrauch.getLetzterVerbrauch(aZaId, LetzterEndpunkt.Datum);

    EndDatum   := BasisEndpunkt.Datum;
    StartDatum := LetzterEndpunkt.Datum;
    Datum := StartDatum;
    while Datum < EndDatum do
    begin
      DBVerbrauch.Init;
      DBVerbrauch.ZaId  := aZaId;
      DBVerbrauch.Wert  := VerbrauchProTag;
      DBVerbrauch.Datum := Datum;
      DBVerbrauch.SaveToDB;
      Datum := IncDay(Datum, 1);
    end;

    if NaechsterEndpunkt.Datum <= BasisEndpunkt.Datum then
      exit;

    Tage := DaysBetween(BasisEndpunkt.Datum, NaechsterEndpunkt.Datum);
    VerbrauchGesamt := NaechsterEndpunkt.Wert - BasisEndpunkt.Wert;
    VerbrauchProTag := VerbrauchGesamt / Tage;
    EndDatum   := NaechsterEndpunkt.Datum;
    StartDatum := BasisEndpunkt.Datum;
    Datum := StartDatum;
    while Datum < EndDatum do
    begin
      DBVerbrauch.Init;
      DBVerbrauch.ZaId  := aZaId;
      DBVerbrauch.Wert  := VerbrauchProTag;
      DBVerbrauch.Datum := Datum;
      DBVerbrauch.SaveToDB;
      Datum := IncDay(Datum, 1);
    end;


  finally
    FreeAndNil(DBVerbrauch);
    FreeAndNil(DBZaehlerstand);
  end;

end;


procedure TwmaEnergieverbrauchZaehlerstandUpdate.VerbrauchKomplettNeuBerechnen(aZaId: Integer);
var
  DBVerbrauch: TDBEnergieverbrauchVerbrauch;
  DBZaehlerstandList: TDBEnergieverbrauchZaehlerstandList;
  i1: Integer;
begin
  DBZaehlerstandList := TDBEnergieverbrauchZaehlerstandList.Create;
  DBVerbrauch    := TDBEnergieverbrauchVerbrauch.Create(nil);
  try
    DBZaehlerstandList.Trans := fTrans;
    DBVerbrauch.Trans    := fTrans;
    DBVerbrauch.DeleteAllByZaehler(aZaId);
    DBZaehlerstandList.ReadAllByZaehler(aZaId);
    for i1 := 0 to DBZaehlerstandList.Count -1 do
    begin
      CalcVerbrauch(aZaId, DBZaehlerstandList.Item[i1].Datum);
    end;
  finally
    FreeAndNil(DBVerbrauch);
    FreeAndNil(DBZaehlerstandList);
  end;

end;
}



end.
