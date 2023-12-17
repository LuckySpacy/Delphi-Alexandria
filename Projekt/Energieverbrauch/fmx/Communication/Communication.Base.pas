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
    constructor Create; virtual;
    destructor Destroy; override;
    property Token: string read fToken write fToken;
    function ReturnValue: string;
  end;


implementation

{ TCommunicationBase }

constructor TCommunicationBase.Create;
begin
  fBaseURL := '';
  fToken   := '';
  fClient   := TRESTClient.Create(nil);
  fResponse := TRESTResponse.Create(nil);
  fRequest  := TRESTRequest.Create(nil);

  fRequest.Client   := fClient;
  fRequest.Response := fResponse;
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
