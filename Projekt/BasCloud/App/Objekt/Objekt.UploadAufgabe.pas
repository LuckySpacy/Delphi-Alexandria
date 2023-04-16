unit Objekt.UploadAufgabe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  Thread.UploadAufgabe, Objekt.Aufgabe;

type
  TUploadAufgabe = class
  private
    fAufgabe: TAufgabe;
    fAufgabenlist: TList;
    fThreadUploadAufgabe : TThreadUploadAufgabe;
    fOnCompletelyUploaded: TNotifyEvent;
    fOnBevorAufgabeUpload: TNotifyEvent;
    fOnAfterAufgabeUpload: TNotifyEvent;
    procedure UploadNext;
    procedure UploadEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure setAufgabenList(aAufgabenList: TList);
    procedure Start;
    property OnCompletelyUploaded: TNotifyEvent read fOnCompletelyUploaded write fOnCompletelyUploaded;
    property OnBevorAufgabeUpload: TNotifyEvent read fOnBevorAufgabeUpload write fOnBevorAufgabeUpload;
    property OnAfterAufgabeUpload: TNotifyEvent read fOnAfterAufgabeUpload write fOnAfterAufgabeUpload;
  end;

implementation

{ TUploadAufgabe }

uses
  Objekt.BasCloud;

constructor TUploadAufgabe.Create;
begin
  fAufgabenlist := nil;
  fThreadUploadAufgabe := TThreadUploadAufgabe.Create;
  fThreadUploadAufgabe.OnUploadEnde := UploadEnde;
end;

destructor TUploadAufgabe.Destroy;
begin
  FreeAndNil(fThreadUploadAufgabe);
  inherited;
end;

procedure TUploadAufgabe.setAufgabenList(aAufgabenList: TList);
begin
  fAufgabenlist := aAufgabenList;
end;

procedure TUploadAufgabe.Start;
begin
  UploadNext;
end;

procedure TUploadAufgabe.UploadEnde(Sender: TObject);
begin
  if BasCloud.Error = '' then
    fAufgabe.Erledigt := true;
  if Assigned(fOnAfterAufgabeUpload) then
    fOnAfterAufgabeUpload(fAufgabe);
  if (fAufgabenlist.Count > 0) then
    fAufgabenlist.Delete(0);
  UploadNext;
end;

procedure TUploadAufgabe.UploadNext;
begin
  if (fAufgabenlist.Count = 0) and (Assigned(fOnCompletelyUploaded))  then
  begin
    fOnCompletelyUploaded(Self);
    exit;
  end;
  BasCloud.InitError;
  fAufgabe := TAufgabe(fAufgabenlist.Items[0]);
  if Assigned(fOnBevorAufgabeUpload) then
    fOnBevorAufgabeUpload(fAufgabe);
  try
    fThreadUploadAufgabe.DoUploadAufgabe(fAufgabe);
  except
    on E: Exception do
    begin
      BasCloud.Error := 'Fehler: ' + E.Message;
    end;
  end;
end;

end.
