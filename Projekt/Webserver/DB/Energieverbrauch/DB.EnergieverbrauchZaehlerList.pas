unit DB.EnergieverbrauchZaehlerList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.EnergieverbrauchZaehler, System.Contnrs;


type
  TDBEnergieverbrauchZaehlerList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBEnergieverbrauchZaehler;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBEnergieverbrauchZaehler read getItem;
    function Add: TDBEnergieverbrauchZaehler;
    procedure ReadAll;
    procedure ReadbyId(aId: Integer);
  end;

implementation

{ TDBEnergieverbrauchZaehlerList }


constructor TDBEnergieverbrauchZaehlerList.Create;
begin
  inherited;

end;

destructor TDBEnergieverbrauchZaehlerList.Destroy;
begin

  inherited;
end;

function TDBEnergieverbrauchZaehlerList.getItem(Index: Integer): TDBEnergieverbrauchZaehler;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBEnergieverbrauchZaehler(fList.Items[Index]);
end;



function TDBEnergieverbrauchZaehlerList.Add: TDBEnergieverbrauchZaehler;
begin
  Result := TDBEnergieverbrauchZaehler.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBEnergieverbrauchZaehlerList.ReadAll;
var
  x: TDBEnergieverbrauchZaehler;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from zaehler where za_DELETE != ' + QuotedStr('T') +
                       ' order by za_zaehler';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehler.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;



procedure TDBEnergieverbrauchZaehlerList.ReadbyId(aId: Integer);
var
  x: TDBEnergieverbrauchZaehler;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from zaehler where za_DELETE != ' + QuotedStr('T') +
                       ' and za_id = ' + aId.ToString +
                       ' order by za_zaehler';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchZaehler.Create(nil);
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
