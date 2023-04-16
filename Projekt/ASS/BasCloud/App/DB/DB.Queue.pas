unit DB.Queue;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBQueue = class(TDBBasis)
  private
    fId: Integer;
    fBez: string;
    fProcess: Integer;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Insert: Boolean;
    property Id: Integer read fId write fId;
    property Bez: string read fBez write fBez;
    property Process: Integer read fProcess write fProcess;
    procedure LoadFromQuery(aQry: TFDQuery);
    function InsertProcess_AlleDaten: Boolean;
    procedure InsertProcess_SyncDB;
    procedure InsertProcess_FulleVonBasCloudList;
    procedure InsertProcess_AlleZaehlerstaendeLaden;
    procedure InsertProcess_AlleZaehlerstaendeLadenWdh;
    procedure InsertProcess_ManuelRefresh;
    procedure InsertProcess_UploadZaehlerstand;
    function InProcess(aProcess: Integer): Boolean;
    procedure DeleteAll;
  end;

implementation

{ TDBQueue }

uses
  Objekt.BasCloud, fmx.Types;

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
  fId      := 0;
  fBez     := '';
  fProcess := 0;
end;


function TDBQueue.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into queue (qu_bez, qu_process) values (:bez, :process)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('bez').AsString := fBez;
    fQuery.ParamByName('process').AsInteger := fProcess;
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;



function TDBQueue.InProcess(aProcess: Integer): Boolean;
var
  s: string;
begin
  Result := false;
  try
    fQuery.close;
    s := 'select * from queue where qu_process = :process';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('process').AsInteger := aProcess;
    fQuery.Open;
    Result := not fQuery.Eof;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InProcess: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;




function TDBQueue.InsertProcess_AlleDaten: Boolean;
begin
  Result := false;
  try
    if InProcess(1) then
      exit;
    Init;
    fBez := 'Alle Daten';
    fProcess := 1;
    if not InProcess(fProcess) then
      Result := Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_AlleDaten: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

procedure TDBQueue.InsertProcess_AlleZaehlerstaendeLaden;
begin
  try
    if InProcess(4) then
      exit;
    Init;
    fBez := 'Alle Zählerstände laden';
    fProcess := 4;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_AlleZaehlerstaendeLaden: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

procedure TDBQueue.InsertProcess_AlleZaehlerstaendeLadenWdh;
begin
  try
    Init;
    fBez := 'Alle Zählerstände laden';
    fProcess := 6;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_AlleZaehlerstaendeLadenWdh: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

procedure TDBQueue.InsertProcess_SyncDB;
begin
  try
    if InProcess(3) then
      exit;
    Init;
    fBez := 'Datenbank synchronisieren';
    fProcess := 3;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_SyncDB: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;


procedure TDBQueue.InsertProcess_FulleVonBasCloudList;
begin
  try
    if InProcess(2) then
      exit;
    Init;
    fBez := 'Fülle interne Liste von BAScloudliste';
    fProcess := 2;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_FulleVonBasCloudList: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

procedure TDBQueue.InsertProcess_ManuelRefresh;
begin
  try
    if InProcess(5) then
      exit;
    Init;
    fBez := 'Manuellen Refresh';
    fProcess := 5;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_ManuelRefresh: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;

procedure TDBQueue.InsertProcess_UploadZaehlerstand;
begin
  try
    if InProcess(5) then
      exit;
    Init;
    fBez := 'Upload Zaehlerstand';
    fProcess := 7;
    if not InProcess(fProcess) then
      Insert;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.InsertProcess_ManuelRefresh: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;



procedure TDBQueue.LoadFromQuery(aQry: TFDQuery);
begin
  fId          := aQry.FieldByName('qu_id').AsInteger;
  fBez         := aQry.FieldByName('qu_bez').AsString;
  fProcess     := aQry.FieldByName('qu_process').AsInteger;
end;


procedure TDBQueue.DeleteAll;
var
  s: string;
begin
  try
    s := 'delete from queue';
    fQuery.SQL.Text := s;
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBQueue.DeleteAll: ' + E.Message);
      BasCloud.Error := E.Message;
    end;
  end;
end;



end.
