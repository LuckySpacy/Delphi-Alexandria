unit Objekt.SortList;

interface

uses
  SysUtils, Classes, System.Contnrs, Objekt.Sort, NFSToolbarTypes;

type
  TSortObjList = class
  private
    function GetCount: Integer;
    function GetSortObj(Index: Integer): TSortObj;
  protected
    fList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Clear;
    function Add: TSortObj;
    property Item[Index: Integer]: TSortObj read GetSortObj;
    function getItem(aToolbarItem: TNFSToolbarItem): TSortObj;
    procedure Sort;
  end;

implementation

{ TSortObjList }

uses
  System.Math;

function NrSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := CompareValue(TSortObj(Item1).Nr, TSortObj(Item2).Nr);
end;


constructor TSortObjList.Create;
begin
  fList := TObjectList.Create;
end;

destructor TSortObjList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TSortObjList.Add: TSortObj;
begin
  Result := TSortObj.Create;
  fList.Add(Result);
end;

procedure TSortObjList.Clear;
begin
  fList.Clear;
end;


function TSortObjList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TSortObjList.getItem(aToolbarItem: TNFSToolbarItem): TSortObj;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if TSortObj(fList.Items[i1]).ToolbarItem = aToolbarItem then
    begin
      Result := TSortObj(fList.Items[i1]);
      exit;
    end;
  end;
end;

function TSortObjList.GetSortObj(Index: Integer): TSortObj;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TSortObj(fList[Index]);
end;


procedure TSortObjList.Sort;
begin
  fList.Sort(@NrSortieren);
end;

end.
