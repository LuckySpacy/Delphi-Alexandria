unit Objekt.AktualDaten;

interface

uses
  System.SysUtils, System.Classes, Thread.Timer, db.queueList, DB.Device, DB.Gebaude,
  Objekt.GebaudeList, Objekt.ZaehlerList, Objekt.AufgabeList, DB.Zaehler, DB.ToDoList,
  DB.ToDo, objekt.Zaehlerstand, Objekt.Zaehler, DB.Zaehlerstandbild, db.Queue;

type
  TProgressInfoEvent = procedure(aInfo: string; aIndex, aCount: Integer) of object;
  TAktualDaten = class
  private
    {$IFDEF WIN32}
    fDebugList: TStringList;
    fDebugPfad: string;
    {$ENDIF WIN32}
    fTimer: TThreadTimer;
    fDBQueueList: TDBQueueList;
    fDBQueue: TDBQueue;
    fTimerIsStop: Boolean;
    fDBDevice: TDBDevice;
    fDBGebaude: TDBGebaude;
    fGebaudeList: TGebaudeList;
    fZaehlerList: TZaehlerList;
    fAufgabeList: TAufgabeList;
    fDBZaehler  : TDBZaehler;
    fDBZaehlerstandbild: TDBZaehlerstandbild;
    fDBToDoList : TDBToDoList;
    fDBToDo     : TDBToDo;
    fCheckNeueAufgaben: TDateTime;
    fCheckUploadZaehlerstaende: TDateTime;
    fOnCloseApp: TNotifyEvent;
    fTimerBusy: Boolean;
    fOnProgressInfo: TProgressInfoEvent;
    fNeueAufgaben: Integer;
    fOnAufgabenListChanged: TNotifyEvent;
    fOnEndRefreshProcess: TNotifyEvent;
    fHochgeladeneZaehlerList: TList;
    procedure DoCheckNeueAufgaben;
    procedure Aktual(Sender: TObject);
    function LadeGebaudedaten: Boolean;
    procedure ZaehlerGebaudeZuordnen;
    procedure LadeAlleZaehler;
    procedure LadeAlleZaehlerstaende;
    procedure LadeAufgaben;
    procedure FiltereAufgabenFuerAnsicht;
    function LadeZaehlerstaende_Refresh: Integer;
    procedure LadeZaehlerstaende;
    procedure LadeZaehlerstandBilder;
    procedure Fuelle_BAScloud_Gebaudedaten;
    procedure Fuelle_BAScloud_Zaehler;
    procedure Fuelle_BAScloud_Aufgabe;
    function Sync_DB_Gebaude: Boolean;
    function Sync_DB_Zaehler: Boolean;
    function Sync_DB_Zaehlerstand: Boolean;
    function Sync_DB_Aufgabe: Boolean;
    function UploadZaehlerstaende: Boolean;
    procedure sendNotification_HochgeladeneZaehler;
    procedure LadeGebaudeDaten_From_BasCloudList_Into_InternList;
    procedure LadeZaehlerDaten_From_BasCloudList_Into_InternList;
    procedure LadeAufgabeDaten_From_BasCloudList_Into_InternList;
    procedure UpdateDBZaehlerstand(aZaehler: TZaehler);
    {$IFDEF WIN32}
    procedure SaveDebugList(aPath, aFilename: string);
    {$ENDIF WIN32}
  public
    constructor Create;
    destructor Destroy; override;
    procedure AktualdatenStart;
    procedure Stop;
    property OnCloseApp: TNotifyEvent read fOnCloseApp write fOnCloseApp;
    function TimerAktiv: Boolean;
    property OnProgressInfo: TProgressInfoEvent read fOnProgressInfo write fOnProgressInfo;
    property OnAufgabenListChanged: TNotifyEvent read fOnAufgabenListChanged write fOnAufgabenListChanged;
    property OnEndRefreshProcess: TNotifyEvent read fOnEndRefreshProcess write fOnEndRefreshProcess;
    procedure CheckTimer;
  end;

implementation

{ TAktualDaten }

uses
  Json.Properties, Json.Devices, Json.EventsCollection, Json.Readings,
  Json.PropertyAssociatedDevices, DB.ZaehlerUpdateList, Objekt.Aufgabe,
  Objekt.Basislist, Objekt.AufgabePointerList, Objekt.Gebaude,
  Json.Device, Objekt.Bascloud, Objekt.JBascloud, DateUtils, fmx.Types,
  FMX.DialogService;



constructor TAktualDaten.Create;
begin
  {$IFDEF WIN32}
  fDebugList := TStringList.Create;
  fDebugPfad := 'c:\temp\BAScloud\';
  {$ENDIF WIN32}

  fTimerBusy := false;
  fTimer := TThreadTimer.Create;
  fTimer.Interval := 5000;
  fTimer.OnTimer := Aktual;
  fDBQueueList := TDBQueueList.Create;
  fTimerIsStop := false;
  fDBDevice  := TDBDevice.Create;
  fDBGebaude := TDBGebaude.Create;
  fDBZaehler  := TDBZaehler.Create;
  fDBToDoList := TDBToDoList.Create;
  fDBToDo     := TDBToDo.Create;
  fDBZaehlerstandbild := TDBZaehlerstandbild.Create;
  fDBQueue := TDBQueue.Create;


  fGebaudeList := TGebaudeList.Create;
  fZaehlerList := TZaehlerList.Create;
  fAufgabeList := TAufgabeList.Create;
  fHochgeladeneZaehlerList := TList.Create;

end;

destructor TAktualDaten.Destroy;
begin
  log.d('TAktualDaten.Destroy');
  {$IFDEF WIN32}
  FreeAndNil(fDebugList);
  {$ENDIF WIN32}

  FreeAndNil(fTimer);
  FreeAndNil(fDBQueueList);
  FreeAndNil(fDBDevice);
  FreeAndNil(fDBGebaude);
  FreeAndNil(fGebaudeList);
  FreeAndNil(fZaehlerList);
  FreeAndNil(fAufgabeList);
  FreeAndNil(fDBZaehler);
  FreeAndNil(fDBToDoList);
  FreeAndNil(fDBToDo);
  FreeAndNil(fDBZaehlerstandbild);
  FreeAndNil(fDBQueue);
  FreeAndNil(fHochgeladeneZaehlerList);
  inherited;
end;

{$IFDEF WIN32}
procedure TAktualDaten.SaveDebugList(aPath, aFilename: string);
begin
  if DirectoryExists(fDebugPfad) then
  begin
    if not DirectoryExists(aPath) then
      ForceDirectories(aPath);
    fDebugList.SaveToFile(IncludeTrailingPathDelimiter(aPath) + aFilename);
  end;
end;
{$ENDIF WIN32}

procedure TAktualDaten.AktualdatenStart;
begin
  fOnProgressInfo('TAktualDaten.Start', 0, 0);
  log.d('TAktualDaten.Start');
  fCheckNeueAufgaben         := IncMinute(now, Bascloud.TimerIntervalCheck.NeueAufgaben);
  fCheckUploadZaehlerstaende := IncMinute(now, BasCloud.TimerIntervalCheck.UploadZaehlerstaende);
  fTimerIsStop := false;
  fTimer.Start;
end;

procedure TAktualDaten.Stop;
begin
  fOnProgressInfo('TAktualDaten.Stop', 0, 0);
  log.d('TAktualDaten.Stop');
  fTimerIsStop := true;
  fTimer.Stop;

  if fTimerBusy then
    log.d('fTimerBusy = true')
  else
    log.d('fTimerBusy = false');

  if BasCloud.CloseAPP then
    log.d('BasCloud.CloseAPP = true')
  else
    log.d('BasCloud.CloseAPP = false');

  if (not fTimerBusy) and (BasCloud.CloseAPP) and (Assigned(fOnCloseApp)) then
    fOnCloseApp(Self);
