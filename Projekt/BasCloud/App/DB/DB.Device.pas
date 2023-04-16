unit DB.Device;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBDevice = class(TDBBasis)
  private
    fId: string;
    fEinheit: string;
    fGbId: string;
    fAksId: string;
    fDescription: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Insert: Boolean;
    function Patch: Boolean;
    function Read(aId: string): Boolean;
    function Update: Boolean;
    property Id: string read fId write fId;
    property Einheit: string read fEinheit write fEinheit;
    property Description: string read fDescription write fDescription;
    property AksId: string read fAksId write fAksId;
    property GbId: string read fGbId write fGbId;
    procedure LoadFromQuery(aQry: TFDQuery);
  end;

implementation

{ TDBDevice }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;

constructor TDBDevice.Create;
begin
  inherited;
  Init;
end;

destructor TDBDevice.Destroy;
begin

  inherited;
end;

procedure TDBDevice.Init;
begin
  fId          := '';
  fEinheit     := '';
  fGbId        := '';
  fAksId       := '';
  fDescription := '';
end;

function TDBDevice.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into device (de_id, de_einheit, de_description, de_aksid, de_gb_id) values ' +
         '(:id, :einheit, :description, :aksid, :gbid)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := fId;
    fQuery.ParamByName('einheit').AsString := copy(Trim(fEinheit), 1, 200);
    fQuery.ParamByName('description').AsString :=  copy(Trim(fDescription), 1, 200);
    fQuery.ParamByName('aksid').AsString := copy(Trim(fAksId), 1, 100);
    fQuery.ParamByName('gbid').AsString := fgbid;
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBDevice.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

function TDBDevice.Patch: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := ' update device set de_einheit = :einheit, de_description = :description, de_aksid = :aksid,' +
         ' de_gb_id = :gbid' +
         ' where de_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := fId;
    fQuery.ParamByName('einheit').AsString := copy(Trim(fEinheit), 1, 200);;
    fQuery.ParamByName('description').AsString := copy(Trim(fDescription), 1, 200);;
    fQuery.ParamByName('aksid').AsString := copy(Trim(fAksId), 1, 100);;
    fQuery.ParamByName('gbid').AsString := fgbid;
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBDevice.Patch: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;


function TDBDevice.Read(aId: string): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from device where de_id = :id';
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
      log.d('TDBDevice.Read: ' + E.Message);
    end;
  end;
end;

function TDBDevice.Update: Boolean;
begin
  if fId = '' then
    Result := Insert
  else
    Result := Patch;
end;

procedure TDBDevice.LoadFromQuery(aQry: TFDQuery);
begin
  fId          := aQry.FieldByName('de_id').AsString;
  fEinheit     := aQry.FieldByName('de_einheit').AsString;
  fDescription := aQry.FieldByName('de_description').AsString;
  fAksId       := aQry.FieldByName('de_aksid').AsString;
  fGbid        := aQry.FieldByName('de_gb_id').AsString;
end;


end.
