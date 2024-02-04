unit Communication.Base;

interface

uses
  System.SysUtils, System.Types, System.Classes, Rest.Client;

type
  TCommunicationBase = class
  protected
    fBaseURL: string;
    fToken: string;
    fClient  : TRESTClient;
    fResponse: TRESTResponse;
    fRequest : TRESTRequest;
  private
  public
    constructor Create(aToken: string); virtual;
    destructor Destroy; override;
    property Token: string read fToken write fToken;
    function ReturnValue: string;
  end;


implementation

{ TCommunicationBase }

uses
  REST.Types;

constructor TCommunicationBase.Create(aToken: string);
begin
  fBaseURL := '';
  fToken   := aToken;
  fClient   := TRESTClient.Create(nil);
  fResponse := TRESTResponse.Create(nil);
  fRequest  := TRESTRequest.Create(nil);

  fRequest.Client   := fClient;
  fRequest.Response := fResponse;

  if aToken > '' then
    fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);

end;

destructor TCommunicationBase.Destroy;
begin
  FreeAndNil(fClient);
  FreeAndNil(fResponse);
  FreeAndNil(fRequest);
  inherited;
end;

function TCommunicationBase.ReturnValue: string;
begin
  Result := fResponse.Content;
end;


end.
