unit wma.EnergieverbrauchZaehlerDelete;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehler;

type
  TwmaEnergieverbrauchZaehlerDelete = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerDelete }

uses
  Datenmodul.Database, Payload.EnergieverbrauchZaehlerUpdate;

constructor TwmaEnergieverbrauchZaehlerDelete.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchZaehlerDelete.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerDelete.DoIt(aRequest: TWebRequest;
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
    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehler.Trans := fTrans;
    if PZaehler.FieldByName('ZA_ID').AsInteger > 0 then
      DBZaehler.Read(PZaehler.FieldByName('ZA_ID').AsInteger);

    if PZaehler.FieldByName('ZA_ID').AsInteger <> DBZaehler.Id then
    begin
      JErrorList.setError('ZA_ID ' + PZaehler.FieldByName('ZA_ID').AsString + ' nicht in der Datenbank gefunden', c.JsonError.cJIdNichtInTabelleGefunden);
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehler.Delete;

    aResponse.Content := '{"Ok":"true"}';

  finally
    FreeAndNil(DBZaehler);
    FreeAndNil(PZaehler);
  end;

end;


end.
