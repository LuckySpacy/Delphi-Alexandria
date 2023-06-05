unit Objekt.Aufgaben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Thread.Timer, Objekt.QueueList, Objekt.Queue, types.PhotoOrga,
  Thread.LadeBildListFromDB, Thread.ReadFiles;


type
  TAufgaben = class
  private
    fTimer: TThreadTimer;
    fOnStopTimer: TNotifyEvent;
    fAufgabeBusy: TQueueProcess;
    fPleaseStopTimer: Boolean;
    fThreadLadeBildListFromDB: TThreadLadeBildListFromDB;
    fThreadReadFiles: TThreadReadFiles;
    fOnEndLadeBildListFromDB: TNotifyEvent;
    fOnProgressMaxValue: TNotifyIntEvent;
    fOnProgress: TProgressEvent;
    procedure ProgressMaxValue(aValue: Integer);
    procedure Progress(aIndex: Integer; aValue: string);
    procedure TimerStoped(Sender: TObject);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure DoTimer(Sender: TObject);
    property OnStopTimer: TNotifyEvent read fOnStopTimer write fOnStopTimer;
    property OnEndLadeBildListFromDB: TNotifyEvent read fOnEndLadeBildListFromDB write fOnEndLadeBildListFromDB;
    function TimerRunning: Boolean;
    procedure EndeAufgabe(Sender: TObject);
    procedure EndeLadeBildListFromDB(Sender: TObject);
    procedure LadeBildListFromDB;
    property OnProgressMaxValue: TNotifyIntEvent read fOnProgressMaxValue write fOnProgressMaxValue;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
  end;

implementation

{ TAufgaben }

uses
  objekt.PhotoOrga, Fmx.DialogService;

constructor TAufgaben.Create;
begin
  fPleaseStopTimer := false;
  fAufgabeBusy := c_quNone;
  fTimer := TThreadTimer.Create;
  fTimer.OnTimer := DoTimer;
  fTimer.OnStopTimer := TimerStoped;
  fThreadLadeBildListFromDB := TThreadLadeBildListFromDB.Create;
  fThreadLadeBildListFromDB.OnEnde := EndeLadeBildListFromDB;
  fThreadReadFiles := TThreadReadFiles.Create;
  fThreadReadFiles.OnEnde := EndeAufgabe;
  fThreadReadFiles.OnProgress := Progress;
  fThreadReadFiles.OnProgressMaxValue := ProgressMaxValue;
end;

destructor TAufgaben.Destroy;
begin
  FreeAndNil(fThreadLadeBildListFromDB);
  FreeAndNil(fThreadReadFiles);
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
    if fAufgabeBusy <> TQueueProcess.c_quNone then
      exit;
    for i1 := 0 to PhotoOrga.QueueList.Count -1 do
    begin
      Queue := PhotoOrga.QueueList.Item[i1];

      if (Queue.Process = c_quLadeBilderFromDB) and (not Queue.Del) then
      begin
        fAufgabeBusy := TQueueProcess.c_quLadeBilderFromDB;
        fThreadLadeBildListFromDB.Start;
      end;

      if (Queue.Process = c_quReadFiles) and (not Queue.Del) then
      begin
        //TDialogService.ShowMessage('ReadFiles');
        fAufgabeBusy := TQueueProcess.c_quReadFiles;
        fThreadReadFiles.Start;
      end;
      if (Queue.Process = c_quReadAllBilder) and (not Queue.Del) then
      begin
        fAufgabeBusy := TQueueProcess.c_quReadAllBilder;
      end;
    end;
  finally
    PhotoOrga.QueueList.DeleteAllMarked;
  end;
end;


procedure TAufgaben.EndeAufgabe(Sender: TObject);
begin
  fAufgabeBusy := TQueueProcess.c_quNone;
  if fPleaseStopTimer then
    fTimer.Stop;
end;

procedure TAufgaben.EndeLadeBildListFromDB(Sender: TObject);
begin
  fAufgabeBusy := TQueueProcess.c_quNone;
  if Assigned(fOnEndLadeBildListFromDB) then
    fOnEndLadeBildListFromDB(Self);
end;

procedure TAufgaben.LadeBildListFromDB;
begin
  fAufgabeBusy := TQueueProcess.c_quLadeBilderFromDB;
  fThreadLadeBildListFromDB.Start;
end;

procedure TAufgaben.Progress(aIndex: Integer; aValue: string);
begin
  exit;
  if Assigned(fOnProgress) then
  begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fOnProgress(aIndex, aValue);
    end);
  end;
end;

procedure TAufgaben.ProgressMaxValue(aValue: Integer);
begin
  exit;
  if Assigned(fOnProgressMaxValue) then
  begin
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      fOnProgressMaxValue(aValue);
    end);
  end;
end;

procedure TAufgaben.Start;
begin
  fTimer.Start;
end;

procedure TAufgaben.Stop;
begin
  if fAufgabeBusy = TQueueProcess.c_quNone  then
  begin
    fTimer.Stop;
    exit;
  end;
  fPleaseStopTimer := true;
  if fAufgabeBusy = TQueueProcess.c_quLadeBilderFromDB then
    fThreadLadeBildListFromDB.Stop := true;
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
