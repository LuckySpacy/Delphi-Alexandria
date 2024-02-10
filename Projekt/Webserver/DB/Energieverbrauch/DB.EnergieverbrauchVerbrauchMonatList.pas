unit DB.EnergieverbrauchVerbrauchMonatList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.EnergieverbrauchVerbrauchMonat, System.Contnrs;


type
  TDBEnergieverbrauchVerbrauchMonatList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBEnergieverbrauchVerbrauchMonat;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBEnergieverbrauchVerbrauchMonat read getItem;
    function Add: TDBEnergieverbrauchVerbrauchMonat;
    procedure ReadAll;
    procedure ReadbyId(aId: Integer);
    procedure ReadZeitraum(aZaId: Integer; aMonatVon, aJahrVon, aMonatBis, aJahrBis: Integer);
  end;

implementation

{ TDBEnergieverbrauchVerbrauchMonatList }


constructor TDBEnergieverbrauchVerbrauchMonatList.Create;
begin
  inherited;

end;

destructor TDBEnergieverbrauchVerbrauchMonatList.Destroy;
begin

  inherited;
end;

function TDBEnergieverbrauchVerbrauchMonatList.Add: TDBEnergieverbrauchVerbrauchMonat;
begin
  Result := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TDBEnergieverbrauchVerbrauchMonatList.getItem(
  Index: Integer): TDBEnergieverbrauchVerbrauchMonat;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBEnergieverbrauchVerbrauchMonat(fList.Items[Index]);
end;


procedure TDBEnergieverbrauchVerbrauchMonatList.ReadAll;
var
  x: TDBEnergieverbrauchVerbrauchMonat;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := 'select * from verbrauchmonat where vm_DELETE != ' + QuotedStr('T') +
                       ' order by vm_za_id, vm_jahr, vm_monat';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchVerbrauchMonatList.ReadbyId(aId: Integer);
var
  x: TDBEnergieverbrauchVerbrauchMonat;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from verbrauchmonat where vm_DELETE != ' + QuotedStr('T') +
                       ' and vm_za_id = ' + aId.ToString +
                       ' order by vm_Jahr, vm_Monat';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    fQuery.RollbackTrans;
  end;
end;

procedure TDBEnergieverbrauchVerbrauchMonatList.ReadZeitraum(aZaId, aMonatVon,
  aJahrVon, aMonatBis, aJahrBis: Integer);
var
  x: TDBEnergieverbrauchVerbrauchMonat;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Trans := fTrans;
  fQuery.Close;
  fQuery.OpenTrans;
  try
    fQuery.SQL.Text := ' select * from verbrauchmonat where vm_DELETE != ' + QuotedStr('T') +
                       ' and vm_za_id = ' + aZaId.ToString +
                       ' and vm_Jahr  >=  :Jahrvon ' +
                       ' and vm_Monat >=  :Monatvon ' +
                       ' and vm_Jahr  <=  :Jahrbis ' +
                       ' and vm_Monat <=  :Monatbis ' +
                       ' order by vm_jahr, vm_monat';
    fQuery.ParamByName('Jahrvon').AsInteger   := aJahrvon;
    fQuery.ParamByName('Monatvon').AsInteger  := aMonatvon;
    fQuery.ParamByName('Jahrbis').AsInteger   := aJahrbis;
    fQuery.ParamByName('Monatbis').AsInteger  := aMonatbis;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
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
