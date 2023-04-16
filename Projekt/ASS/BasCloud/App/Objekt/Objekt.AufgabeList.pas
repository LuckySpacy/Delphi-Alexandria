unit Objekt.AufgabeList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Aufgabe, Json.EventsCollection,
  Json.Device, Objekt.ZaehlerList;

type
  TAufgabeList = class(TBasisList)
  private
    function getItem(Index: Integer): TAufgabe;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TAufgabe read getItem;
    function Add_AdHoc(aZuId: Integer): TAufgabe;
    function Add(aId: string): TAufgabe;
    function getById(aId: string): TAufgabe;
    function getByZuId(aZuId: Integer): TAufgabe;
    procedure LoadFromJson(aEventsCollection: TJEventsCollection);
    procedure LoadFromJson2(aEventsCollection: TJEventsCollection; aZaehlerList: TZaehlerList);
    procedure DatumSort;
    procedure ListViewSortStr;
    procedure ZaehlerSortieren;
    function IsWaitingForUpload: Boolean;
    procedure DeleteAufgabe(aId: string);
    procedure EntferneAlleErledigteAufgaben;
    function AnzahlErledigteAufgaben: Integer;
   {$IFDEF WIN32}
    procedure SaveToFile(aFilename: string);
   {$ENDIF WIN32}
    procedure SetzeAlleUnterDatumAufErledigt(aDatum: TDateTime; aZaehlerId: string);
    function LastAufgabeFromNow(aZaehlerId: string): TAufgabe;
    function AnzahlOffeneAufgaben: Integer;
    function AnzahlUeberfaelligeAufgaben: Integer;
  end;

implementation

{ TAufgabeList }

uses
  Objekt.BasCloud, Objekt.Zaehler, System.DateUtils, Objekt.JBasCloud, DB.ToDo,
  fmx.Types;


function DateSort(Item1, Item2: Pointer): Integer;
begin
  //Result := -CompareDate(TAufgabe(Item1).Datum, TAufgabe(Item2).Datum);
  Result := CompareDate(TAufgabe(Item1).Datum, TAufgabe(Item2).Datum);
end;

function ZaehlerSort(Item1, Item2: Pointer): Integer;
begin
  //Result := -CompareDate(TAufgabe(Item1).Datum, TAufgabe(Item2).Datum);
  Result := CompareStr(TAufgabe(Item1).ZaehlerId,  TAufgabe(Item2).ZaehlerId);
end;

function ListViewSort(Item1, Item2: Pointer): Integer;
begin
  //Result := -CompareDate(TAufgabe(Item1).Datum, TAufgabe(Item2).Datum);
  Result := CompareStr(TAufgabe(Item1).ListViewSortStr,  TAufgabe(Item2).ListViewSortStr);
end;



constructor TAufgabeList.Create;
begin
  inherited;

end;



destructor TAufgabeList.Destroy;
begin

  inherited;
end;


function TAufgabeList.Add(aId: string): TAufgabe;
begin
  Result := getById(aId);
  if Result <> nil then
    exit;
  Result := TAufgabe.Create;
  Result.Id := aId;
  fList.Add(Result);
end;

function TAufgabeList.Add_AdHoc(aZuId: Integer): TAufgabe;
begin
  Result := getByZuId(aZuId);
  if Result <> nil then
    exit;
  Result := TAufgabe.Create;
  Result.Id := IntToStr(aZuId);
  Result.ZuId := aZuId;
  fList.Add(Result);
end;


function TAufgabeList.getById(aId: string): TAufgabe;
var
  i1: Integer;
begin
  Result := nil;
  if aId = '' then
    exit;
  for i1 := 0 to fList.Count -1 do
  if SameText(aId, TAufgabe(fList.Items[i1]).Id) then
  begin
    Result := TAufgabe(fList.Items[i1]);
    exit;
  end;
end;

function TAufgabeList.getByZuId(aZuId: Integer): TAufgabe;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  if TAufgabe(fList.Items[i1]).ZuId = aZuId then
  begin
    Result := TAufgabe(fList.Items[i1]);
    exit;
  end;
