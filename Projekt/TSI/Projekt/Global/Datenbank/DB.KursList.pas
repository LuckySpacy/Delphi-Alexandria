unit DB.KursList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Kurs, Objekt.ObjektList;


type
  TDBKursList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBKurs;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBKurs read getItem;
    function Add: TDBKurs;
    procedure ReadAll(aAkId: Integer);
    function LastKurs(aAkId: Integer): TDateTime;
    procedure ReadFromStart(aAkId: Integer; aDateTime: TDateTime);
  end;

implementation

{ TDBKursList }


constructor TDBKursList.Create;
begin
  inherited;

end;

destructor TDBKursList.Destroy;
begin

  inherited;
end;

function TDBKursList.getItem(Index: Integer): TDBKurs;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBKurs(fList.Items[Index]);
end;


function TDBKursList.Add: TDBKurs;
begin
  Result := TDBKurs.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;



procedure TDBKursList.ReadAll(aAkId: Integer);
var
  x: TDBKurs;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from kurs where ku_DELETE != ' + QuotedStr('T') +
                       ' and ku_ak_id = ' + IntToStr(aAkId) +
                       ' order by ku_datum';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBKurs.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fQuery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

function TDBKursList.LastKurs(aAkId: Integer): TDateTime;
begin
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select max(ku_datum) from kurs where ku_DELETE != ' + QuotedStr('T') +
                       ' and ku_ak_id = ' + IntToStr(aAkId);
    fQuery.Open;
    Result := 0;
    if not fQuery.Eof then
      Result := fQuery.Fields[0].AsDateTime;
    fQuery.Close;
  finally
    RollbackTrans;
  end;
end;


procedure TDBKursList.ReadFromStart(aAkId: Integer; aDateTime: TDateTime);
var
  x: TDBKurs;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from kurs where ku_DELETE != ' + QuotedStr('T') +
                       ' and ku_ak_id = ' + IntToStr(aAkId) +
                       ' and ku_datum >= :datum' +
                       ' order by ku_datum';
    fQuery.ParamByName('datum').AsDateTime := aDateTime;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBKurs.Create(nil);
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
