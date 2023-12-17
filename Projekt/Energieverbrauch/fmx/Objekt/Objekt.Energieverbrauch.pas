unit Objekt.Energieverbrauch;

interface

uses
  System.SysUtils, Objekt.HostIni, Objekt.JZaehlerList;

type
  TEnergieverbrauch = class
  private
    fHostIni: THostIni;
    fHostConnectionOk: Boolean;
    fJZaehlerList: TJZaehlerlist;
  public
    constructor Create;
    destructor Destroy; override;
    property HostIni: THostIni read fHostIni write fHostIni;
    property HostConnectionOk: Boolean read fHostConnectionOk write fHostConnectionOk;
    property ZaehlerList: TJZaehlerlist read fJZaehlerList;
  end;

var
  Energieverbrauch: TEnergieverbrauch;

implementation

{ THostIni }

constructor TEnergieverbrauch.Create;
begin
  fHostIni := THostIni.Create;
  fHostConnectionOk := false;
  fJZaehlerList := TJZaehlerList.Create;
end;

destructor TEnergieverbrauch.Destroy;
begin
  FreeAndNil(fHostIni);
  FreeAndNil(fJZaehlerList);
  inherited;
end;


end.
