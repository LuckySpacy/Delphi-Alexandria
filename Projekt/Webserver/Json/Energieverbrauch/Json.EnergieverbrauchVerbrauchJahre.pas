unit Json.EnergieverbrauchVerbrauchJahre;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Json.ErrorList;

type
  TJEnergieverbrauchVerbrauchJahre = class(TFeldList)
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

{ TJEnergieverbrauchVerbrauchJahre }

uses
  System.JSON, System.Generics.Collections;

constructor TJEnergieverbrauchVerbrauchJahre.Create;
begin
  inherited;
  Add('ZA_ID');
  Add('WERT');
  Add('JAHR');
  fJErrorList := nil;
  Init;
end;

destructor TJEnergieverbrauchVerbrauchJahre.Destroy;
begin

  inherited;
end;


procedure TJEnergieverbrauchVerbrauchJahre.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;


procedure TJEnergieverbrauchVerbrauchJahre.CheckValues;
begin

end;


function TJEnergieverbrauchVerbrauchJahre.getJsonString: string;
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
    JsonObject.AddPair('VerbrauchJahr', JsonFelder);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;




procedure TJEnergieverbrauchVerbrauchJahre.setErrorList(aJErrorList: TJErrorList);
begin

end;

procedure TJEnergieverbrauchVerbrauchJahre.setJsonString(const Value: string);
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
    JsonZaehler := JsonObject.GetValue('VerbrauchJahr') as TJSONObject;
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
