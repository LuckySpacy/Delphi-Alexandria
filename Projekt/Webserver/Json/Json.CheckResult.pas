unit Json.CheckResult;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Json.ErrorList;

type
  TJCheckResult = class(TFeldList)
  private
    fJErrorList: TJErrorList;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    property JsonString: string read getJsonString write setJsonString;
    procedure setErrorList(aJErrorList: TJErrorList);
  end;

implementation

{ TJCheckResult }

uses
  System.JSON, System.Generics.Collections;

constructor TJCheckResult.Create;
begin
  inherited;
  Add('OK');
  fJErrorList := nil;
  Init;
end;

destructor TJCheckResult.Destroy;
begin

  inherited;
end;

procedure TJCheckResult.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;

function TJCheckResult.getJsonString: string;
var
  i1: Integer;
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create;
  try
    for i1 := 0 to FieldCount -1 do
      JsonObject.AddPair(Field[i1].Feldname, Field[i1].AsString);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;



procedure TJCheckResult.setErrorList(aJErrorList: TJErrorList);
begin

end;

procedure TJCheckResult.setJsonString(const Value: string);
var
  JsonObject: TJSONObject;
  s: string;
  JsonStr: string;
  i1: Integer;
begin
  Init;
  JsonStr := Value;
  try
    JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
    for i1 := 0 to FieldCount -1 do
    begin
      if JsonObject.TryGetValue(Field[i1].Feldname, s) then
        Field[i1].AsString := s;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

end;

end.
