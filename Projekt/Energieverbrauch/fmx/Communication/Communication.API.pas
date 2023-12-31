unit Communication.API;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.Base, Rest.Types,
  Objekt.JError, Objekt.JErrorList;

type
  TCommunicationAPI = class(TCommunicationBase)
  private
    fJError: TJError;
    fJErrorList: TJErrorList;
    procedure Read_ErrorString(aValue: string);
  protected
    procedure Read_Error;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Post(aUrl, aJsonString: string): Boolean;
    function Get(aUrl: string): Boolean;
    property ErrorList: TJErrorList read fJErrorList;
    function Delete(aUrl, aJsonString: string): Boolean;
    //procedure Read_ErrorString(aValue: string);
  end;

implementation

{ TCommunicationAPI }

uses
  Objekt.Energieverbrauch;

constructor TCommunicationAPI.Create;
begin
  inherited;
  fJError     := nil;
  fJErrorList := TJErrorList.Create;
  fBaseUrl    := Energieverbrauch.HostIni.Host + ':' + Energieverbrauch.HostIni.Port.ToString;
end;

destructor TCommunicationAPI.Destroy;
begin
  if fJErrorList <> nil then
    FreeAndNil(fJErrorList);
  if fJError <> nil then
    FreeAndNil(fJError);
  inherited;
end;

function TCommunicationAPI.Get(aUrl: string): Boolean;
begin
  Result := true;
  fRequest.Params.Clear;
  fClient.BaseURL := fBaseURL + aUrl;
  //fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
  fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.Method := rmGet;
  try
    try
      fRequest.Execute;
    except
      Result := false;
    end;
  finally
    Read_Error;
  end;
end;

function TCommunicationAPI.Post(aUrl, aJsonString: string): Boolean;
var
  JError: TJError;
  ErrorMsg: string;
begin
  ErrorMsg := '';
  Result := true;
  fClient.BaseURL := fBaseURL + aUrl;
  fRequest.Params.Clear;
  //fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.AddBody(aJsonString, ctAPPLICATION_JSON);
  fRequest.Method := rmPost;
  try
    try
      fRequest.Execute;
    except
      on E: Exception do
      begin
        ErrorMsg := E.Message;
        Result := false;
      end;
    end;
  finally
    Read_Error;
    if ErrorMsg > '' then
    begin
      JError := fJErrorList.Add;
      JError.FieldByName('Title').AsString := ErrorMsg;
    end;
  end;
end;


function TCommunicationAPI.Delete(aUrl, aJsonString: string): Boolean;
var
  JError: TJError;
  ErrorMsg: string;
begin
  ErrorMsg := '';
  Result := true;
  fClient.BaseURL := fBaseURL + aUrl;
  fRequest.Params.Clear;
  //fRequest.AddParameter('Content-Type', 'application/vnd.api+json', pkHTTPHEADER, [poDoNotEncode]);
  fRequest.AddBody(aJsonString, ctAPPLICATION_JSON);
  fRequest.Method := rmDELETE;
  try
    try
      fRequest.Execute;
    except
      on E: Exception do
      begin
        ErrorMsg := E.Message;
        Result := false;
      end;
    end;
  finally
    Read_Error;
    if ErrorMsg > '' then
    begin
      JError := fJErrorList.Add;
      JError.FieldByName('Title').AsString := ErrorMsg;
    end;
  end;
end;

procedure TCommunicationAPI.Read_Error;
begin
  Read_ErrorString(fResponse.Content);
end;


procedure TCommunicationAPI.Read_ErrorString(aValue: string);
var
  ReturnValue: string;
  //i1: Integer;
  //JError: TJError;
begin
  try
    fJErrorList.Clear;
    ReturnValue := aValue;
    if fJError <> nil then
      FreeAndNil(fJError);

    fJErrorList.JsonString := aValue;

  except
  end;
end;

end.
