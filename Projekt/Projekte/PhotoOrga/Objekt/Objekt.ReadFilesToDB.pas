unit Objekt.ReadFilesToDB;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs,
  fmx.StdCtrls, Types.PhotoOrga, Objekt.ReadFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics

  {$IFDEF ANDROID}
  ,AndroidApi.IOUtilsEx
  ,DW.EXIF, DW.UIHelper
  {$ENDIF ANDROID}

  ;

type
  TReadFilesToDB = class
  private
    fOnProgressMaxValue: TNotifyIntEvent;
    fOnProgress: TProgressEvent;
    fStop: Boolean;
    fReadFiles: TReadFiles;
    procedure ProgressMaxValue(aValue: Integer);
    procedure Progress(aIndex: Integer; aValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    property OnProgressMaxValue: TNotifyIntEvent read fOnProgressMaxValue write fOnProgressMaxValue;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property Stop: Boolean read fStop write fStop;
  end;

implementation

{ TReadFilesToDB }

uses
  Datenmodul.db, Objekt.BildList, Objekt.Bild, Objekt.PhotoOrga;

constructor TReadFilesToDB.Create;
begin
  fReadFiles := TReadFiles.Create;
  fReadFiles.OnProgressMaxValue := ProgressMaxValue;
  fReadFiles.OnProgress := Progress;
end;

destructor TReadFilesToDB.Destroy;
begin
  FreeAndNil(fReadFiles);
  inherited;
end;



procedure TReadFilesToDB.ProgressMaxValue(aValue: Integer);
begin
  if Assigned(fOnProgressMaxValue) then
    fOnProgressMaxValue(aValue);
end;

procedure TReadFilesToDB.Start;
begin
  fReadFiles.Start;
end;



procedure TReadFilesToDB.Progress(aIndex: Integer; aValue: string);
var
  Pfad: string;
  Filename: string;
  qry : TFDQuery;
  Bild: TBild;
  Stream: TMemoryStream;
begin
  if fStop then
    fReadFiles.Stop := fStop;
  if Assigned(fOnProgress) then
    fOnProgress(aIndex, aValue);
  Pfad := Lowercase(ExtractFilePath(aValue));
  Filename := Lowercase(ExtractFileName(aValue));
  qry := dm_db.FDQuery;
  qry.Close;
  qry.SQL.Text := 'select * from Bild where pfad = :pfad and bildname = :bildname';
  qry.ParamByName('pfad').AsString := Pfad;
  qry.ParamByName('bildname').AsString := Filename;
  qry.Open;
  if not qry.eof then
    exit;
  Bild := PhotoOrga.BildList.Add;
  Bild.LoadFromFile(aValue);
  qry.Close;
  qry.sql.Text := ' insert into bild (id, Pfad, Bildname, Oriantation, Longitude, Latitude, Thumb) ' +
                  ' values ' +
                  ' (:InId, :InPfad, :InBildname, :InOriantation, :InLongitude, :InLatitude, :InThumb)';
  Bild.Id := Bild.ErzeugeGuid;
  qry.ParamByName('inId').AsString := Bild.Id;
  qry.ParamByName('InPfad').AsString := Pfad;
  qry.ParamByName('InBildname').AsString := Filename;
  qry.ParamByName('InOriantation').AsString := Bild.Orientation;
  qry.ParamByName('InLongitude').AsString := Bild.Longitude;
  qry.ParamByName('InLatitude').AsString := Bild.Latitude;
  //Bild.Thumb.SaveToFile('d:\Bachmann\Daten\OneDrive\Bilder\x.jpg');
  Stream := TMemoryStream.Create;
  try
    Bild.Thumb.SaveToStream(Stream);
    Stream.Position := 0;
    qry.ParamByName('InThumb').LoadFromStream(Stream, ftBlob);
    qry.execSql;
  finally
    FreeAndNil(Stream);
  end;
end;


end.