end;


procedure TAktualDaten.Aktual(Sender: TObject);
var
  i1: Integer;
  ProgressCount: Integer;
  AnzahlLadeZaehlerstaende: Integer;
begin
  fOnProgressInfo('TAktualDaten.Aktual', 0, 0);
  fTimer.Stop;
  fTimerBusy := true;
  try
    try
      if fTimerIsStop then
      begin
        log.d('Timer wurde gestoppt');
        fOnProgressInfo('TAktualDaten--> Timer wurde gestoppt', 0, 0);
      end;

      if not BasCloud.CanLoadBAScloudData then
      begin
        log.d('not BasCloud.CanLoadBAScloudData');
        fOnProgressInfo('TAktualDaten--> CanLoadBAScloudData', 0, 0);
        exit;
      end;

      fOnProgressInfo('fDBQueueList.ReadAll', 0, 0);
      log.d('TAktualDaten.Aktual -> fDBQueueList.ReadAll');
      fDBQueueList.ReadAll;
      fOnProgressInfo('Anzahl = ' + IntToStr(fDBQueueList.Count), 0, 0);

      if now > fCheckUploadZaehlerstaende then
      begin
        log.d('TAktualDaten.Aktual --> UploadZaehlerstaende (Start)');
        fOnProgressInfo('TAktualDaten.Aktual --> UploadZaehlerstaende (Start)', 0, 0);
        if UploadZaehlerstaende then
        begin
          fCheckNeueAufgaben := 0; // Aufgaben müssen direkt im Anschluss aktualisiert werden.
          sendNotification_HochgeladeneZaehler;
        end;
        fCheckUploadZaehlerstaende := IncMinute(now, Bascloud.TimerIntervalCheck.UploadZaehlerstaende);
        log.d('TAktualDaten.Aktual --> UploadZaehlerstaende (Ende)');
        fOnProgressInfo('TAktualDaten.Aktual --> UploadZaehlerstaende (Ende)', 0, 0);
      end;

      if now > fCheckNeueAufgaben then
      begin
        DoCheckNeueAufgaben;
        if fTimerIsStop then
          exit;
        {
        LadeAufgaben;
        if fTimerIsStop then
          exit;
        FiltereAufgabenFuerAnsicht;
        if fTimerIsStop then
          exit;
        Fuelle_BAScloud_Aufgabe;
        if fTimerIsStop then
          exit;

        Sync_DB_Aufgabe;
        fCheckNeueAufgaben := IncMinute(now, Bascloud.TimerIntervalCheck.NeueAufgaben);

        if BasCloud.AufgabenListViewAktualisieren then
        begin
          TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                if Assigned(fOnAufgabenListChanged) then
                  fOnAufgabenListChanged(Self);
              end);
        end;
         }
      end;

      for i1 := 0 to fDBQueueList.count -1 do
      begin
        fOnProgressInfo('Processnummer = ' +  IntToStr(fDBQueueList.Item[i1].Process), 0, 0);

        if fDBQueueList.Item[i1].Process = 1 then
        begin
          ProgressCount := 15;
          fOnProgressInfo('Lade Gebäudedaten', 1, ProgressCount);
          log.d('fDBQueueList.Item[i1].Process = 1');
          LadeGebaudedaten;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Zähler Gebäude Zuordnen', 2, ProgressCount);
          ZaehlerGebaudeZuordnen;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Lade Aufgaben', 3, ProgressCount);
          LadeAufgaben;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Filtere Aufgaben für Ansicht', 4, ProgressCount);
          FiltereAufgabenFuerAnsicht;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Lade Zählerstände', 5, ProgressCount);
          LadeZaehlerstaende;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Lade Zählerstände Bilder', 6, ProgressCount);
          LadeZaehlerstandBilder;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Fülle BAScloud Gebäudedaten', 7, ProgressCount);
          Fuelle_BAScloud_Gebaudedaten;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          if not BasCloud.CanLoadBAScloudData then
          begin
            fOnProgressInfo('not BasCloud.CanLoadBAScloudData', 0, 0);
            exit;
          end;
          fOnProgressInfo('Fülle BAScloud Zähler', 8, ProgressCount);
          Fuelle_BAScloud_Zaehler;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Fülle BAScloud Aufgabe', 9, ProgressCount);
          Fuelle_BAScloud_Aufgabe;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Sync DB Gebäude', 10, ProgressCount);
          Sync_DB_Gebaude;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Sync DB Zähler', 11, ProgressCount);
          Sync_DB_Zaehler;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Sync DB Zählerstand', 12, ProgressCount);
          Sync_DB_Zaehlerstand;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          fOnProgressInfo('Sync DB Aufgabe', 13, ProgressCount);
          Sync_DB_Aufgabe;


          fOnProgressInfo('Lade alle Zähler', 14, ProgressCount);
          LadeAlleZaehler;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;

          fOnProgressInfo('Daten wurden in der APP aktualisiert', 15, ProgressCount);
          log.d('Daten wurden in der APP aktualisiert.');
          if BasCloud.Ini.Mitteilungseinstellung.DatenInAppAktualisiert then
          begin
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              BasCloud.sendNotification('Daten wurden in der APP aktualisiert.');
            end);
          end;
        end;

        if fDBQueueList.Item[i1].Process = 2 then  // Fülle interne Liste von BAScloudliste
        begin
          log.d('fDBQueueList.Item[i1].Process = 2 (Start)');
          LadeGebaudeDaten_From_BasCloudList_Into_InternList;
          LadeZaehlerDaten_From_BasCloudList_Into_InternList;
          LadeAufgabeDaten_From_BasCloudList_Into_InternList;
          log.d('fDBQueueList.Item[i1].Process = 2 (Ende)');
        end;

        if fDBQueueList.Item[i1].Process = 3 then //Synchronisiere Datenbank mit Liste
        begin
          log.d('fDBQueueList.Item[i1].Process = 3 (Start)');
          fOnProgressInfo('fDBQueueList.Item[i1].Process = 3 (Start)', 0, 0);
          fOnProgressInfo('Sync DB Gebäude', 1, 4);
          Sync_DB_Gebaude;
          //if fTimerIsStop then
          //  exit;
          fOnProgressInfo('Sync DB Zähler', 2, 4);
          Sync_DB_Zaehler;
          //if fTimerIsStop then
          //  exit;
          fOnProgressInfo('Sync DB Zählerstand', 3, 4);
          Sync_DB_Zaehlerstand;
          //if fTimerIsStop then
          //  exit;
           fOnProgressInfo('Sync DB Aufgabe', 4, 4);
           Sync_DB_Aufgabe;
           log.d('fDBQueueList.Item[i1].Process = 3 (Ende)');
          fOnProgressInfo('fDBQueueList.Item[i1].Process = 3 (Ende)', 0, 0);
        end;

        if (fDBQueueList.Item[i1].Process = 4) or (fDBQueueList.Item[i1].Process = 6) then // Alle Zählerstände laden
        begin
          fOnProgressInfo('fDBQueueList.Item[i1].Process = 4 (Start)', 0, 0);
          log.d('fDBQueueList.Item[i1].Process = 4 - Alle Zählerstände laden (Start)');
          LadeAlleZaehlerstaende;
          if fDBQueue.InProcess(5) then // manueller Refresh
          begin
            fDBQueueList.DeleteById(fDBQueueList.Item[i1].Id);
            exit;
          end;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          LadeZaehlerstandBilder;
          if fTimerIsStop then
          begin
            fOnProgressInfo('fTimerIsStop', 0, 0);
            exit;
          end;
          Sync_DB_Zaehlerstand;
          log.d('fDBQueueList.Item[i1].Process = 4 Alle Zählerstände laden (Ende)');
          fOnProgressInfo('fDBQueueList.Item[i1].Process = 4 (Ende)', 0, 0);
          fOnProgressInfo('Alle Zählerstände wurden geladen', 0, 0);
          if BasCloud.Ini.Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen then
            fOnProgressInfo('Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen = true', 0, 0)
          else
            fOnProgressInfo('Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen = false', 0, 0);

          if BasCloud.Ini.Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen then
          begin
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              BasCloud.sendNotification('Alle Zählerstände wurden geladen.');
            end);
          end;
        end;

        if fDBQueueList.Item[i1].Process = 5 then // Manuellen Refresh
        begin
          try
            fOnProgressInfo('fDBQueueList.Item[i1].Process = 5 (Start)', 0, 0);
            log.d('fDBQueueList.Item[i1].Process = 5 - Manuellen Refresh (Start)');

            if UploadZaehlerstaende then
              sendNotification_HochgeladeneZaehler;

            AnzahlLadeZaehlerstaende := LadeZaehlerstaende_Refresh;
            if (AnzahlLadeZaehlerstaende > 0) and (BasCloud.Ini.Mitteilungseinstellung.ZaehlerstaendeAktualisiert) then
            begin
              TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                BasCloud.sendNotification(IntToStr(AnzahlLadeZaehlerstaende) +  ' Zählerstände aktualisiert.');
              end);
              if fTimerIsStop then
              begin
                fOnProgressInfo('fTimerIsStop', 0, 0);
                exit;
              end;
              Sync_DB_Zaehlerstand;
            end;

            LadeAufgaben;
            FiltereAufgabenFuerAnsicht;
            Fuelle_BAScloud_Aufgabe;

            if (fNeueAufgaben > 0) and (BasCloud.Ini.Mitteilungseinstellung.NeueAufgaben) then
            begin
              TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                BasCloud.sendNotification(IntToStr(fNeueAufgaben) +  ' neue Aufgabe(n).');
              end);
            end;

            if (BasCloud.AufgabenListViewAktualisieren) or (fNeueAufgaben > 0) then
            begin
              TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                if Assigned(fOnAufgabenListChanged) then
                  fOnAufgabenListChanged(Self);
              end);
            end;

            fOnProgressInfo('fDBQueueList.Item[i1].Process = 5 (Ende)', 0, 0);

            if BasCloud.Ini.Mitteilungseinstellung.DatenWurdenAktualisiert then
            begin
              TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                BasCloud.sendNotification('Daten wurden aktualisiert.');
              end);
            end;

            log.d('fDBQueueList.Item[i1].Process = 5 - Manuellen Refresh (Ende)');

          finally
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              if Assigned(fOnEndRefreshProcess) then
                fOnEndRefreshProcess(Self);
            end);
          end;

        end;


        if fDBQueueList.Item[i1].Process = 7 then // Upload Zaehlerstand
        begin
          log.d('TAktualDaten.Aktual --> UploadZaehlerstaende (Start)');
          fOnProgressInfo('TAktualDaten.Aktual --> UploadZaehlerstaende (Start)', 0, 0);
          if UploadZaehlerstaende then
          begin
            fCheckNeueAufgaben := 0; // Aufgaben müssen direkt im Anschluss aktualisiert werden.
            sendNotification_HochgeladeneZaehler;
          end;
          fCheckUploadZaehlerstaende := IncMinute(now, Bascloud.TimerIntervalCheck.UploadZaehlerstaende);
          log.d('TAktualDaten.Aktual --> UploadZaehlerstaende (Ende)');
          fOnProgressInfo('TAktualDaten.Aktual --> UploadZaehlerstaende (Ende)', 0, 0);
          DoCheckNeueAufgaben;
        end;



        fOnProgressInfo('fDBQueueList.DeleteById ' +  IntToStr(fDBQueueList.Item[i1].Process), 0, 0);
        fDBQueueList.DeleteById(fDBQueueList.Item[i1].Id);
        if fTimerIsStop then
        begin
          fOnProgressInfo('fTimerIsStop', 0, 0);
          break;
        end;

      end;

    except
      on E: Exception do
      begin
        log.d('TAktualDaten.Aktual: Error: ' + E.Message);
      end;
    end;
  finally
    if BasCloud.CloseAPP then
    begin
      Stop;
      fTimerBusy := false;
      if Assigned(fOnCloseApp) then
        fOnCloseApp(Self);
    end
    else
    begin
      if BasCloud.AufgabenListViewAktualisieren then
      begin
        TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              if Assigned(fOnAufgabenListChanged) then
                fOnAufgabenListChanged(Self);
            end);
      end;
    end;
    fTimerBusy := false;
    if not fTimerIsStop then
      fTimer.Start;
  end;
