unit wma.EnergieverbrauchZaehlerstandReadZeitraum;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError;

type
  TwmaEnergieverbrauchZaehlerstandReadZeitraum = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandReadZeitraum }

uses
  Payload.EnergieverbrauchZaehlerstandRead, DB.EnergieverbrauchZaehlerstand,
  DB.EnergieverbrauchZaehlerstandList, JSON.EnergieverbrauchZaehlerstand,
  JSON.EnergieverbrauchZaehlerstandList;


constructor TwmaEnergieverbrauchZaehlerstandReadZeitraum.Create;
begin
  inherited;
end;

destructor TwmaEnergieverbrauchZaehlerstandReadZeitraum.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerstandReadZeitraum.DoIt(
  aRequest: TWebRequest; aResponse: TWebResponse);
var
  PZaehlerstandRead: TPEnergieverbrauchZaehlerstandRead;
  DatumVon: TDateTime;
  DatumBis: TDateTime;
  DBZaehlerstandList: TDBEnergieverbrauchZaehlerstandList;
  JZaehlerstandList: TJEnergieverbrauchZaehlerstandList;
  JZaehlerstand: TJEnergieverbrauchZaehlerstand;
  i1: Integer;
begin
  inherited;
  PZaehlerstandRead := TPEnergieverbrauchZaehlerstandRead.Create;
  DBZaehlerstandList := TDBEnergieverbrauchZaehlerstandList.Create;
  JZaehlerstandList  := TJEnergieverbrauchZaehlerstandList.Create;
  try
    PZaehlerstandRead.JsonString := aRequest.Content;
    if (PZaehlerstandRead.FieldByName('ZS_ZA_ID').AsString = '') or (PZaehlerstandRead.FieldByName('ZS_ZA_ID').AsInteger = 0) then
      JErrorList.setError('Wert für ZS_ZA_ID ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if (PZaehlerstandRead.FieldByName('DATUMVON').AsString = '') then
      JErrorList.setError('Wert für DATUMVON ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if (PZaehlerstandRead.FieldByName('DATUMBIS').AsString = '') then
      JErrorList.setError('Wert für DATUMBIS ist leer', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToDate(PZaehlerstandRead.FieldByName('DATUMVON').AsString, DatumVon) then
      JErrorList.setError('DATUMVON ist kein Datumwert', c.JsonError.cJIdPayloadNichtKorrekt);

    if not TryStrToDate(PZaehlerstandRead.FieldByName('DATUMBIS').AsString, DatumBis) then
      JErrorList.setError('DATUMBIS ist kein Datumwert', c.JsonError.cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehlerstandList.Trans := fTrans;
    DBZaehlerstandList.ReadZeitraum(PZaehlerstandRead.FieldByName('ZS_ZA_ID').AsInteger, DatumVon, DatumBis);


    for i1 := 0 to DBZaehlerstandList.Count -1 do
    begin
      JZaehlerstand := JZaehlerstandList.Add;
      DBZaehlerstandList.Item[i1].LoadToJsonObjekt(JZaehlerstand);
    end;
    aResponse.Content := JZaehlerstandList.JsonString;


  finally
    FreeAndNil(PZaehlerstandRead);
    FreeAndNil(DBZaehlerstandList);
    FreeAndNil(JZaehlerstandList);
  end;

end;

end.
