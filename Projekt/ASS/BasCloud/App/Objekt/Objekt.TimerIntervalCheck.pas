unit Objekt.TimerIntervalCheck;

interface

uses
  System.SysUtils, System.Classes;

type
  TTimerIntervalCheck = class
  private
    fUploadZaehlerstaende: Integer;
    fNeueAufgaben: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property NeueAufgaben: Integer read fNeueAufgaben;
    property UploadZaehlerstaende: Integer read fUploadZaehlerstaende;
  end;

implementation

{ TimerIntervalCheck }

constructor TTimerIntervalCheck.Create;
begin
  fNeueAufgaben   := 20; // Minuten
  fUploadZaehlerstaende := 1; // Minuten
end;

destructor TTimerIntervalCheck.Destroy;
begin

  inherited;
end;

end.
