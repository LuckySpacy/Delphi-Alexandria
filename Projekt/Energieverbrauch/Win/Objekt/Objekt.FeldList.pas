unit Objekt.FeldList;

interface


uses
  SysUtils, System.Classes, System.Contnrs, Objekt.BasisList, Objekt.Feld;

type
  TFeldList = class(TBasisList)
  private
    function getField(aIndex: Integer): TFeld;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(aName: string): TFeld;
    function FieldByName(aName: string): TFeld;
    property Field[aIndex: Integer]: TFeld read getField;
    function FieldCount: Integer;
  end;

implementation

{ TFeldList }



constructor TFeldList.Create;
begin
  inherited;

end;

destructor TFeldList.Destroy;
begin

  inherited;
end;

function TFeldList.Add(aName: string): TFeld;
begin
  Result := TFeld.Create(nil);
  Result.Feldname := aName;
  fList.Add(Result);
end;


function TFeldList.getField(aIndex: Integer): TFeld;
begin
  Result := nil;
  if aIndex > fList.Count then
    exit;
  Result := TFeld(fList.Items[aIndex]);
end;

function TFeldList.FieldByName(aName: string): TFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(Field[i1].Feldname, aName) then
    begin
      Result := Field[i1];
      exit;
    end;
  end;
end;

function TFeldList.FieldCount: Integer;
begin
  Result := fList.Count;
end;

end.