end;


procedure TAktualDaten.DoCheckNeueAufgaben;
begin
  LadeAufgaben;
  if fTimerIsStop then
    exit;
  FiltereAufgabenFuerAnsicht;
  if fTimerIsStop then
    exit;
  Fuelle_BAScloud_Aufgabe;
  if fTimerIsStop then
    exit;

  Sync_DB_Aufgabe;
  fCheckNeueAufgaben := IncMinute(now, Bascloud.TimerIntervalCheck.NeueAufgaben);

  if BasCloud.AufgabenListViewAktualisieren then
  begin
    TThread.Synchronize(TThread.CurrentThread,
      procedure
        begin
          if Assigned(fOnAufgabenListChanged) then
            fOnAufgabenListChanged(Self);
          end);
  end;

end;


function TAktualDaten.LadeGebaudedaten: Boolean;
var
  JProperties: TJProperties;
begin
  log.d('TAktualDaten.LadeGebaudedaten --> Start');
  {$IFDEF WIN32}
    fDebugList.Clear;
  {$ENDIF WIN32}
  Result := false;
  if not BasCloud.CanLoadBAScloudData then
  begin
    log.d('BasCloud.CanLoadBAScloudData = false');
    exit;
  end;
  try
    fGebaudeList.Clear;
    JProperties := JBasCloud.Read_Properties;
    if JProperties = nil then
    begin
      {$IFDEF WIN32}
        fDebugList.Add('JProperties = nil');
        SaveDebugList(fDebugPfad, 'LadeGebaudedaten.txt');
      {$ENDIF WIN32}
      exit;
    end;

    {$IFDEF WIN32}
      fDebugList.Add('Error:' + BasCloud.Error);
      SaveDebugList(fDebugPfad, 'LadeGebaudedaten.txt');
    {$ENDIF WIN32}

    fGebaudeList.LoadFromJson(JProperties);
    FreeAndNil(JProperties);

    Result := true;
    log.d('TAktualDaten.LadeGebaudedaten --> Ende');
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.LadeGebaudedaten: ' + E.Message);
    end;
  end;
end;

procedure TAktualDaten.ZaehlerGebaudeZuordnen;
var
  i1, i2: Integer;
  JPropertyAssociatedDevices: TPropertyAssociatedDevices;
  Zaehler: TZaehler;
begin
  log.d('TAktualDaten.ZaehlerGebaudeZuordnen --> Start');
  {$IFDEF WIN32}
    fDebugList.Clear;
  {$ENDIF WIN32}
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    for i1 := 0 to fGebaudeList.Count -1 do
    begin
      JPropertyAssociatedDevices := JBasCloud.Read_PropertieAssociatedDevices(fGebaudeList.Item[i1].id);  // <-- Alle Zähler eines Gebäude lesen
      if JPropertyAssociatedDevices = nil then
        continue;
      for i2 := 0 to Length(JPropertyAssociatedDevices.Data) -1 do
      begin
        Zaehler := fZaehlerList.Add(JPropertyAssociatedDevices.Data[i2].Id);
        Zaehler.AksId        := JPropertyAssociatedDevices.Data[i2].attributes.aksId;
        Zaehler.Beschreibung := JPropertyAssociatedDevices.Data[i2].attributes.description;
        Zaehler.Einheit      := JPropertyAssociatedDevices.Data[i2].attributes.&unit;
        Zaehler.Gebaude      := fGebaudeList.Item[i1];
      end;
     {$IFDEF WIN32}
      fDebugList.Add('Error:' + BasCloud.Error);
      SaveDebugList(fDebugPfad, 'ZaehlerGebaudeZuordnen.txt');
     {$ENDIF WIN32}
     FreeAndNil(JPropertyAssociatedDevices);
    end;
    log.d('TAktualDaten.ZaehlerGebaudeZuordnen --> Ende');

  except

  end;

