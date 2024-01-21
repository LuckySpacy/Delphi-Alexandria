unit Payload.EnergieverbrauchZaehlerUpdate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Objekt.Feld, Objekt.FeldList,
  Json.ErrorList;

type
  TPEnergieverbrauchZaehlerUpdate = class(TFeldList)
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

{ TPEnergieverbrauchZaehlerUpdate }

uses
  System.JSON, System.Generics.Collections, c.JsonError;

constructor TPEnergieverbrauchZaehlerUpdate.Create;
begin
  inherited;
  Add('ZA_ID');
  Add('ZA_ZAEHLER');
  fJErrorList := TJErrorList.Create;
  Init;
end;

procedure TPEnergieverbrauchZaehlerUpdate.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FieldCount -1 do
      Field[i1].AsString := '';
end;

destructor TPEnergieverbrauchZaehlerUpdate.Destroy;
begin
  FreeAndNil(fJErrorList);
  inherited;
end;

function TPEnergieverbrauchZaehlerUpdate.getJsonString: string;
begin

end;



procedure TPEnergieverbrauchZaehlerUpdate.setJsonString(const Value: string);
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
