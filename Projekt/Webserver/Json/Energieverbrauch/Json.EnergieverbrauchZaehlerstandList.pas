unit Json.EnergieverbrauchZaehlerstandList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.EnergieverbrauchZaehlerstand;

type
  TJEnergieverbrauchZaehlerstandList = class(TBasisList)
  private
    function getItem(Index: Integer): TJEnergieverbrauchZaehlerstand;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJEnergieverbrauchZaehlerstand;
    property Item[Index: Integer]: TJEnergieverbrauchZaehlerstand read getItem;
    property JsonString: string read getJsonString write setJsonString;
    procedure setError(aErrortext: string; aErrorStatus: string);
  end;

implementation

{ TJEnergieverbrauchZaehlerstandList }

uses
  System.JSON, System.Generics.Collections;


constructor TJEnergieverbrauchZaehlerstandList.Create;
begin
  inherited;
  Init;
end;

procedure TJEnergieverbrauchZaehlerstandList.Init;
begin

end;

destructor TJEnergieverbrauchZaehlerstandList.Destroy;
begin

  inherited;
end;

function TJEnergieverbrauchZaehlerstandList.Add: TJEnergieverbrauchZaehlerstand;
begin
  Result := TJEnergieverbrauchZaehlerstand.Create;
  fList.Add(Result);
end;


function TJEnergieverbrauchZaehlerstandList.getItem(
  Index: Integer): TJEnergieverbrauchZaehlerstand;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJEnergieverbrauchZaehlerstand(fList.Items[Index]);
end;

function TJEnergieverbrauchZaehlerstandList.getJsonString: string;
var
  i1, i2: Integer;
  Error: TJEnergieverbrauchZaehlerstand;
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
      Error := TJEnergieverbrauchZaehlerstand(fList.Items[i1]);
      OptionObject := TJSONObject.Create;
      for i2 := 0 to Error.FieldCount -1 do
        OptionObject.AddPair(Error.Field[i2].Feldname, Error.Field[i2].AsString);
      OptionArrayElements.AddElement(OptionObject);
    end;
    JsonObject.AddPair('Zaehlerstandlist', OptionArrayElements);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;



procedure TJEnergieverbrauchZaehlerstandList.setError(aErrortext,
  aErrorStatus: string);
begin

end;

procedure TJEnergieverbrauchZaehlerstandList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  Error: TJEnergieverbrauchZaehlerstand;
begin
  Clear;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    try
      ArrayElements := JsonObject.GetValue('Zaehlerstandlist') as TJSONArray;
      if ArrayElements = nil then
        exit;
    except
      on E: Exception do
      begin
        exit;
      end;
    end;
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
