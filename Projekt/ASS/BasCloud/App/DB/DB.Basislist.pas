unit DB.Basislist;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Objekt.ObjektList;

type
  TDBBasisList = class
  private
    function GetCount: Integer;
  protected
    fList: TObjektList;
    fId: Integer;
    fQuery: TFDQuery;
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

{ TDBBasisList }

uses
  Datenmodul.db;

constructor TDBBasisList.Create;
begin
  fList := TObjektList.Create;
  fId := 0;
  fQuery := TFDQuery.Create(nil);
  fQuery.Connection := dm_db.Connection;
end;

destructor TDBBasisList.Destroy;
begin
  FreeAndNil(fList);
  FreeAndNil(fQuery);
  inherited;
end;


procedure TDBBasisList.Clear;
begin
  fList.Clear;
  fId := 0;
end;


procedure TDBBasisList.Delete(aIndex: Integer);
var
  x: TObject;
begin
  if aIndex > fList.Count -1 then
    exit;
  x := TObject(fList.Items[aIndex]);
  fList.Delete(aIndex);
  FreeAndNil(x);
end;


function TDBBasisList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TDBBasisList.List: TObjektList;
begin
  Result := fList;
end;

end.
