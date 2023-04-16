unit Thread.LadeDaten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls;

type
  TNewInfoEvent = procedure(aInfo: string) of object;
  TThreadLadedaten = class
  private
    fStatusLabel: TLabel;
    fOnEndeDatenLaden: TNotifyEvent;
    procedure DatenLadenEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure setStatusLabel(aLabel: TLabel);
    procedure LadeGebaudedaten;
    procedure LadeAlleZaehler;
    procedure ZaehlerGebaudeZuordnen;
    procedure LadeZaehlerstaende;
    procedure LadeAufgaben;
    procedure FiltereAufgabenFuerAnsicht;
    procedure UploadZaehlerstaende;
    procedure Start;
    procedure RefreshAufgabenListe;
    procedure LadeZaehlerstandBilder;
    property OnEndeDatenLaden: TNotifyEvent read fOnEndeDatenLaden write fOnEndeDatenLaden;
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

end;

destructor TThreadLadedaten.Destroy;
begin
  inherited;
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
  //var
    //JProperties: TJProperties;
    //JDevices: TJDevices;
    //JEventsCollection: TJEventsCollection;
    //JPropertyAssociatedDevices: TPropertyAssociatedDevices;
    //JReadings: TJReadings;
    //Zaehlerstand: TZaehlerstand;
    //i1, i2: Integer;
    //z1: integer;
    //Datum: TDateTime;
    //DBZaehlerUpdateList: TDBZaehlerUpdateList;
    //Aufgabe: TAufgabe;
    //Zaehler: TZaehler;
  begin
    BasCloud.GebaudeList.Clear;
    BasCloud.ZaehlerList.Clear;
    BasCloud.AufgabeList.Clear;
    BasCloud.InitError;
    //exit;
    UploadZaehlerstaende;
    LadeGebaudedaten;
    LadeAufgaben;
    FiltereAufgabenFuerAnsicht;
    ZaehlerGebaudeZuordnen;
    //LadeZaehlerstaende;

    //LadeAlleZaehler;
    //ZaehlerGebaudeZuordnen;
    //LadeAufgaben;
    //LadeZaehlerstaende;
    {
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Gebäudedaten';
    end
    );
    JProperties := JBasCloud.Read_Properties;
    BasCloud.GebaudeList.LoadFromJson(JProperties);
    FreeAndNil(JProperties);
    }

    {
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Zähler';
    end
    );

    // All Devices kann weg, da unten noch mal je Property die Devices geladen werden

    JDevices := JBasCloud.Read_AllDevices;
    BasCloud.ZaehlerList.LoadFromJson(JDevices);
    FreeAndNil(JDevices);
    }
    // -------

    {
    for i1 := 0 to BasCloud.GebaudeList.Count -1 do
    begin
      JPropertyAssociatedDevices := JBasCloud.Read_PropertieAssociatedDevices(BasCloud.GebaudeList.Item[i1].id);
      if JPropertyAssociatedDevices = nil then
        continue;
      for i2 := 0 to Length(JPropertyAssociatedDevices.Data) -1 do
        BasCloud.ZaehlerList.setGebaudeToZaehler(BasCloud.GebaudeList.Item[i1], JPropertyAssociatedDevices.Data[i2].Id);
    end;
    }

    {
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Aufgaben';
    end
    );

    JEventsCollection := JBasCloud.Read_EventsCollection(BasCloud.UntilDateForEventsCollection);
    BasCloud.AufgabeList.LoadFromJson(JEventsCollection);
    FreeAndNil(JEventsCollection);
    }

    {
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Zählerstände';
    end
    );

    z1 := 0;

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

      // Prüfung, ob für dieses Device schon ein Reading gelesen wurde
      // TODO: -1 ist keine sichere Methode, da der gültige Wertebereich -1 umfasst
      // TODO: Zudem wird bei nicht erfolgreichem Lesen immer wieder das Device abgefragt

      if (BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen) then
        continue;

      //Hier Zählerstand laden
      JReadings := JBasCloud.Read_Readings(BasCloud.AufgabeList.Item[i1].Zaehler.Id);
      inc(z1);
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
    }
    {
    // Dies würde ich nach oben verschieben ....
    DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
    try
      DBZaehlerUpdateList.ReadAll;
      if DBZaehlerUpdateList.Count > 0 then
      begin
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fStatusLabel.Text := 'Upload Zählerstände';
        end
        );

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
            Zaehler.Upload;
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
    }
  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;


procedure TThreadLadedaten.LadeGebaudedaten;
var
  JProperties: TJProperties;
begin
  BasCloud.GebaudeList.Clear;
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Gebäudedaten';
  end);
  JProperties := JBasCloud.Read_Properties;
  BasCloud.GebaudeList.LoadFromJson(JProperties);
  FreeAndNil(JProperties);
end;

procedure TThreadLadedaten.LadeAlleZaehler;
var
  JDevices: TJDevices;
