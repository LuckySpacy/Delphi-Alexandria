unit Objekt.IniDB;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes,
  Objekt.Ini, Objekt.IniBase;

type
  TIniDB = class(TIniBase)
  private
    function getHost: string;
    function getPort: Integer;
    procedure setHost(const Value: string);
    procedure setPort(const Value: Integer);
    function getPfad: string;
    procedure setPfad(const Value: string);
    function getDatenbankName: string;
    procedure setDatenbankName(const Value: string);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Host: string read getHost write setHost;
    property Port: Integer read getPort write setPort;
    property Pfad: string read getPfad write setPfad;
    property DatenbankName: string read getDatenbankName write setDatenbankName;
  end;

implementation

{ TIniDB }

constructor TIniDB.Create;
begin
  inherited;

end;

destructor TIniDB.Destroy;
begin

  inherited;
end;

function TIniDB.getPfad: string;
begin
  Result := ReadIni(fIniFullname, 'DB', 'Pfad', '');
end;

function TIniDB.getHost: string;
begin
  Result := ReadIni(fIniFullname, 'DB', 'Host', '');
end;

function TIniDB.getDatenbankName: string;
begin
  Result := ReadIni(fIniFullname, 'DB', 'Datenbankname', '');
end;

function TIniDB.getPort: Integer;
begin
  Result := ReadIniInt(fIniFullname, 'DB', 'Port', 0);
end;

procedure TIniDB.setDatenbankName(const Value: string);
begin
  WriteIni(fIniFullname, 'DB', 'Datenbankname', Trim(Value));
end;


procedure TIniDB.setHost(const Value: string);
begin
  WriteIni(fIniFullname, 'DB', 'Host', Trim(Value));
end;

procedure TIniDB.setPfad(const Value: string);
begin
  WriteIni(fIniFullname, 'DB', 'Pfad', Trim(Value));
end;

procedure TIniDB.setPort(const Value: Integer);
begin
  WriteIni(fIniFullname, 'DB', 'Port', Value.ToString);
end;

end.
