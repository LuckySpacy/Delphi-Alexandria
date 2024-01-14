unit Objekt.WebserviceIni;

interface

uses
  SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.IniDatenbanken;

type
  TWebserviceIni = class
  private
    fDatenbanken: TIniDatenbanken;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Datenbanken: TIniDatenbanken read fDatenbanken write fDatenbanken;
  end;


implementation

{ TWebserviceIni }

constructor TWebserviceIni.Create;
begin
  fDatenbanken := TIniDatenbanken.Create;
end;

destructor TWebserviceIni.Destroy;
begin
  FreeAndNil(fDatenbanken);
  inherited;
end;

end.
