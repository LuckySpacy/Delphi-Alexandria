unit JObjekt.Zaehler;

interface

uses
  System.SysUtils, System.JSON, JObjekt.ErrorList;

type
  TJObjZaehler = class
  private
    fJsonObject: TJSONObject;
    fJsonString: string;
    fJObjErrorList: TJObjErrorList;
    procedure setJsonString(const Value: string);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property JsonObject: TJSONObject read fJsonObject write fJsonObject;
    property JsonString: string read fJsonString write setJsonString;
    function CheckValues: string;
  end;

implementation

{ TJObjZaehler }

uses
  JObjekt.Error;


constructor TJObjZaehler.Create;
begin
  fJsonObject := nil;
  fJObjErrorList := nil;
end;

destructor TJObjZaehler.Destroy;
begin
  if fJsonObject <> nil then
    FreeAndNil(fJsonObject);
  if fJObjErrorList <> nil then
    FreeAndNil(fJObjErrorList);
  inherited;
end;

procedure TJObjZaehler.setJsonString(const Value: string);
begin
  fJsonString := Value;
  if fJsonObject <> nil then
    FreeAndNil(fJsonObject);
  JsonObject := TJSONObject.ParseJSONValue(fJsonString) as TJSONObject;
end;

function TJObjZaehler.CheckValues: string;
var
  s: string;
  i: Integer;
  Error: TJObjError;
begin
  Result := '';
  if fJObjErrorList <> nil then
    FreeAndNil(fJObjErrorList);
  fJObjErrorList := TJObjErrorList.Create;
  try
    if fJsonObject.FindValue('ZA_ID') = nil then
    begin
      Error := fJObjErrorList.add;
      Error.Status := '1';
      Error.Code := 'Wert ZA_ID fehlt';
    end;
    if fJsonObject.FindValue('ZA_ZAEHLER') = nil then
    begin
      Error := fJObjErrorList.add;
      Error.Status := '1';
      Error.Code := 'Wert ZA_ZAEHLER fehlt';
    end;
    s := fJsonObject.GetValue('ZA_ID').Value;
    if not TryStrToInt(s, i) then
    begin
      Error := fJObjErrorList.add;
      Error.Status := '1';
      Error.Code := 'Wert ZA_ID ist nicht numerisch = ' + s;
    end;

    Result := fJObjErrorList.JsonString;
  finally
    FreeAndNil(fJObjErrorList);
  end;
end;


end.
