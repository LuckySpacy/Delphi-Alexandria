unit View.GuVJahreList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  View.GuVJahre, Objekt.ObjektList;


type
  TVWGuVJahreList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TVWGuVJahre;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TVWGuVJahre read getItem;
    function Add: TVWGuVJahre;
    procedure ReadAll;
  end;

implementation

{ TVWGuVJahreList }


constructor TVWGuVJahreList.Create;
begin
  inherited;

end;

destructor TVWGuVJahreList.Destroy;
begin

  inherited;
end;

function TVWGuVJahreList.Add: TVWGuVJahre;
begin
  Result := TVWGuVJahre.Create;
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TVWGuVJahreList.getItem(Index: Integer): TVWGuVJahre;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TVWGuVJahre(fList.Items[Index]);
end;

procedure TVWGuVJahreList.ReadAll;
var
  x: TVWGuVJahre;
begin
  fList.Clear;
  if fTrans = nil then
    exit;

  fQuery.Transaction := fTrans;
  fQuery.Sql.Text := ' select ak_id, ak_aktie, ak_wkn, ak_depot,' +
                     ' gj_jahr1, gj_prozent1, gj_jahr2, gj_prozent2, gj_jahr3, gj_prozent3,' +
                     ' gj_jahr4, gj_prozent4, gj_jahr5, gj_prozent5, gj_jahr6, gj_prozent6, gj_durchschnitt,'+
                     ' GJ_PROZ365TAGE, GJ_TSI27, GJ_ABWPROZ, GJ_ABWPROZSORT' +
                     ' from aktie ' +
                     ' join guvjahre on gj_ak_id = ak_id ' +
                     ' order by ak_aktie';
  OpenTrans;
  try
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TVWGuVJahre.Create;
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
