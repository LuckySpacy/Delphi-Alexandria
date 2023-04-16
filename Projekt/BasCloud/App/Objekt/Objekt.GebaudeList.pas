unit Objekt.GebaudeList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Gebaude, Json.Properties;

type
  TGebaudeList = class(TBasisList)
  private
    function getItem(Index: Integer): TGebaude;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TGebaude read getItem;
    function Add(aId: string): TGebaude;
    function getById(aId: string): TGebaude;
    procedure LoadFromJson(aJProperties: TJProperties);
  end;

implementation

{ TGebaudeList }


constructor TGebaudeList.Create;
begin
  inherited;

end;

destructor TGebaudeList.Destroy;
begin

  inherited;
end;


function TGebaudeList.Add(aId: string): TGebaude;
begin
  Result := getById(aId);
  if Result <> nil then
    exit;
  Result := TGebaude.Create;
  Result.Id := aId;
  fList.Add(Result);
end;


function TGebaudeList.getById(aId: string): TGebaude;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  if SameText(aId, TGebaude(fList.Items[i1]).Id) then
  begin
    Result := TGebaude(fList.Items[i1]);
    exit;
  end;
end;

function TGebaudeList.getItem(Index: Integer): TGebaude;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TGebaude(fList.Items[Index]);
end;

procedure TGebaudeList.LoadFromJson(aJProperties: TJProperties);
var
  i1: Integer;
  Gebaude: TGebaude;
begin
  Clear;
  for i1 := 0 to Length(aJProperties.data) -1 do
  begin
    Gebaude := Add(aJProperties.data[i1].id);
    Gebaude.Gebaudename := aJProperties.data[i1].attributes.name;
    Gebaude.Ort         := aJProperties.data[i1].attributes.City;
    Gebaude.Land        := aJProperties.data[i1].attributes.country;
    Gebaude.Plz         := aJProperties.data[i1].attributes.postalCode;
    Gebaude.Strasse     := aJProperties.data[i1].attributes.street;
  end;
end;

end.
