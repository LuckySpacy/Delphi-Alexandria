unit wma.EnergieverbrauchZaehlerUpdate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehler;

type
  TwmaEnergieverbrauchZaehlerUpdate = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerUpdate }

uses
  Datenmodul.Database, db.TBTransaction, Payload.EnergieverbrauchZaehlerUpdate;

constructor TwmaEnergieverbrauchZaehlerUpdate.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchZaehlerUpdate.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerUpdate.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  DBZaehler: TDBEnergieverbrauchZaehler;
  PZaehler: TPEnergieverbrauchZaehlerUpdate;
begin
  inherited;
  DBZaehler := TDBEnergieverbrauchZaehler.Create(nil);
  PZaehler  := TPEnergieverbrauchZaehlerUpdate.Create;
  try
    PZaehler.JsonString := aRequest.Content;
    if PZaehler.FieldByName('ZA_ID').AsString = '' then
      JErrorList.setError('Wert für ZA_ID fehlt', c.JsonError.cJIdPayloadNichtKorrekt);
    if PZaehler.FieldByName('ZA_ZAEHLER').AsString = '' then
      JErrorList.setError('Wert für ZA_ZAEHLER fehlt', c.JsonError.cJIdPayloadNichtKorrekt);
    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehler.Trans := fTrans;
    if PZaehler.FieldByName('ZA_ID').AsInteger > 0 then
      DBZaehler.Read(PZaehler.FieldByName('ZA_ID').AsInteger);

    DBZaehler.Zaehler := PZaehler.FieldByName('ZA_ZAEHLER').AsString;
    DBZaehler.SaveToDB;

    aResponse.Content := '{"Ok":"true"}';

  finally
    FreeAndNil(DBZaehler);
    FreeAndNil(PZaehler);
  end;

end;

end.
