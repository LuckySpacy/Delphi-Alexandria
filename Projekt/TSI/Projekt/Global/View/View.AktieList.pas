unit View.AktieList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  View.Aktie, Objekt.ObjektList;


type
  TVWAktieList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TVWAktie;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TVWAktie read getItem;
    function Add: TVWAktie;
    procedure ReadAll(aSSId: Integer);
  end;

implementation

{ TVWAktieList }


constructor TVWAktieList.Create;
begin
  inherited;

end;

destructor TVWAktieList.Destroy;
begin

  inherited;
end;

function TVWAktieList.getItem(Index: Integer): TVWAktie;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TVWAktie(fList.Items[Index]);
end;

function TVWAktieList.Add: TVWAktie;
begin
  Result := TVWAktie.Create;
  Result.Trans := Trans;
  fList.Add(Result);
end;




procedure TVWAktieList.ReadAll(aSSId: Integer);
var
  x: TVWAktie;
begin
  fList.Clear;
  if fTrans = nil then
    exit;

  fQuery.Transaction := fTrans;
  fQuery.Sql.Text := ' select * from aktie ' +
                     ' join akst on as_ak_id = ak_id and as_ss_id =' + IntToStr(aSSId) +
                     ' where ak_aktiv = :aktiv' +
                     ' order by aktie.AK_AKTIE';
  fQuery.ParamByName('aktiv').AsString := 'T';
  OpenTrans;
  try
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TVWAktie.Create;
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
