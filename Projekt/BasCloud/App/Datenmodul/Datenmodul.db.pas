unit Datenmodul.db;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.UI, DB.UpgradeList;

type
  Tdm_db = class(TDataModule)
    Connection: TFDConnection;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fDBUpgradeList: TDBUpgradeList;
  public
    procedure Connect;
    function getDatenbankFilename: string;
    procedure DoUpgrade;
  end;

var
  dm_db: Tdm_db;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ Tdm_db }

uses
  System.IOUtils, FMX.DialogService, fmx.Types;

procedure Tdm_db.DataModuleCreate(Sender: TObject);
begin
  fDBUpgradeList := TDBUpgradeList.Create;
end;

procedure Tdm_db.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fDBUpgradeList);
end;


procedure Tdm_db.Connect;
begin
  Connection.Connected := true;
end;

procedure Tdm_db.ConnectionBeforeConnect(Sender: TObject);
var
{$IF Defined(WIN32) or Defined(WIN64)}
  Pfad: string;
  iPos: Integer;
{$IFEND}
  Filename: string;
begin
  {$IFDEF WIN32}
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  iPos := Pos('win32', LowerCase(Pfad));
  if iPos > 0 then
  begin
    Pfad := IncludeTrailingPathDelimiter(copy(Pfad, 1, iPos-1));
    Filename := Pfad + 'Datenbank\BasCloud.db';
    Connection.Params.Values['Database'] := Filename;
  end;
  {$ENDIF WIN32}

  {$IFDEF WIN64}
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  iPos := Pos('win64', LowerCase(Pfad));
  if iPos > 0 then
  begin
    Pfad := IncludeTrailingPathDelimiter(copy(Pfad, 1, iPos-1));
    Filename := Pfad + 'Datenbank\BasCloud.db';
    Connection.Params.Values['Database'] := Filename;
  end;
  {$ENDIF WIN64}


  {$IFDEF IOS}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  Connection.Params.Values['Database'] := Filename;
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  log.d('Filename: ' + Filename);
  if not FileExists(Filename) then
    TDialogService.ShowMessage(Filename);
  Connection.Params.Values['Database'] := Filename;
  //Connection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  {$ENDIF ANDROID}
end;


function Tdm_db.getDatenbankFilename: string;
begin
  Result := '';
  {$IFDEF IOS}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  {$ENDIF ANDROID}
end;



procedure Tdm_db.DoUpgrade;
begin
  log.d('fDBUpgradeList.CreateIfNotExist');
  fDBUpgradeList.CreateIfNotExist;
end;


end.
