unit DB.Zaehler;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  JObjekt.Zaehler, db.TBTransaction;

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
    function Patch(aJObjZaehler: TJObjZaehler): Boolean;
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

function TDBZaehler.Patch(aJObjZaehler: TJObjZaehler): Boolean;
begin //
  Init;
  fID     := aJObjZaehler.JsonObject.GetValue('ZA_ID').Value.ToInteger;
  Zaehler := aJObjZaehler.JsonObject.GetValue('ZA_ZAEHLER').Value;
  //SaveToDB;
end;


end.
