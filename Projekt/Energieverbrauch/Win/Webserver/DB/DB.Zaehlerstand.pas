unit DB.Zaehlerstand;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  Objekt.JZaehlerstand, Objekt.FeldList,
  c.JsonError,
  db.TBTransaction, Objekt.JErrorList;

type
  TDBZaehlerstand = class(TDBBasis)
  private
    fZaId: Integer;
    fWertStr: string;
    fTimestamp: string;
    fDatum: TDateTime;
    fWert: Currency;
    procedure setDatum(const Value: TDateTime);
    procedure setTimestamp(const Value: string);
    procedure setWert(const Value: Currency);
    procedure setWertStr(const Value: string);
    procedure setZaId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure FuelleDBFelderFromJson; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    procedure SaveToDB; override;
    procedure Patch(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
    procedure JRead(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
    procedure JDelete(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
    property ZaId: Integer read fZaId write setZaId;
    property Wert: Currency read fWert write setWert;
    property WertStr: string read fWertStr write setWertStr;
    property Datum: TDateTime read fDatum write setDatum;
    property Timestamp: string read fTimestamp write setTimestamp;
  end;

implementation

{ TDBZaehlerstand }


constructor TDBZaehlerstand.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('ZS_ZA_ID', ftString);
  fFeldList.Add('ZS_WERT', ftFloat);
  fFeldList.Add('ZS_DATUM', ftDateTime);
  fFeldList.Add('ZS_WERTSTR', ftString);
  fFeldList.Add('ZS_TIMESTAMP', ftString);
  Init;
end;

destructor TDBZaehlerstand.Destroy;
begin //
  inherited;
end;

procedure TDBZaehlerstand.Init;
begin
  inherited;
  FuelleDBFelder;
end;




procedure TDBZaehlerstand.FuelleDBFelder;
begin
  fFeldList.FieldByName('ZS_ZA_ID').AsInteger  := fZaId;
  fFeldList.FieldByName('ZS_WERT').AsFloat     := fWert;
  fFeldList.FieldByName('ZS_WERTSTR').AsString := fWertStr;
  fFeldList.FieldByName('ZS_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('ZS_TIMESTAMP').AsString := fTimestamp;
  inherited;
end;

procedure TDBZaehlerstand.FuelleDBFelderFromJson;
begin
  inherited;
  fId   := fFeldList.FieldByName('ZS_ID').AsInteger;
  fZaId := fFeldList.FieldByName('ZS_ZA_ID').AsInteger;
  fWert := fFeldList.FieldByName('ZS_WERT').AsFloat;
  fWertStr := fFeldList.FieldByName('ZS_WERTSTR').AsString;
  fDatum := fFeldList.FieldByName('ZS_DATUM').AsDateTime;
  fTimestamp := fFeldList.FieldByName('ZS_TIMESTAMP').AsString;

  if fTimestamp = '' then
  begin
    fWertStr := fFeldList.FieldByName('ZS_WERT').AsString;
    fTimestamp := FormatDateTime('yyyyy-mm-dd hh:nn:ss:zzz', now);
    FeldList.FieldByName('ZS_WERTSTR').AsString := fWertStr;
    FeldList.FieldByName('ZS_TIMESTAMP').AsString := fTimestamp;
  end;

end;

function TDBZaehlerstand.getGeneratorName: string;
begin
  Result := 'ZS_ID';
end;

function TDBZaehlerstand.getTableName: string;
begin
  Result := 'ZAEHLERSTAND';
end;

function TDBZaehlerstand.getTablePrefix: string;
begin
  Result := 'ZS';
end;



procedure TDBZaehlerstand.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fZaId := aQuery.FieldByName('ZS_ZA_ID').AsInteger;
  fWert := aQuery.FieldByName('ZS_WERT').AsFloat;
  fWertStr := aQuery.FieldByName('ZS_WERTSTR').AsString;
  fDatum := aQuery.FieldByName('ZS_DATUM').AsDateTime;
  fTimestamp := aQuery.FieldByName('ZS_TIMESTAMP').AsString;
  FuelleDBFelder;
end;





procedure TDBZaehlerstand.SaveToDB;
begin
  inherited;

end;






procedure TDBZaehlerstand.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('ZS_DATUM').AsDateTime := fDatum;
end;

procedure TDBZaehlerstand.setTimestamp(const Value: string);
begin
  UpdateV(fTimestamp, Value);
  fFeldList.FieldByName('ZS_TIMESTAMP').AsString := fTimestamp;
end;

procedure TDBZaehlerstand.setWert(const Value: Currency);
begin
  UpdateV(fWert, Value);
  fFeldList.FieldByName('ZS_WERT').AsFloat := fWert;
end;

procedure TDBZaehlerstand.setWertStr(const Value: string);
begin
  UpdateV(fWertStr, Value);
  fFeldList.FieldByName('ZS_WERTSTR').AsString := fWertStr;
end;

procedure TDBZaehlerstand.setZaId(const Value: Integer);
begin
  UpdateV(fZaId, Value);
  fFeldList.FieldByName('ZS_ZA_ID').AsInteger := fZaId;
end;

procedure TDBZaehlerstand.Patch(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
begin
  try
    Init;
    LoadFromJsonObjekt(aJZaehlerstand);
    if FeldList.FieldByName('ZS_ID').AsInteger > 0 then
    begin
      Read(FeldList.FieldByName('ZS_ID').AsInteger);
      if fId = 0 then
      begin
        aJErrorList.setError('ZS_ID ' + QuotedStr(aJZaehlerstand.FieldByName('ZS_ID').AsString) + ' ist ungültig.', cJIdNichtInTabelleGefunden);
        exit;
      end;
      LoadFromJsonObjekt(aJZaehlerstand);
      ForceUpdate;
      SaveToDB;
      exit;
    end;
    SaveToDB;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehlerstand.Patch -> ' +  E.Message, '99');
    end;
  end;
end;


procedure TDBZaehlerstand.JDelete(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
begin
  try
    JRead(aJZaehlerstand, aJErrorList);
    if aJErrorList.Count > 0 then
      exit;
    if (fId > 0) and (fFeldList.FieldByName('ZS_DELETE').AsBoolean) then
    begin
      aJErrorList.setError('ZS_ID ' + QuotedStr(aJZaehlerstand.FieldByName('ZS_ID').AsString) + ' bereits gelöscht.', cJdBereitsGeloescht);
      exit;
    end;
    Delete;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehlerstand.JDelete -> ' +  E.Message, '99');
    end;
  end;
end;

procedure TDBZaehlerstand.JRead(aJZaehlerstand: TJZaehlerstand; aJErrorList: TJErrorList);
begin
  try
    Init;
    LoadFromJsonObjekt(aJZaehlerstand);
    if fFeldList.FieldByName('ZS_ID').AsInteger = 0 then
    begin
      aJErrorList.setError('ZS_ID ' + QuotedStr(aJZaehlerstand.FieldByName('ZS_ID').AsString) + ' ist ungültig.',cJIdUngueltig);
      exit;
    end;
    Read(aJZaehlerstand.FieldByName('ZS_ID').AsInteger);
    if fId = 0 then
    begin
      aJErrorList.setError('ZS_ID ' + QuotedStr(aJZaehlerstand.FieldByName('ZS_ID').AsString) + ' nicht in der Tabelle gefunden.', cJIdNichtInTabelleGefunden);
      exit;
    end;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehlerstand.JRead -> ' +  E.Message, '99');
    end;
  end;
end;

end.
