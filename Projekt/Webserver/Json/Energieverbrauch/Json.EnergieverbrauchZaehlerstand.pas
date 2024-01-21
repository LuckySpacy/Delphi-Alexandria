unit Json.EnergieverbrauchZaehlerstand;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Json.ErrorList;

type
  TJEnergieverbrauchZaehlerstand = class(TFeldList)
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

{ TJEnergieverbrauchZaehlerstand }

uses
  System.JSON, System.Generics.Collections;

constructor TJEnergieverbrauchZaehlerstand.Create;
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

destructor TJEnergieverbrauchZaehlerstand.Destroy;
begin

  inherited;
end;

procedure TJEnergieverbrauchZaehlerstand.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;



procedure TJEnergieverbrauchZaehlerstand.CheckValues;
begin

end;


function TJEnergieverbrauchZaehlerstand.getJsonString: string;
var
  i1: Integer;
  JsonObject: TJSONObject;
  JsonFelder: TJSONObject;
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


procedure TJEnergieverbrauchZaehlerstand.setErrorList(aJErrorList: TJErrorList);
begin

end;

procedure TJEnergieverbrauchZaehlerstand.setJsonString(const Value: string);
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

end;

end.
