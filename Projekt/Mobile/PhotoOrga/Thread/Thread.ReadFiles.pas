unit Thread.ReadFiles;

interface

uses
  System.SysUtils, System.Classes, FMX.Graphics, Objekt.ReadFilesToDB, types.PhotoOrga;


type
  TThreadReadFiles = class
  private
    fOnEnde: TNotifyEvent;
    fStop: Boolean;
    fReadFilesToDB: TReadFilesToDB;
    fOnProgressMaxValue: TNotifyIntEvent;
    fOnProgress: TProgressEvent;
    procedure ReadFiles;
    procedure Ende(Sender: TObject);
    procedure setStop(const Value: Boolean);
    procedure ProgressMaxValue(aValue: Integer);
    procedure Progress(aIndex: Integer; aValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property OnEnde: TNotifyEvent read fOnEnde write fOnEnde;
    procedure Start;
    property Stop: Boolean read fStop write setStop;
    property OnProgressMaxValue: TNotifyIntEvent read fOnProgressMaxValue write fOnProgressMaxValue;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
  end;


implementation

{ TThreadReadFiles }

constructor TThreadReadFiles.Create;
begin
  fReadFilesToDB := TReadFilesToDB.Create;
  fReadFilesToDB.OnProgress := Progress;
  fReadFilesToDB.OnProgressMaxValue := ProgressMaxValue;
end;

destructor TThreadReadFiles.Destroy;
begin
  FreeAndNil(fReadFilesToDB);
  inherited;
end;

procedure TThreadReadFiles.Ende(Sender: TObject);
begin
  if Assigned(fOnEnde) then
    fOnEnde(nil);
end;

procedure TThreadReadFiles.Progress(aIndex: Integer; aValue: string);
begin
  if Assigned(fOnProgress) then
    fOnProgress(aIndex, aValue);
end;

procedure TThreadReadFiles.ProgressMaxValue(aValue: Integer);
begin
  if Assigned(fOnProgressMaxValue) then
    fOnProgressMaxValue(aValue);
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
