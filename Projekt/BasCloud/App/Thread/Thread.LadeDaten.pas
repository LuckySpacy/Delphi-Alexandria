unit Thread.LadeDaten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Thread.UploadZaehlerstaende, Objekt.DBSync, Objekt.LadeDatenFromDB, DB.Zaehlerstandbild;

type
  TNewInfoEvent = procedure(aInfo: string) of object;
  TThreadLadedaten = class
  private
    fThreadUploadZaehlerstaende: TThreadUploadZaehlerstaende;
    fStatusLabel: TLabel;
    fOnEndeDatenLaden: TNotifyEvent;
    fDBSync: TDBSync;
    fOffline: Boolean;
    fLadeDatenFromDB: TLadeDatenFromDB;
    fEndeLadenImHintergrund: TNotifyEvent;
    fDBZaehlerstandBild: TDBZaehlerstandbild;
    procedure DatenLadenEnde(Sender: TObject);
    procedure EndeLadenImHintergrund(Sender: TObject);
    procedure LadeZaehlerstandBilder;
    procedure setOffline(const Value: Boolean);
    //procedure UploadZaehlerstaende;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setStatusLabel(aLabel: TLabel);
    function LadeGebaudedaten: Boolean;
    procedure LadeAlleZaehler;
    procedure ZaehlerGebaudeZuordnen;
    procedure LadeZaehlerstaende;
    procedure LadeAufgaben;
    procedure FiltereAufgabenFuerAnsicht;
    procedure Start;
    procedure RefreshAufgabenListe;
    procedure LadeImHintergrund;
    procedure RefreshImHintergrund;
    procedure DoUploadZaehlerstaende;
    property OnEndeDatenLaden: TNotifyEvent read fOnEndeDatenLaden write fOnEndeDatenLaden;
    property OnEndeLadenImHintergrund: TNotifyEvent read fEndeLadenImHintergrund write fEndeLadenImHintergrund;
    property Offline: Boolean read fOffline write setOffline;
  end;

implementation

{ TAfterLogin }

uses
  Json.Properties, Json.Devices, Json.EventsCollection, Json.Readings, Objekt.Zaehlerstand,
  Json.PropertyAssociatedDevices, DB.ZaehlerUpdateList, Objekt.Aufgabe, Objekt.Zaehler,
  Objekt.Basislist, Objekt.AufgabeList, Objekt.AufgabePointerList,
  Json.Device;

constructor TThreadLadedaten.Create;
begin
  fThreadUploadZaehlerstaende := TThreadUploadZaehlerstaende.Create;
  fDBSync := TDBSync.Create;
  fDBZaehlerstandBild := TDBZaehlerstandbild.Create;
end;

destructor TThreadLadedaten.Destroy;
begin
  FreeAndNil(fThreadUploadZaehlerstaende);
  FreeAndNil(fDBSync);
  FreeAndNil(fDBZaehlerstandBild);
  inherited;
end;






procedure TThreadLadedaten.setOffline(const Value: Boolean);
begin
  fOffline := Value;
end;

procedure TThreadLadedaten.setStatusLabel(aLabel: TLabel);
begin
  fStatusLabel := aLabel;
end;


procedure TThreadLadedaten.DatenLadenEnde(Sender: TObject);
begin
  if Assigned(fOnEndeDatenLaden) then
    fOnEndeDatenLaden(Self);
end;

procedure TThreadLadedaten.Start;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    BasCloud.GebaudeList.Clear;
    BasCloud.ZaehlerList.Clear;
    BasCloud.AufgabeList.Clear;
    BasCloud.InitError;

    if fOffline then
    begin
      fLadeDatenFromDB := TLadeDatenFromDB.Create;
      try
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Gebäudedaten';
        end);
        fLadeDatenFromDB.Gebaude;
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Zähler';
        end);
        fLadeDatenFromDB.Device; // Zähler
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Aufgaben';
        end);
        fLadeDatenFromDB.ToDo;
      finally
        FreeAndNil(fLadeDatenFromDB);
      end;
    end;

    if not fOffline then
    begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Gebäude';
      end);
      if not LadeGebaudedaten then
        exit;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Zähler Gebäude zuordnen';
      end);
      ZaehlerGebaudeZuordnen;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Aufgaben';
      end);
      LadeAufgaben;  // <-- Alle Aufgaben lesen und gleichzeitig den Zähler der Aufgabe zuordnen
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Filtere Aufgaben für die Ansicht';
      end);
      FiltereAufgabenFuerAnsicht;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Upload Zählerstände';
      end);
      fThreadUploadZaehlerstaende.UploadZaehlerstaende;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Zählerbilder';
      end);
      LadeZaehlerstandBilder;
    end;

  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;

