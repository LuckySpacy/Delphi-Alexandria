unit DB.ZaehlerUpdateList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.ZaehlerUpdate, Firedac.Stan.Param;

type
  TDBZaehlerUpdateList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBZaehlerUpdate;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBZaehlerUpdate read getItem;
    function Add: TDBZaehlerUpdate;
    function ReadAll: Integer;
    //procedure DeleteAllTransferd;
    function DeviceIdExist(aDeviceId: string): Boolean;
    function ToDoIdExist(aToDoId: string): Boolean;
    procedure DeleteAll;
  end;

implementation

{ TDBZaehlerUpdateList }


uses
  Objekt.BasCloud, fmx.Types;


constructor TDBZaehlerUpdateList.Create;
begin
  inherited;

end;



destructor TDBZaehlerUpdateList.Destroy;
begin

  inherited;
end;

function TDBZaehlerUpdateList.DeviceIdExist(aDeviceId: string): Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(TDBZaehlerUpdate(fList.Items[i1]).DeId, aDeviceId) then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function TDBZaehlerUpdateList.ToDoIdExist(aToDoId: string): Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(TDBZaehlerUpdate(fList.Items[i1]).ToDoId, aToDoId) then
    begin
      Result := true;
      exit;
    end;
  end;
end;


function TDBZaehlerUpdateList.getItem(Index: Integer): TDBZaehlerUpdate;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBZaehlerUpdate(fList.Items[Index]);
end;

function TDBZaehlerUpdateList.Add: TDBZaehlerUpdate;
begin
  Result := TDBZaehlerUpdate.Create;
  fList.Add(Result);
end;


function TDBZaehlerUpdateList.ReadAll: Integer;
var
  ZaehlerUpdate: TDBZaehlerUpdate;
begin
  BasCloud.Log('Start --> TDBZaehlerUpdateList.ReadAll');
  Result := 0;
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from zaehlerupdate order by zu_datum';  // <-- Reihenfolge des hochladens beachten
    try
      fQuery.Open;
      Result := fQuery.RecordCount;
    except
      on E: Exception do
      begin
        Result := -1;
        log.d('TDBZaehlerUpdateList.ReadAll: ' + E.Message);
        BasCloud.Log('          Error: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      Inc(Result);
      ZaehlerUpdate := Add;
      ZaehlerUpdate.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdateList.ReadAll: ' + E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBZaehlerUpdateList.ReadAll');
end;


procedure TDBZaehlerUpdateList.DeleteAll;
begin
  try
    fQuery.Close;
    fQuery.SQL.Text := 'delete from zaehlerupdate';
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBZaehlerUpdateList.DeleteAll: ' + E.Message);
    end;
  end;
end;


{
procedure TDBZaehlerUpdateList.DeleteAllTransferd;
begin
  BasCloud.Log('Start --> TDBZaehlerUpdateList.DeleteAllTransferd');
  fQuery.Close;
  fQuery.Sql.Text := 'delete from zaehlerupdate where zu_importdatum > :importdatum';
  fQuery.ParamByName('importdatum').AsDateTime := 0;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      BasCloud.Log('          Error: ' + E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBZaehlerUpdateList.DeleteAllTransferd');
end;
}


end.