end;

procedure TAktualDaten.LadeAlleZaehler;
var
  JDevices: TJDevices;
  ZaehlerList: TZaehlerList;
  Zaehler: TZaehler;
  i1: Integer;
begin
  log.d('TAktualDaten.LadeAlleZaehler --> Start');
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    ZaehlerList := TZaehlerList.Create;
    try
      JDevices := JBasCloud.Read_AllDevices;
      ZaehlerList.LoadFromJson(JDevices);
      FreeAndNil(JDevices);

      {$IFDEF WIN32}
      fDebugList.Clear;
      for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
        fDebugList.Add(BasCloud.ZaehlerList.Item[i1].Id);
      SaveDebugList(fDebugPfad, 'ZaehlerId.txt');
      {$ENDIF WIN32}

      for i1 := 0 to ZaehlerList.Count -1 do
      begin
        if fZaehlerList.getById(ZaehlerList.Item[i1].Id) <> nil then
          continue;
        Zaehler := fZaehlerList.Add(ZaehlerList.Item[i1].Id);
        Zaehler.AksId        := ZaehlerList.Item[i1].aksId;
        Zaehler.Beschreibung := ZaehlerList.Item[i1].Beschreibung;
        Zaehler.Einheit      := ZaehlerList.Item[i1].Einheit;
        Zaehler.Gebaude      := nil;
      end;

      for i1 := 0 to fZaehlerList.Count -1 do
      begin
        Zaehler := BasCloud.ZaehlerList.Add(fZaehlerList.Item[i1].Id);
        Zaehler.AksId        := fZaehlerList.Item[i1].aksId;
        Zaehler.Beschreibung := fZaehlerList.Item[i1].Beschreibung;
        Zaehler.Einheit      := fZaehlerList.Item[i1].Einheit;
        Zaehler.Gebaude      := fZaehlerList.Item[i1].Gebaude;
      end;


    finally
      FreeAndNil(ZaehlerList);
      log.d('TAktualDaten.LadeAlleZaehler --> Ende');
    end;
  except
  end;
end;

procedure TAktualDaten.LadeAlleZaehlerstaende;
var
  i1: Integer;
  Zaehlerstand: TZaehlerstand;
  BasZaehler: TZaehler;
  Anzahl: Integer;
begin
  log.d('TAktualDaten.LadeAlleZaehlerstaende --> Start');
  try
    //exit;
    if not BasCloud.CanLoadBAScloudData then
    begin
      log.d('not BasCloud.CanLoadBAScloudData');
      exit;
    end;
    Anzahl := fZaehlerList.Count;
    for i1 := 0 to fZaehlerList.Count -1 do
    begin

      if fZaehlerList.Item[i1].ZaehlerstandGeprueftAm = trunc(now) then
        continue;

          {
      if SameText('8f377cf9-fc89-499f-b816-566482dc4f00', fZaehlerList.Item[i1].Id) then
        log.d('');
      if SameText('ee5b2b9f-a051-4113-937c-ff71713fa6bc', fZaehlerList.Item[i1].Id) then
      begin
        log.d('BRAS-001');
        fZaehlerList.Item[i1].Zaehlerstand.Eingelesen := false;
        fZaehlerList.Item[i1].ReadZaehlerstand;
      end;
      if SameText('a757bfd9-642f-4102-8dd6-bf41ea0cfb3f', fZaehlerList.Item[i1].Id) then
        log.d('BRAS-002');
      }
      if fDBQueue.InProcess(5) then // manueller Refresh
      begin
        fOnProgressInfo('fDBQueue.InProcess(5) = manueller Refresh', 0, 0);

        fDBQueue.InsertProcess_AlleZaehlerstaendeLadenWdh;
        exit;
      end;

      log.d('Satz: ' + IntToStr(i1+1) + ' von ' + IntToStr(Anzahl));
      fOnProgressInfo('Satz: ' + IntToStr(i1+1) + ' von ' + IntToStr(Anzahl), 0, 0);

      //if fZaehlerList.Item[i1].Id = '7d53bf22-f233-41a3-86bf-524bd73abd0a' then
      //  log.d('Zähler: ' + fZaehlerList.Item[i1].Id);


      if fTimerIsStop then
        break;

      fZaehlerList.Item[i1].ZaehlerstandGeprueftAm := trunc(now);

      if (fZaehlerList.Item[i1].Zaehlerstand = nil) then
        continue;

      if (fZaehlerList.Item[i1].Zaehlerstand <> nil) and (fZaehlerList.Item[i1].Zaehlerstand.Eingelesen) then
      begin
        BasZaehler := BasCloud.ZaehlerList.getById(fZaehlerList.Item[i1].Id);
        if BasZaehler = nil then // Sollte nicht sein.
          continue;
        Zaehlerstand := fZaehlerList.Item[i1].Zaehlerstand;
        Zaehlerstand.Copy(BasZaehler.Zaehlerstand);
        continue;
      end;

      if fZaehlerList.Item[i1].Zaehlerstand.Id = '' then
        fZaehlerList.Item[i1].ReadZaehlerstand;

      if fZaehlerList.Item[i1].Zaehlerstand.Id = '' then
        continue;  // Kein Zählerstand vorhanden

     // if fZaehlerList.Item[i1].Zaehlerstand.Id = '25cf5fa2-e6f9-4eed-87ea-29356c9eb013' then
     //   log.d('ZählerstandId = ' + fZaehlerList.Item[i1].Zaehlerstand.Id);


      fDBZaehler.Read(fZaehlerList.Item[i1].Zaehlerstand.Id);

      //log.d('Zählerdatum = ' + FormatDateTime('dd.mm.yyyy', fDBZaehler.CreateDatum));

      BasZaehler := BasCloud.ZaehlerList.getById(fZaehlerList.Item[i1].Id);
      if BasZaehler = nil then // Sollte nicht sein.
        continue;
      Zaehlerstand := fZaehlerList.Item[i1].Zaehlerstand;
      Zaehlerstand.Copy(BasZaehler.Zaehlerstand);


      if trunc(fDBZaehler.CreateDatum) = trunc(now) then
      begin
        log.d('Zähler wurde heute schon eingelesen');
        continue; // Zähler wurde heute schon eingelesen
      end;

      if fDBZaehler.Id = '' then
        fDBZaehler.save(fZaehlerList.Item[i1]);


      //Hier Zählerstand laden
      fZaehlerList.Item[i1].ReadZaehlerstand;
      if not fZaehlerList.Item[i1].Zaehlerstand.EingelesenErfolgreich then
        continue;

      //if fZaehlerList.Item[i1].Zaehlerstand.Id = '25cf5fa2-e6f9-4eed-87ea-29356c9eb013' then
      //  log.d('ZählerstandId = ' + fZaehlerList.Item[i1].Zaehlerstand.Id);

      fDBZaehlerstandbild.Read(fZaehlerList.Item[i1].Zaehlerstand.Id);
      if fDBZaehlerstandbild.Id = fZaehlerList.Item[i1].Zaehlerstand.Id then
        continue; // Zählerstand wurde schon eingelesen

      if (fDBZaehlerstandbild.LoadFromDevice(fZaehlerList.Item[i1])) and (fDBZaehlerstandbild.getBildSize = 0) then
        continue; // Es kommt vor, dass Zählerstände autom. hochgeladen werden. Diese haben keine Bilder
                  // Deshalb wird hier nicht versucht ständige neue Bilder zu laden, wenn es sowieso keine Bilder gibt.


      Zaehlerstand := fZaehlerList.Item[i1].Zaehlerstand;
      Zaehlerstand.ReadingImage;
      log.d('Image aus BASCloud gelesen');


      if fDBZaehlerstandbild.save(fZaehlerList.Item[i1]) then
        log.d('Image gespeichert')
      else
        log.d('Fehler beim Speichern des Image');


      Zaehlerstand.ClearImage; //<-- Zählerbild nicht im Speicher des Smartphones halten


      //BasZaehler.Zaehlerstand.Copy(Zaehlerstand);
      //Zaehlerstand.Copy(BasZaehler.Zaehlerstand);

      //TDialogService.ShowMessage('Alle Zählerstände wurden geladen');
    end;
    log.d('TAktualDaten.LadeAlleZaehlerstaende --> Ende');
  except

  end;

