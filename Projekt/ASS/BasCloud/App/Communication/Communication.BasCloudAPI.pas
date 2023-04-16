unit Communication.BasCloudAPI;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.Base, Rest.Types,
  Json.Error, Json.SystemError, Objekt.ErrorList, Objekt.Error;

type
  TCommunicationBasCloudAPI = class(TCommunicationBase)
  private
    fJError: TJError;
    fJSystemError: TJSystemError;
    fErrorList: TErrorList;
   protected
    procedure Read_Error;
  public
    constructor Create;
    destructor Destroy; override;
    function Post(aUrl, aJsonString: string): Boolean;
    function Get(aUrl: string): Boolean;
    property ErrorList: TErrorList read fErrorList;
    procedure Read_ErrorString(aValue: string);
  end;

implementation

{ TCommunicationBasCloudAPI }

constructor TCommunicationBasCloudAPI.Create;
begin
  inherited;
  fBaseURL := 'https://api.bascloud.net/v2/';
  fJError := nil;
  fJSystemError := nil;
  fErrorList := TErrorList.Create;
end;

destructor TCommunicationBasCloudAPI.Destroy;
begin
  if fJError <> nil then
    FreeAndNil(fJError);
  if fJSystemError <> nil then
    FreeAndNil(fJSystemError);
  FreeAndNil(fErrorList);
  inherited;
end;


function TCommunicationBasCloudAPI.Post(aUrl, aJsonString: string): Boolean;
var
  Error: TError;
  ErrorMsg: string;
begin
  ErrorMsg := '';
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
        ErrorMsg := E.Message;
        Result := false;
      end;
    end;
  finally
    Read_Error;
    if ErrorMsg > '' then
    begin
      Error := fErrorList.Add;
      Error.Title := ErrorMsg;
    end;
  end;
end;


function TCommunicationBasCloudAPI.Get(aUrl: string): Boolean;
begin
  Result := true;
  fRequest.Params.Clear;
  fClient.BaseURL := fBaseURL + aUrl;
  fClient.AddAuthParameter('Authorization', 'Bearer ' + fToken , TRESTRequestParameterKind.pkHTTPHEADER,[TRESTRequestParameterOption.poDoNotEncode]);
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



procedure TCommunicationBasCloudAPI.Read_Error;
begin
  Read_ErrorString(fResponse.Content);
end;

procedure TCommunicationBasCloudAPI.Read_ErrorString(aValue: string);
var
  ReturnValue: string;
  i1: Integer;
  Error: TError;
begin
  try
    fErrorList.Clear;
    ReturnValue := aValue;
    if fJError <> nil then
      FreeAndNil(fJError);

    if fJSystemError <> nil then
      FreeAndNil(fJSystemError);

    if copy(ReturnValue, 1, 28) = '{"type":"errors","errors":[{' then
    begin
      fJError := TJError.FromJsonString(ReturnValue);
    end;

    if (Pos('"statusCode":', ReturnValue) > 0) and (Pos('"message":', ReturnValue) > 0)
    and (Pos('"activityId":', ReturnValue) > 0) then
    begin
      fJSystemError := TJSystemError.FromJsonString(ReturnValue);
    end;

    if (fJError <> nil) and (Length(fJError.errors) > 0) then
    begin
      for i1 := 0 to Length(fJError.errors) -1 do
      begin
        Error := fErrorList.Add;
        Error.Status := fJError.errors[i1].status;
        Error.Detail := fJError.errors[i1].detail;
        Error.Title  := fJError.errors[i1].title;
      end;
    end;

    if fJSystemError <> nil then
    begin
      Error := fErrorList.Add;
      Error.Status     := FloatToStr(fJSystemError.statusCode);
      Error.Title      := fJSystemError.message;
      Error.ActivityId := fJSystemError.activityId;
      Error.SystemError := true;
    end;

  except
  end;
end;

end.

