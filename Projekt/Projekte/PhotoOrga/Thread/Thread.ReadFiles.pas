unit Thread.ReadFiles;

interface

uses
  System.SysUtils, System.Classes, FMX.Graphics, Objekt.ReadFilesToDB;


type
  TThreadReadFiles = class
  private
    fOnEnde: TNotifyEvent;
    fStop: Boolean;
    fReadFilesToDB: TReadFilesToDB;
    procedure ReadFiles;
    procedure Ende(Sender: TObject);
    procedure setStop(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property OnEnde: TNotifyEvent read fOnEnde write fOnEnde;
    procedure Start;
    property Stop: Boolean read fStop write setStop;
  end;


implementation

{ TThreadReadFiles }

constructor TThreadReadFiles.Create;
begin
  fReadFilesToDB := TReadFilesToDB.Create;
end;

destructor TThreadReadFiles.Destroy;
begin
  FreeAndNil(fReadFilesToDB);
  inherited;
end;

procedure TThreadReadFiles.Ende(Sender: TObject);
begin

end;

procedure TThreadReadFiles.ReadFiles;
begin
  fReadFilesToDB.Start
end;

procedure TThreadReadFiles.setStop(const Value: Boolean);
begin
  fStop := Value;
  fReadFilesToDB.Stop := Value;
end;

procedure TThreadReadFiles.Start;
var
  t: TThread;
begin
  fStop := false;
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    ReadFiles;
  end
  );
  t.OnTerminate := Ende;
  t.Start;
end;

end.
