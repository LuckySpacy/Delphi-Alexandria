unit DB.Bilder;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, DB.Basis, FMX.Graphics;

type
  TDBBilder = class(TDBBasis)
  private
    fId: string;
    fPfad: string;
    fBildname: string;
    fShortImage:  TMemoryStream;
    fShortBitmap: TBitmap;
    fLastWriteTimeUtc: string;
    fLatitute: string;
    fLongitude: string;
    fCameraModel: string;
    fDatum: string;
    fOrientation: string;
    fCameraMarke: string;
    function getInsertStatement: string;
    function getUpdateStatement: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init;
    property Id: string read fId write fId;
    property Pfad: string read fPfad write fPfad;
    property Bildname: string read fBildname write fBildname;
    property LastWriteTimeUtc: string read fLastWriteTimeUtc write fLastWriteTimeUtc;
    property Datum: string read fDatum write fDatum;
    property CameraMarke: string read fCameraMarke write fCameraMarke;
    property CameraModel: string read fCameraModel write fCameraModel;
    property Orientation: string read fOrientation write fOrientation;
    property Latitude: string read fLatitute write fLatitute;
    property Longitude: string read fLongitude write fLongitude;
    procedure LoadBildIntoBitmap(aBitmap: TBitmap);
    procedure LoadShortImageIntoBitmap(aBitmap: TBitmap);
    function Insert: Boolean;
    procedure setShortImage(aMs: TMemoryStream);
    function Read_Bild(aPath, aFilename: string): Boolean;
    procedure LoadFromQuery(aQry: TFDQuery);
    function ShortBitmap: TBitmap;
  end;


implementation

{ TDBBilder }

uses
  FMX.DialogService, fmx.Types, System.IOUtils;

constructor TDBBilder.Create;
begin
  inherited;
  fShortImage := nil;
  fShortBitmap := nil;
  Init;
end;

destructor TDBBilder.Destroy;
begin
  if fShortImage <> nil then
    FreeAndNil(fShortImage);
  if fShortBitmap <> nil then
    FreeAndNil(fShortBitmap);

  inherited;
end;


procedure TDBBilder.Init;
begin
  fId := '';
  fPfad := '';
  fBildname := '';
  if fShortImage <> nil then
    FreeAndNil(fShortImage);
  if fShortBitmap <> nil then
    FreeAndNil(fShortBitmap);
  fCameraModel := '';
  fCameraMarke := '';
  fLatitute    := '';
  fLongitude   := '';
  fDatum       := '';
  fOrientation := '';
end;



procedure TDBBilder.LoadShortImageIntoBitmap(aBitmap: TBitmap);
begin
  fShortImage.Position := 0;
  try
    if fShortImage.Size > 100 then
      aBitmap.LoadFromStream(fShortImage);
  except
    on E: Exception do
    begin
      log.d('TDBBilder.LoadBildIntoBitmap: ' + E.Message);
      exit;
    end;
  end;
  fShortImage.Position := 0;
end;




procedure TDBBilder.setShortImage(aMs: TMemoryStream);
begin
  try
    aMs.Position := 0;
    if fShortImage <> nil then
      FreeAndNil(fShortImage);
    fShortImage := TMemoryStream.Create;
    fShortImage.Position := 0;
    if aMs.Size > 100 then
      fShortImage.LoadFromStream(aMs);
    fShortImage.Position := 0;
  except
    on E: Exception do
    begin
      log.d('TDBBilder.setBild: ' + E.Message);
      exit;
    end;
  end;
end;

function TDBBilder.ShortBitmap: TBitmap;
begin
  Result := fShortBitmap;
end;

procedure TDBBilder.LoadBildIntoBitmap(aBitmap: TBitmap);
begin
  fShortImage.Position := 0;
  aBitmap.LoadFromStream(fShortImage);
  fShortImage.Position := 0;
end;

procedure TDBBilder.LoadFromQuery(aQry: TFDQuery);
var
  Stream: TStream;
  Filename: string;
begin
  if aQry.Eof then
  begin
    Init;
    exit;
  end;
  if (aQry.FieldByName('bi_shortimage').AsString = '') then
  begin
    if fShortImage <> nil then
      FreeAndNil(fShortImage);
  end;

  if fShortImage <> nil then
    FreeAndNil(fShortImage);

  if fShortBitmap <> nil then
    FreeAndNil(fShortBitmap);


  fShortImage := TMemoryStream.Create;

  Stream := aQry.CreateBlobStream(aQry.FieldByName('bi_shortimage'), bmRead);
  Stream.Position := 0;
  if Stream.Size > 100 then
  begin
    fShortImage.LoadFromStream(Stream);
    fShortBitmap := TBitmap.Create;
    Stream.Position := 0;
    fShortBitmap.LoadFromStream(Stream);
    //Filename := TPath.combine(aQry.FieldByName('bi_pfad').AsString, aQry.FieldByName('bi_Bildname').AsString);
    //fShortBitmap.LoadThumbnailFromFile(Filename, 200, 200);
    //fShortBitmap.LoadThumbnailFromFile(Filename, 100, 100);
  end;
  fShortImage.Position := 0;
  FreeAndNil(Stream);

  fId       := aQry.FieldByName('bi_id').AsString;
  fPfad     := aQry.FieldByName('bi_pfad').AsString;
  fBildname := aQry.FieldByName('bi_Bildname').AsString;
  fLastWriteTimeUtc := aQry.FieldByName('bi_lastwritetimeutc').AsString;
  fDatum := aQry.FieldByName('bi_datum').AsString;
  fCameraModel := aQry.FieldByName('bi_cameramodel').AsString;
  fCameraMarke := aQry.FieldByName('bi_cameramarke').AsString;
  fOrientation := aQry.FieldByName('bi_orientation').AsString;
  fLatitute    := aQry.FieldByName('bi_latitude').AsString;
  fLongitude   := aQry.FieldByName('bi_longitude').AsString;
