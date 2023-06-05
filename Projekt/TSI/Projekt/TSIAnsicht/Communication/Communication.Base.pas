unit Communication.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TCommunicationBase = class
  private
    fNetHTTPClient: TNetHTTPClient;
    fNetHTTPRequest: TNetHTTPRequest;
    fContent: string;
    procedure NetHTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
  public
    constructor Create;
    destructor Destroy; override;
    property Content: string read fContent;
    function Get(aURL: string): string;
  end;

implementation

{ TCommunicationBase }

constructor TCommunicationBase.Create;
begin
  fNetHTTPClient  := TNetHTTPClient.Create(nil);
  fNetHTTPRequest := TNetHTTPRequest.Create(nil);
  fNetHTTPRequest.Client := fNetHTTPClient;
  fNetHTTPRequest.OnRequestCompleted := NetHTTPRequestRequestCompleted;
end;

destructor TCommunicationBase.Destroy;
begin
  FreeAndNil(fNetHTTPRequest);
  FreeAndNil(fNetHTTPClient);
  inherited;
end;

function TCommunicationBase.Get(aURL: string): string;
begin
  fNetHTTPRequest.MethodString := 'GET';
  fNetHTTPRequest.URL := aUrl;
  fNetHTTPRequest.Execute;
end;

procedure TCommunicationBase.NetHTTPRequestRequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
begin
  fContent := AResponse.ContentAsString;
end;

end.
