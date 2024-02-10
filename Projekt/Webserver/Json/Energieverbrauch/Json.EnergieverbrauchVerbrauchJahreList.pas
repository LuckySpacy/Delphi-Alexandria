unit Json.EnergieverbrauchVerbrauchJahreList;

interface
uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Json.EnergieverbrauchVerbrauchJahre;

type
  TJEnergieverbrauchVerbrauchJahreList = class(TBasisList)
  private
    function getItem(Index: Integer): TJEnergieverbrauchVerbrauchJahre;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJEnergieverbrauchVerbrauchJahre;
    property Item[Index: Integer]: TJEnergieverbrauchVerbrauchJahre read getItem;
    property JsonString: string read getJsonString write setJsonString;
    procedure setError(aErrortext: string; aErrorStatus: string);
  end;

implementation

{ TJEnergieverbrauchVerbrauchJahreList }

uses
  System.JSON, System.Generics.Collections;


constructor TJEnergieverbrauchVerbrauchJahreList.Create;
begin
  inherited;
  Init;
end;

procedure TJEnergieverbrauchVerbrauchJahreList.Init;
begin

end;

destructor TJEnergieverbrauchVerbrauchJahreList.Destroy;
begin

  inherited;
end;

function TJEnergieverbrauchVerbrauchJahreList.Add: TJEnergieverbrauchVerbrauchJahre;
begin
  Result := TJEnergieverbrauchVerbrauchJahre.Create;
  fList.Add(Result);
end;


function TJEnergieverbrauchVerbrauchJahreList.getItem(
  Index: Integer): TJEnergieverbrauchVerbrauchJahre;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJEnergieverbrauchVerbrauchJahre(fList.Items[Index]);
end;

function TJEnergieverbrauchVerbrauchJahreList.getJsonString: string;
var
  i1, i2: Integer;
  Error: TJEnergieverbrauchVerbrauchJahre;
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
      Error := TJEnergieverbrauchVerbrauchJahre(fList.Items[i1]);
      OptionObject := TJSONObject.Create;
      for i2 := 0 to Error.FieldCount -1 do
        OptionObject.AddPair(Error.Field[i2].Feldname, Error.Field[i2].AsString);
      OptionArrayElements.AddElement(OptionObject);
    end;
    JsonObject.AddPair('VerbrauchJahrelist', OptionArrayElements);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;



procedure TJEnergieverbrauchVerbrauchJahreList.setError(aErrortext,
  aErrorStatus: string);
begin

end;

procedure TJEnergieverbrauchVerbrauchJahreList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  Error: TJEnergieverbrauchVerbrauchJahre;
begin
  Clear;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    try
      ArrayElements := JsonObject.GetValue('VerbrauchMonatelist') as TJSONArray;
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
