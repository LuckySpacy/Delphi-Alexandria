unit Objekt.DBSync;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs, FMX.StdCtrls, DB.Gebaude,
  db.Device, db.ToDo, db.Zaehler, db.toDoList;

type
  TDBSync = class
  private
    fDBGebaude: TDBGebaude;
    fDBDevice: TDBDevice;
    fDBToDo: TDBToDo;
    fDBZaehler: TDBZaehler;
    fDBToDoList : TDBToDoList;
  public
    constructor Create;
    destructor Destroy; override;
    function Gebaude: Boolean;
    function Device: Boolean;
    function ToDo: Boolean;
    function Zaehlerstand: Boolean;
  end;

implementation

{ TDBSync }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;

constructor TDBSync.Create;
begin
  fDBGebaude  := TDBGebaude.Create;
  fDBDevice   := TDBDevice.Create;
  fDBToDo     := TDBToDo.Create;
  fDBZaehler  := TDBZaehler.Create;
  fDBToDoList := TDBToDoList.Create;
end;

destructor TDBSync.Destroy;
begin
  FreeAndNil(fDBGebaude);
  FreeAndNil(fDBDevice);
  FreeAndNil(fDBToDo);
  FreeAndNil(fDBZaehler);
  FreeAndNil(fDBToDoList);
  inherited;
end;

function TDBSync.Gebaude: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
begin
  Result := true;
  for i1 := 0 to BasCloud.GebaudeList.Count -1 do
  begin
    DoPatch := fDBGebaude.Read(BasCloud.GebaudeList.Item[i1].Id);
    fDBGebaude.Id          := BasCloud.GebaudeList.Item[i1].Id;
    fDBGebaude.Gebaudename := BasCloud.GebaudeList.Item[i1].Gebaudename;
    fDBGebaude.Ort         := BasCloud.GebaudeList.Item[i1].Ort;
    fDBGebaude.Plz         := BasCloud.GebaudeList.Item[i1].Plz;
    fDBGebaude.Strasse     := BasCloud.GebaudeList.Item[i1].Strasse;
    fDBGebaude.Land        := BasCloud.GebaudeList.Item[i1].Land;
    if doPatch then
      Result := fDBGebaude.Patch
    else
      Result := fDBGebaude.Insert;
  end;
end;


function TDBSync.Device: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
begin
  Result := true;
  for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
  begin
    log.d(IntToStr(i1));
    fDBDevice.GbId := '';
    DoPatch := fDBDevice.Read(BasCloud.ZaehlerList.Item[i1].Id);
    fDBDevice.Id          := BasCloud.ZaehlerList.Item[i1].Id;
    fDBDevice.Einheit     := BasCloud.ZaehlerList.Item[i1].Einheit;
    fDBDevice.AksId       := BasCloud.ZaehlerList.Item[i1].AksId;
    fDBDevice.Description := BasCloud.ZaehlerList.Item[i1].Beschreibung;

    if BasCloud.ZaehlerList.Item[i1].Gebaude <> nil then
      fDBDevice.GbId := BasCloud.ZaehlerList.Item[i1].Gebaude.Id;

    if doPatch then
      Result := fDBDevice.Patch
    else
      Result := fDBDevice.Insert;
  end;
end;

function TDBSync.ToDo: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
begin
  Result := true;
  fDBToDoList.DeleteAll;
  for i1 := 0 to BasCloud.AufgabeList.Count -1 do
  begin
    if not BasCloud.AufgabeList.Item[i1].Anzeigen then
      continue;

    fDBToDo.GbId := '';
    fDBToDo.DeId := '';
    DoPatch := fDBToDo.Read(BasCloud.AufgabeList.Item[i1].Id);
    fDBToDo.Id          := BasCloud.AufgabeList.Item[i1].Id;
    fDBToDo.Datum       := BasCloud.AufgabeList.Item[i1].Datum;
    fDBToDo.Status      := BasCloud.AufgabeList.Item[i1].Status;
    fDBToDo.Kommentar   := BasCloud.AufgabeList.Item[i1].Notiz;

    if (BasCloud.AufgabeList.Item[i1].Zaehler <> nil) and (BasCloud.AufgabeList.Item[i1].Zaehler.Gebaude <> nil) then
      fDBToDo.GbId := BasCloud.AufgabeList.Item[i1].Zaehler.Gebaude.Id;

    if (BasCloud.AufgabeList.Item[i1].Zaehler <> nil)  then
      fDBToDo.deId := BasCloud.AufgabeList.Item[i1].Zaehler.Id;

    if doPatch then
      Result := fDBToDo.Patch
    else
      Result := fDBToDo.Insert;
  end;
end;



function TDBSync.Zaehlerstand: Boolean;
var
  i1: Integer;
  Ms: TMemoryStream;
begin
  Result := true;
  for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
  begin

    //if BasCloud.ZaehlerList.Item[i1].Id = 'eb2542c2-b58f-469a-be88-dde785d6e916' then
    //if BasCloud.ZaehlerList.Item[i1].Id = '8f377cf9-fc89-499f-b816-566482dc4f00' then
    if BasCloud.ZaehlerList.Item[i1].Id = '90d0838a-bbf5-4bd1-8f17-f5c93be65167' then
    begin
      log.d('Hallo ' + IntToStr(i1));
    end;

    fDBZaehler.DeleteDevice(BasCloud.ZaehlerList.Item[i1].Id);

    if BasCloud.ZaehlerList.Item[i1].Zaehlerstand = nil then
      continue;

    if BasCloud.ZaehlerList.Item[i1].Gebaude = nil then
      continue;

    if BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Id = '' then
      continue;

    ms := TMemoryStream.Create;
    try
      //BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Image.Bitmap.SaveToStream(ms);
      BasCloud.ZaehlerList.Item[i1].Zaehlerstand.SaveImageToStream(ms);
      ms.Position := 0;
      fDBZaehler.setBild(ms);
    finally
      FreeAndNil(ms);
    end;
    fDBZaehler.Id          := BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Id;
    fDBZaehler.GbId        := BasCloud.ZaehlerList.Item[i1].Gebaude.Id;
    fDBZaehler.deId        := BasCloud.ZaehlerList.Item[i1].Id;
    fDBZaehler.Stand       := FloatToStr(BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Zaehlerstand);
    fDBZaehler.Datum       := BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Datum;
    Result := fDBZaehler.Insert;
  end;
end;


end.
