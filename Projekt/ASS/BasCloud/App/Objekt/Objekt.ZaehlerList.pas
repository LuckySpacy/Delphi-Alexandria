unit Objekt.ZaehlerList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Zaehler, Json.Devices, Objekt.Gebaude;

type
  TZaehlerList = class(TBasisList)
  private
    function getItem(Index: Integer): TZaehler;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TZaehler read getItem;
    function Add(aId: string): TZaehler;
    function getById(aId: string): TZaehler;
    procedure LoadFromJson(aJDevices: TJDevices);
    function setGebaudeToZaehler(aGebaude: TGebaude; aDeviceId: string): Boolean;
  end;

implementation

{ TZaehlerList }


constructor TZaehlerList.Create;
begin
  inherited;

end;

destructor TZaehlerList.Destroy;
begin

  inherited;
end;

function TZaehlerList.Add(aId: string): TZaehler;
begin
  Result := getById(aId);
  if Result <> nil then
    exit;
  Result := TZaehler.Create;
  Result.Id := aId;
  fList.Add(Result);
end;


function TZaehlerList.getById(aId: string): TZaehler;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  if SameText(aId, TZaehler(fList.Items[i1]).Id) then
  begin
    Result := TZaehler(fList.Items[i1]);
    exit;
  end;
end;

function TZaehlerList.getItem(Index: Integer): TZaehler;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TZaehler(fList.Items[Index]);
end;

procedure TZaehlerList.LoadFromJson(aJDevices: TJDevices);
var
  i1: Integer;
  Zaehler: TZaehler;
begin
  //Clear;
  for i1 := 0 to Length(aJDevices.data) -1 do
  begin
    Zaehler := Add(aJDevices.data[i1].id);
    Zaehler.AksId        := aJDevices.data[i1].attributes.aksId;
    Zaehler.Beschreibung := aJDevices.data[i1].attributes.description;
    Zaehler.Einheit      := aJDevices.data[i1].attributes.&unit;
  end;
end;

function TZaehlerList.setGebaudeToZaehler(aGebaude: TGebaude; aDeviceId: string): Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fList.Count -1 do
  begin
    if TZaehler(fList.Items[i1]).Id = aDeviceId then
    begin
      TZaehler(fList.Items[i1]).Gebaude := aGebaude;
      Result := true;
      break;
    end;
  end;
end;



end.
