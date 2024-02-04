unit DB.EnergieverbrauchVerbrauchList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.EnergieverbrauchVerbrauch, System.Contnrs;


type
  TDBEnergieverbrauchVerbrauchList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBEnergieverbrauchVerbrauch;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBEnergieverbrauchVerbrauch read getItem;
    function Add: TDBEnergieverbrauchVerbrauch;
    procedure ReadAll;
    procedure ReadbyId(aId: Integer);
    procedure ReadZeitraum(aZaId: Integer; aDatumvon, aDatumbis: TDateTime);
  end;

implementation

{ TDBEnergieverbrauchVerbrauchList }


constructor TDBEnergieverbrauchVerbrauchList.Create;
begin
  inherited;

end;

destructor TDBEnergieverbrauchVerbrauchList.Destroy;
begin

  inherited;
end;

function TDBEnergieverbrauchVerbrauchList.Add: TDBEnergieverbrauchVerbrauch;
begin
  Result := TDBEnergieverbrauchVerbrauch.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;



function TDBEnergieverbrauchVerbrauchList.getItem(Index: Integer): TDBEnergieverbrauchVerbrauch;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBEnergieverbrauchVerbrauch(fList.Items[Index]);
end;

procedure TDBEnergieverbrauchVerbrauchList.ReadAll;
var
  x: TDBEnergieverbrauchVerbrauch;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from verbrauch where vb_DELETE != ' + QuotedStr('T') +
                       ' order by vb_za_id, vb_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauch.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchVerbrauchList.ReadbyId(aId: Integer);
var
  x: TDBEnergieverbrauchVerbrauch;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from verbrauch where vb_DELETE != ' + QuotedStr('T') +
                       ' and vb_za_id = ' + aId.ToString +
                       ' order by vb_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauch.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchVerbrauchList.ReadZeitraum(aZaId: Integer;
  aDatumvon, aDatumbis: TDateTime);
var
  x: TDBEnergieverbrauchVerbrauch;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from verbrauch where vb_DELETE != ' + QuotedStr('T') +
                       ' and vb_za_id = ' + aZaId.ToString +
                       ' and vb_datum >= :Datumvon ' +
                       ' and vb_datum <= :Datumbis ' +
                       ' order by vb_datum';
    fQuery.ParamByName('Datumvon').AsDateTime := trunc(aDatumvon);
    fQuery.ParamByName('Datumbis').AsDateTime := trunc(aDatumbis);
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauch.Create(nil);
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
