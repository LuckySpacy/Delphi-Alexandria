unit Objekt.JZaehlerstand;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Objekt.JErrorList;

type
  TJZaehlerstand = class(TFeldList)
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


constructor TJZaehlerstand.Create;
begin
  inherited;
  Add('ZS_ID');
  Add('ZS_ZA_ID');
  Add('ZS_WERT');
  Add('ZS_DATUM');
  Add('ZS_WERTSTR');
  Add('ZS_TIMESTAMP');
  Add('JAHR');
  Add('DATUMVON');
  Add('DATUMBIS');
  Add('VERBRAUCH');
  fJErrorList := nil;
  Init;
end;

destructor TJZaehlerstand.Destroy;
begin

  inherited;
end;

procedure TJZaehlerstand.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;


{
function TJZaehlerstand.getJsonString: string;
var
  i1: Integer;
  JsonObject: TJSONObject;
  JsonFelder: TJSONObject;
  //JsonPos: TJSONArray;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonFelder := TJSONObject.Create;
    for i1 := 0 to FieldCount -1 do
      JsonFelder.AddPair(Field[i1].Feldname, Field[i1].AsString);
    JsonObject.AddPair('Zaehlerstand', JsonFelder);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;
}

function TJZaehlerstand.getJsonString: string;
var
  i1: Integer;
  //JsonObject: TJSONObject;
  JsonFelder: TJSONObject;
  //JsonPos: TJSONArray;
begin
  JsonFelder := TJSONObject.Create;
  try
    for i1 := 0 to FieldCount -1 do
      JsonFelder.AddPair(Field[i1].Feldname, Field[i1].AsString);
    Result := JsonFelder.ToJSON;
  finally
    FreeAndNil(JsonFelder);
  end;
end;



procedure TJZaehlerstand.setErrorList(aJErrorList: TJErrorList);
begin
  fJErrorList := aJErrorList;
end;

procedure TJZaehlerstand.setJsonString(const Value: string);
var
  JsonObject: TJSONObject;
  i1: Integer;
  s: string;
  JsonStr: string;
begin
  Init;
  JsonStr := Value;
  JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    try
      for i1 := 0 to FieldCount -1 do
      begin
        if JsonObject.TryGetValue(Field[i1].Feldname, s) then
          Field[i1].AsString := s;
      end;
    except
      on E: Exception do
      begin
        fJErrorList.setError(E.Message, '99');
        exit;
      end;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

  {
  try
    JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
    JsonZaehler := JsonObject.GetValue('Zaehlerstand') as TJSONObject;
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
  }
end;


procedure TJZaehlerstand.CheckValues;
begin //

end;

end.
