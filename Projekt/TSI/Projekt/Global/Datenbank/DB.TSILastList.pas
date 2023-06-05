unit DB.TSILastList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.TSILast, Objekt.ObjektList;


type
  TDBTSILastList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBTSILast;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBTSILast read getItem;
    function Add: TDBTSILast;
    procedure ReadAll(aAkId: Integer);
  end;

implementation

{ TDBTSILastList }


constructor TDBTSILastList.Create;
begin
  inherited;

end;

destructor TDBTSILastList.Destroy;
begin

  inherited;
end;

function TDBTSILastList.getItem(Index: Integer): TDBTSILast;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBTSILast(fList.Items[Index]);
end;

function TDBTSILastList.Add: TDBTSILast;
begin
  Result := TDBTSILast.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBTSILastList.ReadAll(aAkId: Integer);
var
  x: TDBTSILast;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from tsilast where tl_DELETE != ' + QuotedStr('T') +
                       ' and tl_ak_id = ' + IntToStr(aAkId);
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBTSILast.Create(nil);
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
