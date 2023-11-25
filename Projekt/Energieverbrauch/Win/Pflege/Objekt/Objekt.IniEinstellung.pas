unit Objekt.IniEinstellung;

interface

uses
  IniFiles, SysUtils, Types, Registry, Variants, Windows, Classes,
  Objekt.Ini, Objekt.IniBase;

type
  TIniEinstellung = class(TIniBase)
  private
    function getHost: string;
    function getPort: Integer;
    procedure setHost(const Value: string);
    procedure setPort(const Value: Integer);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Host: string read getHost write setHost;
    property Port: Integer read getPort write setPort;
  end;

implementation

{ TIniEinstellung }

constructor TIniEinstellung.Create;
begin
  inherited;

end;

destructor TIniEinstellung.Destroy;
begin

  inherited;
end;

function TIniEinstellung.getHost: string;
begin
  Result := ReadIni(fIniFullname, 'Remote', 'Host', '');
end;

function TIniEinstellung.getPort: Integer;
begin
  Result := ReadIniInt(fIniFullname, 'Remote', 'Port', 0);
end;

procedure TIniEinstellung.setHost(const Value: string);
begin
  WriteIni(fIniFullname, 'Remote', 'Host', Trim(Value));
end;

procedure TIniEinstellung.setPort(const Value: Integer);
begin
  WriteIni(fIniFullname, 'Remote', 'Port', Value.ToString);
end;

end.
