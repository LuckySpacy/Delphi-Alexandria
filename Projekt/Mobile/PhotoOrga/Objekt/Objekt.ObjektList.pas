unit Objekt.ObjektList;

interface

uses
  SysUtils, System.Classes;

type
  TObjektList = class
  private
  protected
    fList: TList;
  public
    procedure Clear;
    procedure Del(Index: Integer);
    constructor Create; virtual;
    destructor Destroy; override;
    function Count: Integer;
    function Items(aIndex: Integer): TObject;
    function AddPointer(Item: Pointer): Integer;
  end;

implementation

{ TObjektList }



constructor TObjektList.Create;
begin
  inherited;
  fList := TList.Create;
end;

destructor TObjektList.Destroy;
begin
  clear;
  FreeAndNil(fList);
  inherited;
end;


function TObjektList.Items(aIndex: Integer): TObject;
begin
  Result := TObject(fList.Items[aIndex]);
end;


procedure TObjektList.Clear;
var
  i1: Integer;
  x: TObject;
begin
  for i1 := fList.Count -1 downto 0 do
  begin
    x := TObject(fList.Items[i1]);
    FreeAndNil(x);
  end;
  fList.Clear;
  inherited;
end;


procedure TObjektList.Del(Index: Integer);
var
  x: TObject;
begin
  x := TObject(fList.Items[Index]);
  FreeAndNil(x);
  fList.Delete(Index);
end;

function TObjektList.Count: Integer;
begin
  Result := fList.Count;
end;

function TObjektList.AddPointer(Item: Pointer): Integer;
begin
  Result := fList.Add(Item);
end;





end.