end;



procedure TAktualDaten.LadeAufgaben;
var
  JEventsCollection: TJEventsCollection;
  {$IFDEF WIN32}
  i1: Integer;
  {$ENDIF WIN32}
begin
  log.d('TAktualDaten.LadeAufgaben --> Start');
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    {$IFDEF WIN32}
    fDebugList.Clear;
    {$ENDIF WIN32}

    JEventsCollection := JBasCloud.Read_EventsCollection(BasCloud.UntilDateForEventsCollection);
    fAufgabeList.LoadFromJson2(JEventsCollection, fZaehlerlist); // <-- Alle Aufgaben lesen und gleichzeitig den Zähler der Aufgabe zuordnen

    {$IFDEF WIN32}
    for i1 := 0 to fAufgabeList.Count -1 do
      fDebugList.Add(fAufgabeList.Item[i1].id + fAufgabeList.Item[i1].Zaehler.Id + ' - ' + FormatDateTime('dd.mm.yyyy', fAufgabeList.Item[i1].Datum) + fAufgabeList.Item[i1].Zaehler.AksId);
    {$ENDIF WIN32}


    FreeAndNil(JEventsCollection);
    {$IFDEF WIN32}
      fDebugList.Add('Error:' + BasCloud.Error);
      SaveDebugList(fDebugPfad, 'LadeAufgaben.txt');
    {$ENDIF WIN32}

    log.d('TAktualDaten.LadeAufgaben --> Ende');
  except
  end;
end;


procedure TAktualDaten.FiltereAufgabenFuerAnsicht;
var
  i1: Integer;
  AufgabeZaehlerAlle: TBasisList;
  AufgabeZaehler: TAufgabePointerList;
  ZaehlerId: string;
  Aufgabe: TAufgabe;
begin//
  log.d('TAktualDaten.FiltereAufgabenFuerAnsicht --> Start');
  {$IFDEF WIN32}
  fDebugList.Clear;
  {$ENDIF WIN32}
  AufgabeZaehlerAlle := TBasisList.Create;
  try
    ZaehlerId := '';
    fAufgabeList.ZaehlerSortieren;
    //BasCloud.AufgabeList.SaveToFile('AufgebListAlle.txt');
    AufgabeZaehler := nil;
    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      Aufgabe := fAufgabeList.Item[i1];
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
      fDebugList.Sorted := true;
      fDebugList.Duplicates := dupIgnore;
      for i1 := 0 to fAufgabeList.Count -1 do
        fDebugList.Add(fAufgabeList.Item[i1].Zaehler.Id + ' - ' + fAufgabeList.Item[i1].Zaehler.AksId);
      SaveDebugList(fDebugPfad, 'ZaehlerInAufgabe.txt');
      fDebugList.Sorted := false;
      fDebugList.Duplicates := dupAccept;

    {$ENDIF WIN32}


    //BasCloud.AufgabeList.SaveToFile('AufgebeAnzeigen.txt');


    // Alles was nicht angezeigt wird, kommt aus der Liste wieder raus.
    for i1 := fAufgabeList.Count -1 downto 0 do
    begin
      if not fAufgabeList.Item[i1].Anzeigen then
        fAufgabeList.Delete(i1);
    end;

  finally
    FreeAndNil(AufgabeZaehlerAlle);
    log.d('TAktualDaten.FiltereAufgabenFuerAnsicht --> Ende');
  end;
end;




procedure TAktualDaten.LadeZaehlerstaende;
var
  i1: Integer;
begin
  log.d('TAktualDaten.LadeZaehlerstaende --> Start');
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    for i1 := 0 to fAufgabeList.Count -1 do
    begin

        // Sicherheitsprüfung, falls inkonsistente Daten zurückkommen
      if (fAufgabeList.Item[i1].Zaehler = nil) then
        continue;

      if (fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen) then
        continue;

      //Hier Zählerstand laden
      fAufgabeList.Item[i1].Zaehler.ReadZaehlerstand;
    end;
    log.d('TAktualDaten.LadeZaehlerstaende --> Ende');
  except
  end;
end;

function TAktualDaten.LadeZaehlerstaende_Refresh: Integer;
var
  i1: Integer;
  MerkeStand: Currency;
  Aufgabe: TAufgabe;
begin
  Result := 0;
  log.d('TAktualDaten.LadeZaehlerstaende_Refresh --> Start');
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen := false;
      if SameText('8f377cf9-fc89-499f-b816-566482dc4f00', fAufgabeList.Item[i1].Zaehler.Id) then
        log.d('');
    end;

    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      if SameText('8f377cf9-fc89-499f-b816-566482dc4f00', fAufgabeList.Item[i1].Zaehler.Id) then
        log.d('');

        // Sicherheitsprüfung, falls inkonsistente Daten zurückkommen
      if (fAufgabeList.Item[i1].Zaehler = nil) then
        continue;

      if fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Eingelesen then
        continue;

      MerkeStand := fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Zaehlerstand;
      //Hier Zählerstand laden
      fAufgabeList.Item[i1].Zaehler.ReadZaehlerstand;

      if MerkeStand <> fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Zaehlerstand then
      begin
        fAufgabeList.Item[i1].Zaehler.Zaehlerstand.ReadingImage;
        fDBZaehlerstandbild.save(fZaehlerList.Item[i1]);
        Aufgabe := BasCloud.AufgabeList.getById(fAufgabeList.Item[i1].id);
        if Aufgabe <> nil then
          fAufgabeList.Item[i1].Zaehler.Zaehlerstand.Copy(Aufgabe.Zaehler.Zaehlerstand);
        inc(Result);
      end;

    end;
    log.d('TAktualDaten.LadeZaehlerstaende_Refresh --> Ende');
  except
  end;
end;

procedure TAktualDaten.LadeZaehlerstandBilder;
var
  Zaehlerstand: TZaehlerstand;
  i1: Integer;
