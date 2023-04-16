unit Json.SystemError;

interface

uses Generics.Collections, Rest.Json;

type

  TJSystemError = class
  private
    FActivityId: String;
    FMessage: String;
    FStatusCode: Extended;
  public
    property activityId: String read FActivityId write FActivityId;
    property message: String read FMessage write FMessage;
    property statusCode: Extended read FStatusCode write FStatusCode;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJSystemError;
  end;

implementation

{TRootClass}


function TJSystemError.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJSystemError.FromJsonString(AJsonString: string): TJSystemError;
begin
  result := TJson.JsonToObject<TJSystemError>(AJsonString)
end;

end.