(*
procedure TThreadLadedaten.Start;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    BasCloud.GebaudeList.Clear;
    BasCloud.ZaehlerList.Clear;
    BasCloud.AufgabeList.Clear;
    BasCloud.InitError;

    if fOffline then
    begin
      fLadeDatenFromDB := TLadeDatenFromDB.Create;
      try
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Gebäudedaten';
        end);
        fLadeDatenFromDB.Gebaude;
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Zähler';
        end);
        fLadeDatenFromDB.Device; // Zähler
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Lade Aufgaben';
        end);
        fLadeDatenFromDB.ToDo;
      finally
        FreeAndNil(fLadeDatenFromDB);
      end;
    end;

    if not fOffline then
    begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Gebäude';
      end);
      if not LadeGebaudedaten then
        exit;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Zähler Gebäude zuordnen';
      end);
      ZaehlerGebaudeZuordnen;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Aufgaben';
      end);
      LadeAufgaben;  // <-- Alle Aufgaben lesen und gleichzeitig den Zähler der Aufgabe zuordnen
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Filtere Aufgaben für die Ansicht';
      end);
      FiltereAufgabenFuerAnsicht;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Upload Zählerstände';
      end);
      LadeZaehlerstandBilder;
      fThreadUploadZaehlerstaende.UploadZaehlerstaende;
    end;

  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;
*)


function TThreadLadedaten.LadeGebaudedaten: Boolean;
var
  JProperties: TJProperties;
  {$IFDEF WIN32}
  List: TStringList;
  {$ENDIF WIN32}
