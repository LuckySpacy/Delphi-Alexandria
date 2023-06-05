unit View.AnsichtList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  View.Ansicht, Objekt.ObjektList;


type
  TVWAnsichtList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TVWAnsicht;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TVWAnsicht read getItem;
    function Add: TVWAnsicht;
    procedure ReadAll;
    procedure SortAktie;
  end;

implementation

{ TVWAktieList }

function AktieSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := AnsiCompareText(TVWAnsicht(Item1).FeldList.FieldByName('AK_AKTIE').AsString, TVWAnsicht(Item2).FeldList.FieldByName('AK_AKTIE').AsString);
end;


constructor TVWAnsichtList.Create;
begin
  inherited;

end;

destructor TVWAnsichtList.Destroy;
begin

  inherited;
end;

function TVWAnsichtList.getItem(Index: Integer): TVWAnsicht;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TVWAnsicht(fList.Items[Index]);
end;

function TVWAnsichtList.Add: TVWAnsicht;
begin
  Result := TVWAnsicht.Create;
  Result.Trans := Trans;
  fList.Add(Result);
end;




procedure TVWAnsichtList.ReadAll;
var
  x: TVWAnsicht;
begin
  fList.Clear;
  if fTrans = nil then
    exit;

  fQuery.Transaction := fTrans;
  fQuery.Sql.Text := ' select ak_id, ak_aktie, ak_wkn, ak_link, ak_bi_id, ak_symbol, ak_depot, ak_aktiv, ' +
                     ' tsilast12.tl_datum tl_datum12, tsilast12.tl_wert tl_wert12,' +
                     ' tsilast27.tl_datum tl_datum27, tsilast27.tl_wert tl_wert27,' +
                     ' ht_hoch_jahrkurs, ht_hoch_jahrdatum, ht_hoch_hjahrkurs, ht_hoch_hjahrdatum, ht_tief_jahrkurs, ht_tief_jahrdatum, ht_tief_hjahrkurs, ht_tief_hjahrdatum,' +
                     ' ap_datum7, ap_wert7, ap_datum14, ap_wert14, ap_datum30, ap_wert30, ap_datum60, ap_wert60, ap_datum90, ap_wert90, ap_datum180, ap_wert180, ap_datum365, ap_wert365, ' +
                     ' HT_LETZTERKURS, HT_LETZTERKURSDATUM, ap_datum1, ap_wert1, HT_EPS, HT_KGV, HT_KGVSORT ' +
                     ' from aktie ' +
                     ' join tsilast tsilast12 on tsilast12.tl_ak_id = ak_id and tsilast12.tl_wochen = 12 ' +
                     ' join tsilast tsilast27 on tsilast27.tl_ak_id = ak_id and tsilast27.tl_wochen = 27 ' +
                     ' join kurshochtief  on ht_ak_id = ak_id ' +
                     ' join abwproz  on ap_ak_id = ak_id ' +
                     ' order by tsilast27.tl_wert desc';
  OpenTrans;
  try
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TVWAnsicht.Create;
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


procedure TVWAnsichtList.SortAktie;
begin
  fList.Sort(@AktieSortieren);
end;

end.
