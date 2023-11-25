unit Objekt.Logger;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Log4d;

type
  TLogger = class
  private
    fPath: string;
    fLogPath: string;
    fLog: log4d.TLogLogger;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Info(aValue: string);
    procedure Warn(aValue: string);
    procedure Error(aValue: string);
  end;

implementation

{ TLogger }

constructor TLogger.Create;
begin
  fPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if (not FileExists(fPath + 'log4d.props')) then
    raise Exception.Create('Log-Konfigurationsdatei (log4d.props) nicht gefunden');

  TLogPropertyConfigurator.Configure(fPath + 'log4d.props');

  fLogPath := fPath + '\LogFiles\';

  if not DirectoryExists(fLogPath) then
    ForceDirectories(fLogPath);

  fLog := TLogLogger.GetLogger('Energieverbrauch');

  if fLog.Appenders.Count = 1 then
    (fLog.Appenders[0] as ILogRollingFileAppender).renameLogfile(fLogPath + 'Energieverbrauch.log');  //<-- Pfad zuweisen
end;

destructor TLogger.Destroy;
begin

  inherited;
end;

procedure TLogger.Error(aValue: string);
begin
  fLog.Error(aValue);
end;

procedure TLogger.Info(aValue: string);
begin
  fLog.Info(aValue);
end;

procedure TLogger.Warn(aValue: string);
begin
  fLog.Warn(aValue);
end;

end.
