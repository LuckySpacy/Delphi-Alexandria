unit DB.TSIList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.TSI, Objekt.ObjektList;


type
  TDBTSIList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBTSI;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBTSI read getItem;
    function Add: TDBTSI;
    procedure ReadAll(aAkId: Integer);
    procedure ReadAllWochen(aAkId, aWochen: Integer);
  end;

implementation

{ TDBTSIList }


constructor TDBTSIList.Create;
begin
  inherited;

end;

destructor TDBTSIList.Destroy;
begin

  inherited;
end;

function TDBTSIList.Add: TDBTSI;
begin
  Result := TDBTSI.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TDBTSIList.getItem(Index: Integer): TDBTSI;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBTSI(fList.Items[Index]);
end;

procedure TDBTSIList.ReadAll(aAkId: Integer);
var
  x: TDBTSI;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from tsi where ts_DELETE != ' + QuotedStr('T') +
                       ' and ts_ak_id = ' + IntToStr(aAkId) +
                       ' order by ts_wochen, ts_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBTSI.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TDBTSIList.ReadAllWochen(aAkId, aWochen: Integer);
var
  x: TDBTSI;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from tsi where ts_DELETE != ' + QuotedStr('T') +
                       ' and ts_ak_id = ' + IntToStr(aAkId) +
                       ' and ts_wochen = ' + IntToStr(aWochen) +
                       ' order by ts_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBTSI.Create(nil);
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
