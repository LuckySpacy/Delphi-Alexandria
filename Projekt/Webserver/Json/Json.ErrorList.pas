unit Json.ErrorList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.Error;

type
  TJErrorList = class(TBasisList)
  private
    function getItem(Index: Integer): TJError;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJError;
    property Item[Index: Integer]: TJError read getItem;
    property JsonString: string read getJsonString write setJsonString;
    procedure setError(aErrortext: string; aErrorStatus: string);
  end;


implementation

{ TErrorList }

uses
  System.JSON, System.Generics.Collections;


constructor TJErrorList.Create;
begin
  inherited;
  Init;
end;

destructor TJErrorList.Destroy;
begin

  inherited;
end;


procedure TJErrorList.Init;
begin

end;


function TJErrorList.Add: TJError;
begin
  Result := TJError.Create;
  fList.Add(Result);
end;

function TJErrorList.getItem(Index: Integer): TJError;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJError(fList.Items[Index]);
end;



function TJErrorList.getJsonString: string;
var
  i1, i2: Integer;
  Error: TJError;
  JsonObject, OptionObject: TJSONObject;
  OptionArrayElements: TJSONArray;
begin
  OptionArrayElements := nil;
  JsonObject := TJSONObject.Create;
  try
    if fList.Count > 0 then
      OptionArrayElements := TJSONArray.Create;
    for i1 := 0 to fList.Count -1 do
    begin
      Error := TJError(fList.Items[i1]);
      OptionObject := TJSONObject.Create;
      for i2 := 0 to Error.FieldCount -1 do
        OptionObject.AddPair(Error.Field[i2].Feldname, Error.Field[i2].AsString);
      OptionArrayElements.AddElement(OptionObject);
    end;
    JsonObject.AddPair('Errors', OptionArrayElements);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;





procedure TJErrorList.setError(aErrortext, aErrorStatus: string);
var
  Error: TJError;
begin
  Error := Add;
  Error.FieldByName('Title').AsString  := aErrorText;
  Error.FieldByName('Status').AsString := aErrorStatus;
end;

procedure TJErrorList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  Error: TJError;
begin
  Clear;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  if JsonObject = nil then
    exit;
  try
    try
      ArrayElements := JsonObject.GetValue('Errors') as TJSONArray;
    except
      on E: Exception do
      begin
        exit;
      end;
    end;
    if ArrayElements = nil then
      exit;
    for i1 := 0 to ArrayElements.Count -1 do
    begin
      JsonError := ArrayElements.Items[i1] as TJSONObject;
      Error := Add;
      for i2 := 0 to Error.FieldCount -1 do
      begin
        if JsonError.TryGetValue(Error.Field[i2].Feldname, s) then
          Error.Field[i2].AsString := s;
      end;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

end;

end.
