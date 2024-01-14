unit Json.EnergieverbrauchZaehler;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Json.ErrorList;

type
  TJEnergieverbrauchZaehler = class(TFeldList)
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

{ TJEnergieverbrauchZaehler }

uses
  System.JSON, System.Generics.Collections;

constructor TJEnergieverbrauchZaehler.Create;
begin
  inherited;
  Add('ZA_ID');
  Add('ZA_ZAEHLER');
  fJErrorList := nil;
  Init;
end;

destructor TJEnergieverbrauchZaehler.Destroy;
begin

  inherited;
end;


procedure TJEnergieverbrauchZaehler.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;


procedure TJEnergieverbrauchZaehler.CheckValues;
begin

end;


function TJEnergieverbrauchZaehler.getJsonString: string;
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
    JsonObject.AddPair('Zaehler', JsonFelder);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;




procedure TJEnergieverbrauchZaehler.setErrorList(aJErrorList: TJErrorList);
begin

end;

procedure TJEnergieverbrauchZaehler.setJsonString(const Value: string);
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


end.