begin
  Result := false;
  BasCloud.GebaudeList.Clear;
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Gebäudedaten';
  end);
  {$IFDEF WIN32}
  List := TStringList.Create;
  {$ENDIF WIN32}

  JProperties := JBasCloud.Read_Properties;
  if JProperties = nil then
  begin
    {$IFDEF WIN32}
      List.Add('JProperties = nil');
      if DirectoryExists('c:\temp\') then
        List.SaveToFile('c:\temp\LadeGebaudedaten.txt');
    {$ENDIF WIN32}
    exit;
  end;

  {$IFDEF WIN32}
    List.Add('Error:' + BasCloud.Error);
    if DirectoryExists('c:\temp\') then
      List.SaveToFile('c:\temp\LadeGebaudedaten.txt');
  {$ENDIF WIN32}


  BasCloud.GebaudeList.LoadFromJson(JProperties);
  FreeAndNil(JProperties);
  Result := true;
  {$IFDEF WIN32}
  FreeAndNil(List);
  {$ENDIF WIN32}
end;


procedure TThreadLadedaten.LadeAlleZaehler;
var
  JDevices: TJDevices;
  {$IFDEF WIN32}
  List: TStringList;
  i1: Integer;
  {$ENDIF WIN32}
begin
  {
  BasCloud.ZaehlerList.Clear;
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Zähler';
  end);
  }
  JDevices := JBasCloud.Read_AllDevices;
  BasCloud.ZaehlerList.LoadFromJson(JDevices);
  FreeAndNil(JDevices);

  {$IFDEF WIN32}
  List := TStringList.Create;
  if DirectoryExists('c:\temp') then
  begin
    for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
      List.Add(BasCloud.ZaehlerList.Item[i1].Id);
    List.SaveToFile('c:\temp\ZaehlerId.txt');
  end;
  FreeAndNil(List);
  {$ENDIF WIN32}


end;

procedure TThreadLadedaten.ZaehlerGebaudeZuordnen;
var
  i1, i2: Integer;
  JPropertyAssociatedDevices: TPropertyAssociatedDevices;
  Zaehler: TZaehler;
  {$IFDEF WIN32}
  List: TStringList;
  {$ENDIF WIN32}
begin
  {$IFDEF WIN32}
  List := TStringList.Create;
  {$ENDIF WIN32}
  for i1 := 0 to BasCloud.GebaudeList.Count -1 do
  begin
    JPropertyAssociatedDevices := JBasCloud.Read_PropertieAssociatedDevices(BasCloud.GebaudeList.Item[i1].id);  // <-- Alle Zähler eines Gebäude lesen
    if JPropertyAssociatedDevices = nil then
      continue;
    for i2 := 0 to Length(JPropertyAssociatedDevices.Data) -1 do
    begin
      Zaehler := BasCloud.ZaehlerList.Add(JPropertyAssociatedDevices.Data[i2].Id);
      Zaehler.AksId        := JPropertyAssociatedDevices.Data[i2].attributes.aksId;
      Zaehler.Beschreibung := JPropertyAssociatedDevices.Data[i2].attributes.description;
      Zaehler.Einheit      := JPropertyAssociatedDevices.Data[i2].attributes.&unit;
      Zaehler.Gebaude      := BasCloud.GebaudeList.Item[i1];
      //BasCloud.ZaehlerList.setGebaudeToZaehler(BasCloud.GebaudeList.Item[i1], JPropertyAssociatedDevices.Data[i2].Id); // <-- Zähler dem Gebäude zuordnen.
    end;
   {$IFDEF WIN32}
    List.Add('Error:' + BasCloud.Error);
    if DirectoryExists('c:\temp\') then
      List.SaveToFile('c:\temp\ZaehlerGebaudeZuordnen.txt');
   {$ENDIF WIN32}

  end;

  {$IFDEF WIN32}
   FreeAndNil(List);
  {$ENDIF WIN32}

end;

procedure TThreadLadedaten.LadeZaehlerstaende;
var
  i1: Integer;
  JReadings: TJReadings;
  Zaehlerstand: TZaehlerstand;
  Datum: TDateTime;
begin
  //BasCloud.AufgabeList.Clear;
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
      fStatusLabel.Text := 'Lade Zählerstände';
  end);

  for i1 := 0 to BasCloud.AufgabeList.Count -1 do
  begin

    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Zählerstände (' + inttostr(i1) + '/' + inttostr(BasCloud.AufgabeList.Count -1) + ')';
    end);

      // Sicherheitsprüfung, falls inkonsitente Daten zurückkommen
    if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
      continue;

    if (BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen) then
      continue;

    //Hier Zählerstand laden
    JReadings := JBasCloud.Read_Readings(BasCloud.AufgabeList.Item[i1].Zaehler.Id);
    BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen := true;
    if (JReadings = nil) or (Length(JReadings.data) = 0) then
      continue;

    Zaehlerstand := BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand;
    Zaehlerstand.Zaehlerstand := JReadings.Data[0].Attributes.Value;
    Datum := BasCloud.DatumObj.getDateTimeFromTimestamp(JReadings.Data[0].attributes.timestamp);
    Zaehlerstand.Datum := Datum;
    Zaehlerstand.Id := JReadings.Data[0].id;
    FreeAndNil(JReadings);
      //Zaehlerstand.ReadingImage;
  end;
end;


procedure TThreadLadedaten.DoUploadZaehlerstaende;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    fThreadUploadZaehlerstaende.UploadZaehlerstaende;
  end
  );
  //t.OnTerminate := DatenLadenEnde;
  t.Start;
end;


procedure TThreadLadedaten.EndeLadenImHintergrund(Sender: TObject);
begin
  if Assigned(fEndeLadenImHintergrund) then
    fEndeLadenImHintergrund(Self);
end;