begin
  log.d('TAktualDaten.LadeZaehlerstandBilder --> Start');
  if not BasCloud.CanLoadBAScloudData then
    exit;
  try
    for i1 := 0 to fAufgabeList.Count -1 do
      fAufgabeList.Item[i1].Zaehler.Zaehlerstand.ClearImage;

    {$IFDEF WIN32}
      fDebugList.Clear;
    {$ENDIF WIN32}
    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      if (fAufgabeList.Item[i1].Zaehler = nil) then
        continue;
      Zaehlerstand := fAufgabeList.Item[i1].Zaehler.Zaehlerstand;
      if (Zaehlerstand.Image <> nil) then
        continue;
      {$IFDEF WIN32}
      fDebugList.Add(fAufgabeList.Item[i1].Zaehler.id);
      {$ENDIF WIN32}
      log.d('Zählerstand-Id: ' + Zaehlerstand.Id);
      Zaehlerstand.ReadingImage;
      fDBZaehlerstandbild.save(fZaehlerList.Item[i1]);

      {$IFDEF WIN32}
      if DirectoryExists(fDebugPfad + 'Test\') then
      begin
        if not DirectoryExists(fDebugPfad + 'LadeZaehlerstandBilder') then
          ForceDirectories(fDebugPfad + 'LadeZaehlerstandBilder');
        if Zaehlerstand.Image <> nil then
            Zaehlerstand.Image.Bitmap.SaveToFile(fDebugPfad + 'LadeZaehlerstandBilder\' +Zaehlerstand.id + '.jpg');
      end;
      {$ENDIF WIN32}


    end;
    {$IFDEF WIN32}
      SaveDebugList(fDebugPfad + 'Test\', 'ZaehlerId.txt');
    {$ENDIF WIN32}
    log.d('TAktualDaten.LadeZaehlerstandBilder --> Ende');

  except

  end;
end;




procedure TAktualDaten.Fuelle_BAScloud_Gebaudedaten;
var
  i1: Integer;
  Gebaude: TGebaude;
begin
  log.d('TAktualDaten.Fuelle_BAScloud_Gebaudedaten --> Start');
  for i1 := 0 to fGebaudeList.Count -1 do
  begin
    Gebaude := BasCloud.GebaudeList.Add(fGebaudeList.Item[i1].id);
    fGebaudeList.Item[i1].Copy(Gebaude);
  end;
  log.d('TAktualDaten.Fuelle_BAScloud_Gebaudedaten --> Ende');
end;


procedure TAktualDaten.Fuelle_BAScloud_Zaehler;
var
  i1: Integer;
  Zaehler: TZaehler;
  Zaehlerstand: TZaehlerstand;
begin

  log.d('TAktualDaten.Fuelle_BAScloud_Zaehler --> Start');
  try
    for i1 := 0 to fZaehlerList.Count -1 do
    begin
      Zaehler := Bascloud.ZaehlerList.Add(fZaehlerList.Item[i1].id);
      fZaehlerList.Item[i1].Copy(Zaehler);

      if (Zaehler.Gebaude = nil) and (fZaehlerList.Item[i1].Gebaude <> nil) then
        Zaehler.Gebaude := BasCloud.GebaudeList.getById(fZaehlerList.Item[i1].Gebaude.id);

      log.d(Zaehler.Id);
      Zaehlerstand := Zaehler.Zaehlerstand;
      fZaehlerList.Item[i1].Zaehlerstand.Copy(Zaehlerstand);

        {$IFDEF WIN32}
        if DirectoryExists(fDebugPfad + 'Test') then
        begin
          if not DirectoryExists(fDebugPfad + 'Test\Fuelle_BAScloud_Zaehler') then
            ForceDirectories(fDebugPfad + 'Test\Fuelle_BAScloud_Zaehler');
          if Zaehlerstand.Image <> nil then
              Zaehlerstand.Image.Bitmap.SaveToFile(fDebugPfad + 'Test\Fuelle_BAScloud_Zaehler\' +Zaehlerstand.id + '.jpg');
        end;
        {$ENDIF WIN32}
    end;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Fuelle_BAScloud_Zaehler: ' + e.Message);
    end;
  end;
  log.d('TAktualDaten.Fuelle_BAScloud_Zaehler --> Ende');

end;

procedure TAktualDaten.Fuelle_BAScloud_Aufgabe;
var
  i1: Integer;
  Aufgabe: TAufgabe;
  Zaehler: TZaehler;
  MerkeAnzahlAufgaben: Integer;
begin
  try
    fNeueAufgaben := 0;
    log.d('TAktualDaten.Fuelle_BAScloud_Aufgabe --> Start');
    {$IFDEF WIN32}
      fDebugList.Clear;
      for i1 := 0 to BasCloud.AufgabeList.Count -1 do
        fDebugList.Add(BasCloud.AufgabeList.Item[i1].id + ' - ' + BasCloud.AufgabeList.Item[i1].Zaehler.id + ' - ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', BasCloud.AufgabeList.Item[i1].Datum) + BasCloud.AufgabeList.Item[i1].Zaehler.AksId);
      SaveDebugList(fDebugPfad + 'Fuelle_BAScloud_Aufgabe\', 'BasCloudAufgabeList.txt');
      fDebugList.Clear;
      for i1 := 0 to fAufgabeList.Count -1 do
        fDebugList.Add(fAufgabeList.Item[i1].id + fAufgabeList.Item[i1].Zaehler.Id + ' - ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', fAufgabeList.Item[i1].Datum) + fAufgabeList.Item[i1].Zaehler.AksId);
      SaveDebugList(fDebugPfad + 'Fuelle_BAScloud_Aufgabe\', 'fAufgabeList.txt');
    {$ENDIF WIN32}

    MerkeAnzahlAufgaben := BasCloud.AufgabeList.Count;
    for i1 := BasCloud.AufgabeList.Count -1 downto 0 do
    begin
      Aufgabe := fAufgabeList.getById(BasCloud.AufgabeList.Item[i1].Id);
  //    if (Aufgabe.Id = '') and (Aufgabe.ZuId <= 0) then
  //      continue;
      if Aufgabe = nil then
      begin
        BasCloud.AufgabeList.DeleteAufgabe(BasCloud.AufgabeList.Item[i1].Id); // <-- Aufgabe ist nicht mehr in der Cloud;
        BasCloud.AufgabenListViewAktualisieren := true;
       end;
    end;

    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      if BasCloud.AufgabeList.getById(fAufgabeList.item[i1].Id) = nil then
        inc(fNeueAufgaben);
      Aufgabe := BasCloud.AufgabeList.Add(fAufgabeList.item[i1].Id);
      fAufgabeList.item[i1].Copy(Aufgabe);
      Zaehler := Bascloud.ZaehlerList.getById(fAufgabeList.item[i1].ZaehlerId);
      Aufgabe.Zaehler := Zaehler;
    end;

    if MerkeAnzahlAufgaben <> BasCloud.AufgabeList.Count then
      BasCloud.AufgabenListViewAktualisieren := true;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Fuelle_BAScloud_Aufgabe: ' + E.Message);
    end;
  end;

  log.d('TAktualDaten.Fuelle_BAScloud_Aufgabe --> Ende');
end;


function TAktualDaten.Sync_DB_Gebaude: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
begin
  Result := false;
  try
    fDBGebaude.OnProgressInfo := fOnProgressInfo;
    log.d('TAktualDaten.Sync_DB_Gebaude --> Start');
    Result := true;
    fOnProgressInfo('Anzahl Gebäudelist', 0, fGebaudeList.Count);
    for i1 := 0 to fGebaudeList.Count -1 do
    begin
      fOnProgressInfo('fDBGebaude.Read (Start)', 0, fGebaudeList.Count);
      DoPatch := fDBGebaude.Read(fGebaudeList.Item[i1].Id);
      fOnProgressInfo('fDBGebaude.Read (Ende)', 0, fGebaudeList.Count);
      fDBGebaude.Id          := fGebaudeList.Item[i1].Id;
      fDBGebaude.Gebaudename := fGebaudeList.Item[i1].Gebaudename;
      fDBGebaude.Ort         := fGebaudeList.Item[i1].Ort;
      fDBGebaude.Plz         := fGebaudeList.Item[i1].Plz;
      fDBGebaude.Strasse     := fGebaudeList.Item[i1].Strasse;
      fDBGebaude.Land        := fGebaudeList.Item[i1].Land;
      if doPatch then
      begin
        fOnProgressInfo('doPatch', i1, fGebaudeList.Count);
        Result := fDBGebaude.Patch;
      end
      else
      begin
        fOnProgressInfo('doInsert', i1, fGebaudeList.Count);
        Result := fDBGebaude.Insert;
      end;
    end;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Sync_DB_Gebaude: ' + E.Message);
    end;
  end;
  log.d('TAktualDaten.Sync_DB_Gebaude --> Ende');
end;



function TAktualDaten.Sync_DB_Zaehler: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
begin
  Result := false;
  log.d('TAktualDaten.Sync_DB_Zaehler --> Start');
  try
    Result := true;
    for i1 := 0 to fZaehlerList.Count -1 do
    begin
      fDBDevice.GbId := '';
      DoPatch := fDBDevice.Read(fZaehlerList.Item[i1].Id);
      fDBDevice.Id          := fZaehlerList.Item[i1].Id;
      fDBDevice.Einheit     := fZaehlerList.Item[i1].Einheit;
      fDBDevice.AksId       := fZaehlerList.Item[i1].AksId;
      fDBDevice.Description := fZaehlerList.Item[i1].Beschreibung;

      if fZaehlerList.Item[i1].Gebaude <> nil then
        fDBDevice.GbId := fZaehlerList.Item[i1].Gebaude.Id;

      if doPatch then
        Result := fDBDevice.Patch
      else
        Result := fDBDevice.Insert;
    end;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Sync_DB_Zaehler: ' + E.Message);
    end;
  end;
  log.d('TAktualDaten.Sync_DB_Zaehler --> Ende');
end;

function TAktualDaten.Sync_DB_Zaehlerstand: Boolean;
var
  i1: Integer;
  {$IFDEF WIN32}
  List: TStringList;
  {$ENDIF WIN32}
//  Ms: TMemoryStream;
begin
  log.d('TAktualDaten.Sync_DB_Zaehlerstand --> Start');
  Result := true;
  try
    {$IFDEF WIN32}
    List := TStringList.Create;
    try
      for i1 := 0 to fZaehlerList.Count -1 do
        List.Add(fZaehlerList.Item[i1].Id + ' ' + fZaehlerList.Item[i1].Zaehlerstand.Id + ' ' + fZaehlerList.Item[i1].AksId);
      List.SaveToFile('c:\temp\BAScloud\AktualDaten_ZaehlerListe.txt');
    finally
      FreeAndNil(List);
    end;
   {$ENDIF WIN32}

    for i1 := 0 to fZaehlerList.Count -1 do
    begin

      //if fZaehlerList.Item[i1].Zaehlerstand.Id = '28322a36-88e0-4a6b-9dd5-f5a56abbf968' then
      // log.d('ZählerstandId = ' + fZaehlerList.Item[i1].Zaehlerstand.Id);

      if (fZaehlerList.Item[i1].Zaehlerstand = nil) or (fZaehlerList.Item[i1].Zaehlerstand.Id = '') then
      begin
        fDBZaehler.DeleteDevice(fZaehlerList.Item[i1].Id); // Alle Readings zum Device löschen
        continue;
      end;

      if fZaehlerList.Item[i1].Gebaude = nil then
        continue;

      fDBZaehler.Read(fZaehlerList.Item[i1].Zaehlerstand.Id);
      if fDBZaehler.Id = fZaehlerList.Item[i1].Zaehlerstand.Id then
        continue; // Reading schon eingelesen

      {
      ms := TMemoryStream.Create;
      try
        fZaehlerList.Item[i1].Zaehlerstand.SaveImageToStream(ms);
        ms.Position := 0;
        fDBZaehler.setBild(ms);
      finally
        FreeAndNil(ms);
      end;
      }

      fDBZaehler.Id          := fZaehlerList.Item[i1].Zaehlerstand.Id;
      fDBZaehler.GbId        := fZaehlerList.Item[i1].Gebaude.Id;
      fDBZaehler.deId        := fZaehlerList.Item[i1].Id;
      fDBZaehler.Stand       := FloatToStr(fZaehlerList.Item[i1].Zaehlerstand.Zaehlerstand);
      fDBZaehler.Datum       := fZaehlerList.Item[i1].Zaehlerstand.Datum;
      fDBZaehler.CreateDatum := now;
      Result := fDBZaehler.Insert;
      fDBZaehlerstandbild.save(fZaehlerList.Item[i1]);


    end;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Sync_DB_Zaehlerstand: ' + E.Message);
    end;
  end;
  log.d('TAktualDaten.Sync_DB_Zaehlerstand --> Ende');
end;



function TAktualDaten.TimerAktiv: Boolean;
begin
  Result := fTimerIsStop;
end;

function TAktualDaten.Sync_DB_Aufgabe: Boolean;
var
  i1: Integer;
  DoPatch: Boolean;
  Aufgabe: TAufgabe;
begin
  log.d('TAktualDaten.Sync_DB_Aufgabe --> Start');
  Result := true;
  try
    //fDBToDoList.DeleteAll;

    // Prüfen ob Aufgaben zwischenzeitlich erledigt wurden, bzw. sich nicht mehr in der Cloud befinden
    fDBToDoList.ReadAll;
    for i1 := 0 to fDBToDoList.Count -1 do
    begin
      if fDBToDoList.Item[i1].Id = '' then
        continue;
      Aufgabe := fAufgabeList.getById(fDBToDoList.Item[i1].Id);
      if Aufgabe = nil then
        fDBToDo.Delete(fDBToDoList.Item[i1].Id);
    end;

    for i1 := 0 to fAufgabeList.Count -1 do
    begin
      if not fAufgabeList.Item[i1].Anzeigen then
        continue;

      fDBToDo.GbId := '';
      fDBToDo.DeId := '';
      DoPatch := fDBToDo.Read(fAufgabeList.Item[i1].Id);
      fDBToDo.Id          := fAufgabeList.Item[i1].Id;
      fDBToDo.Datum       := fAufgabeList.Item[i1].Datum;
      fDBToDo.Status      := fAufgabeList.Item[i1].Status;
      fDBToDo.Kommentar   := fAufgabeList.Item[i1].Notiz;

      if (fAufgabeList.Item[i1].Zaehler <> nil) and (fAufgabeList.Item[i1].Zaehler.Gebaude <> nil) then
        fDBToDo.GbId := fAufgabeList.Item[i1].Zaehler.Gebaude.Id;

      if (fAufgabeList.Item[i1].Zaehler <> nil)  then
        fDBToDo.deId := fAufgabeList.Item[i1].Zaehler.Id;

      if doPatch then
        Result := fDBToDo.Patch
      else
        Result := fDBToDo.Insert;
    end;
  except
    on E: Exception do
    begin
      log.d('TAktualDaten.Sync_DB_Aufgabe: ' + E.Message);
    end;
  end;
  log.d('TAktualDaten.Sync_DB_Aufgabe --> Ende');
end;


function TAktualDaten.UploadZaehlerstaende: Boolean;
var
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  //DBToDo: TDBToDo;
  Zaehler: TZaehler;
  Aufgabe: TAufgabe;
  i1: Integer;
//  s: string;
  Anzahl: Integer;
begin
  fHochgeladeneZaehlerList.Clear;
  log.d('TAktualDaten.UploadZaehlerstaende --> Start');
  Result := false;
  {$IFDEF WIN32}
    fDebugList.Clear;
  {$ENDIF WIN32}
  try
    //DBToDo := TDBToDo.Create;
    DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
    try
      Anzahl := DBZaehlerUpdateList.ReadAll;
      if Anzahl < 0 then
      begin
        fOnProgressInfo('Fehler in TAktualDaten.UploadZaehlerstaende.ReadAll', 0 ,0);
        exit;
      end;
      fOnProgressInfo('DBZaehlerUpdateList.ReadAll', Anzahl ,0);
      for i1 := 0 to DBZaehlerUpdateList.Count -1 do
      begin
        Aufgabe := nil;
        if (DBZaehlerUpdateList.Item[i1].ToDoId = '') and (DBZaehlerUpdateList.Item[i1].DeId = '') then
        begin
          // Das kann eigentlich nicht sein --> Keine Aufgabe und kein Zähler kein Upload
          DBZaehlerUpdateList.Item[i1].DeleteById(DBZaehlerUpdateList.Item[i1].Id);
          continue;
        end;
        if DBZaehlerUpdateList.Item[i1].ToDoId > '' then
          Aufgabe := BasCloud.AufgabeList.getById(DBZaehlerUpdateList.Item[i1].ToDoId);

        if Aufgabe = nil then
          Aufgabe := BasCloud.AufgabeList.getByZuId(DBZaehlerUpdateList.Item[i1].Id); // Finde Ad hoc Aufgabe

        if Aufgabe <> nil then
        begin
          if (Aufgabe.Zaehler <> nil) and (Aufgabe.Zaehler.Zaehlerstand <> nil) then
          begin
            BasCloud.InitError;
            Aufgabe.Zaehler.Zaehlerstand.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
            Aufgabe.Zaehler.Zaehlerstand.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
            Aufgabe.Zaehler.Zaehlerstand.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
            if Aufgabe.Upload then
            begin
              Log.d('Zählerstand hochgeladen');
              Result := true;
              DBZaehlerUpdateList.Item[i1].DeleteById(DBZaehlerUpdateList.Item[i1].Id);
              UpdateDBZaehlerstand(Aufgabe.Zaehler);
              BasCloud.AufgabenListViewAktualisieren := true;
            end;
            continue;
          end;
        end;

        Zaehler := BasCloud.ZaehlerList.getById(DBZaehlerUpdateList.Item[i1].DeId);
        if Zaehler = nil then // Darf nicht sein, dass Zähler nicht gefunden wurde
        begin
          DBZaehlerUpdateList.Item[i1].DeleteById(DBZaehlerUpdateList.Item[i1].Id);
          continue;
        end;

        Zaehler.Zaehlerstand.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
        Zaehler.Zaehlerstand.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
        Zaehler.Zaehlerstand.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
        BasCloud.InitError;
        if Zaehler.Upload then
        begin
          DBZaehlerUpdateList.Item[i1].DeleteById(DBZaehlerUpdateList.Item[i1].Id);
          UpdateDBZaehlerstand(Zaehler);
          BasCloud.AufgabenListViewAktualisieren := true;
          fHochgeladeneZaehlerList.Add(Zaehler);
          Result := true;
        end;
      end;
    finally
      FreeAndNil(DBZaehlerUpdateList);
      //FreeAndNil(DBToDo);
    end;
    log.d('TAktualDaten.UploadZaehlerstaende --> Ende');
  except
    on e: exception do
    begin
      log.d('TAktualDaten.UploadZaehlerstaende: ' + e.Message);
    end;
  end;

end;

procedure TAktualDaten.sendNotification_HochgeladeneZaehler;
var
  s: string;
  //i1: Integer;
begin
  if not BasCloud.Ini.Mitteilungseinstellung.ZaehlerWurdeHochgeladen then
    exit;
  s := 'Zählerstände wurden hochgeladen';
  {
  s := 'Hochgeladene Zähler: ' + sLineBreak;
  for i1 := 0 to fHochgeladeneZaehlerList.Count -1 do
  begin
    s := s + 'Zähler: ' + TZaehler(fHochgeladeneZaehlerList.Items[i1]).AksId + sLineBreak;
    s := s + 'Stand: ' + FloatToStr(TZaehler(fHochgeladeneZaehlerList.Items[i1]).Zaehlerstand.Zaehlerstand) + sLineBreak;
    if i1 < fHochgeladeneZaehlerList.Count-1 then
      s := s + ' ' + sLineBreak;
  end;
  }
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    BasCloud.sendNotification(s);
  end);

end;



procedure TAktualDaten.LadeGebaudeDaten_From_BasCloudList_Into_InternList;
var
  i1: Integer;
  Gebaude: TGebaude;
begin
  for i1 := 0 to BasCloud.GebaudeList.Count -1 do
  begin
    Gebaude := fGebaudeList.Add(BasCloud.GebaudeList.Item[i1].id);
    BasCloud.GebaudeList.Item[i1].Copy(Gebaude);
  end;
end;

procedure TAktualDaten.LadeZaehlerDaten_From_BasCloudList_Into_InternList;
var
  i1: Integer;
  Zaehler: TZaehler;
  Zaehlerstand: TZaehlerstand;
  Gebaude: TGebaude;
begin
  for i1 := 0 to BasCloud.ZaehlerList.Count -1 do
  begin
    Zaehler := fZaehlerList.Add(BasCloud.ZaehlerList.Item[i1].id);
    Gebaude := nil;
    if BasCloud.ZaehlerList.Item[i1].Gebaude <> nil then
      Gebaude := fGebaudeList.getById(BasCloud.ZaehlerList.Item[i1].Gebaude.id);
    BasCloud.ZaehlerList.Item[i1].Copy(Zaehler);
    Zaehler.Gebaude := Gebaude;
    Zaehlerstand := Zaehler.Zaehlerstand;
    BasCloud.ZaehlerList.Item[i1].Zaehlerstand.Copy(Zaehlerstand);
  end;
end;


procedure TAktualDaten.LadeAufgabeDaten_From_BasCloudList_Into_InternList;
var
  Aufgabe: TAufgabe;
  Zaehler: TZaehler;
  i1: Integer;
begin
  for i1 := 0 to BasCloud.AufgabeList.Count -1 do
  begin
    Aufgabe := fAufgabeList.Add(BasCloud.AufgabeList.item[i1].Id);
    BasCloud.AufgabeList.item[i1].Copy(Aufgabe);
    Zaehler := fZaehlerList.getById(BasCloud.AufgabeList.item[i1].ZaehlerId);
    Aufgabe.Zaehler := Zaehler;
  end;
end;

procedure TAktualDaten.UpdateDBZaehlerstand(aZaehler: TZaehler);
begin
  try
    fDBZaehler.DeleteDevice(aZaehler.id);
    fDBZaehler.Init;
    if aZaehler.Gebaude <> nil then
      fDBZaehler.GbId := aZaehler.Gebaude.Id;
    fDBZaehler.DeId  := aZaehler.Id;
    fDBZaehler.Stand := FloatToStr(aZaehler.Zaehlerstand.Zaehlerstand);
    fDBZaehler.Datum := aZaehler.Zaehlerstand.Datum;
    fDBZaehler.Id    := aZaehler.Zaehlerstand.Id;
    fDBZaehler.Insert;

    fDBZaehlerstandbild.save(aZaehler);
  except
    on e: exception do
    begin
      log.d('TAktualDaten.UpdateDBZaehlerstand: ' + e.Message);
    end;
  end;

end;


procedure TAktualDaten.CheckTimer;
var
  Diff: Int64;
begin
  log.d('TAktualDaten.CheckTimer (Start)');
  Diff := MinutesBetween(now, fTimer.LastCheck);
  log.d('Diff: ' + IntToStr(Diff));
  if diff > 10 then
  begin
    log.d('Timer freigeben');
    if Assigned(fTimer) then
      FreeAndNil(fTimer);
    log.d('Timer erzeugen');
    fTimer := TThreadTimer.Create;
    fTimer.Interval := 5000;
    fTimer.OnTimer := Aktual;
    log.d('Timer starten');
    if Assigned(fOnEndRefreshProcess) then
      fOnEndRefreshProcess(Self);
    fTimer.Start;
  end;
  log.d('TAktualDaten.CheckTimer (Ende)');

end;




end.
