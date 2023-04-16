unit DB.UpgradeList;

interface

uses
  SysUtils, System.Classes, DB.BasisList, DB.Upgrade, Firedac.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDBUpgradeList = class(TDBBasisList)
  private
    function getItem(Index: Integer): TDBUpgrade;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TDBUpgrade read getItem;
    function Add: TDBUpgrade;
    procedure ReadAll;
    procedure CreateIfNotExist;
  end;


implementation

{ TDBUpgradeList }

uses
  Objekt.BasCloud, Datenmodul.db, fmx.Types;


constructor TDBUpgradeList.Create;
begin
  inherited;
end;


destructor TDBUpgradeList.Destroy;
begin
  inherited;
end;

function TDBUpgradeList.getItem(Index: Integer): TDBUpgrade;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBUpgrade(fList.Items[Index]);
end;

function TDBUpgradeList.Add: TDBUpgrade;
begin
  Result := TDBUpgrade.Create;
  fList.Add(Result);
end;



procedure TDBUpgradeList.ReadAll;
var
  DBUprade: TDBUpgrade;
begin
  try
    BasCloud.Log('Start --> TDBUpgradeList.ReadAll');
    fQuery.Close;
    fQuery.Sql.Text := 'select * from dbupgrade order by up_datum desc';
    try
      fQuery.Open;
    except
      on E: Exception do
      begin
        log.d('TDBUpgradeList.ReadAll: ' + E.Message);
        BasCloud.Log('          Error: ' + E.Message);
      end;
    end;
    fList.Clear;
    while not fQuery.Eof do
    begin
      DBUprade := Add;
      DBUprade.LoadFromQuery(fQuery);
      fQuery.Next;
    end;
  except
    on E: Exception do
    begin
      log.d('TDBUpgradeList.ReadAll: ' +  E.Message);
    end;
  end;
  BasCloud.Log('Ende --> TDBUpgradeList.ReadAll');
end;



procedure TDBUpgradeList.CreateIfNotExist;
begin
  fQuery.Close;
  fQuery.Sql.Add('CREATE TABLE if not exists upgrade (');
  fQuery.Sql.Add('up_id INTEGER PRIMARY KEY AUTOINCREMENT,');
  fQuery.Sql.Add('up_datum       VARCHAR (14))');
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      log.d('TDBUpgradeList.CreateIfNotExist: ' +  E.Message);
    end;
  end;
end;


end.
