unit Objekt.Zaehler;

interface

uses
  System.SysUtils, Objekt.Zaehlerstand, Objekt.Gebaude, System.Classes;

type
  TZaehler = class
  private
    fEinheit: string;
    fId: string;
    fBeschreibung: string;
    fAksId: string;
    fZaehlerstand: TZaehlerstand;
    fGebaude: TGebaude;
    fZaehlerstandGeprueftAm: TDateTime;
    //fZaehlerstandNeu: TZaehlerstand;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Id: string read fId write fId;
    property AksId: string read fAksId write fAksId;
    property Beschreibung: string read fBeschreibung write fBeschreibung;
    property Einheit: string read fEinheit write fEinheit;
    property Zaehlerstand: TZaehlerstand read fZaehlerstand;
    //property ZaehlerstandNeu: TZaehlerstand read fZaehlerstandNeu;
    Property Gebaude: TGebaude read fGebaude write fGebaude;
    procedure Init;
   // procedure CopyZaehlerstandNeuToZaehlerstand;
    procedure InsertInZaehlerUpdate(aAufgabeId: String);
    function Upload: Boolean;
    procedure ReadZaehlerstand;
    function getLastZuId: Integer;
    procedure Copy(aZaehler: TZaehler);
    property ZaehlerstandGeprueftAm: TDateTime read fZaehlerstandGeprueftAm write fZaehlerstandGeprueftAm;
  end;

implementation

{ TZaehler }

uses
  DB.ZaehlerUpdate, Objekt.BasCloud, Objekt.JBasCloud, Json.Readings, Json.Reading;


constructor TZaehler.Create;
begin
  fZaehlerstand    := TZaehlerstand.Create;
  //fZaehlerstandNeu := TZaehlerstand.Create;
  Init;
end;

destructor TZaehler.Destroy;
begin
  FreeAndNil(fZaehlerstand);
  //FreeAndNil(fZaehlerstandNeu);
  inherited;
end;

procedure TZaehler.Init;
begin
  fEinheit      := '';
  fId           := '';
  fBeschreibung := '';
  fAksId        := '';
  fGebaude      := nil;
end;

procedure TZaehler.Copy(aZaehler: TZaehler);
begin
  aZaehler.Einheit := fEinheit;
  aZaehler.Id      := fId;
  aZaehler.Beschreibung := fBeschreibung;
  aZaehler.AksId := fAksId;
end;



{
procedure TZaehler.CopyZaehlerstandNeuToZaehlerstand;
var
  ms: TMemoryStream;
begin
  fZaehlerstand.Id           := fZaehlerstandNeu.Id;
  fZaehlerstand.Zaehlerstand := fZaehlerstandNeu.Zaehlerstand;
  fZaehlerstand.Datum        := fZaehlerstandNeu.Datum;
  ms := TMemoryStream.Create;
  try
    fZaehlerstandNeu.Image.Bitmap.SaveToStream(ms);
    ms.Position := 0;
    if fZaehlerstand.Image = nil then
      fZaehlerstand.CreateImage;
    fZaehlerstand.Image.Bitmap.LoadFromStream(ms);
  finally
    FreeAndNil(ms);
  end;
  fZaehlerstandNeu.Init;
end;
}



procedure TZaehler.InsertInZaehlerUpdate(aAufgabeId: string);
var
  DBZaehlerUpdate: TDBZaehlerUpdate;
  ms: TMemoryStream;
