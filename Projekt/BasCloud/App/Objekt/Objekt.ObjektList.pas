unit Objekt.ObjektList;

interface

uses
  SysUtils, System.Classes;

type
  TObjektList = class(TList)
  private
  protected
  public
    procedure Clear; override;
    procedure Del(Index: Integer);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TObjektList }

procedure TObjektList.Clear;
var
  i1: Integer;
  x: TObject;
begin
  for i1 := Count -1 downto 0 do
  begin
    x := TObject(Items[i1]);
    FreeAndNil(x);
  end;
  inherited;
end;

constructor TObjektList.Create;
begin
  inherited;

end;

procedure TObjektList.Del(Index: Integer);
var
  x: TObject;
begin
  x := TObject(Items[Index]);
  FreeAndNil(x);
  Delete(Index);
end;

destructor TObjektList.Destroy;
begin
  clear;
  inherited;
end;


end.