(*
procedure TThreadLadedaten.UploadZaehlerstaende;
var
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  Zaehler: TZaehler;
  Aufgabe: TAufgabe;
  i1: Integer;
begin
  try
    DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
    try
      DBZaehlerUpdateList.ReadAll;
      if DBZaehlerUpdateList.Count > 0 then
      begin
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Upload Zählerstände';
        end);

        for i1 := 0 to DBZaehlerUpdateList.Count -1 do
        begin
          if (DBZaehlerUpdateList.Item[i1].ToDoId = '') and (DBZaehlerUpdateList.Item[i1].DeId > '') then
          begin
            Zaehler := BasCloud.ZaehlerList.getById(DBZaehlerUpdateList.Item[i1].DeId);
            if Zaehler = nil then
              continue;
            Zaehler.ZaehlerstandNeu.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
            Zaehler.ZaehlerstandNeu.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
            Zaehler.ZaehlerstandNeu.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
            BasCloud.InitError;
            if Zaehler.Upload then
              DBZaehlerUpdateList.Item[i1].DeleteByZaehler(Zaehler.Id);
          end;

          Aufgabe := BasCloud.AufgabeList.getById(DBZaehlerUpdateList.Item[i1].ToDoId);
          if Aufgabe = nil then
            continue;
          Aufgabe.Zaehler.ZaehlerstandNeu.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
          Aufgabe.Zaehler.ZaehlerstandNeu.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
          Aufgabe.Zaehler.ZaehlerstandNeu.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
          BasCloud.InitError;
          Aufgabe.Upload;
          if BasCloud.Error = '' then
          begin
            DBZaehlerUpdateList.Item[i1].DeleteByAufgabe(Aufgabe.Id);
            BasCloud.AufgabeList.DeleteAufgabe(Aufgabe.id);
          end;
        end;
      end;

    finally
      FreeAndNil(DBZaehlerUpdateList);
    end;
  except
  end;
end;
*)



