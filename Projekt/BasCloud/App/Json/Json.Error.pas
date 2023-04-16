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
  end;

  TJError = class
  private
    FErrors: TArray<TErrorsClass>;
  public
    property errors: TArray<TErrorsClass> read FErrors write FErrors;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJError;
  end;


implementation

{TErrorsClass}


function TErrorsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
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
  result := TJson.JsonToObject<TJError>(AJsonString)
end;


end.