end;


function TDBBilder.getInsertStatement: string;
begin
  Result := ' insert into bilder (bi_id, bi_shortimage, bi_longimage, bi_pfad, bi_bildname, bi_LastWriteTimeUtc,' +
              'bi_datum, bi_cameramarke, bi_cameramodel, bi_orientation, bi_latitude, bi_longitude' +
             ') ' +
            ' values ' +
            ' (:id, :shortimage, :longimage, :pfad, :bildname, :LastWriteTimeUtc, ' +
            ':datum, :cameramarke, :cameramodel, :orientation, :latitude, :longitude' +
            ')';

end;


function TDBBilder.getUpdateStatement: string;
begin
  Result := ' update bilder set bi_shortimage =:shortimage, bi_longimage =:longimage,' +
            ' bi_pfad = :pfad, bi_bildname = :bildname, bi_lastwritetimeutc = :lastwritetimeutc,' +
            ' bi_datum =:datum, bi_cameramarke = :cameramarke, bi_cameramodel = :cameramodel, bi_orientation = :orientation,' +
            ' bi_latitude = :latitude, bi_longitude = :longitude' +
            ' where bi_id = :id';
end;


function TDBBilder.Insert: Boolean;
var
  WasOpen: Boolean;
begin
  try
    if fQuery.Transaction <> nil then
      WasOpen := fQuery.Transaction.Active;
    if (fQuery.Transaction <> nil) and (not fQuery.Transaction.Active) then
      fQuery.Transaction.StartTransaction;
    fQuery.SQL.Text := getInsertStatement;
    fId := ErzeugeGuid;
    fQuery.ParamByName('id').AsString := fId;
    fQuery.ParamByName('pfad').AsString := fPfad;
    fQuery.ParamByName('bildname').AsString := fBildname;
    fQuery.ParamByName('longimage').AsString := '';
    fQuery.ParamByName('lastwritetimeutc').AsString := fLastWriteTimeUtc;
    fQuery.ParamByName('datum').AsString := fDatum;
    fQuery.ParamByName('cameramarke').AsString := fCameraMarke;
    fQuery.ParamByName('cameramodel').AsString := fCameraModel;
    fQuery.ParamByName('orientation').AsString := fOrientation;
    fQuery.ParamByName('latitude').AsString := fLatitute;
    fQuery.ParamByName('longitude').AsString := fLongitude;
    if fShortImage <> nil then
    begin
      fShortImage.Position := 0;
      if fShortImage.Size > 100 then
        fQuery.ParamByName('shortimage').LoadFromStream(fShortImage, ftBlob);
      fShortImage.Position := 0;
    end;
    fQuery.ExecSQL;
    if (fQuery.Transaction <> nil) and (not wasOpen) and (fQuery.Transaction.Active) then
      fQuery.Transaction.Commit;
  except
    on E: Exception do
    begin
      log.d('TDBBilder.Insert: ' + E.Message);
      exit;
    end;
  end;
  Result := true;
end;


function TDBBilder.Read_Bild(aPath, aFilename: string): Boolean;
var
  s: string;
  WasOpen: Boolean;
begin
  try
   if fQuery.Transaction <> nil then
     WasOpen := fQuery.Transaction.Active;
   if (fQuery.Transaction <> nil) and (not fQuery.Transaction.Active) then
     fQuery.Transaction.StartTransaction;

    s := ' select * from bilder' +
         ' where bi_pfad = :pfad' +
         ' and bi_bildname = :bildname';
    fQuery.SQL.Text := s;
    fQuery.ParamByName('pfad').AsString := aPath;
    fQuery.ParamByName('bildname').AsString := aFilename;
    fQuery.Open;
    Result := not fQuery.Eof;
    if Result then
      LoadFromQuery(fQuery)
    else
      Init;
    fQuery.Close;
    if (fQuery.Transaction <> nil) and (not WasOpen) and (fQuery.Transaction.Active) then
      fQuery.Transaction.Rollback;

  except
    on E: Exception do
    begin
      log.d('TDBBilder.Read_Bild: ' + E.Message);
    end;
  end;
end;


end.
