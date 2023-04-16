unit DB.Queue;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics, DB.Types;

type
  TDBQueue = class(TDBBasis)
  private
    fId: string;
    fBez: string;
    fProcess: Integer;
    fZeitpunkt: string;
    function getInsertStatement: string;
    function getUpdateStatement: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromQuery(aQry: TFDQuery);
    procedure Init;
    property Id: string read fId write fId;
    property Bez: string read fBez write fBez;
    property Process: Integer read fProcess write fProcess;
    property Zeitpunkt: string read fZeitpunkt write fZeitpunkt;
    function Insert: Boolean;
    function Delete: Boolean;
    function DeleteProcess(aProcess: TQueueProcess) : Boolean;
    procedure AddNewProcess(aQueueProcess: TQueueProcess);
  end;

implementation

{ TDBQueue }

uses
  FMX.DialogService, fmx.Types, Datenmodul.db;


constructor TDBQueue.Create;
begin
  inherited;
  Init;
end;


destructor TDBQueue.Destroy;
begin

  inherited;
end;

procedure TDBQueue.Init;
begin
  fId      := '';
  fBez     := '';
  fProcess := 0;
  fZeitpunkt := '';
end;


function TDBQueue.getInsertStatement: string;
begin
  Result := 'insert into queue (QU_Id, QU_Bez, QU_Process, QU_Zeitpunkt) values ' +
             '(:Id, :Bez, :Process, :Zeitpunkt)';
end;

function TDBQueue.getUpdateStatement: string;
begin
  Result := ' update queue set QU_Id = :QU_Id, QU_Bez = :Bez, QU_Process = :Process' +
            ' where QU_Id = :Id';
end;


function TDBQueue.Insert: Boolean;
begin
  try
    fQuery.SQL.Text := getInsertStatement;
    fId := ErzeugeGuid;
    fQuery.ParamByName('id').AsString := fId;
    fQuery.ParamByName('Bez').AsString := fBez;
    fQuery.ParamByName('Process').AsInteger := fProcess;
    fQuery.ParamByName('Zeitpunkt').AsString := FormatDateTime('yyyymmddhhnnsszzz', now);
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.Insert: ' + E.Message);
      exit;
    end;
  end;
  Result := true;
end;

procedure TDBQueue.LoadFromQuery(aQry: TFDQuery);
begin
  if aQry.Eof then
  begin
    Init;
    exit;
  end;
  fId        := aQry.FieldByName('qu_id').AsString;
  fBez       := aQry.FieldByName('qu_bez').AsString;
  fProcess   := aQry.FieldByName('qu_process').AsInteger;
  fZeitpunkt := aQry.FieldByName('qu_zeitpunkt').AsString;
end;

procedure TDBQueue.AddNewProcess(aQueueProcess: TQueueProcess);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dm_db.Connection;
    Qry.Sql.Text := 'select * from queue where qu_process = ' + IntToStr(ord(aQueueProcess));
    Qry.open;
    if not qry.eof then
      exit;
    if aQueueProcess = c_quAktualThumbnails then
      fBez := 'Aktualisiere Thumbnails';
    Insert;
  finally
    FreeAndNil(Qry);
  end;
end;

function TDBQueue.Delete: Boolean;
begin
  Result := true;
  fQuery.SQL.Text := 'delete from queue where qu_id = ' + QuotedStr(fId);
  try
    fQuery.ExecSql;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.Delete: ' + E.Message);
      exit;
    end;
  end;
end;

function TDBQueue.DeleteProcess(aProcess: TQueueProcess): Boolean;
begin
  Result := true;
  fQuery.SQL.Text := 'delete from queue where qu_process = ' + IntToStr(Ord(aProcess));
  try
    fQuery.ExecSql;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.DeleteProcess: ' + E.Message);
      exit;
    end;
  end;
end;

end.
