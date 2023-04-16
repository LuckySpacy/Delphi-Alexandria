unit Thread.UploadZaehlerstaende;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Objekt.Aufgabe;

type
  TThreadUploadZaehlerstaende = class
  private
    fOnUploadEnde: TNotifyEvent;
    fOnBreakUpload: TNotifyEvent;
    procedure UploadEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DoUploadZaehlerstaende;
    property OnUploadEnde: TNotifyEvent read fOnUploadEnde write fOnUploadEnde;
    property OnBreakUpload: TNotifyEvent read fOnBreakUpload write fOnBreakUpload;
    procedure UploadZaehlerstaende;
  end;


implementation

{ TThreadUploadZaehlerstaende }

uses
  DB.ZaehlerUpdateList, Objekt.Zaehler, DB.ToDo, fmx.Types;

constructor TThreadUploadZaehlerstaende.Create;
begin

end;

destructor TThreadUploadZaehlerstaende.Destroy;
begin

  inherited;
end;

procedure TThreadUploadZaehlerstaende.DoUploadZaehlerstaende;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    UploadZaehlerstaende;
  end
  );
  t.OnTerminate := UploadEnde;
  t.Start;
end;

procedure TThreadUploadZaehlerstaende.UploadEnde(Sender: TObject);
begin
  if Assigned(fOnUploadEnde) then
    fOnUploadEnde(Self);
end;


procedure TThreadUploadZaehlerstaende.UploadZaehlerstaende;
var
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  DBToDo: TDBToDo;
  Zaehler: TZaehler;
  Aufgabe: TAufgabe;
  i1: Integer;
  {$IFDEF WIN32}
  List: TStringList;
  {$ENDIF WIN32}
begin
  {$IFDEF WIN32}
    List := TStringList.Create;
  {$ENDIF WIN32}

  try
    log.d('TThreadUploadZaehlerstaende.UploadZaehlerstaende;');
    DBToDo := TDBToDo.Create;
    DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
    try
      DBZaehlerUpdateList.ReadAll;
      {$IFDEF WIN32}
        List.Add('DBZaehlerUpdateList.Count = ' + IntToStr(DBZaehlerUpdateList.Count));
      {$ENDIF WIN32}
      if DBZaehlerUpdateList.Count > 0 then
      begin
        for i1 := 0 to DBZaehlerUpdateList.Count -1 do
        begin
          if (BasCloud.BreakUpload) and Assigned(fOnBreakUpload) then
          begin
            fOnBreakUpload(self);
            exit;
          end;

          if (DBZaehlerUpdateList.Item[i1].ToDoId = '') and (DBZaehlerUpdateList.Item[i1].DeId > '') then
          begin // Es existiert keine Aufgabe
            Zaehler := BasCloud.ZaehlerList.getById(DBZaehlerUpdateList.Item[i1].DeId);
            if Zaehler = nil then
              continue;
            Zaehler.Zaehlerstand.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
            Zaehler.Zaehlerstand.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
            Zaehler.Zaehlerstand.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
            BasCloud.InitError;
            if Zaehler.Upload then
              DBZaehlerUpdateList.Item[i1].DeleteByZaehler(Zaehler.Id);
            continue;
          end;

          Aufgabe := BasCloud.AufgabeList.getById(DBZaehlerUpdateList.Item[i1].ToDoId);
          if Aufgabe = nil then
          begin
            if DBZaehlerUpdateList.Item[i1].Id > 0 then
              Aufgabe := BasCloud.AufgabeList.getByZuId(DBZaehlerUpdateList.Item[i1].Id);
            if Aufgabe = nil then
              continue;
          end;
          Aufgabe.Zaehler.Zaehlerstand.Zaehlerstand := StrToFloat(DBZaehlerUpdateList.Item[i1].Stand);
          Aufgabe.Zaehler.Zaehlerstand.Datum        := DBZaehlerUpdateList.Item[i1].Datum;
          Aufgabe.Zaehler.Zaehlerstand.LoadBitmapFromStream(DBZaehlerUpdateList.Item[i1].getBildStream);
          BasCloud.InitError;
          if Aufgabe.Upload then
          begin
            if not Aufgabe.AdHoc then
            begin
              DBZaehlerUpdateList.Item[i1].DeleteByAufgabe(Aufgabe.Id);
              DBToDo.Delete(Aufgabe.id);
            end;
            if Aufgabe.AdHoc then
            begin
              DBZaehlerUpdateList.Item[i1].DeleteById(Aufgabe.ZuId);
              Aufgabe.Erledigt := true;
              Aufgabe.WaitForUpload := false;
            end;
            //Aufgabe.Erledigt := true;
            //BasCloud.AufgabeList.DeleteAufgabe(Aufgabe.id);
          end
          else
          begin
            Aufgabe.Erledigt := false;
            Aufgabe.WaitForUpload := true;
          end;
        end;
      end;

      for i1 := 0 to BasCloud.AufgabeList.Count -1 do
      begin
        if (BasCloud.AufgabeList.Item[i1].Erledigt) and (BasCloud.AufgabeList.Item[i1].Anzeigen) then
        begin
         {$IFDEF WIN32}
          List.Add('SetzeAlleUnterDatumAufErledigt' + BasCloud.AufgabeList.Item[i1].Id);
         {$ENDIF WIN32}
          BasCloud.AufgabeList.SetzeAlleUnterDatumAufErledigt(trunc(now), BasCloud.AufgabeList.Item[i1].ZaehlerId);
        end;
      end;

      {$IFDEF WIN32}
        if DirectoryExists('c:\temp') then
          List.SaveToFile('c:\temp\UploadZaehlerstaende.txt');
      {$ENDIF WIN32}


    finally
      FreeAndNil(DBZaehlerUpdateList);
      FreeAndNil(DBToDo);
     {$IFDEF WIN32}
       FreeAndNil(List);
    {$ENDIF WIN32}
    end;
  except
  end;
end;


end.
