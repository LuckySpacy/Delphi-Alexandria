unit DB.Zaehler;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  c.JsonError,
  JObjekt.Zaehler, db.TBTransaction, Objekt.JZaehler, Objekt.JErrorList;

type
  TDBZaehler = class(TDBBasis)
  private
    fZaehler: string;
    fBild: TMemoryStream;
    procedure setZaehler(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure FuelleDBFelderFromJson; override;
    //function getTableId: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    procedure SaveToDB; override;
    property Zaehler: string read fZaehler write setZaehler;
    procedure setBild(aStream: TMemoryStream);
    procedure LoadBildFromFile(aFullFilename: string);
    procedure Patch(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
    procedure JRead(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
    procedure JDelete(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
  end;

implementation

{ TDBZaehler }


constructor TDBZaehler.Create(AOwner: TComponent);
begin
  inherited;
  fBild := TMemoryStream.Create;
  fFeldList.Add('ZA_ZAEHLER', ftString);
  fFeldList.Add('ZA_BILD', ftBlob);
  Init;
end;

destructor TDBZaehler.Destroy;
begin
   FreeAndNil(fBild);
  inherited;
end;

procedure TDBZaehler.Init;
begin
  inherited;
  fZaehler := '';
  fBild.Clear;
  FuelleDBFelder;
end;




procedure TDBZaehler.FuelleDBFelder;
begin
  fFeldList.FieldByName('ZA_ZAEHLER').AsString  := fZaehler;
  inherited;
end;

procedure TDBZaehler.FuelleDBFelderFromJson;
begin
  inherited;

end;

function TDBZaehler.getGeneratorName: string;
begin
  Result := 'ZA_ID';
end;

function TDBZaehler.getTableName: string;
begin
  Result := 'ZAEHLER';
end;

function TDBZaehler.getTablePrefix: string;
begin
  Result := 'ZA';
end;


procedure TDBZaehler.LoadBildFromFile(aFullFilename: string);
begin
  fBild.Clear;
  fBild.LoadFromFile(aFullFilename);
  fBild.Position := 0;
  fFeldList.FieldByName('ZA_BILD').SaveToStream(fBild);
  fBild.Position := 0;
end;

procedure TDBZaehler.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fZaehler  := aQuery.FieldByName('ZA_ZAEHLER').AsString;
  aQuery.LoadFromStream(fBild, TBlobField(aQuery.FieldByName('ZA_BILD')));
  FuelleDBFelder;
end;



procedure TDBZaehler.SaveToDB;
begin
  inherited;

end;

procedure TDBZaehler.setBild(aStream: TMemoryStream);
begin
  fBild.Clear;
  fBild.Position := 0;
  aStream.Position := 0;
  fBild.LoadFromStream(aStream);
  fFeldList.FieldByName('ZA_BILD').SaveToStream(fBild);
  fBild.Position := 0;
  aStream.Position := 0;
end;


procedure TDBZaehler.setZaehler(const Value: string);
begin
  UpdateV(fZaehler, Value);
  fFeldList.FieldByName('ZA_ZAEHLER').AsString := fZaehler;
end;


procedure TDBZaehler.Patch(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
begin
  try
    Init;
    LoadFromJsonObjekt(aJZaehler);
    if FeldList.FieldByName('ZA_ID').AsInteger > 0 then
    begin
      Read(FeldList.FieldByName('ZA_ID').AsInteger);
      if fId = 0 then
      begin
        aJErrorList.setError('ZA_ID ' + QuotedStr(aJZaehler.FieldByName('ZA_ID').AsString) + ' ist ungültig.', cJIdNichtInTabelleGefunden);
        exit;
      end;
      LoadFromJsonObjekt(aJZaehler);
      ForceUpdate;
      SaveToDB;
      exit;
    end;
    SaveToDB;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehler.Patch -> ' +  E.Message, '99');
    end;
  end;
end;


procedure TDBZaehler.JDelete(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
begin
  try
    JRead(aJZaehler, aJErrorList);
    if aJErrorList.Count > 0 then
      exit;
    if (fId > 0) and (fFeldList.FieldByName('ZA_DELETE').AsBoolean) then
    begin
      aJErrorList.setError('ZA_ID ' + QuotedStr(aJZaehler.FieldByName('ZA_ID').AsString) + ' bereits gelöscht.', cJdBereitsGeloescht);
      exit;
    end;
    Delete;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehler.JDelete -> ' +  E.Message, '99');
    end;
  end;
end;

procedure TDBZaehler.JRead(aJZaehler: TJZaehler; aJErrorList: TJErrorList);
begin
  try
    Init;
    LoadFromJsonObjekt(aJZaehler);
    if fFeldList.FieldByName('ZA_ID').AsInteger = 0 then
    begin
      aJErrorList.setError('ZA_ID ' + QuotedStr(aJZaehler.FieldByName('ZA_ID').AsString) + ' ist ungültig.',cJIdUngueltig);
      exit;
    end;
    Read(aJZaehler.FieldByName('ZA_ID').AsInteger);
    if fId = 0 then
    begin
      aJErrorList.setError('ZA_ID ' + QuotedStr(aJZaehler.FieldByName('ZA_ID').AsString) + ' nicht in der Tabelle gefunden.', cJIdNichtInTabelleGefunden);
      exit;
    end;
  except
    on E: Exception do
    begin
      aJErrorList.setError('TDBZaehler.JRead -> ' +  E.Message, '99');
    end;
  end;
end;






end.
