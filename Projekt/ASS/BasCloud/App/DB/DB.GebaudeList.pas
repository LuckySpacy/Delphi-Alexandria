unit DB.GebaudeList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Gebaude, Firedac.Stan.Param;

type
  TDBGebaudeList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBGebaude;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBGebaude read getItem;
    function Add: TDBGebaude;
    procedure ReadAll;
    procedure DeleteAll;
  end;


implementation

{ TDBZaehlerUpdateList }

uses
  Objekt.BasCloud, fmx.Types;


constructor TDBGebaudeList.Create;
begin
  inherited;

end;


destructor TDBGebaudeList.Destroy;
begin

  inherited;
end;

function TDBGebaudeList.getItem(Index: Integer): TDBGebaude;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBGebaude(fList.Items[Index]);
end;


procedure TDBGebaudeList.ReadAll;
var
  Gebaude: TDBGebaude;
begin
  BasCloud.Log('Start --> TDBGebaudeList.ReadAll');
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from gebaude';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBGebaudeList.ReadAll: ' + E.Message);
        BasCloud.Log('          Error: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      Gebaude := Add;
      Gebaude.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBGebaudeList.ReadAll: ' + E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBGebaudeList.ReadAll');
end;

function TDBGebaudeList.Add: TDBGebaude;
begin
  Result := TDBGebaude.Create;
  fList.Add(Result);
end;

procedure TDBGebaudeList.DeleteAll;
begin
  fQuery.Close;
  fQuery.Sql.Text := 'delete from gebaude';
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBGebaudeList.DeleteAll: ' + E.Message);
      BasCloud.Log('          Error: ' + E.Message);
    end;
  end;
end;



end.
