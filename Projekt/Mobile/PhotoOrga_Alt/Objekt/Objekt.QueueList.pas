unit Objekt.QueueList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, Objekt.ObjektList, Objekt.Queue;

type
  TQueueList = class(TObjektList)
  private
    function getQueue(Index: Integer): TQueue;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(aProcess: TQueueProcess): TQueue;
    property Item[Index: Integer]: TQueue read getQueue;
    function getByProcess(aProcess: TQueueProcess): TQueue;
    procedure DeleteAllMarked;
    procedure DeleteProcess(aProcess: TQueueProcess);
  end;

implementation

{ TQueueList }


constructor TQueueList.Create;
begin
  inherited;

end;


destructor TQueueList.Destroy;
begin

  inherited;
end;

function TQueueList.Add(aProcess: TQueueProcess): TQueue;
begin
  Result := getByProcess(aProcess);
  if Result <> nil then
    exit;
  Result := TQueue.Create;
  Result.Process := aProcess;
  fList.Add(Result);
end;


function TQueueList.getByProcess(aProcess: TQueueProcess): TQueue;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if (TQueue(fList.Items[i1]).Process = aProcess) and (not TQueue(fList.Items[i1]).Del) then
    begin
      Result := TQueue(fList.Items[i1]);
      exit;
    end;
  end;
end;

function TQueueList.getQueue(Index: Integer): TQueue;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TQueue(fList.Items[Index]);
end;


procedure TQueueList.DeleteAllMarked;
var
  i1: Integer;
begin
  for i1 := fList.Count -1 downto 0 do
  begin
    if TQueue(fList.Items[i1]).Del then
      del(i1);
  end;
end;



procedure TQueueList.DeleteProcess(aProcess: TQueueProcess);
var
  i1: Integer;
begin
  for i1 := fList.Count -1 downto 0 do
  begin
    if TQueue(fList.Items[i1]).Process = aProcess then
      TQueue(fList.Items[i1]).Del := true;
  end;
end;

end.
