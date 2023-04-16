unit DB.ToDo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBToDo = class(TDBBasis)
  private
    fId: string;
    fGbId: string;
    fDeId: string;
    fStatus: string;
    fDatum: TDateTime;
    fDueDate: string;
    fKommentar: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Id: string read fId write fId;
    procedure Init;
    function Insert: Boolean;
    function Patch: Boolean;
    function Read(aId: string): Boolean;
    function Update: Boolean;
    property GbId: string read fGbId write fGbId;
    property DeId: string read fDeId write fDeId;
    property Datum: TDateTime read fDatum write fDatum;
    property Status: string read fStatus write fStatus;
    property Kommentar: string read fKommentar write fKommentar;
    property DueDate: string read fDueDate write fDueDate;
    procedure LoadFromQuery(aQry: TFDQuery);
    function Delete(aId: string): Boolean;
  end;

implementation

{ TDBToDo }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;

constructor TDBToDo.Create;
begin
  inherited;
  Init;
end;


destructor TDBToDo.Destroy;
begin

  inherited;
end;

procedure TDBToDo.Init;
begin
  fId        := '';
  fGbId      := '';
  fDeId      := '';
  fStatus    := '';
  fDatum     := 0;
  fDueDate   := '';
  fKommentar := '';

end;

function TDBToDo.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into todo (to_id, to_gb_id, to_de_id, to_datum, to_status, to_kommentar, to_duedate) values ' +
         '(:id, :gbid, :deid, :datum, :status, :kommentar, :duedate)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString   := fId;
    fQuery.ParamByName('gbid').AsString := fGbId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ParamByName('datum').AsDateTime := fDatum;
    fQuery.ParamByName('status').AsString := fStatus;
    fQuery.ParamByName('kommentar').AsString := fKommentar;
    fQuery.ParamByName('duedate').AsString := fDueDate;
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBToDo.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

function TDBToDo.Patch: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := ' update todo set to_gb_id = :gbid, to_de_id = :deid, to_datum = :datum,' +
         ' to_status = :status, to_kommentar = :kommentar, to_duedate = :duedate' +
         ' where to_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := fId;
    fQuery.ParamByName('gbid').AsString := fGbId;
    fQuery.ParamByName('deid').AsString := fDeId;
    fQuery.ParamByName('datum').AsDateTime := fDatum;
    fQuery.ParamByName('status').AsString := fStatus;
    fQuery.ParamByName('kommentar').AsString := fKommentar;
    fQuery.ParamByName('duedate').AsString := fDueDate;
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBToDo.Patch: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;


procedure TDBToDo.LoadFromQuery(aQry: TFDQuery);
begin
  fId        := aQry.FieldByName('to_id').AsString;
  fGbId      := aQry.FieldByName('to_gb_id').AsString;
  fDeId      := aQry.FieldByName('to_de_id').AsString;
  fDatum     := aQry.FieldByName('to_datum').AsDateTime;
  fStatus    := aQry.FieldByName('to_status').AsString;
  fKommentar := aQry.FieldByName('to_kommentar').AsString;
  fDueDate   := aQry.FieldByName('to_duedate').AsString;
end;


function TDBToDo.Read(aId: string): Boolean;
var
  s: string;
begin
  try
    s := 'select * from todo where to_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.Open;
    Result := not fQuery.Eof;
    if Result then
      LoadFromQuery(fQuery)
    else
      Init;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBToDo.Read: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

function TDBToDo.Delete(aId: string): Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'delete from todo where to_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBToDo.Delete: ' + E.Message);
      Result := false;
    end;
  end;
end;



function TDBToDo.Update: Boolean;
begin
  if fId = '' then
    Result := Insert
  else
    Result := Patch;
end;


end.
