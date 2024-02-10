unit Json.EnergieverbrauchVerbrauchMonate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList, Json.ErrorList;

type
  TJEnergieverbrauchVerbrauchMonate = class(TFeldList)
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

{ TJEnergieverbrauchVerbrauchMonate }

uses
  System.JSON, System.Generics.Collections;

constructor TJEnergieverbrauchVerbrauchMonate.Create;
begin
  inherited;
  Add('VM_ID');
  Add('VM_ZA_ID');
  Add('VM_WERT');
  Add('VM_MONAT');
  Add('VM_JAHR');
  fJErrorList := nil;
  Init;
end;

destructor TJEnergieverbrauchVerbrauchMonate.Destroy;
begin

  inherited;
end;


procedure TJEnergieverbrauchVerbrauchMonate.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
    Field[i1].AsString := '';
end;


procedure TJEnergieverbrauchVerbrauchMonate.CheckValues;
begin

end;


function TJEnergieverbrauchVerbrauchMonate.getJsonString: string;
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
    JsonObject.AddPair('VerbrauchMonat', JsonFelder);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;




procedure TJEnergieverbrauchVerbrauchMonate.setErrorList(aJErrorList: TJErrorList);
begin

end;

procedure TJEnergieverbrauchVerbrauchMonate.setJsonString(const Value: string);
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
    JsonZaehler := JsonObject.GetValue('VerbrauchMonat') as TJSONObject;
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
