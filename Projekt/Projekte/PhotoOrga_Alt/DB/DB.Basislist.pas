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
    fConnection: TFDConnection;
    function GetCount: Integer;
    procedure setConnection(const Value: TFDConnection);
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
    property Connection: TFDConnection read fConnection write setConnection;
    function AddPointer(Item: Pointer): Integer;

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
 // fQuery.Connection := dm_db.Connection;
  //fQuery.Transaction := dm_db.fdt_Trans;
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
  x := TObject(fList.Items(aIndex));
  fList.Del(aIndex);
  FreeAndNil(x);
end;

function TDBBasisList.AddPointer(Item: Pointer): Integer;
begin
  Result := fList.AddPointer(Item);
end;



function TDBBasisList.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TDBBasisList.List: TObjektList;
begin
  Result := fList;
end;

procedure TDBBasisList.setConnection(const Value: TFDConnection);
begin
  fConnection := Value;
  fQuery.Connection := fConnection;
end;

end.
