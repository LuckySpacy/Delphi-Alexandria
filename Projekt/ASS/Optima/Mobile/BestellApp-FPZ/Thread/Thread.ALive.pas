unit Thread.ALive;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs;

type
  TThreadALive = class
  private
    fOnSuccess: TNotifyEvent;
    fOnFailed: TNotifyEvent;
    procedure Ende(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Check;
    property OnSuccess: TNotifyEvent read fOnSuccess write fOnSuccess;
    property OnFailed: TNotifyEvent read fOnFailed write fOnFailed;
  end;

implementation

{ TThreadALive }

uses
  Objekt.JFPZ;


constructor TThreadALive.Create;
begin

end;

destructor TThreadALive.Destroy;
begin

  inherited;
end;

procedure TThreadALive.Ende(Sender: TObject);
begin
  if (JFPZ.ErrorList.Count = 0) and (Assigned(fOnFailed)) then
  begin
    fOnFailed(Self);
    exit;
  end;
  if (JFPZ.ErrorList.ConnectToServerError) and (Assigned(fOnFailed)) then
  begin
    fOnFailed(Self);
    exit;
  end;

  if (JFPZ.ErrorList.Item[0].Status = 'OK') and (Assigned(fOnSuccess)) then
    fOnSuccess(Self);

end;

procedure TThreadALive.Check;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    JFPZ.Alive;
  end
  );
  t.OnTerminate := Ende;
  t.Start;
end;



end.
