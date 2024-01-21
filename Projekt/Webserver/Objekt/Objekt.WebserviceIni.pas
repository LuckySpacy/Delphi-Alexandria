unit Objekt.WebserviceIni;

interface

uses
  SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.IniDatenbanken,
  Objekt.Ini, Objekt.IniWebservice;

type
  TWebserviceIni = class
  private
    fDatenbanken: TIniDatenbanken;
    fWebservice: TIniWebservice;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Datenbanken: TIniDatenbanken read fDatenbanken write fDatenbanken;
    property Webservice : TIniWebservice read fWebservice  write fWebservice;
  end;


implementation

{ TWebserviceIni }

constructor TWebserviceIni.Create;
begin
  fDatenbanken := TIniDatenbanken.Create;
  fWebservice := TIniWebservice.Create;
end;

destructor TWebserviceIni.Destroy;
begin
  FreeAndNil(fWebservice);
  FreeAndNil(fDatenbanken);
  inherited;
end;


end.
