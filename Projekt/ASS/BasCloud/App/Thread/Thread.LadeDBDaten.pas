unit Thread.LadeDBDaten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Objekt.JBasCloud, Objekt.BasCloud,
  FMX.Dialogs, FMX.StdCtrls, Objekt.DBSync, Objekt.LadeDatenFromDB;

type
  TNewInfoEvent = procedure(aInfo: string) of object;
  TThreadLadeDBDaten = class
  private
    fLadeDatenFromDB: TLadeDatenFromDB;
    fStatusLabel: TLabel;
    fOnEndeDatenLaden: TNotifyEvent;
    procedure DatenLadenEnde(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure setStatusLabel(aLabel: TLabel);
    procedure Start;
    property OnEndeDatenLaden: TNotifyEvent read fOnEndeDatenLaden write fOnEndeDatenLaden;
  end;

implementation

{ TThreadLadedaten }

constructor TThreadLadeDBDaten.Create;
begin

end;


destructor TThreadLadeDBDaten.Destroy;
begin

  inherited;
end;

procedure TThreadLadeDBDaten.setStatusLabel(aLabel: TLabel);
begin
  fStatusLabel := aLabel;
end;

procedure TThreadLadeDBDaten.Start;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    BasCloud.GebaudeList.Clear;
    BasCloud.ZaehlerList.Clear;
    BasCloud.AufgabeList.Clear;
    BasCloud.InitError;
    fLadeDatenFromDB := TLadeDatenFromDB.Create;
    try
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Gebäudedaten';
      end);
      fLadeDatenFromDB.Gebaude;
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Zähler';
      end);
      fLadeDatenFromDB.Device; // Zähler
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        fStatusLabel.Text := 'Lade Aufgaben';
      end);
      fLadeDatenFromDB.ToDo;
    finally
      FreeAndNil(fLadeDatenFromDB);
    end;
  end
  );
  t.OnTerminate := DatenLadenEnde;
  t.Start;
end;


procedure TThreadLadeDBDaten.DatenLadenEnde(Sender: TObject);
begin
  if Assigned(fOnEndeDatenLaden) then
    fOnEndeDatenLaden(Self);
end;


end.
