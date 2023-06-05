unit Objekt.IniFirebird;

interface

uses
  IniFiles, SysUtils, Types, Variants, Classes,
  Objekt.Ini, Objekt.IniBase;

type
  TIniFirebird = class(TIniBase)
  private
    function getDatenbankname: string;
    function getDatenbankpfad: string;
    function getHost: string;
    function getPasswort: string;
    function getUsername: string;
    procedure setDatenbankname(const Value: string);
    procedure setDatenbankpfad(const Value: string);
    procedure setHost(const Value: string);
    procedure setPasswort(const Value: string);
    procedure setUsername(const Value: string);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Datenbankname: string read getDatenbankname write setDatenbankname;
    property Host: string read getHost write setHost;
    property Datenbankpfad: string read getDatenbankpfad write setDatenbankpfad;
    property Username: string read getUsername write setUsername;
    property Passwort: string read getPasswort write setPasswort;
  end;

implementation

{ TIniFirebird }

constructor TIniFirebird.Create;
begin
  inherited;
  fSection := 'Firebird';
end;

destructor TIniFirebird.Destroy;
begin

  inherited;
end;

function TIniFirebird.getDatenbankname: string;
begin
  Result := ReadIni(fIniFullName, fSection, 'Datenbankname', '');
end;

function TIniFirebird.getDatenbankpfad: string;
begin
  Result := ReadIni(fIniFullName, fSection, 'Datenbankpfad', '');
end;

function TIniFirebird.getHost: string;
begin
  Result := ReadIni(fIniFullName, fSection, 'Host', '');
end;

function TIniFirebird.getPasswort: string;
begin
  Result := ReadIni(fIniFullName, fSection, 'Passwort', '');
end;

function TIniFirebird.getUsername: string;
begin
  Result := ReadIni(fIniFullName, fSection, 'Username', '');
end;

procedure TIniFirebird.setDatenbankname(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Datenbankname', Value);
end;

procedure TIniFirebird.setDatenbankpfad(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Datenbankpfad', Value);
end;

procedure TIniFirebird.setHost(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Host', Value);
end;

procedure TIniFirebird.setPasswort(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Passwort', Value);
end;

procedure TIniFirebird.setUsername(const Value: string);
begin
  WriteIni(fIniFullname, fSection, 'Username', Value);
end;

end.
