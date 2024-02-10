unit wma.EnergieverbrauchZaehlerstandDelete;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehlerstand, Objekt.EnergieverbrauchCalc, DB.EnergieverbrauchVerbrauch;

type
  TwmaEnergieverbrauchZaehlerstandDelete = class(TwmaBaseEnergieverbrauch)
  private
    fEnergieverbrauchCalc: TEnergieverbrauchCalc;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandDelete }

uses
  Datenmodul.Database, Payload.EnergieverbrauchZaehlerstandUpdate, DateUtils;

constructor TwmaEnergieverbrauchZaehlerstandDelete.Create;
begin
  inherited;
  fEnergieverbrauchCalc := TEnergieverbrauchCalc.Create(fTrans);
end;

destructor TwmaEnergieverbrauchZaehlerstandDelete.Destroy;
begin
  FreeAndNil(fEnergieverbrauchCalc);
  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerstandDelete.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  DBZaehlerstand: TDBEnergieverbrauchZaehlerstand;
  DBVerbrauch   : TDBEnergieverbrauchVerbrauch;
  PZaehlerstand: TPEnergieverbrauchZaehlerstandUpdate;
  LetzterZaehlerstand: TDateTime;
  NaechsterZaehlerstand: TDateTime;
  JahrVon, Jahrbis: Integer;
begin
  inherited;
  DBZaehlerstand := TDBEnergieverbrauchZaehlerstand.Create(nil);
  DBVerbrauch    := TDBEnergieverbrauchVerbrauch.Create(nil);
  PZaehlerstand  := TPEnergieverbrauchZaehlerstandUpdate.Create;
  try
    PZaehlerstand.JsonString := aRequest.Content;
    if (PZaehlerstand.FieldByName('ZS_ID').AsString = '') or (PZaehlerstand.FieldByName('ZS_ID').AsString = '0') then
      JErrorList.setError('Wert für ZS_ID fehlt', c.JsonError.cJIdPayloadNichtKorrekt);
    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;
    DBVerbrauch.Trans := fTrans;
    DBZaehlerstand.Trans := fTrans;
    if PZaehlerstand.FieldByName('ZS_ID').AsInteger > 0 then
      DBZaehlerstand.Read(PZaehlerstand.FieldByName('ZS_ID').AsInteger);

    if PZaehlerstand.FieldByName('ZS_ID').AsInteger <> DBZaehlerstand.Id then
    begin
      JErrorList.setError('ZS_ID ' + PZaehlerstand.FieldByName('ZS_ID').AsString + ' nicht in der Datenbank gefunden', c.JsonError.cJIdNichtInTabelleGefunden);
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    LetzterZaehlerstand   := DBZaehlerstand.getLetzterEndpunkt(DBZaehlerstand.ZaId, DBZaehlerstand.Datum);
    NaechsterZaehlerstand := DBZaehlerstand.getNaechsterEndpunkt(DBZaehlerstand.ZaId, DBZaehlerstand.Datum);
    JahrVon := YearOf(LetzterZaehlerstand);
    if NaechsterZaehlerstand < StrToDate('01.01.1900') then
    begin
      NaechsterZaehlerstand := StrToDate('31.12.3000'); // es gibt kein nächster Zählerstand
      JahrBis := JahrVon;
    end
    else
      JahrBis := YearOf(NaechsterZaehlerstand);
    if DBZaehlerstand.Delete then
    begin
      DBVerbrauch.DeleteBereich(DBZaehlerstand.ZaId, LetzterZaehlerstand, NaechsterZaehlerstand);
      fEnergieverbrauchCalc.CalcVerbrauch(DBZaehlerstand.ZaId, LetzterZaehlerstand);
      fEnergieverbrauchCalc.CalcVerbrauchMonate(DBZaehlerstand.ZaId, JahrVon);
      if JahrVon <> JahrBis then
        fEnergieverbrauchCalc.CalcVerbrauchMonate(DBZaehlerstand.ZaId, JahrVon);
    end;

    aResponse.Content := '{"Ok":"true"}';

  finally
    FreeAndNil(DBZaehlerstand);
    FreeAndNil(DBVerbrauch);
    FreeAndNil(PZaehlerstand);
  end;

end;


end.
