unit Json.Error;

interface

uses
  Generics.Collections, Rest.Json;

type
  TErrorsClass = class
  private
    FDetail: String;
    FStatus: String;
    FTitle: String;
  public
    property detail: String read FDetail write FDetail;
    property status: String read FStatus write FStatus;
    property title: String read FTitle write FTitle;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TErrorsClass;
    destructor Destroy; override;
  end;

  TJError = class
  private
    FErrors: TArray<TErrorsClass>;
  public
    property errors: TArray<TErrorsClass> read FErrors write FErrors;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJError;
    function Add: TArray<TErrorsClass>;
    class function getErrorStr(aTitle, aStatus, aDetail: string): string;
  end;


implementation

{TErrorsClass}

uses
  System.SysUtils;


function TErrorsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

destructor TErrorsClass.Destroy;
begin

  inherited;
end;

class function TErrorsClass.FromJsonString(AJsonString: string): TErrorsClass;
begin
  result := TJson.JsonToObject<TErrorsClass>(AJsonString)
end;


{TRootClass}
destructor TJError.Destroy;
var
  LerrorsItem: TErrorsClass;
begin

 for LerrorsItem in FErrors do
   LerrorsItem.free;

  inherited;
end;

function TJError.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJError.FromJsonString(AJsonString: string): TJError;
begin
  try
    result := TJson.JsonToObject<TJError>(AJsonString)
  except
    Result := nil;
  end;
end;


function TJError.Add: TArray<TErrorsClass>;
begin
  SetLength(FErrors, Length(FErrors)+1);
  FErrors[High(FErrors)] := TErrorsClass.Create;
  Result := FErrors;
end;

class function TJError.getErrorStr(aTitle, aStatus, aDetail: string): string;
var
  JError: TJError;
  JErrors: TArray<TErrorsClass>;
begin
  JError := TJError.Create;
  try
    JErrors := JError.Add;
    JErrors[High(JErrors)].title  := aTitle;
    JErrors[High(JErrors)].detail := aDetail;
    JErrors[High(JErrors)].status := aStatus;
    Result := JError.ToJsonString;
  finally
    FreeAndNil(JError);
  end;
end;

end.
