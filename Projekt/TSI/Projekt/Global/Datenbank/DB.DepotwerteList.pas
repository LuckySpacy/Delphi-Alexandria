unit DB.DepotwerteList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Depotwerte, Objekt.ObjektList;


type
  TDBDepotwerteList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBDepotwerte;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBDepotwerte read getItem;
    function Add: TDBDepotwerte;
    procedure ReadAll;
    function DeleteAll(aDpId: Integer): Boolean;
  end;

implementation

{ TDBDepotwerteList }


constructor TDBDepotwerteList.Create;
begin
  inherited;

end;


destructor TDBDepotwerteList.Destroy;
begin

  inherited;
end;


function TDBDepotwerteList.Add: TDBDepotwerte;
begin
  Result := TDBDepotwerte.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;



function TDBDepotwerteList.getItem(Index: Integer): TDBDepotwerte;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBDepotwerte(fList.Items[Index]);
end;


procedure TDBDepotwerteList.ReadAll;
var
  x: TDBDepotwerte;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from depotwerte where dw_DELETE != ' + QuotedStr('T');
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBDepotwerte.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


function TDBDepotwerteList.DeleteAll(aDpId: Integer): Boolean;
var
  qry: TIBQuery;
  WasOpen: Boolean;
begin
  Result := false;
  WasOpen := fTrans.InTransaction;
  qry := TIBQuery.Create(nil);
  try
    qry.Transaction := fTrans;
    if not WasOpen then
      fTrans.StartTransaction;
    qry.sql.Text := 'delete from depotwerte where dw_dp_id = :id';
    qry.ParamByName('id').AsInteger := aDpId;
    try
      qry.ExecSQL;
    except
      exit;
    end;
    if not WasOpen then
      fTrans.Commit;
    Result := true;
  finally
    FreeAndNil(qry);
  end;

end;


end.
