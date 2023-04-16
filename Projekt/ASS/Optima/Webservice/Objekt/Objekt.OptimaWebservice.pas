unit Objekt.OptimaWebservice;

interface

uses
  SysUtils, Types, Variants, Objekt.IBDIniList;

type
  TOptimaWebservice = class
  private
    fPfad: string;
    fIBDIniList: TIBDIniList;
  public
    constructor Create;
    destructor Destroy; override;
    function IBDIniList: TIBDIniList;
  end;

var
  Ows: TOptimaWebservice;

implementation

{ TOptimaWebservice }

uses
  Objekt.IBDIni, system.IOUtils;

constructor TOptimaWebservice.Create;
begin
  fPfad := TPath.Combine(TPath.GetHomePath, 'OptimaWebservice');
  if not TDirectory.Exists(fPfad) then
    TDirectory.CreateDirectory(fPfad);
  fIBDIniList := TIBDIniList.Create;
  fIBDIniList.IniPfad := fPfad;
  fIBDIniList.Add('Optima');
  fIBDIniList.Add('Bestellung');
end;

destructor TOptimaWebservice.Destroy;
begin
  FreeAndNil(fIBDIniList);
  inherited;
end;


function TOptimaWebservice.IBDIniList: TIBDIniList;
begin
  Result := fIBDIniList;
end;

end.
