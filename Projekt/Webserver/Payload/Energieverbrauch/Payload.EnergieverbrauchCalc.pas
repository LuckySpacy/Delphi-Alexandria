unit Payload.EnergieverbrauchCalc;

interface


// Payload f�r alle Z�hlerstandread Abfragen.

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList,
  Json.ErrorList;

type
  TPEnergieverbrauchCalc = class(TFeldList)
  private
    fJErrorList: TJErrorList;
    function getJsonString: string;
    procedure setJsonString(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    property JsonString: string read getJsonString write setJsonString;
    property JErrorList: TJErrorList read fJErrorList;
  end;

implementation

{ TPEnergieverbrauchCalc }

uses
  System.JSON, System.Generics.Collections, c.JsonError;

constructor TPEnergieverbrauchCalc.Create;
begin
  inherited;
  Add('ZS_ZA_ID');
  Add('DATUMVON');
  Add('DATUMBIS');
  fJErrorList := TJErrorList.Create;
  Init;
end;

destructor TPEnergieverbrauchCalc.Destroy;
begin

  inherited;
end;

procedure TPEnergieverbrauchCalc.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
      Field[i1].AsString := '';
end;


function TPEnergieverbrauchCalc.getJsonString: string;
var
  i1: Integer;
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create;
  try
    for i1 := 0 to FieldCount -1 do
      JsonObject.AddPair(Field[i1].Feldname, Field[i1].AsString);
    Result := JsonObject.ToJSON;
  finally
    FreeAndNil(JsonObject);
  end;
end;

procedure TPEnergieverbrauchCalc.setJsonString(const Value: string);
var
  JsonObject: TJSONObject;
  i1: Integer;
  s: string;
  JsonStr: string;
begin
  Init;
  JsonStr := Value;
  try
    JsonObject := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  except
    on E: Exception do
    begin
      fJErrorList.setError(E.Message, cJIdPayloadNichtKorrekt);
      exit;
    end;
  end;
  try
    for i1 := 0 to FieldCount -1 do
    begin
      if JsonObject.TryGetValue(Field[i1].Feldname, s) then
        Field[i1].AsString := s;
    end;
  finally
    FreeAndNil(JsonObject);
  end;

end;
end.
