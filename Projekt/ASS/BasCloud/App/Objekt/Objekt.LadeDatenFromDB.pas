unit Objekt.LadeDatenFromDB;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs, FMX.StdCtrls, DB.Gebaude,
  db.Device, db.ToDo, db.Zaehler, db.GebaudeList, Objekt.Gebaude, DB.DeviceList, Objekt.Zaehler, db.todolist,
  Objekt.Aufgabe, db.ZaehlerUpdate, db.ZaehlerUpdateList;

type
  TLadeDatenFromDB = class
  private
    fDBGebaudeList: TDBGebaudeList;
    fDBDeviceList: TDBDeviceList;
    fDBToDoList: TDBToDoList;
    fDBZaehlerstand: TDBZaehler;
    fDBZaehlerUpdate: TDBZaehlerUpdate;
    fDBZaehlerUpdateList: TDBZaehlerUpdateList;
  public
    constructor Create;
    destructor Destroy; override;
    function Gebaude: Boolean;
    function Device: Boolean;
    function ToDo: Boolean;
    //function Alle: Boolean;
  end;

implementation

{ TLadeDatenFromDB }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;


constructor TLadeDatenFromDB.Create;
begin
  fDBGebaudeList   := TDBGebaudeList.Create;
  fDBDeviceList    := TDBDeviceList.Create;
  fDBToDoList      := TDBToDoList.Create;
  fDBZaehlerstand  := TDBZaehler.Create;
  fDBZaehlerUpdate := TDBZaehlerUpdate.Create;
  fDBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
end;

destructor TLadeDatenFromDB.Destroy;
begin
  FreeAndNil(fDBGebaudeList);
  FreeAndNil(fDBDeviceList);
  FreeAndNil(fDBToDoList);
  FreeAndNil(fDBZaehlerstand);
  FreeAndNil(fDBZaehlerUpdate);
  FreeAndNil(fDBZaehlerUpdateList);
  inherited;
end;

{
function TLadeDatenFromDB.Alle: Boolean;
begin
  Gebaude;
  Device;
  ToDo;
end;
}

function TLadeDatenFromDB.Device: Boolean;
var
  i1, i2: Integer;
  Zaehler: TZaehler;
  DBDevice: TDBDevice;
  Zaehlerstand: Currency;
begin
  Result := true;
  fDBDeviceList.ReadAll;
  for i1 := 0 to fDBDeviceList.Count -1 do
  begin
    DBDevice := fDBDeviceList.item[i1];
    Zaehler := BasCloud.ZaehlerList.Add(DBDevice.Id);
    Zaehler.AksId        := DBDevice.AksId;
    Zaehler.Beschreibung := DBDevice.Description;
    Zaehler.Einheit      := DBDevice.Einheit;

    if DBDevice.Id = '90d0838a-bbf5-4bd1-8f17-f5c93be65167' then
    begin
      log.d('Hallo ' + IntToStr(i1));
    end;

    for i2 := 0 to BasCloud.GebaudeList.Count -1 do
    begin
      if DBDevice.GbId = BasCloud.GebaudeList.Item[i2].Id then
      begin
        Zaehler.Gebaude := BasCloud.GebaudeList.Item[i2];
        break;
      end;
    end;


    fDBZaehlerUpdate.ReadFromDevice(Zaehler.Id);
    if fDBZaehlerUpdate.Id > 0 then
    begin
      Zaehler.Zaehlerstand.Id := '';
      Zaehler.Zaehlerstand.Eingelesen := true;

      if TryStrToCurr(fDBZaehlerUpdate.Stand, Zaehlerstand) then
      begin
        Zaehler.Zaehlerstand.Zaehlerstand := Zaehlerstand;
        Zaehler.Zaehlerstand.EingelesenErfolgreich := true;
      end
      else
        Zaehler.Zaehlerstand.Zaehlerstand := 0;

      Zaehler.Zaehlerstand.ClearImage;
      Zaehler.Zaehlerstand.CreateImage;
      fDBZaehlerUpdate.LoadBildIntoBitmap(Zaehler.Zaehlerstand.Image.Bitmap);
      Zaehler.Zaehlerstand.Datum := fDBZaehlerUpdate.Datum;
      continue;
    end;


    fDBZaehlerstand.ReadDevice(Zaehler.id);
    if fDBZaehlerstand.Id = '' then
    begin
      continue;
    end;

    Zaehler.Zaehlerstand.Id := fDBZaehlerstand.Id;

    if TryStrToCurr(fDBZaehlerstand.Stand, Zaehlerstand) then
    begin
      Zaehler.Zaehlerstand.Zaehlerstand := Zaehlerstand;
      Zaehler.Zaehlerstand.Eingelesen := true;
      Zaehler.Zaehlerstand.EingelesenErfolgreich := true;
    end
    else
      Zaehler.Zaehlerstand.Zaehlerstand := 0;

    Zaehler.Zaehlerstand.Eingelesen := true;

    Zaehler.Zaehlerstand.ClearImage;
    //Zaehler.Zaehlerstand.CreateImage;
    //fDBZaehlerstand.LoadBildIntoBitmap(Zaehler.Zaehlerstand.Image.Bitmap);
    Zaehler.Zaehlerstand.Datum := fDBZaehlerstand.Datum;
  end;
