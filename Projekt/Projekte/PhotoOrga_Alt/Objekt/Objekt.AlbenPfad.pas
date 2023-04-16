unit Objekt.AlbenPfad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Bild, Objekt.BildList;

type
  TAlbenPfad = class
  private
    fPfad: string;
    fList: TList;
    fId: string;
    function ErzeugeGuid: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Pfad: string read fPfad write fPfad;
    property List: TList read fList;
    procedure Add(aBild: TBild);
    function getById(aBildId: string): TBild;
    property Id: string read fId;
  end;

implementation

{ TAlbenPfad }



constructor TAlbenPfad.Create;
begin
  fList := TList.Create;
  fId := ErzeugeGuid;
end;

destructor TAlbenPfad.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;


function TAlbenPfad.getById(aBildId: string): TBild;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if TBild(fList.Items[i1]).Id = aBildId then
    begin
      Result := TBild(fList.Items[i1]);
      exit;
    end;
  end;
end;

procedure TAlbenPfad.Add(aBild: TBild);
begin
  if getById(aBild.id) = nil then
    fList.Add(aBild);
end;

function TAlbenPfad.ErzeugeGuid: string;
var
  GuId: TGUid;
begin //
  CreateGUID(GuId);
  Result := GUIDToString(GuId);
  Result := StringReplace(Result , '{', '', [rfReplaceAll]);
  Result := StringReplace(Result , '}', '', [rfReplaceAll]);
end;


end.