end;



function TAufgabeList.getItem(Index: Integer): TAufgabe;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAufgabe(fList.Items[Index]);
end;

function TAufgabeList.IsWaitingForUpload: Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fList.Count -1 do
  begin
    if TAufgabe(fList.Items[i1]).WaitForUpload then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function TAufgabeList.LastAufgabeFromNow(aZaehlerId: string): TAufgabe;
var
  i1: Integer;
  List: TStringList;
  d: TdateTime;
begin
  Result := nil;
  List := TStringList.Create;
  List.Add('Gesuchter Zähler: ' + aZaehlerId);
  for i1 := 0 to fList.Count -1 do
  begin
    if getItem(i1).ZaehlerId <> aZaehlerId then
      continue;

    d := getItem(i1).Datum;
    if d = 0 then
      continue;

    if trunc(getItem(i1).Datum) > trunc(now) + BasCloud.AufgabeKarrenztage  then
      continue;

    if (Result = nil) and (trunc(getItem(i1).Datum) <= trunc(now) + BasCloud.AufgabeKarrenztage)  then
    begin
      Result := getItem(i1);
      List.Add('Zaehlerdatum (nil): ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', Result.Datum) + ' ' + Result.ZaehlerId + ' ' + Result.Zaehler.Id);
      continue;
    end;

    if (Result <> nil) and (trunc(getItem(i1).Datum) > trunc(Result.Datum)) then
    begin
      Result := getItem(i1);
      List.Add('Zaehlerdatum: ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', Result.Datum) + ' ' + Result.ZaehlerId + ' ' + Result.Zaehler.Id);
    end;

  end;


  {$IFDEF WIN32}
  List.SaveToFile('c:\temp\gefundenerZaehler.txt');
  {$ENDIF WIN32}

  FreeAndNil(List);
end;



// Alle Aufgaben lesen und gleichzeitig den Zähler der Aufgabe zuordnen
procedure TAufgabeList.LoadFromJson(aEventsCollection: TJEventsCollection);
var
  i1: Integer;
  Aufgabe: TAufgabe;
  Zaehler: TZaehler;
  JDevice: TJDevice;
begin

  Clear;
  for i1 := 0 to Length(aEventsCollection.data) -1 do
  begin
    Zaehler := BasCloud.ZaehlerList.getById(aEventsCollection.data[i1].attributes.deviceId);
    if Zaehler = nil then
    begin
      JDevice := JBasCloud.Read_Device(aEventsCollection.data[i1].attributes.deviceId);
      if (JDevice = nil) then
        continue;
      if (BasCloud.Error > '') then
      begin
        FreeAndNil(JDevice);
        continue;
      end;
      Zaehler := BasCloud.ZaehlerList.Add(JDevice.Data.Id);
      Zaehler.AksId        := JDevice.data.attributes.aksId;
      Zaehler.Beschreibung := JDevice.data.attributes.description;
      Zaehler.Einheit      := JDevice.data.attributes.&unit;
      FreeAndNil(JDevice);
    end;
    if not Zaehler.Zaehlerstand.Eingelesen then
      Zaehler.ReadZaehlerstand;
    Aufgabe := Add(aEventsCollection.data[i1].id);
    Aufgabe.Datum  := BasCloud.DatumObj.getDateTimeFromTimestamp(aEventsCollection.data[i1].attributes.dueDate);
    Aufgabe.ZaehlerId := aEventsCollection.data[i1].attributes.deviceId;
    Aufgabe.Notiz     := aEventsCollection.data[i1].attributes.note;
    Aufgabe.Status    := aEventsCollection.data[i1].attributes.state;
    Aufgabe.TaskId    := aEventsCollection.data[i1].attributes.taskId;
    Aufgabe.Zaehler   := Zaehler;
  end;

end;

