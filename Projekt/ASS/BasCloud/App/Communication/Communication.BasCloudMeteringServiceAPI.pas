unit Communication.BasCloudMeteringServiceAPI;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.Base, Rest.Types;

type
  TCommunicationBasCloudMeteringServiceAPI = class(TCommunicationBase)
  private
  public
    constructor Create;
    destructor Destroy; override;
    function Get(aUrl: string): Boolean;
    function Post(aUrl, aJsonString: string): Boolean;
  end;

implementation

{ TCommunicationBasCloudMeteringServiceAPI }

constructor TCommunicationBasCloudMeteringServiceAPI.Create;
begin
  inherited;
  fBaseURL := 'https://y5mazgmex7.execute-api.eu-west-1.amazonaws.com/v2/';
end;

destructor TCommunicationBasCloudMeteringServiceAPI.Destroy;
begin

  inherited;
end;


function TCommunicationBasCloudMeteringServiceAPI.Get(aUrl: string): Boolean;
begin
  Result := true;
  fRequest.Params.Clear;
  fClient.BaseUrl := fBaseURL + aUrl;
  fClient.Params.Clear;
  fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
  fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.Method := rmGet;
  try
    fRequest.Execute;
  except
    Result := false;
  end;

end;

function TCommunicationBasCloudMeteringServiceAPI.Post(aUrl, aJsonString: string): Boolean;
begin
  Result := true;
  fClient.BaseURL := fBaseURL + aUrl;
  fRequest.Params.Clear;
  fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
  //fRequestMeteringService.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  if aJsonString > '' then
    fRequest.AddBody(aJsonString, ctAPPLICATION_JSON);
  fRequest.Method := rmPost;
  try
    fRequest.Execute;
  except
    Result := false;
  end;
end;



end.
