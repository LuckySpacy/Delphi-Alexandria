unit Objekt.Login;

interface

uses
  System.SysUtils, System.Types, System.Classes, Rest.Client, Json.ErrorList,
  Json.Error;

type
  TLogin = class
  protected
    fBaseURL: string;
    //fToken: string;
    fClient  : TRESTClient;
    fResponse: TRESTResponse;
    fRequest : TRESTRequest;
    fJErrorList: TJErrorList;
  private
   function Post(aUrl, aJsonString: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    //property Token: string read fToken write fToken;
    property BaseUrl: string read fBaseUrl write fBaseUrl;
    function getToken(aUrl, aUser, aPassword, aModul: string): string;
    function CheckConnect(aUrl: string): Boolean;
    property JErrorList: TJErrorList read fJErrorList;
  end;


implementation

{ TLogin }

uses
  Rest.Types, Payload.Login, c.JsonError, JSON.CheckResult, Json.Token;


constructor TLogin.Create;
begin
  fBaseURL := '';
  fClient   := TRESTClient.Create(nil);
  fResponse := TRESTResponse.Create(nil);
  fRequest  := TRESTRequest.Create(nil);

  fRequest.Client   := fClient;
  fRequest.Response := fResponse;
  fJErrorList := TJErrorList.Create;

  //fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);

end;

destructor TLogin.Destroy;
begin
  FreeAndNil(fClient);
  FreeAndNil(fResponse);
  FreeAndNil(fRequest);
  FreeAndNil(fJErrorList);
  inherited;
end;

function TLogin.getToken(aUrl, aUser, aPassword, aModul: string): string;
var
  PLogin: TPLogin;
  JToken: TJToken;
begin
  Result := '';
  PLogin := TPLogin.Create;
  try
    PLogin.FieldByName('User').AsString     := aUser;
    PLogin.FieldByName('Password').AsString := aPassword;
    PLogin.FieldByName('Modul').AsString    := aModul;
    Post(aUrl, PLogin.JsonString);
  finally
    FreeAndNil(PLogin);
  end;
  JToken := TJToken.Create;
  try
    JToken.JsonString := fResponse.Content;
    Result := JToken.FieldByName('Token').AsString;
  finally
    FreeAndNil(JToken);
  end;
end;

function TLogin.Post(aUrl, aJsonString: string): Boolean;
//var
//  JError: TJError;
begin
  Result := true;
  fClient.BaseURL := fBaseURL + aUrl;
  fRequest.Params.Clear;
  fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.AddBody(aJsonString, ctAPPLICATION_JSON);
  fRequest.Method := rmPost;
  try
    try
      fRequest.Execute;
    except
      on E: Exception do
      begin
        fJErrorList.setError(e.Message, c.JsonError.cJException);
        Result := false;
      end;
    end;
  finally
  end;
end;


function TLogin.CheckConnect(aUrl: string): Boolean;
var
//  JError: TJError;
  JCheckResult: TJCheckResult;
begin
  JErrorList.Clear;
  Result := false;
  fClient.BaseURL := fBaseURL + aUrl;
  fRequest.Params.Clear;
  fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.Method := rmGet;
  JCheckResult := TJCheckResult.Create;
  try
    try
      fRequest.Execute;
      JCheckResult.JsonString := fResponse.Content;
      if JCheckResult.FieldByName('OK').AsString = 'true' then
        Result := true;
    except
      on E: Exception do
      begin
        fJErrorList.setError(e.Message, c.JsonError.cJException);
        Result := false;
      end;
    end;
  finally
    FreeAndNil(JCheckResult);
  end;
end;


end.
