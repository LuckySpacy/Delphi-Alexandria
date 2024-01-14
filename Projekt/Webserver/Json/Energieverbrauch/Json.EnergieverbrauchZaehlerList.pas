unit Json.EnergieverbrauchZaehlerList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.EnergieverbrauchZaehler;

type
  TJEnergieverbrauchZaehlerList = class(TBasisList)
  private
    function getItem(Index: Integer): TJEnergieverbrauchZaehler;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJEnergieverbrauchZaehler;
    property Item[Index: Integer]: TJEnergieverbrauchZaehler read getItem;
    property JsonString: string read getJsonString write setJsonString;
    procedure setError(aErrortext: string; aErrorStatus: string);
  end;

implementation

{ TJEnergieverbrauchZaehlerList }

uses
  System.JSON, System.Generics.Collections;


constructor TJEnergieverbrauchZaehlerList.Create;
begin
  inherited;
  Init;
end;

procedure TJEnergieverbrauchZaehlerList.Init;
begin

end;

destructor TJEnergieverbrauchZaehlerList.Destroy;
begin

  inherited;
end;

function TJEnergieverbrauchZaehlerList.Add: TJEnergieverbrauchZaehler;
begin
  Result := TJEnergieverbrauchZaehler.Create;
  fList.Add(Result);
end;


function TJEnergieverbrauchZaehlerList.getItem(
  Index: Integer): TJEnergieverbrauchZaehler;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJEnergieverbrauchZaehler(fList.Items[Index]);
end;

function TJEnergieverbrauchZaehlerList.getJsonString: string;
var
  i1, i2: Integer;
  Error: TJEnergieverbrauchZaehler;
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
      Error := TJEnergieverbrauchZaehler(fList.Items[i1]);
      OptionObject := TJSONObject.Create;
      for i2 := 0 to Error.FieldCount -1 do
        OptionObject.AddPair(Error.Field[i2].Feldname, Error.Field[i2].AsString);
      OptionArrayElements.AddElement(OptionObject);
    end;
    JsonObject.AddPair('Zaehlerlist', OptionArrayElements);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;



procedure TJEnergieverbrauchZaehlerList.setError(aErrortext,
  aErrorStatus: string);
begin

end;

procedure TJEnergieverbrauchZaehlerList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  Error: TJEnergieverbrauchZaehler;
begin
  Clear;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    try
      ArrayElements := JsonObject.GetValue('Zaehlerlist') as TJSONArray;
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
