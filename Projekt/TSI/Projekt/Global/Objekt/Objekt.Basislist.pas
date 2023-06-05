unit Objekt.Basislist;

interface

uses
  SysUtils, Classes, Objekt.ObjektList;

type
  TBasisList = class
  private
    function GetCount: Integer;
  protected
    fList: TObjektList;
    fId: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Clear; virtual;
    property Id: Integer read fId write fId;
    procedure Delete(aIndex: Integer);
    function List: TObjektList;
  end;

implementation

{ TBasisList }

constructor TBasisList.Create;
begin
  fList := TObjektList.Create;
  fId := 0;
end;

procedure TBasisList.Delete(aIndex: Integer);
var
  x: TObject;
begin
  if aIndex > fList.Count -1 then
    exit;
  x := TObject(fList.Items[aIndex]);
  fList.Delete(aIndex);
  FreeAndNil(x);
end;

destructor TBasisList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;


procedure TBasisList.Clear;
begin
  fList.Clear;
  fId := 0;
end;


function TBasisList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TBasisList.List: TObjektList;
begin
  Result := fList;
end;

end.
