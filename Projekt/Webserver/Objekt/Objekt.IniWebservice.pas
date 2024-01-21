unit Objekt.IniWebservice;

interface

uses
  SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.IniBase;

type
  TIniWebservice = class(TIniBase)
  private
    function getPort: Integer;
    procedure setPort(const Value: Integer);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Port: Integer read getPort write setPort;
  end;

implementation

{ TIniWebservice }

constructor TIniWebservice.Create;
begin
  inherited;
  fSection := 'Webservice';
end;

destructor TIniWebservice.Destroy;
begin

  inherited;
end;

function TIniWebservice.getPort: Integer;
begin
  Result := StrToInt(ReadIni(fIniFullname, fSection, 'Port', '0'));
end;

procedure TIniWebservice.setPort(const Value: Integer);
begin
  WriteIni(fIniFullname, fSection, 'Port', Value.ToString);
end;

end.
