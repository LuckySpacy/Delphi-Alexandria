unit Objekt.Energieverbrauch;

interface

uses
  System.SysUtils, Objekt.HostIni, Objekt.ZaehlerList;

type
  TEnergieverbrauch = class
  private
    fHostIni: THostIni;
    fHostConnectionOk: Boolean;
    fZaehlerList: TZaehlerList;
    fToken: string;
  public
    constructor Create;
    destructor Destroy; override;
    property HostIni: THostIni read fHostIni write fHostIni;
    property HostConnectionOk: Boolean read fHostConnectionOk write fHostConnectionOk;
    property ZaehlerList: TZaehlerList read fZaehlerList;
    property Token: string read fToken write fToken;
  end;

var
  Energieverbrauch: TEnergieverbrauch;

implementation

{ THostIni }

constructor TEnergieverbrauch.Create;
begin
  fHostIni := THostIni.Create;
  fHostConnectionOk := false;
  fZaehlerList := TZaehlerList.Create;
end;

destructor TEnergieverbrauch.Destroy;
begin
  FreeAndNil(fHostIni);
  FreeAndNil(fZaehlerList);
  inherited;
end;


end.
