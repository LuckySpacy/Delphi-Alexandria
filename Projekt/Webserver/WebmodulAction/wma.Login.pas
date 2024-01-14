unit wma.Login;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.Base, Web.HTTPApp,
  Payload.Login, c.JsonError;

type
  TwmaLogin = class(TwmaBase)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaLogin }

uses
  DB.Token, Datenmodul.Database;

constructor TwmaLogin.Create;
begin
  inherited;
end;

destructor TwmaLogin.Destroy;
begin

  inherited;
end;

procedure TwmaLogin.DoIt(aRequest: TWebRequest; aResponse: TWebResponse);
var
  PLogin: TPLogin;
  DBToken: TDBToken;
  Token: string;
begin
  inherited;
  JErrorList.Clear;
  PLogin := TPLogin.Create;
  DBToken := TDBToken.Create(nil);
  try
    PLogin.JsonString := aRequest.Content;
    if PLogin.JErrorList.Count > 0 then
    begin
      aResponse.Content := PLogin.JErrorList.JsonString;
      exit;
    end;

    if PLogin.FieldByName('User').AsString = '' then
      JErrorList.setError('Parameter User ist leer', cJIdPayloadNichtKorrekt);
    if PLogin.FieldByName('Password').AsString = '' then
      JErrorList.setError('Parameter Password ist leer', cJIdPayloadNichtKorrekt);
    if PLogin.FieldByName('Modul').AsString = '' then
      JErrorList.setError('Parameter Modul ist leer', cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := PLogin.JErrorList.JsonString;
      exit;
    end;


    DBToken.Trans := dm.Trans_Token;
    Token := DBToken.getToken(PLogin.FieldByName('User').AsString, PLogin.FieldByName('Password').AsString, PLogin.FieldByName('Modul').AsString);

    if Token = '' then
      JErrorList.setError('Token mit den Paramtern nicht gefunden', cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := PLogin.JErrorList.JsonString;
      exit;
    end;

    aResponse.Content := '{"Token":"'+Token+'"}';

  finally
    FreeAndNil(PLogin);
    FreeAndNil(DBToken);
  end;

end;

end.
