unit Communication.API;

interface

uses
  System.SysUtils, System.Types, System.Classes, Communication.Base, Rest.Types,
  Json.Error, Objekt.ErrorList;

type
  TCommunicationAPI = class(TCommunicationBase)
  private
    fJError: TJError;
    fErrorList: TErrorList;
  protected
    procedure Read_Error;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Post(aUrl, aJsonString: string): Boolean;
    function Get(aUrl: string): Boolean;
    function ErrorList: TErrorList;
  end;

implementation

{ TCommunicationBasCloudAPI }

uses
  Objekt.Error;

constructor TCommunicationAPI.Create;
begin
  inherited;
  fBaseURL := 'http://localhost:8080/';
  fJError  := nil;
  fErrorList := TErrorList.Create;
end;

destructor TCommunicationAPI.Destroy;
begin
  if fJError <> nil then
    FreeAndNil(fJError);
  FreeAndNil(fErrorList);
  inherited;
end;

function TCommunicationAPI.ErrorList: TErrorList;
begin
  Result := fErrorList;
end;

function TCommunicationAPI.Get(aUrl: string): Boolean;
begin

end;

function TCommunicationAPI.Post(aUrl, aJsonString: string): Boolean;
var
  ErrorMsg: string;
  Error: TError;
begin
  fErrorList.clear;
  ErrorMsg := '';
  Result := true;
  try
    fClient.BaseURL := fBaseURL + aUrl;
  except
    on E: Exception do
    begin
      Error := fErrorList.Add;
      Error.Title  := E.Message;
      Error.Status := '-1';
      Error.Detail := '';
      ErrorMsg := E.Message;
      Result := false;
      exit;
    end;
  end;
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
        if Pos('12029', E.Message) > 0 then
        begin
          Error := fErrorList.Add;
          Error.Title  := 'Die Serververbindung konnte nicht hergestellt werden';
          Error.Status := '12029';
          Error.Detail := E.Message;
        end;
        if (Pos('not permitted', E.Message) > 0) and (pos('traffic to', E.Message) > 0) then  // Meldung bei Android
        begin
          Error := fErrorList.Add;
          Error.Title  := 'Die Serververbindung konnte nicht hergestellt werden';
          Error.Status := '12029';
          Error.Detail := E.Message;
        end;
        if (fErrorList.Count = 0) and (copy(ReturnValue, 1, 11) <> '{"errors":[') then
        begin
          Error := fErrorList.Add;
          Error.Title  := E.Message;
          Error.Status := '-1';
          Error.Detail := '';
        end;
        ErrorMsg := E.Message;
        Result := false;
      end;
    end;
  finally
    Read_Error;
  end;
end;

procedure TCommunicationAPI.Read_Error;
var
  i1: Integer;
  Error: TError;
begin
  if fJError <> nil then
    FreeAndNil(fJError);

  if copy(ReturnValue, 1, 11) = '{"errors":[' then
  begin
    fJError := TJError.FromJsonString(ReturnValue);
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
  end;

end;

end.
