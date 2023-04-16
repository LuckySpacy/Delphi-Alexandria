unit Objekt.Aufgaben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Thread.Timer, Objekt.QueueList, Objekt.Queue, types.PhotoOrga;


type
  TAufgaben = class
  private
    fTimer: TThreadTimer;
    fOnStopTimer: TNotifyEvent;
    procedure TimerStoped(Sender: TObject);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure DoTimer(Sender: TObject);
    property OnStopTimer: TNotifyEvent read fOnStopTimer write fOnStopTimer;
    function TimerRunning: Boolean;
  end;

implementation

{ TAufgaben }

uses
  objekt.PhotoOrga;

constructor TAufgaben.Create;
begin
  fTimer := TThreadTimer.Create;
  fTimer.OnTimer := DoTimer;
  fTimer.OnStopTimer := TimerStoped;
end;

destructor TAufgaben.Destroy;
begin
  FreeAndNil(fTimer);
  inherited;
end;

procedure TAufgaben.DoTimer(Sender: TObject);
var
  i1: Integer;
  Queue: TQueue;
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
      end;
      if (Queue.Process = c_quReadAllBilder) and (not Queue.Del) then
      begin
      end;
    end;
  finally
    PhotoOrga.QueueList.DeleteAllMarked;
  end;
end;


procedure TAufgaben.Start;
begin
  fTimer.Start;
end;

procedure TAufgaben.Stop;
begin
  fTimer.Stop;
end;

function TAufgaben.TimerRunning: Boolean;
begin
  Result := fTimer.TimerRunning;
end;

procedure TAufgaben.TimerStoped(Sender: TObject);
begin
  if Assigned(fOnStopTimer) then
    fOnStopTimer(Self);
end;

end.
