unit DB.AktieList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Aktie, Objekt.ObjektList;


type
  TDBAktieList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBAktie;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBAktie read getItem;
    function Add: TDBAktie;
    procedure ReadAll;
  end;

implementation

{ TDBAktieList }


constructor TDBAktieList.Create;
begin
  inherited;

end;

destructor TDBAktieList.Destroy;
begin

  inherited;
end;

function TDBAktieList.Add: TDBAktie;
begin
  Result := TDBAktie.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TDBAktieList.getItem(Index: Integer): TDBAktie;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBAktie(fList.Items[Index]);
end;

procedure TDBAktieList.ReadAll;
var
  x: TDBAktie;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * from aktie ' +
                       ' where ak_DELETE != ' + QuotedStr('T') +
                       ' and ak_aktiv = ' + QuotedStr('T');
    ;
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBAktie.Create(nil);
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
