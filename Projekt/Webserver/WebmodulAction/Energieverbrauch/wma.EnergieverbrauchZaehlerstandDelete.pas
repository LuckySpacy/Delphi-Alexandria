unit wma.EnergieverbrauchZaehlerstandDelete;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError, DB.EnergieverbrauchZaehlerstand;

type
  TwmaEnergieverbrauchZaehlerstandDelete = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandDelete }

uses
  Datenmodul.Database, Payload.EnergieverbrauchZaehlerstandUpdate;

constructor TwmaEnergieverbrauchZaehlerstandDelete.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchZaehlerstandDelete.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchZaehlerstandDelete.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  DBZaehlerstand: TDBEnergieverbrauchZaehlerstand;
  PZaehlerstand: TPEnergieverbrauchZaehlerstandUpdate;
begin
  inherited;
  DBZaehlerstand := TDBEnergieverbrauchZaehlerstand.Create(nil);
  PZaehlerstand  := TPEnergieverbrauchZaehlerstandUpdate.Create;
  try
    PZaehlerstand.JsonString := aRequest.Content;
    if PZaehlerstand.FieldByName('ZS_ID').AsString = '' then
      JErrorList.setError('Wert für ZS_ID fehlt', c.JsonError.cJIdPayloadNichtKorrekt);
    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehlerstand.Trans := fTrans;
    if PZaehlerstand.FieldByName('ZS_ID').AsInteger > 0 then
      DBZaehlerstand.Read(PZaehlerstand.FieldByName('ZS_ID').AsInteger);

    if PZaehlerstand.FieldByName('ZS_ID').AsInteger <> DBZaehlerstand.Id then
    begin
      JErrorList.setError('ZS_ID ' + PZaehlerstand.FieldByName('ZS_ID').AsString + ' nicht in der Datenbank gefunden', c.JsonError.cJIdNichtInTabelleGefunden);
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehlerstand.Delete;

    aResponse.Content := '{"Ok":"true"}';

  finally
    FreeAndNil(DBZaehlerstand);
    FreeAndNil(PZaehlerstand);
  end;

end;


end.
