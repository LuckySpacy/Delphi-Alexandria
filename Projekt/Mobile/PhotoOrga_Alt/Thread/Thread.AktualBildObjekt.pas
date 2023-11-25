unit Thread.AktualBildObjekt;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  Objekt.PhotoOrga;


type
  TThreadAktualBildObjekt = class
  private
    fOnEnde: TNotifyEvent;
    procedure Ende(Sender: TObject);
    procedure Lade;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    property OnEnde: TNotifyEvent read fOnEnde write fOnEnde;
  end;

implementation

{ TThreadAktualBildObjekt }

uses
  db.BilderList;

constructor TThreadAktualBildObjekt.Create;
begin

end;

destructor TThreadAktualBildObjekt.Destroy;
begin

  inherited;
end;

procedure TThreadAktualBildObjekt.Ende(Sender: TObject);
begin
  if Assigned(fOnEnde) then
    fOnEnde(Self);
end;

procedure TThreadAktualBildObjekt.Lade;
var
  DBBilderList: TDBBilderList;
begin
  DBBilderList := TDBBilderList.Create;
  try
    DBBilderList.Connection := PhotoOrga.Connection;
    DBBilderList.ReadAllToBilderList;
  finally
    FreeAndNil(DBBilderList);
  end;
end;

procedure TThreadAktualBildObjekt.Start;
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    Lade;
  end
  );
  t.OnTerminate := Ende;
  t.Start;

end;

end.