procedure TAufgabeList.LoadFromJson2(aEventsCollection: TJEventsCollection; aZaehlerList: TZaehlerList);
var
  i1: Integer;
  Aufgabe: TAufgabe;
  Zaehler: TZaehler;
  JDevice: TJDevice;
begin
  try
    log.d('TAufgabeList.LoadFromJson2(aEventsCollection -> Start');
    log.d('Anzahl: ' + IntToStr(Length(aEventsCollection.data)));
    Clear;
    for i1 := 0 to Length(aEventsCollection.data) -1 do
    begin
      Zaehler := aZaehlerList.getById(aEventsCollection.data[i1].attributes.deviceId);
      if Zaehler = nil then
      begin
        log.d('Read_Device: ' + aEventsCollection.data[i1].attributes.deviceId);
        JDevice := JBasCloud.Read_Device(aEventsCollection.data[i1].attributes.deviceId);
        if (JDevice = nil) then
          continue;
        if (BasCloud.Error > '') then
        begin
          FreeAndNil(JDevice);
          continue;
        end;
        Zaehler := aZaehlerList.Add(JDevice.Data.Id);
        Zaehler.AksId        := JDevice.data.attributes.aksId;
        Zaehler.Beschreibung := JDevice.data.attributes.description;
        Zaehler.Einheit      := JDevice.data.attributes.&unit;
        FreeAndNil(JDevice);
      end;
      if not Zaehler.Zaehlerstand.Eingelesen then
      begin
        log.d('Zaehler.ReadZaehlerstand');
        Zaehler.ReadZaehlerstand;
      end;
      Aufgabe := Add(aEventsCollection.data[i1].id);
      Aufgabe.Datum  := BasCloud.DatumObj.getDateTimeFromTimestamp(aEventsCollection.data[i1].attributes.dueDate);
      Aufgabe.ZaehlerId := aEventsCollection.data[i1].attributes.deviceId;
      Aufgabe.Notiz     := aEventsCollection.data[i1].attributes.note;
      Aufgabe.Status    := aEventsCollection.data[i1].attributes.state;
      Aufgabe.TaskId    := aEventsCollection.data[i1].attributes.taskId;
      Aufgabe.Zaehler   := Zaehler;
    end;
  except
    on e: exception do
    begin
      log.d('TAufgabeList.LoadFromJson2: ' + E.Message);
    end;
  end;
  log.d('TAufgabeList.LoadFromJson2(aEventsCollection -> Ende');

end;


procedure TAufgabeList.ListViewSortStr;
begin
  fList.Sort(@ListViewSort);
end;


procedure TAufgabeList.DatumSort;
begin
  fList.Sort(@DateSort);
end;

procedure TAufgabeList.ZaehlerSortieren;
begin
  fList.Sort(@ZaehlerSort);
end;



procedure TAufgabeList.DeleteAufgabe(aId: string);
var
  //Id: Integer;
  i1: Integer;
  DBToDo: TDBToDo;
begin
  DBToDo := TDBToDo.Create;
  try
    for i1 := 0 to fList.Count -1 do
    begin
      if aId = TAufgabe(fList.Items[i1]).Id then
      begin
        DBToDo.Delete(TAufgabe(fList.Items[i1]).Id);
        fList.Del(i1);
        exit;
      end;
    end;
  finally
    FreeAndNil(DBToDo);
  end;
end;

procedure TAufgabeList.EntferneAlleErledigteAufgaben;
var
  i1: Integer;
  Aufgabe: TAufgabe;
  DBToDo: TDBToDo;
begin
  DBToDo := TDBToDo.Create;
  try
    for i1 := fList.Count -1 downto 0 do
    begin
      Aufgabe := TAufgabe(fList.Items[i1]);
      if Aufgabe.Erledigt then
      begin
        DBToDo.Delete(Aufgabe.Id);
        fList.Del(i1);
      end;
    end;
  finally
    FreeAndNil(DBToDo);
  end;
end;

function TAufgabeList.AnzahlErledigteAufgaben: Integer;
var
  i1: Integer;
  Aufgabe: TAufgabe;
