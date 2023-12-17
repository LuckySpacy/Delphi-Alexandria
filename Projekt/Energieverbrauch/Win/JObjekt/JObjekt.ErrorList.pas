unit JObjekt.ErrorList;

interface

uses
  SysUtils, Classes, Objekt.Basislist, JObjekt.Error, System.JSON;

type
  TJObjErrorList = class(TBasisList)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: TJObjError;
    function JsonString: string;
  end;

implementation

{ TJObjErrorList }


constructor TJObjErrorList.Create;
begin
  inherited;

end;

destructor TJObjErrorList.Destroy;
begin

  inherited;
end;


function TJObjErrorList.Add: TJObjError;
begin
  Result := TJObjError.Create;
  fList.Add(Result);
end;


function TJObjErrorList.JsonString: string;
var
  i1: Integer;
  x: TJObjError;
  JsonObject, ErrorObject: TJSONObject;
  ErrorsArrayElements: TJSONArray;
begin

  if fList.Count = 0 then
  begin
    Result := '';
    exit;
  end;

  JsonObject := TJSONObject.Create;
  try
    // Erstellen des äußeren JSON-Objekts

    // Erstellen des "errors"-Arrays
    ErrorsArrayElements := TJSONArray.Create;

    for i1 := 0 to fList.Count -1 do
    begin
      x := TJObjError(fList.Items[i1]);
      // Erstellen des ersten Fehlerobjekts
      ErrorObject := TJSONObject.Create;
      ErrorObject.AddPair('code', x.Code);
      ErrorObject.AddPair('status', x.Status);
      ErrorObject.AddPair('title', x.Title);
      ErrorObject.AddPair('detail', x.Detail);
      ErrorsArrayElements.AddElement(ErrorObject);
    end;


    // Das "errors"-Array zum äußeren JSON-Objekt hinzufügen
    //ErrorsArray.AddPair('error', ErrorsArrayElements);
    //JsonObject.AddPair('errors', ErrorsArray);
    JsonObject.AddPair('errors', ErrorsArrayElements);

    Result := JsonObject.ToString;

  finally
    JsonObject.Free;
  end;
end;



end.
