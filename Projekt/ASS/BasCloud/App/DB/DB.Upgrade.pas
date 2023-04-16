unit DB.Upgrade;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBUpgrade = class(TDBBasis)
  private
    fId: Integer;
    fDatum: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    function Insert: Boolean;
    function Read(aId: Integer): Boolean;
    property Id: Integer read fId write fId;
    property Datum: string read fDatum write fDatum;
    procedure LoadFromQuery(aQry: TFDQuery);
    function LastUpdate: string;
  end;

implementation

{ TDBUpgrade }

uses
   Objekt.BasCloud, fmx.Types;

constructor TDBUpgrade.Create;
begin
  inherited;
  Init;
end;

destructor TDBUpgrade.Destroy;
begin

  inherited;
end;

procedure TDBUpgrade.Init;
begin
  fId    := 0;
  fDatum := '';
end;

function TDBUpgrade.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into upgrade (up_datum) values (:datum)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('datum').AsString := fDatum;
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      BasCloud.Error := E.Message;
      log.d('TDBUpgrade.Insert: ' + E.Message)
    end;
  end;
end;

procedure TDBUpgrade.LoadFromQuery(aQry: TFDQuery);
begin
  fId          := aQry.FieldByName('up_id').AsInteger;
  fDatum       := aQry.FieldByName('up_datum').AsString;
end;

function TDBUpgrade.Read(aId: Integer): Boolean;
var
  s: string;
begin
  Result := false;
  try
    s := 'select * from upgrade where up_id = :id';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsInteger := aId;
    fQuery.Open;
    Init;
    if not fQuery.Eof then
    begin
      LoadFromQuery(fQuery);
      Result := true;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBUpgrade.Read: ' +  E.Message)
    end;
  end;
end;

function TDBUpgrade.LastUpdate: string;
var
  s: string;
begin
  Result := '';
  try
    s := 'select * from upgrade order by up_datum desc';
    fQuery.Close;
    fQuery.SQL.Text := s;
    fQuery.Open;
    Init;
    if not fQuery.Eof then
    begin
      LoadFromQuery(fQuery);
      Result := fDatum;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBUpgrade.LastUpdate: ' +  E.Message)
    end;
  end;
end;


end.
