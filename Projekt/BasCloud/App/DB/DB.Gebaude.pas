unit DB.Gebaude;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBGebaude = class(TDBBasis)
  private
    fId: string;
    fGebaudename: string;
    fStrasse: string;
    fOrt: string;
    fLand: string;
    fPlz: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    property Id: string read fId write fId;
    property Gebaudename: string read fGebaudename write fGebaudename;
    property Ort: string read fOrt write fOrt;
    property Land: string read fLand write fLand;
    property Strasse: string read fStrasse write fStrasse;
    property Plz: string read fPlz write fPlz;
    procedure Init;
    function Insert: Boolean;
    function Patch: Boolean;
    function Read(aId: string): Boolean;
    function Update: Boolean;
    procedure LoadFromQuery(aQry: TFDQuery);
  end;

implementation

{ TDBGebaude }

uses
  Objekt.BasCloud, FMX.DialogService, fmx.Types;

constructor TDBGebaude.Create;
begin
  inherited;
  Init;
end;

destructor TDBGebaude.Destroy;
begin

  inherited;
end;

procedure TDBGebaude.Init;
begin
  fId          := '';
  fGebaudename := '';
  fStrasse     := '';
  fOrt         := '';
  fLand        := '';
  fPlz         := '';
end;

function TDBGebaude.Insert: Boolean;
var
  s: string;
begin
  Result := true;
  try
    s := 'insert into Gebaude (gb_id, gb_name, gb_ort, gb_land, gb_plz, gb_strasse) values ' +
         '(:gbid, :gbname, :ort, :land, :plz, :strasse)';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('gbid').AsString := fId;
    fQuery.ParamByName('gbname').AsString := fGebaudename;
    fQuery.ParamByName('ort').AsString := fOrt;
    fQuery.ParamByName('land').AsString := fland;
    fQuery.ParamByName('plz').AsString := fPlz;
    fQuery.ParamByName('strasse').AsString := fStrasse;
    fQuery.ExecSQL;

  except
    on E: Exception do
    begin
      log.d('TDBGebaude.Insert: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;


function TDBGebaude.Patch: Boolean;
var
  s: string;
begin
  Result := true;
  s := ' update Gebaude set gb_name = :gbname, gb_ort = :ort, gb_land = :land,' +
       ' gb_plz = :plz, gb_strasse = :strasse' +
       ' where gb_id = :id';

  fQuery.Sql.Text := s;
  fQuery.ParamByName('id').AsString     := fId;
  fQuery.ParamByName('gbname').AsString := fGebaudename;
  fQuery.ParamByName('ort').AsString := fOrt;
  fQuery.ParamByName('land').AsString := fland;
  fQuery.ParamByName('plz').AsString := fPlz;
  fQuery.ParamByName('strasse').AsString := fStrasse;

  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBGebaude.Patch: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;

end;


function TDBGebaude.Read(aId: string): Boolean;
var
  s: string;
begin
  ProgressInfo('TDBGebaude.Read->fQuery.close', 0, 0);
  try
    fQuery.close;
    s := 'select * from Gebaude where gb_id = :id';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('id').AsString := aId;
    ProgressInfo('TDBGebaude.Read->Id:' + aId, 0, 0);
    ProgressInfo('TDBGebaude.Read->fQuery.open', 0, 0);
    try
      fQuery.Open;
    except
      on E:Exception do
      begin
        ProgressInfo('TDBGebaude.Read->Fehler:' + E.Message, 0, 0);
      end;
    end;
    if fQuery.Eof then
      ProgressInfo('TDBGebaude.Read->fQuery.Eof = true', 0, 0)
    else
      ProgressInfo('TDBGebaude.Read->fQuery.Eof = false', 0, 0);
    Result := not fQuery.Eof;
    if Result then
      LoadFromQuery(fQuery)
    else
      Init;
    fQuery.Close;
  except
    on E: Exception do
    begin
      log.d('TDBGebaude.Patch: ' + E.Message);
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;


function TDBGebaude.Update: Boolean;
begin
  if fId = '' then
    Result := Insert
  else
    Result := Patch;
end;

procedure TDBGebaude.LoadFromQuery(aQry: TFDQuery);
begin
  fId          := aQry.FieldByName('gb_id').AsString;
  fGebaudename := aQry.FieldByName('gb_name').AsString;
  fOrt         := aQry.FieldByName('gb_ort').AsString;
  fLand        := aQry.FieldByName('gb_land').AsString;
  fPlz         := aQry.FieldByName('gb_plz').AsString;
  fStrasse     := aQry.FieldByName('gb_strasse').AsString;
end;

end.
