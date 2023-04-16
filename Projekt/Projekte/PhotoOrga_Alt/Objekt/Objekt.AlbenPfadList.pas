unit Objekt.AlbenPfadList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Bild, Objekt.BildList,
  Objekt.AlbenPfad;

type
  TAlbenPfadList = class(TObjektList)
  private
    function getAlbenPfad(Index: Integer): TAlbenPfad;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(aPfad: string): TAlbenPfad;
    function getByPfad(aPfad: string): TAlbenPfad;
    property Item[Index: Integer]: TAlbenPfad read getAlbenPfad;
  end;

implementation

{ TAlbenPfadList }


constructor TAlbenPfadList.Create;
begin
  inherited;

end;

destructor TAlbenPfadList.Destroy;
begin

  inherited;
end;


function TAlbenPfadList.Add(aPfad: string): TAlbenPfad;
begin
  Result := getByPfad(aPfad);
  if Result <> nil then
    exit;
  Result := TAlbenpfad.Create;
  Result.Pfad := aPfad;
  fList.Add(Result);
end;


function TAlbenPfadList.getAlbenPfad(Index: Integer): TAlbenPfad;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAlbenPfad(fList.Items[Index]);
end;

function TAlbenPfadList.getByPfad(aPfad: string): TAlbenPfad;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(TAlbenPfad(fList.Items[i1]).Pfad, aPfad) then
    begin
      Result := TAlbenPfad(fList.Items[i1]);
      exit;
    end;
  end;
end;

end.
