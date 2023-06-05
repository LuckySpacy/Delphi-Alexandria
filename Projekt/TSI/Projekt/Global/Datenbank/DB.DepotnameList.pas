unit DB.DepotnameList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Depotname, Objekt.ObjektList;


type
  TDBDepotnameList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBDepotname;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBDepotname read getItem;
    function Add: TDBDepotname;
    procedure ReadAll;
  end;

implementation

{ TDBDepotnameList }


constructor TDBDepotnameList.Create;
begin
  inherited;

end;

destructor TDBDepotnameList.Destroy;
begin

  inherited;
end;

function TDBDepotnameList.getItem(Index: Integer): TDBDepotname;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBDepotname(fList.Items[Index]);
end;

function TDBDepotnameList.Add: TDBDepotname;
begin
  Result := TDBDepotname.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBDepotnameList.ReadAll;
var
  x: TDBDepotname;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from depot where dp_DELETE != ' + QuotedStr('T');
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBDepotname.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

end.
