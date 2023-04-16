unit Objekt.FPZIni;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Notification, Objekt.Ini;

type
  TFPZIni = class
  private
    fIni: TIni;
    fIniPath: string;
    fIniFilename: string;
    function getLoginMail: string;
    function getLoginPasswort: string;
    procedure setLoginMail(const Value: string);
    procedure setLoginPasswort(const Value: string);
    function getServeradresse: string;
    procedure setServeradresse(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property LoginMail: string read getLoginMail write setLoginMail;
    property LoginPasswort: string read getLoginPasswort write setLoginPasswort;
    property Serveradresse: string read getServeradresse write setServeradresse;
  end;

implementation

{ TFPZIni }

constructor TFPZIni.Create;
begin
  fIni := TIni.Create;
  fIniPath := GetHomePath + PathDelim + 'Documents' + PathDelim;
  if not DirectoryExists(fIniPath) then
    ForceDirectories(fIniPath);
  fIniFilename := fIniPath  +  'FPZ.ini';
end;

destructor TFPZIni.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;

function TFPZIni.getLoginMail: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'EMail', '');
end;

function TFPZIni.getLoginPasswort: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'Passwort', '');
end;


procedure TFPZIni.setLoginMail(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'EMail', Value);
end;

procedure TFPZIni.setLoginPasswort(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'Passwort', Value);
end;

procedure TFPZIni.setServeradresse(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Server', 'Adresse', Value);
end;

function TFPZIni.getServeradresse: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Server', 'Adresse', 'http://localhost:8080/');
end;


end.
