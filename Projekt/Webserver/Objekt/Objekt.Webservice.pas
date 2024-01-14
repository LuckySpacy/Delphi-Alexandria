unit Objekt.Webservice;

interface

uses
  SysUtils, Types, Registry, Variants, Windows, Classes, Objekt.WebserviceIni;

type
  TWebservice = class
  private
    fIni: TWebserviceIni;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Ini: TWebserviceIni read fIni write fIni;

  end;

var
  Webservice: TWebservice;

implementation

{ TWebservice }

constructor TWebservice.Create;
begin //
  fIni := TWebserviceIni.Create;
end;

destructor TWebservice.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;

end.
