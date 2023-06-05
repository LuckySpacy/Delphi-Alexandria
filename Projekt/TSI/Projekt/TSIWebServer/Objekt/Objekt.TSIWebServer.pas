unit Objekt.TSIWebServer;

interface

uses
  IniFiles, Types, Variants, Classes,
  Objekt.IniFirebird, System.SysUtils;

type
  TTSIWebServer = class
  private
    fPfad: string;
    fFirebird: TIniFirebird;
    fTSI: TIniFirebird;
    fKurse: TIniFirebird;
    procedure setPfad(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Firebird: TIniFirebird;
    function TSI: TIniFirebird;
    function Kurse: TIniFirebird;
    property Pfad: string read fPfad write setPfad;
  end;

var
  TSIWebserver: TTSIWebserver;

implementation

{ TTSIWebServer }

constructor TTSIWebServer.Create;
begin
  fFirebird := TIniFirebird.Create;
  fTSI := TIniFirebird.Create;
  fTSI.Section := 'Firbird_TSI';
  fKurse := TIniFirebird.Create;
  fKurse.Section := 'Firebird_Kurse';
  setPfad(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))));
end;

destructor TTSIWebServer.Destroy;
begin
  FreeAndNil(fFireBird);
  FreeAndNil(fTSI);
  FreeAndNil(fKurse);
  inherited;
end;

function TTSIWebServer.Firebird: TIniFirebird;
begin
  Result := Firebird;
end;

function TTSIWebServer.Kurse: TIniFirebird;
begin
  Result := fKurse;
end;

procedure TTSIWebServer.setPfad(const Value: string);
begin
  fPfad := Value;
  fFireBird.Pfad := fPfad;
  fFireBird.IniFullname := IncludeTrailingPathDelimiter(fPfad) + 'TSIWebServer.Ini';
  fTSI.IniFullname := IncludeTrailingPathDelimiter(fPfad) + 'TSIWebServer.Ini';
  fKurse.IniFullname := IncludeTrailingPathDelimiter(fPfad) + 'TSIWebServer.Ini';
end;

function TTSIWebServer.TSI: TIniFirebird;
begin
  Result := fTSI;
end;

end.
