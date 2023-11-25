unit Objekt.BilderList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Bild, Objekt.BildList,
  Objekt.AlbenPfadList, Objekt.AlbenPfad;

type
  TBilderList = class
  private
    fAlleBilder: TBildList;
    fAlbenPfadList: TAlbenPfadList;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property AlleBilder: TBildList read fAlleBilder;
    procedure Clear;
    function Add(aBildId: string): TBild;
    procedure LadeAlben;
    function AlbenPfad(aPfad: string): TList;
    property AlbenPfadList: TAlbenPfadList read fAlbenPfadList;
  end;

implementation

{ TBilderList }


constructor TBilderList.Create;
begin
  fAlleBilder := TBildList.Create;
  fAlbenPfadList := TAlbenPfadList.Create;
end;

destructor TBilderList.Destroy;
begin
  FreeAndNil(fAlleBilder);
  FreeAndNil(fAlbenPfadList);
  inherited;
end;


procedure TBilderList.LadeAlben;
var
  i1: Integer;
  AlbenPfad: TAlbenPfad;
  Bild: TBild;
begin
  for i1 := 0 to fAlleBilder.Count -1 do
  begin
    Bild := fAlleBilder.Item[i1];
    AlbenPfad := fAlbenPfadList.Add(Bild.Pfad);
    AlbenPfad.Add(Bild);
  end;
end;

function TBilderList.Add(aBildId: string): TBild;
var
  i1: Integer;
begin
  for i1 := 0 to fAlleBilder.count -1 do
  begin
    if aBildId = fAlleBilder.Item[i1].id then
    begin
      Result := fAlleBilder.Item[i1];
      exit;
    end;
  end;
  Result := fAlleBilder.Add;
  Result.Id := aBildId;
end;

function TBilderList.AlbenPfad(aPfad: string): TList;
var
  AlbenPfad: TAlbenPfad;
begin
  Result := nil;
  AlbenPfad := fAlbenpfadList.getByPfad(aPfad);
  if AlbenPfad = nil then
    exit;
  Result := AlbenPfad.List;
end;

procedure TBilderList.Clear;
begin
  fAlleBilder.Clear;
  fAlbenPfadList.Clear;
end;


end.
