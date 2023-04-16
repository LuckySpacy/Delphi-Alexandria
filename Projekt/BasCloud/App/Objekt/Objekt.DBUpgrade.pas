unit Objekt.DBUpgrade;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Upgrade, Firedac.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, db.UpgradeList;

type
  TUpgradeDB = class
  private
    fqry_Upgrade: TFDQuery;
    fDBUpgradeList: TDBUpgradeList;
    fDBUpgrade: TDBUpgrade;
    procedure CreateTableQueue;
    procedure CreateTableZaehlerstandbild;
    procedure CreateTableGebaude;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
  end;

implementation

{ TUpgradeDB }

uses
  Objekt.BasCloud, Datenmodul.db, fmx.Types, FMX.DialogService;

constructor TUpgradeDB.Create;
begin
  fqry_Upgrade := TFDQuery.Create(nil);
  fqry_Upgrade.Connection := dm_db.Connection;
  fDBUpgradeList := TDBUpgradeList.Create;
  fDBUpgrade := TDBUpgrade.Create;
end;

destructor TUpgradeDB.Destroy;
begin
  FreeAndNil(fqry_Upgrade);
  FreeAndNil(fDBUpgradeList);
  FreeAndNil(fDBUpgrade);
  inherited;
end;


procedure TUpgradeDB.CreateTableQueue;
begin
  log.d('TUpgradeDB.CreateTableQueue --> Start');
  fqry_Upgrade.Close;
  fqry_Upgrade.SQL.Clear;
  fqry_Upgrade.Sql.Add('CREATE TABLE if not exists queue (');
  fqry_Upgrade.Sql.Add('qu_id INTEGER PRIMARY KEY AUTOINCREMENT,');
  fqry_Upgrade.Sql.Add('qu_process Integer,');
  fqry_Upgrade.Sql.Add('qu_Bez VARCHAR (100))');
  try
    fqry_Upgrade.ExecSQL;
  except
    on E: Exception do
    begin
      log.d(E.Message);
      TDialogService.ShowMessage('CreateTableQueue: ' + E.Message);
    end;
  end;
  log.d('TUpgradeDB.CreateTableQueue --> Ende');
end;

procedure TUpgradeDB.CreateTableZaehlerstandbild;
begin
  log.d('TUpgradeDB.CreateTableZaehlerstandbild --> Start');
  fqry_Upgrade.Close;
  fqry_Upgrade.SQL.Clear;
  fqry_Upgrade.Sql.Add('CREATE TABLE if not exists zaehlerstandbild (');
  fqry_Upgrade.Sql.Add('zb_za_id VARCHAR(100) PRIMARY KEY,');
  fqry_Upgrade.Sql.Add('zb_de_id VARCHAR(100),');
  fqry_Upgrade.Sql.Add('zb_bild blob)');
  try
    fqry_Upgrade.ExecSQL;
  except
    on E: Exception do
    begin
      log.d(E.Message);
      TDialogService.ShowMessage('CreateTableZaehlerstandbild: ' + E.Message);
    end;
  end;
  log.d('TUpgradeDB.CreateTableZaehlerstandbild --> Ende');
end;


procedure TUpgradeDB.CreateTableGebaude;
begin
  log.d('TUpgradeDB.CreateTableGebaude --> Start');
  fqry_Upgrade.Close;
  fqry_Upgrade.SQL.Clear;
  fqry_Upgrade.Sql.Add('CREATE TABLE if not exists gebaude (');
  fqry_Upgrade.Sql.Add('gb_id VARCHAR(100) PRIMARY KEY,');
  fqry_Upgrade.Sql.Add('gb_name VARCHAR(100),');
  fqry_Upgrade.Sql.Add('gb_ort VARCHAR(100),');
  fqry_Upgrade.Sql.Add('gb_land VARCHAR(100),');
  fqry_Upgrade.Sql.Add('gb_plz VARCHAR(20),');
  fqry_Upgrade.Sql.Add('gb_strasse VARCHAR(100))');
  try
    fqry_Upgrade.ExecSQL;
  except
    on E: Exception do
    begin
      log.d(E.Message);
      TDialogService.ShowMessage('CreateTableGebaude: ' + E.Message);
    end;
  end;
  log.d('TUpgradeDB.CreateTableGebaude --> Ende');
end;


procedure TUpgradeDB.Start;
var
  LastUpdate: string;
begin
  LastUpdate := fDBUpgrade.LastUpdate;
  log.d('LastUpdate = ' + LastUpdate);
  if LastUpdate = '' then
  begin
    log.d('TUpgradeDB.Start');
    CreateTableQueue;
    CreateTableZaehlerstandbild;
    CreateTableGebaude;
    fDBUpgrade.Init;
    fDBUpgrade.Datum := '20220615 10:54';
    fDBUpgrade.Insert;
  end;
end;

end.
