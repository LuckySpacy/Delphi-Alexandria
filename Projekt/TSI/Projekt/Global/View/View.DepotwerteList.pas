unit View.DepotwerteList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  View.Depotwerte, Objekt.ObjektList;


type
  TVWDeportwerteList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TVWDepotwerte;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TVWDepotwerte read getItem;
    function Add: TVWDepotwerte;
    procedure ReadAll;
  end;

implementation

{ TVWDeportwerteList }


constructor TVWDeportwerteList.Create;
begin
  inherited;

end;

destructor TVWDeportwerteList.Destroy;
begin

  inherited;
end;

function TVWDeportwerteList.getItem(Index: Integer): TVWDepotwerte;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TVWDepotwerte(fList.Items[Index]);
end;

function TVWDeportwerteList.Add: TVWDepotwerte;
begin
  Result := TVWDepotwerte.Create;
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TVWDeportwerteList.ReadAll;
var
  x: TVWDepotwerte;
begin
  fList.Clear;
  if fTrans = nil then
    exit;

  fQuery.Transaction := fTrans;
  fQuery.Sql.Text := ' select DW_ID, DW_DP_ID, DW_AK_ID, AK_WKN, AK_AKTIE ' +
                     ' from depotwerte ' +
                     ' join aktie on dw_ak_id = ak_id and ak_aktiv = :aktiv and ak_delete != :akdelete'+
                     ' where dw_delete != :dwdelete';
  OpenTrans;
  try
    fQuery.ParamByName('aktiv').AsString := 'T';
    fQuery.ParamByName('dwdelete').AsString := 'T';
    fQuery.ParamByName('akdelete').AsString := 'T';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TVWDepotwerte.Create;
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
