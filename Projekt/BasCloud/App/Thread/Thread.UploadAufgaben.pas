unit Thread.UploadAufgaben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Objekt.Aufgabe, Objekt.Zaehler, db.ZaehlerUpdate, db.ToDo,
  Thread.UploadZaehlerstand, Objekt.AufgabeList;

type
  TThreadUploadAufgaben = class
  private
    fBusy: Boolean;
    fThreadUploadZaehlerstand: TThreadUploadZaehlerstand;
    fDBZaehlerUpdate: TDBZaehlerUpdate;
    fDBToDo: TDBToDo;
    fOnBevorAufgabeUpload: TNotifyEvent;
    fOnAfterAufgabeUpload: TNotifyEvent;
    fOnUploadEnde: TNotifyEvent;
    procedure UploadEnde(Sender: TObject);
    procedure UploadAufgabe(aAufgabe: TAufgabe);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Upload(aAufgabenList: TList);
    property Busy: Boolean read fBusy;
    property OnBevorAufgabeUpload: TNotifyEvent read fOnBevorAufgabeUpload write fOnBevorAufgabeUpload;
    property OnAfterAufgabeUpload: TNotifyEvent read fOnAfterAufgabeUpload write fOnAfterAufgabeUpload;
    property OnUploadEnde: TNotifyEvent read fOnUploadEnde write fOnUploadEnde;
  end;


implementation

{ TThreadUploadAufgaben }

constructor TThreadUploadAufgaben.Create;
begin
  fBusy := false;
  fDBZaehlerUpdate := TDBZaehlerUpdate.Create;
  fDBToDo := TDBToDo.Create;
  fThreadUploadZaehlerstand := TThreadUploadZaehlerstand.Create;
end;

destructor TThreadUploadAufgaben.Destroy;
begin
  FreeAndNil(fDBZaehlerUpdate);
  FreeAndNil(fDBToDo);
  FreeAndNil(fThreadUploadZaehlerstand);
  inherited;
end;

procedure TThreadUploadAufgaben.Upload(aAufgabenList: TList);
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  var
    i1: Integer;
    Aufgabe: TAufgabe;
  begin
    fBusy := true;
    for i1 := 0 to aAufgabenList.Count -1 do
    begin

      BasCloud.InitError;
      Aufgabe := TAufgabe(aAufgabenList.Items[i1]);
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        if Assigned(fOnBevorAufgabeUpload) then
          fOnBevorAufgabeUpload(Aufgabe);
      end);

      UploadAufgabe(Aufgabe);

      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        if Assigned(fOnAfterAufgabeUpload) then
          fOnAfterAufgabeUpload(Aufgabe);
      end);

    end;
  end
  );
  t.OnTerminate := UploadEnde;
  t.Start;
end;

procedure TThreadUploadAufgaben.UploadAufgabe(aAufgabe: TAufgabe);
var
  Zaehler: TZaehler;
//  i1: Integer;
begin
  Zaehler := aAufgabe.Zaehler;

  if not aAufgabe.Upload then
    exit;

  fDBToDo.Delete(aAufgabe.Id);

  if not aAufgabe.AdHoc then
  begin
    fDBZaehlerUpdate.DeleteByAufgabe(aAufgabe.Id);
    fDBToDo.Delete(aAufgabe.id);
  end;
  if aAufgabe.AdHoc then
  begin
    fDBZaehlerUpdate.DeleteById(aAufgabe.ZuId);
    aAufgabe.Erledigt := true;
    aAufgabe.WaitForUpload := false;
  end;

  BasCloud.AufgabeList.SetzeAlleUnterDatumAufErledigt(trunc(now), Zaehler.Id);

end;

procedure TThreadUploadAufgaben.UploadEnde(Sender: TObject);
begin
  fBusy := false;
  if Assigned(fOnUploadEnde) then
    fOnUploadEnde(Self);
end;



end.
