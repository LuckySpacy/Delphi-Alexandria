unit Objekt.JZaehlerstandList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Objekt.JZaehlerstand;

type
  TJZaehlerstandList = class(TBasisList)
  private
    function getItem(Index: Integer): TJZaehlerstand;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJZaehlerstand;
    property Item[Index: Integer]: TJZaehlerstand read getItem;
    property JsonString: string read getJsonString write setJsonString;
  end;


implementation

{ TJZaehlerstandList }

uses
  System.JSON, System.Generics.Collections;


constructor TJZaehlerstandList.Create;
begin
  inherited;
  Init;
end;

destructor TJZaehlerstandList.Destroy;
begin

  inherited;
end;


procedure TJZaehlerstandList.Init;
begin

end;


function TJZaehlerstandList.Add: TJZaehlerstand;
begin
  Result := TJZaehlerstand.Create;
  fList.Add(Result);
end;

function TJZaehlerstandList.getItem(Index: Integer): TJZaehlerstand;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJZaehlerstand(fList.Items[Index]);
end;



function TJZaehlerstandList.getJsonString: string;
var
  i1, i2: Integer;
  Zaehlerstand: TJZaehlerstand;
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
      Zaehlerstand := TJZaehlerstand(fList.Items[i1]);
      OptionObject := TJSONObject.Create;
      for i2 := 0 to Zaehlerstand.FieldCount -1 do
        OptionObject.AddPair(Zaehlerstand.Field[i2].Feldname, Zaehlerstand.Field[i2].AsString);
      OptionArrayElements.AddElement(OptionObject);
    end;
    JsonObject.AddPair('Zaehlerstandlist', OptionArrayElements);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;







procedure TJZaehlerstandList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  JZaehlerstand: TJZaehlerstand;
begin
  Clear;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    try
      ArrayElements := JsonObject.GetValue('Zaehlerstandlist') as TJSONArray;
    except
      on E: Exception do
      begin
        exit;
      end;
    end;
    for i1 := 0 to ArrayElements.Count -1 do
    begin
      JsonError := ArrayElements.Items[i1] as TJSONObject;
      JZaehlerstand := Add;
      for i2 := 0 to JZaehlerstand.FieldCount -1 do
      begin
        if JsonError.TryGetValue(JZaehlerstand.Field[i2].Feldname, s) then
          JZaehlerstand.Field[i2].AsString := s;
      end;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

end;


end.
