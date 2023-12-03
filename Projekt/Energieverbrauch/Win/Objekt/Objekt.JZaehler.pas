unit Objekt.JZaehler;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Objekt.JErrorList;

type
  TJZaehler = class(TFeldList)
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
    procedure CheckValues;
  end;

implementation

{ TJZaehler }

uses
  System.JSON, System.Generics.Collections;


constructor TJZaehler.Create;
begin
  inherited;
  Add('ZA_ID');
  Add('ZA_ZAEHLER');
  fJErrorList := nil;
  Init;
end;

destructor TJZaehler.Destroy;
begin

  inherited;
end;

procedure TJZaehler.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;


function TJZaehler.getJsonString: string;
var
  i1: Integer;
  JsonObject: TJSONObject;
  JsonFelder: TJSONObject;
  JsonPos: TJSONArray;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonFelder := TJSONObject.Create;
    for i1 := 0 to FieldCount -1 do
      JsonFelder.AddPair(Field[i1].Feldname, Field[i1].AsString);
    JsonObject.AddPair('Zaehler', JsonFelder);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;


procedure TJZaehler.setErrorList(aJErrorList: TJErrorList);
begin
  fJErrorList := aJErrorList;
end;

procedure TJZaehler.setJsonString(const Value: string);
var
  JsonObject, JsonZaehler: TJSONObject;
  i1: Integer;
  s: string;
  JsonStr: string;
begin
  Init;
  JsonStr := Value;
  try
    JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
    JsonZaehler := JsonObject.GetValue('Zaehler') as TJSONObject;
  except
    on E: Exception do
    begin
      fJErrorList.setError(E.Message, '99');
      exit;
    end;
  end;
  try
    for i1 := 0 to FieldCount -1 do
    begin
      if JsonZaehler.TryGetValue(Field[i1].Feldname, s) then
        Field[i1].AsString := s;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

end;


procedure TJZaehler.CheckValues;
begin //

end;


end.