procedure TThreadLadedaten.LadeAufgaben;
var
  JEventsCollection: TJEventsCollection;
  {$IFDEF WIN32}
  List: TStringList;
  {$ENDIF WIN32}
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Aufgaben';
  end
  );
  {$IFDEF WIN32}
  List := TStringList.Create;
  {$ENDIF WIN32}

  JEventsCollection := JBasCloud.Read_EventsCollection(BasCloud.UntilDateForEventsCollection);
  BasCloud.AufgabeList.LoadFromJson(JEventsCollection); // <-- Alle Aufgaben lesen und gleichzeitig den Zähler der Aufgabe zuordnen
  FreeAndNil(JEventsCollection);
  {$IFDEF WIN32}
    List.Add('Error:' + BasCloud.Error);
    if DirectoryExists('c:\temp\') then
      List.SaveToFile('c:\temp\LadeAufgaben.txt');
  {$ENDIF WIN32}

  {$IFDEF WIN32}
  FreeAndNil(List);
  {$ENDIF WIN32}
end;



procedure TThreadLadedaten.FiltereAufgabenFuerAnsicht;
var
  i1: Integer;
  AufgabeZaehlerAlle: TBasisList;
  AufgabeZaehler: TAufgabePointerList;
  ZaehlerId: string;
  Aufgabe: TAufgabe;
  //AufgabeId: string;
  //Datum: TDateTime;
{$IFDEF WIN32}
  List: TStringList;
{$ENDIF WIN32}
begin//
  AufgabeZaehlerAlle := TBasisList.Create;
  try
    ZaehlerId := '';
    BasCloud.AufgabeList.ZaehlerSortieren;
    //BasCloud.AufgabeList.SaveToFile('AufgebListAlle.txt');
    AufgabeZaehler := nil;
    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      Aufgabe := BasCloud.AufgabeList.Item[i1];
      if ZaehlerId <> Aufgabe.Zaehler.Id then
      begin
        AufgabeZaehler := TAufgabePointerList.Create;
        AufgabeZaehlerAlle.List.Add(AufgabeZaehler);
        ZaehlerId := Aufgabe.Zaehler.Id;
      end;
      AufgabeZaehler.Add(Aufgabe);
    end;

    for i1 := 0 to AufgabeZaehlerAlle.Count -1 do
    begin
      AufgabeZaehler := TAufgabePointerList(AufgabeZaehlerAlle.List.Items[i1]);
      Aufgabezaehler.setAnzeige;
    end;

    {$IFDEF WIN32}
      List:= TStringList.Create;
      List.Sorted := true;
      List.Duplicates := dupIgnore;
      for i1 := 0 to BasCloud.AufgabeList.Count -1 do
        List.Add(BasCloud.AufgabeList.Item[i1].Zaehler.Id);
      if DirectoryExists('c:\temp\') then
        List.SaveToFile('c:\temp\ZaehlerInAufgabe.txt');
      FreeAndNil(List);
    {$ENDIF WIN32}


    //BasCloud.AufgabeList.SaveToFile('AufgebeAnzeigen.txt');


    // Alles was nicht angezeigt wird, kommt aus der Liste wieder raus.
    for i1 := BasCloud.AufgabeList.Count -1 downto 0 do
    begin
      if not BasCloud.AufgabeList.Item[i1].Anzeigen then
        BasCloud.AufgabeList.Delete(i1);
    end;

  finally
    FreeAndNil(AufgabeZaehlerAlle);
  end;
end;

procedure TThreadLadedaten.RefreshAufgabenListe;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  var
    i1: Integer;
  begin
    for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
      BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Eingelesen := false;

    LadeAufgaben;
    LadeZaehlerstaende;
    FiltereAufgabenFuerAnsicht;
  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;



procedure TThreadLadedaten.LadeImHintergrund;
var
  t: TThread;
begin
  if fOffline then
    exit;
  t := TThread.CreateAnonymousThread(
  procedure
  {$IFDEF WIN32}
  var
  List: TStringList;
  {$ENDIF WIN32}
  begin
    {$IFDEF WIN32}
    List := TStringList.Create;
    List.Add('LadeAlleZaehler');
    {$ENDIF WIN32}
    LadeAlleZaehler;
    //ZaehlerGebaudeZuordnen;

    {$IFDEF WIN32}
    List.Add('LadeZaehlerstandBilder');
    if DirectoryExists('c:\temp') then
       List.SaveToFile('c:\temp\LadeImHintergrund.txt');
    {$ENDIF WIN32}
    LadeZaehlerstandBilder;

    {$IFDEF WIN32}
    List.Add('fDBSync.Gebaude');
    if DirectoryExists('c:\temp') then
       List.SaveToFile('c:\temp\LadeImHintergrund.txt');
    {$ENDIF WIN32}
    fDBSync.Gebaude;

    {$IFDEF WIN32}
    List.Add('fDBSync.Device');
    if DirectoryExists('c:\temp') then
       List.SaveToFile('c:\temp\LadeImHintergrund.txt');
    {$ENDIF WIN32}
    fDBSync.Device;

    {$IFDEF WIN32}
    List.Add('fDBSync.ToDo');
    if DirectoryExists('c:\temp') then
       List.SaveToFile('c:\temp\LadeImHintergrund.txt');
    {$ENDIF WIN32}
    fDBSync.ToDo;


    {$IFDEF WIN32}
    List.Add('fDBSync.Zaehlerstand');
    if DirectoryExists('c:\temp') then
       List.SaveToFile('c:\temp\LadeImHintergrund.txt');
    {$ENDIF WIN32}
    fDBSync.Zaehlerstand;


    {$IFDEF WIN32}
    FreeAndNil(List);
    {$ENDIF WIN32}
  end
  );
  t.OnTerminate := EndeLadenImHintergrund;
  t.Start;
end;


procedure TThreadLadedaten.RefreshImHintergrund;
var
  t: TThread;
begin
  if fOffline then
    exit;
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    LadeZaehlerstandBilder;
    fDBSync.ToDo;
    fDBSync.Zaehlerstand;
  end
  );
  t.OnTerminate := EndeLadenImHintergrund;
  t.Start;
end;

procedure TThreadLadedaten.LadeZaehlerstandBilder;
var
  Zaehlerstand: TZaehlerstand;
  i1: Integer;
  List: TStringList;
begin
  for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.ClearImage;

  List := TStringList.Create;
  for i1 := 0 to BasCloud.AufgabeList.Count -1 do
  begin
    if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
      continue;
    Zaehlerstand := BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand;
    if (Zaehlerstand.Image <> nil) then
      continue;
    List.Add(BasCloud.AufgabeList.Item[i1].Zaehler.id);
    Zaehlerstand.ReadingImage;
    fDBZaehlerstandbild.save(BasCloud.AufgabeList.Item[i1].Zaehler);
  end;
  {$IFDEF WIN32}
  if DirectoryExists('c:\temp\Test\') then
    List.SaveToFile('c:\temp\Test\ZaehlerId.txt');
  {$ENDIF WIN32}
  FreeAndNil(List);
end;




end.
