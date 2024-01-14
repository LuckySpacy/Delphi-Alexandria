unit Objekt.IniDatenbanken;

interface

uses
  SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.IniDB;

type
  TIniDatenbanken = class
  private
    fEnergieverbrauch: TIniDB;
    fToken: TIniDB;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Token: TIniDB read fToken write fToken;
    property Energieverbrauch: TIniDB read fEnergieverbrauch write fEnergieverbrauch;
  end;

implementation

{ TIniDatenbanken }

constructor TIniDatenbanken.Create;
begin
  fEnergieverbrauch := TIniDB.Create;
  fEnergieverbrauch.Section := 'Energieverbrauch';
  fToken := TIniDB.Create;
  fToken.Section := 'Token';
end;

destructor TIniDatenbanken.Destroy;
begin
  FreeAndNil(fEnergieverbrauch);
  FreeAndNil(fToken);
  inherited;
end;

end.
