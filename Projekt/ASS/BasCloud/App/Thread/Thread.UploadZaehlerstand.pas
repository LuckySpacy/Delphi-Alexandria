unit Thread.UploadZaehlerstand;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Objekt.Aufgabe, Objekt.Zaehler, db.ZaehlerUpdate, db.ToDo;

type
  TThreadUploadZaehlerstand = class
  private
    fOnUploadEnde: TNotifyEvent;
    fAufgabe: TAufgabe;
    fDBZaehlerUpdate: TDBZaehlerUpdate;
    fDBToDo: TDBToDo;
    fUploadOk: Boolean;
    fBusy: Boolean;
    procedure UploadEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure UploadAufgabe(aAufgabe: TAufgabe);
    procedure UploadZaehler(aZaehler: TZaehler);
    property OnUploadEnde: TNotifyEvent read fOnUploadEnde write fOnUploadEnde;
    property UploadOk: Boolean read fUploadOk;
    property Busy: Boolean read fBusy;
  end;


implementation

{ TThreadUploadZaehlerstand }

constructor TThreadUploadZaehlerstand.Create;
begin
  fAufgabe := nil;
  fBusy := false;
  fDBZaehlerUpdate := TDBZaehlerUpdate.Create;
  fDBToDo := TDBToDo.Create;
end;

destructor TThreadUploadZaehlerstand.Destroy;
begin
  FreeAndNil(fDBZaehlerUpdate);
  FreeAndNil(fDBToDo);
  inherited;
end;

procedure TThreadUploadZaehlerstand.UploadAufgabe(aAufgabe: TAufgabe);
begin
  fAufgabe := aAufgabe;
  UploadZaehler(aAufgabe.Zaehler);
end;

procedure TThreadUploadZaehlerstand.UploadZaehler(aZaehler: TZaehler);
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    fBusy := true;
    if (fAufgabe = nil) then
      fUploadOk := aZaehler.Upload
    else
      fUploadOk := fAufgabe.Upload;

    if not fUploadOk then
      exit;

    fDBZaehlerUpdate.Read(aZaehler.Id);
    if fDBZaehlerUpdate.ToDoId > '' then
      fDBToDo.Delete(fDBZaehlerUpdate.ToDoId);
    fDBZaehlerUpdate.DeleteByZaehler(aZaehler.Id);

  end
  );
  t.OnTerminate := UploadEnde;
  t.Start;
end;


procedure TThreadUploadZaehlerstand.UploadEnde(Sender: TObject);
begin
  fBusy := true;
  if Assigned(fOnUploadEnde) then
    fOnUploadEnde(Self);
end;


end.
