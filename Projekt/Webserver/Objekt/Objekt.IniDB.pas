unit Objekt.IniDB;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes,
  Objekt.Ini, Objekt.IniBase;

type
  TIniDB = class(TIniBase)
  private
    fSection: string;
    function getHost: string;
    function getPort: Integer;
    procedure setHost(const Value: string);
    procedure setPort(const Value: Integer);
    function getPfad: string;
    procedure setPfad(const Value: string);
    function getDatenbankName: string;
    procedure setDatenbankName(const Value: string);
    function getAktiv: Boolean;
    procedure setAktiv(const Value: Boolean);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Host: string read getHost write setHost;
    property Port: Integer read getPort write setPort;
    property Pfad: string read getPfad write setPfad;
    property Aktiv: Boolean read getAktiv write setAktiv;
    property DatenbankName: string read getDatenbankName write setDatenbankName;
    property Section: string read fSection write fSection;
  end;

implementation

{ TIniDB }

constructor TIniDB.Create;
begin
  inherited;
  fSection := 'DB';

end;

destructor TIniDB.Destroy;
begin

  inherited;
end;

function TIniDB.getPfad: string;
begin
  Result := ReadIni(fIniFullname, fSection, 'Pfad', '');
end;

function TIniDB.getHost: string;
begin
  Result := ReadIni(fIniFullname, fSection, 'Host', '');
end;

function TIniDB.getAktiv: Boolean;
begin
  Result := ReadIni(fIniFullname, fSection, 'Aktiv', '') = 'T';
end;

function TIniDB.getDatenbankName: string;
begin
  Result := ReadIni(fIniFullname, fSection, 'Datenbankname', '');
end;

function TIniDB.getPort: Integer;
begin
  Result := ReadIniInt(fIniFullname, fSection, 'Port', 0);
end;

procedure TIniDB.setAktiv(const Value: Boolean);
begin
  if Value then
    WriteIni(fIniFullname, fSection, 'Aktiv', 'T')
  else
    WriteIni(fIniFullname, fSection, 'Aktiv', 'F');
end;

procedure TIniDB.setDatenbankName(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Datenbankname', Trim(Value));
end;


procedure TIniDB.setHost(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Host', Trim(Value));
end;

procedure TIniDB.setPfad(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Pfad', Trim(Value));
end;

procedure TIniDB.setPort(const Value: Integer);
begin
  WriteIni(fIniFullname, fSection, 'Port', Value.ToString);
end;

end.
