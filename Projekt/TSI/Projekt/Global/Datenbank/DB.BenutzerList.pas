unit DB.BenutzerList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList, DB.BasisList,
  DB.Benutzer, Objekt.ObjektList;


type
  TDBBenutzerList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBBenutzer;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBBenutzer read getItem;
    function Add: TDBBenutzer;
    procedure ReadAll;
  end;

implementation

{ TDBBenutzerList }


constructor TDBBenutzerList.Create;
begin
  inherited;

end;

destructor TDBBenutzerList.Destroy;
begin

  inherited;
end;


function TDBBenutzerList.Add: TDBBenutzer;
begin
  Result := TDBBenutzer.Create(nil);
  Result.Trans := Trans;
  fList.Add(Result);
end;


function TDBBenutzerList.getItem(Index: Integer): TDBBenutzer;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBBenutzer(fList.Items[Index]);
end;

procedure TDBBenutzerList.ReadAll;
var
  x: TDBBenutzer;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Transaction := fTrans;
  fQuery.Close;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from benutzer where be_DELETE != ' + QuotedStr('T');
    fQuery.Open;
    while not fQuery.Eof do
    begin
      x := TDBBenutzer.Create(nil);
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
