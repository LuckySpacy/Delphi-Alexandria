unit Objekt.HostIni;

interface

uses
  System.SysUtils, Objekt.Ini;

type
  THostIni = class
  private
    fIni: TIni;
    fIniPath: string;
    fIniFilename: string;
    function getHost: string;
    function getPort: Integer;
    procedure setHost(const Value: string);
    procedure setPort(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    property Host: string read getHost write setHost;
    property Port: Integer read getPort write setPort;
  end;


implementation
{ THostIni }

constructor THostIni.Create;
begin
  fIni := TIni.Create;
  fIniPath := GetHomePath + PathDelim + 'Documents' + PathDelim;
  if not DirectoryExists(fIniPath) then
    ForceDirectories(fIniPath);
  fIniFilename := fIniPath  +  'Energieverbrauch.ini';
end;

destructor THostIni.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;


function THostIni.getHost: string;
begin
  Result := Trim(fIni.ReadIni(fIniFilename, 'Remote', 'Host', ''));
end;

function THostIni.getPort: Integer;
begin
  Result := fIni.ReadIniToInt(fIniFilename, 'Remote', 'Port', '0');
end;

procedure THostIni.setHost(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Remote', 'Host', Trim(Value));
end;

procedure THostIni.setPort(const Value: Integer);
begin
  fIni.WriteIni(fIniFilename, 'Remote', 'Port', Value.ToString);
end;

end.
