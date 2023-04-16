unit Objekt.Aufgabe;

interface

uses
  System.SysUtils, System.Classes, Objekt.Zaehler;

type
  TAufgabe = class
  private
    fId: string;
    fDatum: TDateTime;
    fZaehlerId: string;
    fNotiz: string;
    fStatus: string;
    fTaskId: string;
    fZaehler: TZaehler;
    fWaitForUpload: Boolean;
    fErledigt: Boolean;
    fAnzeigen: Boolean;
    fZuId: Integer;
    fAdHoc: Boolean;
    fInUpload: Boolean;
    fUploaded: Boolean;
    fListViewSortStr: string;
    procedure setErledigt(const Value: Boolean);
    procedure setDatum(const Value: TDateTime);
    procedure setListViewSortStr;
    procedure setId(const Value: string);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Id: string read fId write setId;
    property ZuId: Integer read fZuId write fZuId;
    property AdHoc: Boolean read fAdHoc write fAdHoc;
    property Zaehler: TZaehler read fZaehler write fZaehler;
    property ZaehlerId: string read fZaehlerId write fZaehlerId;
    property Datum: TDateTime read fDatum write setDatum;
    property Notiz: string read fNotiz write fNotiz;
    property Status: string read fStatus write fStatus;
    property TaskId: string read fTaskId write fTaskId;
    property WaitForUpload: Boolean read fWaitForUpload write fWaitForUpload;
    property InUpload: Boolean read fInUpload write fInUpload;
    property Uploaded: Boolean read fUploaded write fUploaded;
    property Erledigt: Boolean read fErledigt write setErledigt;
    property Anzeigen: Boolean read fAnzeigen write fAnzeigen;
    property ListViewSortStr: string read fListViewSortStr;
    procedure Init;
    function Upload: Boolean;
    procedure InsertInZaehlerUpdate;
    function DarfAufgabeErledigtWerden: Boolean;
    procedure Copy(aAufgabe: TAufgabe);
  end;

implementation

{ TAufgabe }

uses
  Objekt.BasCloud, Objekt.JBasCloud, DB.ZaehlerUpdate;


constructor TAufgabe.Create;
begin
  Init;
end;

destructor TAufgabe.Destroy;
begin
  inherited;
end;

procedure TAufgabe.Init;
begin
  fDatum     := 0;
  fZaehlerId := '';
  fNotiz     := '';
  fStatus    := '';
  fTaskId    := '';
  fZaehlerId := '';
  fZuId      := 0;
  fZaehler := nil;
  fWaitForUpload := false;
  fErledigt := false;
  fAnzeigen := false;
  fAdHoc := false;
  fInUpload := false;
  fUploaded := false;
  fListViewSortStr := '';
end;

procedure TAufgabe.Copy(aAufgabe: TAufgabe);
begin
  aAufgabe.Datum     := fDatum;
  aAufgabe.ZaehlerId := fZaehlerId;
  aAufgabe.Notiz     := fNotiz;
  aAufgabe.Status    := fStatus;
  aAufgabe.TaskId    := fTaskId;
  aAufgabe.ZuId      := fZuid;
  aAufgabe.WaitForUpload := fWaitForUpload;
  aAufgabe.Erledigt := fErledigt;
  aAufgabe.Anzeigen := fAnzeigen;
  aAufgabe.AdHoc   := fAdHoc;
  aAufgabe.InUpload := fInUpload;
  aAufgabe.Uploaded := fUploaded;
end;


function TAufgabe.Upload: Boolean;
var
  EventAsDoneGesetzt: Boolean;
begin
  Result := false;
  try
    if Bascloud.Error > '' then
      exit;
    EventAsDoneGesetzt := false;
    if fZaehler = nil then // Zur Sicherheit
      exit;
    Result := fZaehler.Upload;
    if not Result then
      exit;
    WaitForUpload := false;
    if (not fAdHoc) and (DarfAufgabeErledigtWerden) then
    begin
      JBasCloud.setEventAsDone(fid);
      EventAsDoneGesetzt := true;
    end;
    if fAdHoc then
      EventAsDoneGesetzt := true;

    Result := BasCloud.Error = '';
    fErledigt := (Result) and (EventAsDoneGesetzt) ; // In Form.Aufgabe (FormIsActivate) werden alle erledigten Aufgaben aus der Liste entfernt
    if fErledigt then
      BasCloud.AufgabeList.SetzeAlleUnterDatumAufErledigt(trunc(now), fZaehler.Id);
  except
    on E: Exception do
    begin
      BasCloud.Error := 'Fehler: ' + E.Message;
    end;
  end;
end;



procedure TAufgabe.setListViewSortStr;
begin
  fListViewSortStr := FormatDateTime('yyyymmdd', fDatum) + ' ' + fId;
end;

procedure TAufgabe.InsertInZaehlerUpdate;
begin
  fZaehler.InsertInZaehlerUpdate(fId);
  fWaitForUpload := true;
end;

procedure TAufgabe.setDatum(const Value: TDateTime);
begin
  fDatum := Value;
  setListViewSortStr;
end;

procedure TAufgabe.setErledigt(const Value: Boolean);
begin
  fErledigt := Value;
  //if fErledigt then
  //  fWaitForUpload := false;
end;


procedure TAufgabe.setId(const Value: string);
begin
  fId := Value;
  setListViewSortStr;
end;

function TAufgabe.DarfAufgabeErledigtWerden: Boolean;
begin
  Result := trunc(fDatum) <= trunc(now) + BasCloud.AufgabeKarrenztage
end;

{
procedure TAufgabe.InsertInZaehlerUpdate;
var
  DBZaehlerUpdate: TDBZaehlerUpdate;
  ms: TMemoryStream;
begin
  try
    ms := TMemoryStream.Create;
    DBZaehlerUpdate := TDBZaehlerUpdate.Create;
    try
      DBZaehlerUpdate.DeleteByAufgabe(fid);
      DBZaehlerUpdate.Stand := CurrToStr(fZaehler.ZaehlerstandNeu.Zaehlerstand);
      DBZaehlerUpdate.Datum := fZaehler.ZaehlerstandNeu.Datum;
      DBZaehlerUpdate.DeId  := fZaehler.id;
      DBZaehlerUpdate.GbId  := fZaehler.Gebaude.Id;
      DBZaehlerUpdate.ToDoId := fId;
      fZaehler.ZaehlerstandNeu.Image.Bitmap.SaveToStream(ms);
      DBZaehlerUpdate.setBild(ms);
      DBZaehlerUpdate.ImportDatum := 0;
      DBZaehlerUpdate.Insert;
      fWaitForUpload := true;
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
}

end.
