unit DB.SchnittstelleList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Schnittstelle, Objekt.ObjektList;


type
  TDBSchnittstelleList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBSchnittstelle;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBSchnittstelle read getItem;
    function Add: TDBSchnittstelle;
    procedure ReadAll;
  end;

implementation

{ TDBSchnittstelleList }


constructor TDBSchnittstelleList.Create;
begin
  inherited;

end;

destructor TDBSchnittstelleList.Destroy;
begin

  inherited;
end;

function TDBSchnittstelleList.getItem(Index: Integer): TDBSchnittstelle;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBSchnittstelle(fList.Items[Index]);
end;

function TDBSchnittstelleList.Add: TDBSchnittstelle;
begin
  Result := TDBSchnittstelle.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


procedure TDBSchnittstelleList.ReadAll;
var
  x: TDBSchnittstelle;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from schnittstelle where ss_DELETE != ' + QuotedStr('T') +
                       ' order by ss_name';
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBSchnittstelle.Create(nil);
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
