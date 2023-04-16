unit Objekt.JFPZ;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Graphics,
  Communication.API, Json.Error, Json.Login, Objekt.ErrorList, Json.EAN;

type
  TJFPZ = class
  protected
  private
    fCommunication: TCommunicationAPI;
    fEMail: string;
    fPassword: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Login(aEMail, aPassword: string): string;
    function EAN(aEAN: string): string;
    function ErrorList: TErrorList;
    function ALive: string;
    procedure setBaseUrl(aUrl: string);
  end;

var
  JFPZ: TJFPZ;

implementation

{ TJFPZ }


constructor TJFPZ.Create;
begin
  fCommunication := TCommunicationAPI.Create;
end;

destructor TJFPZ.Destroy;
begin
  FreeAndNil(fCommunication);
  inherited;
end;

function TJFPZ.EAN(aEAN: string): string;
var
  JEAN: TJEAN;
  JString: string;
begin
  JEAN := TJEAN.Create;
  try
    JEAN.EAN    := aEAN;
    JString  := JEAN.ToJsonString;
  finally
    FreeAndNil(JEAN);
  end;

  fCommunication.Post('ean', JString);

  Result := fCommunication.ReturnValue;
end;

function TJFPZ.ErrorList: TErrorList;
begin
  Result := fCommunication.ErrorList;
end;

function TJFPZ.Login(aEMail, aPassword: string): string;
var
  Login: TJLogin;
  JString: string;
begin
  Login := TJLogin.Create;
  try
    Login.Benutzer    := aEMail;
    Login.Passwort := aPassword;
    JString  := Login.ToJsonString;
  finally
    FreeAndNil(Login);
  end;

  fCommunication.Post('Login', JString);

  Result := fCommunication.ReturnValue;
end;

procedure TJFPZ.setBaseUrl(aUrl: string);
begin
  if aUrl[Length(aUrl)] <> '/' then
    aUrl := aUrl + '/';
  fCommunication.BaseUrl := aUrl;
end;

function TJFPZ.ALive: string;
begin
  fCommunication.Post('alive', '');
  Result := fCommunication.ReturnValue;
end;


end.