begin
  BasCloud.ZaehlerList.Clear;
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Zähler';
  end);
  // All Devices kann weg, da unten noch mal je Property die Devices geladen werden
  JDevices := JBasCloud.Read_AllDevices;
  BasCloud.ZaehlerList.LoadFromJson(JDevices);
  FreeAndNil(JDevices);
end;

procedure TThreadLadedaten.ZaehlerGebaudeZuordnen;
var
  i1, i2: Integer;
  JPropertyAssociatedDevices: TPropertyAssociatedDevices;
begin
  for i1 := 0 to BasCloud.GebaudeList.Count -1 do
  begin
    JPropertyAssociatedDevices := JBasCloud.Read_PropertieAssociatedDevices(BasCloud.GebaudeList.Item[i1].id);
    if JPropertyAssociatedDevices = nil then
      continue;
    for i2 := 0 to Length(JPropertyAssociatedDevices.Data) -1 do
    begin
      BasCloud.ZaehlerList.setGebaudeToZaehler(BasCloud.GebaudeList.Item[i1], JPropertyAssociatedDevices.Data[i2].Id);
    end;
  end;
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

procedure TThreadLadedaten.UploadZaehlerstaende;
var
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  Zaehler: TZaehler;
  Aufgabe: TAufgabe;
  i1: Integer;
begin
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
          Zaehler.Upload;
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
end;



procedure TThreadLadedaten.LadeAufgaben;
var
  JEventsCollection: TJEventsCollection;
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    fStatusLabel.Text := 'Lade Aufgaben';
  end
  );

  JEventsCollection := JBasCloud.Read_EventsCollection(BasCloud.UntilDateForEventsCollection);
  BasCloud.AufgabeList.LoadFromJson(JEventsCollection);
  FreeAndNil(JEventsCollection);
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

    //BasCloud.AufgabeList.SaveToFile('AufgebeAnzeigen.txt');

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
  //var
    //JEventsCollection: TJEventsCollection;
    //JReadings: TJReadings;
    //Zaehlerstand: TZaehlerstand;
    //i1: Integer;
    //Datum: TDateTime;
  begin
    LadeAufgaben;
    LadeZaehlerstaende;
    FiltereAufgabenFuerAnsicht;
    {
    BasCloud.AufgabeList.Clear;

    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Aufgaben';
    end
    );

    JEventsCollection := JBasCloud.Read_EventsCollection(BasCloud.UntilDateForEventsCollection);
    if JEventsCollection <> nil then
    begin
      BasCloud.AufgabeList.LoadFromJson(JEventsCollection);
      FreeAndNil(JEventsCollection);
    end;

    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fStatusLabel.Text := 'Lade Zählerstände';
    end
    );

    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
        continue;
      BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Zaehlerstand := -1;
    end;


    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
        continue;
      if (BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Zaehlerstand > -1) then
        continue;
      //Hier Zählerstand laden
      JReadings := JBasCloud.Read_Readings(BasCloud.AufgabeList.Item[i1].Zaehler.Id);
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
    }
  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;


procedure TThreadLadedaten.LadeZaehlerstandBilder;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  var
    Zaehlerstand: TZaehlerstand;
    i1: Integer;
    //JReadings: TJReadings;
    //Datum: TDateTime;
    List: TStringList;
  begin
    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
      BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.ClearImage;

    {
    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
        continue;
      BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.ClearImage;
      if (BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand.Zaehlerstand > -1) then
        continue;
      //Hier Zählerstand laden
      JReadings := JBasCloud.Read_Readings(BasCloud.AufgabeList.Item[i1].Zaehler.Id);
      if (JReadings = nil) or (Length(JReadings.data) = 0) then
        continue;
      Zaehlerstand := BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand;
      Zaehlerstand.Zaehlerstand := JReadings.Data[0].Attributes.Value;
      Datum := BasCloud.DatumObj.getDateTimeFromTimestamp(JReadings.Data[0].attributes.timestamp);
      Zaehlerstand.Datum := Datum;
      Zaehlerstand.Id := JReadings.Data[0].id;
      FreeAndNil(JReadings);
      Zaehlerstand.ReadingImage;
    end;
    }

    List := TStringList.Create;
    for i1 := 0 to BasCloud.AufgabeList.Count -1 do
    begin
      if (BasCloud.AufgabeList.Item[i1].Zaehler = nil) then
        continue;
      Zaehlerstand := BasCloud.AufgabeList.Item[i1].Zaehler.Zaehlerstand;
      if (Zaehlerstand.Zaehlerstand <= -1) then
        continue;
      if (Zaehlerstand.Image <> nil) then
        continue;
      List.Add(BasCloud.AufgabeList.Item[i1].Zaehler.id);
      Zaehlerstand.ReadingImage;
    end;
    {$IFDEF WIN32}
    if DirectoryExists('c:\temp\Test\') then
      List.SaveToFile('c:\temp\Test\ZaehlerId.txt');
    {$ENDIF WIN32}
    FreeAndNil(List);

  end
  );
  //t.OnTerminate := DatenLadenEnde;
  t.Start;
end;


end.
