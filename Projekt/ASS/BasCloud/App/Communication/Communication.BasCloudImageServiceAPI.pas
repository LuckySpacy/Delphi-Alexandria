unit Communication.BasCloudImageServiceAPI;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.Base, Rest.Types,
  FMX.Graphics, System.Net.HttpClientComponent;

type
  TCommunicationBasCloudImageServiceAPI = class(TCommunicationBase)
  private
  public
    constructor Create;
    destructor Destroy; override;
    function GetImageUploadURL(aUrl: string): Boolean;
    procedure Post(aUrl, aContentType: string; aBitmap: TBitmap);
    function Get(aUrl, aContentType: string; aStream: TStream): Boolean;
  end;

implementation

{ TCommunicationBasCloudImageServiceAPI }

constructor TCommunicationBasCloudImageServiceAPI.Create;
begin
  inherited;
  fBaseURL := 'https://fcu337dfq0.execute-api.eu-west-1.amazonaws.com/v2/readings/';
end;

destructor TCommunicationBasCloudImageServiceAPI.Destroy;
begin

  inherited;
end;




function TCommunicationBasCloudImageServiceAPI.Get(aUrl, aContentType: string; aStream: TStream): Boolean;
var
  HTTPRequest: TNetHTTPRequest;
  HTTPClient: TNetHTTPClient;
begin
  Result := true;
  fClient.BaseURL := fBaseUrl + aUrl;
  HTTPRequest := TNetHTTPRequest.Create(nil);
  HTTPClient  := TNetHTTPClient.Create(nil);
  try
    HTTPClient.Accept := 'application/vnd.api+json';
    HTTPClient.ContentType := aContentType;
    HTTPClient.CustomHeaders['Authorization'] := 'Bearer '+fToken;

    aStream.Position := 0;
    HTTPRequest.Client := HTTPClient;
    try
      HTTPRequest.Get(fClient.BaseURL, aStream);
    except
      on E: Exception do
      begin
        Result := false;
        exit;
      end;
    end;
    if aStream.Size < 200 then
      Result := false;
  finally
    FreeAndNil(HTTPRequest);
    FreeAndNil(HTTPClient);
  end;

end;


function TCommunicationBasCloudImageServiceAPI.GetImageUploadURL(aUrl: string): Boolean;
begin
  Result := true;
  fRequest.Params.Clear;
  fClient.BaseURL := fBaseUrl + aUrl;
  fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
  fClient.ContentType := 'image/jpg';
  fRequest.Method := rmGet;
  try
    fRequest.Execute;
  except
    Result := false;
  end;
end;


procedure TCommunicationBasCloudImageServiceAPI.Post(aUrl, aContentType: string; aBitmap: TBitmap);
var
  ms: TMemoryStream;
  HTTPClient: TNetHTTPClient;
  HTTPRequest: TNetHTTPRequest;
begin
  HTTPClient  := TNetHTTPClient.Create(nil);
  HTTPRequest := TNetHTTPRequest.Create(nil);
  ms := TMemoryStream.Create;
  try
    aBitmap.SaveToStream(ms);
    ms.Position := 0;
    HTTPClient.ContentType := aContentType;
    HTTPRequest.Client := HTTPClient;
    HTTPRequest.Put(aUrl, ms);
  finally
    FreeAndNil(ms);
    FreeAndNil(HTTPClient);
    FreeAndNil(HTTPRequest);
  end;
end;

end.
