unit Objekt.Aufgaben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Thread.Timer, Objekt.QueueList, Objekt.Queue, types.PhotoOrga, Thread.AktualThumbnails,
  Thread.AktualBildObjekt;

type
  TIsRunning = class
  private
    fThumbnails: Boolean;
    public
      property Thumbnails: Boolean read fThumbnails write fThumbnails;
  end;

type
  TAufgaben = class
  private
    fTimer: TThreadTimer;
    fThreadAktualThumbnails: TThreadAktualThumbnails;
    fThreadAktualBildObjekt: TThreadAktualBildObjekt;
    fIsRunning: TIsRunning;
    fOnEndAktualThumbnails: TNotifyEvent;
    fOnEndReadAllBilder: TNotifyEvent;
    procedure EndAktualThumbnails(Sender: TObject);
    procedure EndReadAllBilder(Sender: TObject);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure DoTimer(Sender: TObject);
    property OnEndAktualThumbnails: TNotifyEvent read fOnEndAktualThumbnails write fOnEndAktualThumbnails;
    property OnEndReadAllBilder: TNotifyEvent read fOnEndReadAllBilder write fOnEndReadAllBilder;
  end;


implementation

{ TAufgaben }

uses
  Objekt.PhotoOrga, db.BilderList;

constructor TAufgaben.Create;
begin
  fIsRunning := TIsRunning.Create;
  fIsRunning.Thumbnails := false;
  fTimer := TThreadTimer.Create;
  fTimer.OnTimer := DoTimer;
  fThreadAktualThumbnails := TThreadAktualThumbnails.Create;
  fThreadAktualThumbnails.OnEnde := EndAktualThumbnails;
  fThreadAktualBildObjekt := TThreadAktualBildObjekt.Create;
  //PhotoOrga.sendNotification('Das ist eine Testbenachrichtigung');
end;

destructor TAufgaben.Destroy;
begin
  FreeAndNil(fIsRunning);
  FreeAndNil(fThreadAktualThumbnails);
  FreeAndNil(fThreadAktualBildObjekt);
  FreeAndNil(fTimer);
  inherited;
end;

procedure TAufgaben.DoTimer(Sender: TObject);
var
  i1: Integer;
  Queue: TQueue;
  DBBilderList: TDBBilderList;
begin
  fTimer.Stop;
  try
    PhotoOrga.QueueList.DeleteAllMarked;
    if PhotoOrga.QueueList.Count = 0 then
      fTimer.Start;
    for i1 := 0 to PhotoOrga.QueueList.Count -1 do
    begin
      Queue := PhotoOrga.QueueList.Item[i1];
      if (Queue.Process = c_quAktualThumbnails) and (not Queue.Del) then
      begin
        if not fIsRunning.Thumbnails then
        begin
          fIsRunning.Thumbnails := true;
          fThreadAktualThumbnails.Start;
          exit;
        end;
      end;
      if (Queue.Process = c_quReadAllBilder) and (not Queue.Del) then
      begin
        fThreadAktualBildObjekt.OnEnde := EndReadAllBilder;
        fThreadAktualBildObjekt.Start;
      end;
    end;
  finally
    PhotoOrga.QueueList.DeleteAllMarked;
  end;
end;

procedure TAufgaben.EndAktualThumbnails(Sender: TObject);
begin
  fIsRunning.Thumbnails := false;
  PhotoOrga.QueueList.DeleteProcess(c_quAktualThumbnails);
  PhotoOrga.sendNotification('Bilder wurden abgeglichen (Thumbnails)');
  PhotoOrga.QueueList.Add(c_quReadAllBilder);
  fTimer.Start;
  if Assigned(fOnEndAktualThumbnails) then
    fOnEndAktualThumbnails(Self);
end;

procedure TAufgaben.EndReadAllBilder(Sender: TObject);
begin
  PhotoOrga.QueueList.DeleteProcess(c_quReadAllBilder);
  PhotoOrga.sendNotification('Alle Bilder wurden geladen');
  if Assigned(fOnEndReadAllBilder) then
    fOnEndReadAllBilder(Self);
end;

procedure TAufgaben.Start;
begin
  fTimer.Start;
end;

procedure TAufgaben.Stop;
begin
  fTimer.Stop;
end;

end.