begin
  try
    ms := TMemoryStream.Create;
    DBZaehlerUpdate := TDBZaehlerUpdate.Create;
    try
      if aAufgabeId > '' then
        DBZaehlerUpdate.DeleteByAufgabe(aAufgabeId);
      DBZaehlerUpdate.Stand := CurrToStr(fZaehlerstand.Zaehlerstand);
      DBZaehlerUpdate.Datum := fZaehlerstand.Datum;
      DBZaehlerUpdate.DeId  := fid;
      DBZaehlerUpdate.GbId  := fGebaude.Id;
      DBZaehlerUpdate.ToDoId := aAufgabeId;
      fZaehlerstand.Image.Bitmap.SaveToStream(ms);
      DBZaehlerUpdate.setBild(ms);
      DBZaehlerUpdate.ImportDatum := 0;
      DBZaehlerUpdate.Insert;
    finally
      FreeAndNil(DBZaehlerUpdate);
      FreeAndNil(ms);
    end;
  except
    on E: Exception do
    begin
      BasCloud.Error := E.Message;
    end;
  end;
end;

function TZaehler.getLastZuId: Integer;
var
  DBZaehlerUpdate: TDBZaehlerUpdate;
begin
  DBZaehlerUpdate := TDBZaehlerUpdate.Create;
  try
    DBZaehlerUpdate.ReadLastId;
    Result := DBZaehlerUpdate.Id;
  finally
    FreeAndNil(DBZaehlerUpdate);
  end;
end;


procedure TZaehler.ReadZaehlerstand;
var
  JReadings: TJReadings;
  Datum: TDateTime;
begin
  if fZaehlerstand.Eingelesen then
    exit;
  JReadings := JBasCloud.Read_Readings(fId);
  if JReadings = nil then
    exit;
  try
    if BasCloud.Error > '' then
      exit;
    fZaehlerstand.Eingelesen := true;
    //if fId = 'ee5b2b9f-a051-4113-937c-ff71713fa6bc'  then
    //  fZaehlerstand.Zaehlerstand := 0;
    if Length(JReadings.Data) > 0 then
    begin
      fZaehlerstand.Zaehlerstand := JReadings.Data[0].Attributes.Value;
      Datum := BasCloud.DatumObj.getDateTimeFromTimestamp(JReadings.Data[0].attributes.timestamp);
      fZaehlerstand.Datum := Datum;
      fZaehlerstand.Id := JReadings.Data[0].id;
      fZaehlerstand.EingelesenErfolgreich := true;
    end;
  finally
    if JReadings <> nil then
      FreeAndNil(JReadings);
  end;
end;

function TZaehler.Upload: Boolean;
var
  Reading: TJReading;
  NeuId: string;
begin
  Result := false;
  try
    if Bascloud.Error > '' then
      exit;
    //fZaehlerstandNeu.Id := JBasCloud.Create_Reading(fid, fZaehlerstandNeu.Zaehlerstand, fZaehlerstandNeu.Datum);
    NeuId := JBasCloud.Create_Reading(fid, fZaehlerstand.Zaehlerstand, fZaehlerstand.Datum);
    if Trim(NeuId) = '' then
      BasCloud.Error := 'Zählerupload fehlgeschlagen';
    if (BasCloud.Error > '') then
      exit;
    Reading := JBasCloud.Read_Reading(NeuId);
    if Reading = nil then
    begin
      BasCloud.Error := 'Zählerupload fehlgeschlagen';
      exit;
    end;
    try
      if (BasCloud.Error > '') then
        exit;
      try
        if NeuId <> Reading.data.id then
          BasCloud.Error := 'Hochgeladenes Reading nicht gefunden';
        if (BasCloud.Error > '') then
          exit;
      except
        BasCloud.Error := 'Hochgeladenes Reading nicht gefunden';
        exit;
      end;
    finally
      if Reading <> nil then
        FreeAndNil(Reading);
    end;
    //BasCloud.BreakUpload := true;
    if BasCloud.Error > '' then
      exit;
    JBasCloud.Create_ReadingImages(NeuId, 'image/jpeg', fZaehlerstand.Image.Bitmap);
    if BasCloud.Error > '' then
      exit;
    fZaehlerstand.Id := NeuId;
    //CopyZaehlerstandNeuToZaehlerstand;
    Result := BasCloud.Error = '';
  except
    on E: Exception do
    begin
      BasCloud.Error := 'Fehler: ' + E.Message;
    end;
  end;
end;


end.
