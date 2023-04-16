unit Datenmodul.db;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.FMXUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tdm_db = class(TDataModule)
    Connection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    fdt_Trans: TFDTransaction;
    FDManager1: TFDManager;
    procedure ConnectionBeforeConnect(Sender: TObject);
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

{ Tdm_db }

uses
  System.IOUtils, FMX.DialogService, fmx.Types;

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
  Filename := Pfad + 'Photoorga.db3';
  Connection.Params.Values['Database'] := Filename;
  {$ENDIF WIN32}

  {$IFDEF WIN64}
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  iPos := Pos('win64', LowerCase(Pfad));
  if iPos > 0 then
  begin
    Pfad := IncludeTrailingPathDelimiter(copy(Pfad, 1, iPos-1));
    Filename := Pfad + 'SqlLite\Photoorga.db3';
    Connection.Params.Values['Database'] := Filename;
  end;
  {$ENDIF WIN64}


  {$IFDEF IOS}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'Photoorga.db3');
  Connection.Params.Values['Database'] := Filename;
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Filename := TPath.Combine(TPath.GetDocumentsPath, 'Photoorga.db3');
  log.d('Filename: ' + Filename);
  if not FileExists(Filename) then
    TDialogService.ShowMessage('Datenbank exisitiert nicht: ' + Filename);
  Connection.Params.Values['Database'] := Filename;
  //Connection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'BasCloud.db');
  {$ENDIF ANDROID}
end;

function Tdm_db.getDatenbankFilename: string;
begin
  Result := '';
  {$IFDEF IOS}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'Photoorga.db3');
  {$ENDIF IOS}
  {$IFDEF ANDROID}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'Photoorga.db3');
  {$ENDIF ANDROID}
end;

end.
