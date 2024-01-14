unit DB.ZaehlerstandList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Zaehlerstand, System.Contnrs;


type
  TDBZaehlerstandList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBZaehlerstand;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBZaehlerstand read getItem;
    function Add: TDBZaehlerstand;
    procedure ReadAllByZaId(aZaId: Integer);
    procedure ReadAllByZaIdAndJahr(aZaId, aJahr: Integer);
    procedure ReadbyId(aId: Integer);
    procedure ReadAllByZaIdAndZeitraum(aZaId: Integer; aDatumVon, aDatumBis: TDateTime);
  end;

implementation

{ TDBZaehlerstandList }


constructor TDBZaehlerstandList.Create;
begin
  inherited;

end;

destructor TDBZaehlerstandList.Destroy;
begin

  inherited;
end;

function TDBZaehlerstandList.getItem(Index: Integer): TDBZaehlerstand;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBZaehlerstand(fList.Items[Index]);
end;



function TDBZaehlerstandList.Add: TDBZaehlerstand;
begin
  Result := TDBZaehlerstand.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBZaehlerstandList.ReadAllByZaId(aZaId: Integer);
var
  x: TDBZaehlerstand;
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
                       ' order by zs_datum desc';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;



procedure TDBZaehlerstandList.ReadAllByZaIdAndJahr(aZaId, aJahr: Integer);
var
  x: TDBZaehlerstand;
  Von: TDateTime;
  Bis: TDateTime;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  Von := StrToDate('01.01.' + aJahr.ToString);
  bis := StrToDate('31.12.' + aJahr.ToString);
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' and zs_za_id = ' + aZaId.ToString +
                       ' and zs_datum >= :datumvon' +
                       ' and zs_datum <= :datumbis' +
                       ' order by zs_datum desc';
    fQuery.ParamByName('datumvon').AsDate := Von;
    fQuery.ParamByName('datumbis').AsDate := Bis;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBZaehlerstandList.ReadAllByZaIdAndZeitraum(aZaId: Integer; aDatumVon, aDatumBis: TDateTime);
var
  x: TDBZaehlerstand;
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
                       ' and zs_datum >= :datumvon' +
                       ' and zs_datum <= :datumbis' +
                       ' order by zs_datum desc';
    fQuery.ParamByName('datumvon').AsDate := aDatumVon;
    fQuery.ParamByName('datumbis').AsDate := aDatumBis;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBZaehlerstand.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;


procedure TDBZaehlerstandList.ReadbyId(aId: Integer);
var
  x: TDBZaehlerstand;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from zaehlerstand where zs_DELETE != ' + QuotedStr('T') +
                       ' and zs_id = ' + aId.ToString;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBZaehlerstand.Create(nil);
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
