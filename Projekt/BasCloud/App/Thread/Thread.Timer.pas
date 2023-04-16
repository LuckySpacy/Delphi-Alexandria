unit Thread.Timer;

interface

uses
  System.SysUtils, System.Classes;

type
  TThreadTimer = class
  private
    fInterval: Integer;
    fStop: Boolean;
    fOnTimer: TNotifyEvent;
    fOnStopTimer: TNotifyEvent;
    fTimerRunning: Boolean;
    fLastCheck: TDateTime;
    procedure StartTimer;
    procedure EndTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property Interval: Integer read fInterval write fInterval;
    property OnTimer: TNotifyEvent read fOnTimer write fOnTimer;
    property OnStopTimer: TNotifyEvent read fOnStopTimer write fOnStopTimer;
    property LastCheck: TDateTime read fLastCheck write fLastCheck;
    function TimerRunning: Boolean;
  end;

implementation

{ TThreadTimer }

uses
  DateUtils, fmx.Types;

constructor TThreadTimer.Create;
begin
  fInterval := 1000;
  fStop := false;
  fTimerRunning := false;
  fLastCheck := now;
end;

destructor TThreadTimer.Destroy;
begin
  log.d('TThreadTimer.Destroy');
  inherited;
end;


procedure TThreadTimer.Start;
begin
  log.d('TThreadTimer.Start');
  fStop := false;
  if not fTimerRunning then
    StartTimer;
end;


procedure TThreadTimer.StartTimer;
var
  t: TThread;
begin
  log.d('TThreadTimer.StartTimer');
  t := TThread.CreateAnonymousThread(
  procedure
  var
    Ende: TDateTime;
  begin
    fTimerRunning := true;
    Ende := IncMilliSecond(now, fInterval);
    while not fStop do
    begin
      while now < Ende do
      begin
        //log.d('Bevor Sleep');
        Sleep(5000);
        //log.d('After Sleep');
        fLastCheck := now;
        if fStop then
          exit;
      end;
      if Assigned(fOnTimer) then
        fOnTimer(Self);
      {
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        if Assigned(fOnTimer) then
          fOnTimer(nil);
      end);
      }

      Ende := IncMilliSecond(now, fInterval);
    end;
  end
  );
  t.OnTerminate := EndTimer;
  t.Start;

end;

procedure TThreadTimer.EndTimer(Sender: TObject);
begin
  log.d('TThreadTimer.EndTimer');
  fTimerRunning := false;
  if Assigned(fOnStopTimer) then
    fOnStopTimer(nil);
end;



procedure TThreadTimer.Stop;
begin
  log.d('TThreadTimer.Stop');
  fStop := true;
end;

function TThreadTimer.TimerRunning: Boolean;
begin
  Result := fTimerRunning;
end;

end.
