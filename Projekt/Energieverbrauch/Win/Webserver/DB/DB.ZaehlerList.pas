unit DB.ZaehlerList;

interface


uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Zaehler, System.Contnrs;


type
  TDBZaehlerList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBZaehler;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBZaehler read getItem;
    function Add: TDBZaehler;
    procedure ReadAll;
  end;

implementation

{ TDBZaehlerList }


constructor TDBZaehlerList.Create;
begin
  inherited;

end;

destructor TDBZaehlerList.Destroy;
begin

  inherited;
end;

function TDBZaehlerList.getItem(Index: Integer): TDBZaehler;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBZaehler(fList.Items[Index]);
end;



function TDBZaehlerList.Add: TDBZaehler;
begin
  Result := TDBZaehler.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBZaehlerList.ReadAll;
var
  x: TDBZaehler;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from zaehler where za_DELETE != ' + QuotedStr('T') +
                       ' order by za_zaehler desc';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBZaehler.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;



end.
