unit Objekt.IBDIni;

interface

uses
  System.SysUtils, System.Classes, Objekt.Ini;

type
  TIBDIni = class
  private
    fIniPfad: string;
    fName: string;
    fFullFilename: string;
    fIni: TIni;
    procedure setIniPfad(const Value: string);
  public
    function Host: string;
    function Pfad: string;
    function Datenbankname: string;
    property IniPfad: string read fIniPfad write setIniPfad;
    property Name: string read fName write fName;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TIBDIni }

uses
  system.IOUtils;



constructor TIBDIni.Create;
begin
  fIni := TIni.Create;
end;

destructor TIBDIni.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;


function TIBDIni.Datenbankname: string;
begin
  Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Datenbankname', '');
  if Result = '' then
  begin
    fIni.WriteIni(fFullFilename, 'Datenbank ' + Name, 'Datenbankname', 'Demo4.fdb');
    Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Datenbankname', '');
  end;
end;


function TIBDIni.Host: string;
begin
  Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Host', '');
  if Result = '' then
  begin
    fIni.WriteIni(fFullFilename, 'Datenbank ' + Name, 'Host', 'localhost');
    Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Host', '');
  end;
end;

function TIBDIni.Pfad: string;
begin
  Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Pfad', '');
  if Result = '' then
  begin
    fIni.WriteIni(fFullFilename, 'Datenbank ' + Name, 'Pfad', 'c:\Datenbank\');
    Result := fIni.ReadIni(fFullFilename, 'Datenbank ' + Name, 'Pfad', '');
  end;
end;

procedure TIBDIni.setIniPfad(const Value: string);
begin
  fIniPfad := Value;
  fFullFilename := Tpath.Combine(fIniPfad, 'OptimaWebservice.Ini');
end;

end.
