unit Datenmodul.db;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.FMXUI.Wait, FireDAC.Comp.Client,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.DataSet;

type
  Tdm_db = class(TDataModule)
    Connection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDQuery: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    fdt_Trans: TFDTransaction;
    FDManager1: TFDManager;
  private
  public
    procedure Connect;
    function getDatenbankFilename: string;
  end;

var
  dm_db: Tdm_db;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils, FMX.DialogService, fmx.Types;

{ TDataModule1 }

procedure Tdm_db.Connect;
var
{$IF Defined(WIN32) or Defined(WIN64)}
  Pfad: string;
  iPos: Integer;
{$IFEND}
  Filename: string;
begin
  {$IFDEF WIN32}
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  Filename := Pfad + 'PhotoOrgaBild.db';
  Connection.Params.Values['Database'] := Filename;
  {$ENDIF WIN32}

  {$IFDEF WIN64}
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  iPos := Pos('win64', LowerCase(Pfad));
  if iPos > 0 then
  begin
    Pfad := IncludeTrailingPathDelimiter(copy(Pfad, 1, iPos-1));
    Filename := Pfad + 'SqlLite\PhotoOrgaBild.db';
    Connection.Params.Values['Database'] := Filename;
  end;
  {$ENDIF WIN64}


  {$IFDEF IOS}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'PhotoOrgaBild.db');
  Connection.Params.Values['Database'] := Filename;
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'PhotoOrgaBild.db');
  log.d('Filename: ' + Filename);
  if not FileExists(Filename) then
    TDialogService.ShowMessage('Datenbank exisitiert nicht: ' + Filename);
  Connection.Params.Values['Database'] := Filename;
  //Connection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  {$ENDIF ANDROID}
  Connection.Connected := true;
end;

function Tdm_db.getDatenbankFilename: string;
begin
  Result := '';
  {$IFDEF IOS}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'PhotoOrgaBild.db');
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'PhotoOrgaBild.db');
  {$ENDIF ANDROID}
end;

end.