end;

function TLadeDatenFromDB.Gebaude: Boolean;
var
  i1: Integer;
  Gebaude: TGebaude;
  DBGebaude: TDBGebaude;
begin
  Result := true;
  fDBGebaudeList.ReadAll;
  for i1 := 0 to fDBGebaudeList.Count -1 do
  begin
    DBGebaude := fDBGebaudeList.item[i1];
    Gebaude := BasCloud.GebaudeList.Add(DBGebaude.Id);
    Gebaude.Gebaudename := DBGebaude.Gebaudename;
    Gebaude.Strasse     := DBGebaude.Strasse;
    Gebaude.Plz         := DBGebaude.Plz;
    Gebaude.Ort         := DBGebaude.Ort;
    Gebaude.Land        := DBGebaude.Land;
  end;
end;

function TLadeDatenFromDB.ToDo: Boolean;
var
  i1, i2: Integer;
  DBToDo: TDBToDo;
  Aufgabe: TAufgabe;
begin
  Result := true;
  fDBToDoList.ReadAll;
  for i1 := 0 to fDBToDoList.Count -1 do
  begin
    DBToDo := fDBToDoList.Item[i1];
    Aufgabe := BasCloud.AufgabeList.Add(DBToDo.Id);
    Aufgabe.ZaehlerId := DBToDo.DeId;
    Aufgabe.Datum     := DBToDo.Datum;
    Aufgabe.Notiz     := DBToDo.Kommentar;
    Aufgabe.Status    := DBToDo.Status;
    Aufgabe.Anzeigen := true;
    for i2 := 0 to BasCloud.ZaehlerList.Count -1 do
    begin
      if BasCloud.ZaehlerList.Item[i2].Id = Aufgabe.ZaehlerId then
      begin
        Aufgabe.Zaehler := BasCloud.ZaehlerList.Item[i2];
        if Aufgabe.Zaehler.Gebaude = nil then
          log.d('Gebäude fehlt');
        break;
      end;
    end;
  end;
  fDBZaehlerUpdateList.ReadAll;
  for i1 := 0 to fDBZaehlerUpdateList.Count -1 do
  begin
    if Trim(fDBZaehlerUpdateList.Item[i1].ToDoId) > '' then
    begin
      Aufgabe := BasCloud.AufgabeList.getById(fDBZaehlerUpdateList.Item[i1].ToDoId);
      if Aufgabe <> nil then
        Aufgabe.WaitForUpload := true;
      continue;
    end;
    Aufgabe := BasCloud.AufgabeList.Add_AdHoc(fDBZaehlerUpdateList.Item[i1].Id);
    Aufgabe.ZaehlerId := fDBZaehlerUpdateList.Item[i1].DeId;
    Aufgabe.Datum  := trunc(now);
    Aufgabe.Notiz  := 'Ad hoc';
    Aufgabe.Status := 'Ad hoc';
    Aufgabe.Anzeigen := true;
    Aufgabe.AdHoc := true;
    Aufgabe.WaitForUpload := true;

    for i2 := 0 to BasCloud.ZaehlerList.Count -1 do
    begin
      if BasCloud.ZaehlerList.Item[i2].Id = Aufgabe.ZaehlerId then
      begin
        Aufgabe.Zaehler := BasCloud.ZaehlerList.Item[i2];
        Aufgabe.WaitForUpload := true;
        if Aufgabe.Zaehler.Gebaude = nil then
          log.d('Gebäude fehlt');
        break;
      end;
    end;

  end;
end;


end.
