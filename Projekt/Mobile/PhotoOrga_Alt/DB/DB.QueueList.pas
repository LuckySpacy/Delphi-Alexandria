unit DB.QueueList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Queue, Firedac.Stan.Param, DB.Types;

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
    procedure DeleteAll;
  end;

implementation

{ TDBQueueList }

uses
  fmx.Types;



constructor TDBQueueList.Create;
begin
  inherited;

end;

destructor TDBQueueList.Destroy;
begin

  inherited;
end;


procedure TDBQueueList.DeleteAll;
begin

end;



function TDBQueueList.Add: TDBQueue;
begin
  Result := TDBQueue.Create;
  fList.Add(Result);
end;

function TDBQueueList.getItem(Index: Integer): TDBQueue;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBQueue(fList.Items[Index]);
end;

procedure TDBQueueList.ReadAll;
var
  Queue: TDBQueue;
begin
  try
    fQuery.Close;
    fQuery.Sql.Text := 'select * from queue order by qu_zeitpunkt';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBQueueList.ReadAll: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      Queue := Add;
      Queue.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBQueueList.ReadAll: ' + E.Message);
    end;
  end;
end;




end.
