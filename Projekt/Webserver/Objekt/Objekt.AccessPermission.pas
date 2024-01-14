unit Objekt.AccessPermission;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.JsonWebToken, Web.HTTPApp, IdHTTPWebBrokerBridge, IdHTTPHeaderInfo,
  Json.ErrorList;

    {
type
  TIdHTTPAppRequestHelper = class helper for TIdHTTPAppRequest
  public
    function GetRequestInfo: TIdEntityHeaderInfo;
  end;
    }
type
  TAccessPermission = class
  private
    fJWT: TJsonWebToken;
  public
    constructor Create;
    destructor Destroy; override;
    function getBearerToken(aValue: string): string;
    function CheckToken(aToken: string): string;
  end;

implementation

{ TAccessPermission }

uses
  Objekt.Webservice, DB.Token, Datenmodul.Database;

constructor TAccessPermission.Create;
begin
  fJWT := TJsonWebToken.Create;
  fJWT.Schluessel := 'M80g7Zs3YNlg42ta8b4JmpzfIorR31PT4M';
end;

destructor TAccessPermission.Destroy;
begin
  FreeAndNil(fJWT);
  inherited;
end;

function TAccessPermission.getBearerToken(aValue: string): string;
begin
  Result := Trim(StringReplace(aValue, 'Bearer', '', [rfReplaceAll]));
end;

function TAccessPermission.CheckToken(aToken: string): string;
var
  DBToken: TDBToken;
begin
  Result := '';
  DBToken := TDBToken.Create(nil);
  try
    DBToken.Trans := dm.Trans_Token;
    if not DBToken.CheckToken(aToken) then
    begin
      Result := 'Token zum abgleichen nicht gefunden.';
      exit;
    end;
    if not fJWT.VerifyToken(aToken, fJWT.Schluessel) then
    begin
      Result := 'Token ist nicht zulässig';
      exit;
    end;
  finally
    FreeAndNil(DBToken);
  end;

end;

end.
