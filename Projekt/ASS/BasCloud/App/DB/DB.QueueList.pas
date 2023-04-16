unit DB.QueueList;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.BasisList, FMX.Graphics, DB.Queue;

type
  TDBQueueList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBQueue;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBQueue read getItem;
    function Add: TDBQueue;
    procedure ReadAll;
    procedure DeleteById(aId: Integer);
  end;

implementation

{ TDBQueueList }

uses
  Objekt.BasCloud, Datenmodul.db, fmx.Types;

constructor TDBQueueList.Create;
begin
  inherited;

end;


destructor TDBQueueList.Destroy;
begin

  inherited;
end;

function TDBQueueList.getItem(Index: Integer): TDBQueue;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBQueue(fList.Items[Index]);
end;

function TDBQueueList.Add: TDBQueue;
begin
  Result := TDBQueue.Create;
  fList.Add(Result);
end;


procedure TDBQueueList.ReadAll;
var
  DBQueue: TDBQueue;
begin
  BasCloud.Log('Start --> TDBQueueList.ReadAll');
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from queue order by qu_id ';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        BasCloud.Log('          Error: ' + E.Message);
        log.d('TDBQueueList.ReadAll Error(1): ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      DBQueue := Add;
      DBQueue.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBQueueList.ReadAll Error(2): ' + E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBQueueList.ReadAll');
end;


procedure TDBQueueList.DeleteById(aId: Integer);
begin
  try
    fQuery.Close;
    fQuery.SQL.Text := 'delete from queue where qu_id = :id';
    fQuery.ParamByName('id').AsInteger := aId;
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBQueueList.DeleteById: ' + E.Message);
    end;
  end;
end;


end.
