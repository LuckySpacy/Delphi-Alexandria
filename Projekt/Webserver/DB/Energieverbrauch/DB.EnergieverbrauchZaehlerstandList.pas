unit DB.EnergieverbrauchZaehlerstandList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.EnergieverbrauchZaehlerstand, System.Contnrs;


type
  TDBEnergieverbrauchZaehlerstandList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBEnergieverbrauchZaehlerstand;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBEnergieverbrauchZaehlerstand read getItem;
    function Add: TDBEnergieverbrauchZaehlerstand;
    procedure ReadAll;
    procedure ReadbyId(aId: Integer);
    procedure ReadZeitraum(aZaId: Integer; aDatumvon, aDatumbis: TDateTime);
    procedure ReadAllByZaehler(aZaId: Integer);
  end;

implementation

{ TDBEnergieverbrauchZaehlerList }


constructor TDBEnergieverbrauchZaehlerstandList.Create;
begin
  inherited;

end;

destructor TDBEnergieverbrauchZaehlerstandList.Destroy;
begin

  inherited;
end;

function TDBEnergieverbrauchZaehlerstandList.getItem(Index: Integer): TDBEnergieverbrauchZaehlerstand;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBEnergieverbrauchZaehlerstand(fList.Items[Index]);
end;



function TDBEnergieverbrauchZaehlerstandList.Add: TDBEnergieverbrauchZaehlerstand;
begin
  Result := TDBEnergieverbrauchZaehlerstand.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBEnergieverbrauchZaehlerstandList.ReadAll;
var
  x: TDBEnergieverbrauchZaehlerstand;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' order by zs_za_id, zs_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchZaehlerstandList.ReadAllByZaehler(aZaId: Integer);
var
  x: TDBEnergieverbrauchZaehlerstand;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' and zs_za_id = :ZaId' +
                       ' order by zs_za_id, zs_datum';
    fQuery.ParamByName('zaid').AsInteger := aZaId;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;



procedure TDBEnergieverbrauchZaehlerstandList.ReadbyId(aId: Integer);
var
  x: TDBEnergieverbrauchZaehlerstand;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' and zs_za_id = ' + aId.ToString +
                       ' order by zs_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchZaehlerstandList.ReadZeitraum(aZaId: Integer;
  aDatumvon, aDatumbis: TDateTime);
var
  x: TDBEnergieverbrauchZaehlerstand;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' and zs_za_id = ' + aZaId.ToString +
                       ' and zs_datum >= :Datumvon ' +
                       ' and zs_datum <= :Datumbis ' +
                       ' order by zs_datum';
    fQuery.ParamByName('Datumvon').AsDateTime := trunc(aDatumvon);
    fQuery.ParamByName('Datumbis').AsDateTime := trunc(aDatumbis);
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehlerstand.Create(nil);
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