begin
  Result := 0;
  for i1 := fList.Count -1 downto 0 do
  begin
    Aufgabe := TAufgabe(fList.Items[i1]);
    if Aufgabe.Erledigt then
      Inc(Result);
  end;
end;



{$IFDEF WIN32}
procedure TAufgabeList.SaveToFile(aFilename: string);
var
  FullFilename: string;
  Ausgabe: TStringList;
  i1: Integer;
  s: string;
  Aufgabe: TAufgabe;
  Anzeige: string;
begin
  FullFilename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Textausgabe\';
  if not DirectoryExists(FullFilename) then
    ForceDirectories(FullFilename);
  FullFilename := FullFilename + aFilename;
  Ausgabe := TStringList.Create;
  try
    for i1 := 0 to Count -1 do
    begin
      Aufgabe := Item[i1];
      if Aufgabe.Anzeigen then
        Anzeige := 'T'
      else
        Anzeige := 'F';
      s := Aufgabe.Id +';' + FormatDateTime('dd.mm.yyyy', Aufgabe.Datum) + ';' + Aufgabe.ZaehlerId + ';' + Anzeige;
      if Aufgabe.Anzeigen then
        Ausgabe.Add(s);
    end;
    Ausgabe.SaveToFile(FullFilename);
  finally
    FreeAndNil(Ausgabe);
  end;
end;
{$ENDIF WIN32}




procedure TAufgabeList.SetzeAlleUnterDatumAufErledigt(aDatum: TDateTime;
  aZaehlerId: string);
var
  i1: Integer;
  Aufgabe: TAufgabe;
{$IFDEF WIN32}
  List: TStringList;
{$ENDIF WIN32}
begin
 // exit;
{$IFDEF WIN32}
  List := TStringList.Create;
{$ENDIF WIN32}
  for i1 := 0 to fList.Count -1 do
  begin
    Aufgabe := Item[i1];
    if Aufgabe.Zaehler.Id <> aZaehlerId then
      continue;
    if Aufgabe.Erledigt then
      continue;
    if trunc(Aufgabe.Datum) > trunc(aDatum) + BasCloud.AufgabeKarrenztage then
      continue;
    if Aufgabe.AdHoc then
    begin
      Aufgabe.Erledigt := true;
      continue;
    end;
    BasCloud.InitError;
    JBasCloud.setEventAsDone(Aufgabe.Id);
    Aufgabe.Erledigt := BasCloud.Error = '';  // In Form.Aufgabe (FormIsActivate) werden alle erledigten Aufgaben aus der Liste entfernt
    if (Pos('was not found', BasCloud.Error) > 0) and (Pos('404', BasCloud.Error) > 0) then
      Aufgabe.Erledigt := true;
    {$IFDEF WIN32}
    List.Add(Aufgabe.id + ' ' + FormatDateTime('dd.mm.yyyy', Aufgabe.Datum));
    {$ENDIF WIN32}
  end;

{$IFDEF WIN32}
  if DirectoryExists('c:\temp') then
    List.SaveToFile('c:\temp\AufgabenAufErledigtGesetzt.txt');
  FreeAndNil(List);
{$ENDIF WIN32}

end;

function TAufgabeList.AnzahlOffeneAufgaben: Integer;
var
  i1: Integer;
  Aufgabe: TAufgabe;
begin
  //Result := fList.Count;
  Result := 0;
  for i1 := 0 to fList.Count -1 do
  begin
    Aufgabe := Item[i1];
    if not Aufgabe.Anzeigen then
      continue;
    Inc(Result);
  end;

end;

function TAufgabeList.AnzahlUeberfaelligeAufgaben: Integer;
var
  i1: Integer;
  Aufgabe: TAufgabe;
begin
  Result := 0;
  for i1 := 0 to fList.Count -1 do
  begin
    Aufgabe := Item[i1];
    if not Aufgabe.Anzeigen then
      continue;
    if trunc(Aufgabe.Datum) <= trunc(now) then
      Inc(Result);
  end;
end;

end.
