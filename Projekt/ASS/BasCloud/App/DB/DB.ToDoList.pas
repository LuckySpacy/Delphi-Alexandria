unit DB.ToDoList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.ToDo, Firedac.Stan.Param;

type
  TDBToDoList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBToDo;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBToDo read getItem;
    function Add: TDBToDo;
    procedure ReadAll;
    procedure DeleteAll;
  end;


implementation

{ TDBZaehlerUpdateList }

uses
  Objekt.BasCloud, fmx.Types;


constructor TDBToDoList.Create;
begin
  inherited;

end;


destructor TDBToDoList.Destroy;
begin

  inherited;
end;

function TDBToDoList.getItem(Index: Integer): TDBToDo;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBToDo(fList.Items[Index]);
end;


procedure TDBToDoList.DeleteAll;
begin
  try
    fQuery.Close;
    fQuery.Sql.Text := 'delete from todo';
    fQuery.ExecSQL;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBToDoList.DeleteAll: ' + E.Message);
    end;
  end;
end;


procedure TDBToDoList.ReadAll;
var
  ToDo: TDBToDo;
begin
  BasCloud.Log('Start --> TDBToDoList.ReadAll');
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from todo';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBToDoList.ReadAll: ' + E.Message);
        BasCloud.Log('          Error: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      ToDo := Add;
      ToDo.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBToDoList.ReadAll: ' + E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBToDoList.ReadAll');
end;

function TDBToDoList.Add: TDBToDo;
begin
  Result := TDBToDo.Create;
  fList.Add(Result);
end;


end.
