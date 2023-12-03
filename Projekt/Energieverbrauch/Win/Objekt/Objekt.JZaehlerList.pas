unit Objekt.JZaehlerList;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.BasisList, Objekt.JZaehler;

type
  TJZaehlerList = class(TBasisList)
  private
    function getItem(Index: Integer): TJZaehler;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Add: TJZaehler;
    property Item[Index: Integer]: TJZaehler read getItem;
    property JsonString: string read getJsonString write setJsonString;
    procedure setError(aErrortext: string; aErrorStatus: string);
  end;


implementation

{ TJZaehlerList }

uses
  System.JSON, System.Generics.Collections;


constructor TJZaehlerList.Create;
begin
  inherited;
  Init;
end;

destructor TJZaehlerList.Destroy;
begin

  inherited;
end;


procedure TJZaehlerList.Init;
begin

end;


function TJZaehlerList.Add: TJZaehler;
begin
  Result := TJZaehler.Create;
  fList.Add(Result);
end;

function TJZaehlerList.getItem(Index: Integer): TJZaehler;
begin
  Result := nil;
  if Index > Count -1 then
    exit;
  Result := TJZaehler(fList.Items[Index]);
end;



function TJZaehlerList.getJsonString: string;
var
  i1, i2: Integer;
  Error: TJZaehler;
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
      Error := TJZaehler(fList.Items[i1]);
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





procedure TJZaehlerList.setError(aErrortext, aErrorStatus: string);
var
  Error: TJZaehler;
begin
  Error := Add;
  Error.FieldByName('Title').AsString  := aErrorText;
  Error.FieldByName('Status').AsString := aErrorStatus;
end;

procedure TJZaehlerList.setJsonString(const Value: string);
var
  JsonObject, JsonError: TJSONObject;
  ArrayElements: TJSONArray;
  i1, i2: Integer;
  s: string;
  JsonStr: string;
  Error: TJZaehler;
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
