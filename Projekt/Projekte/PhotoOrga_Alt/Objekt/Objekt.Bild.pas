unit Objekt.Bild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, types.PhotoOrga, fmx.Graphics;

type
  TBild = class
  private
    fMS: TMemoryStream;
    fId: string;
    fLastWriteTimeUtc: string;
    fPfad: string;
    fBildname: string;
    fBitmap: TBitmap;
    fLatitude: string;
    fLongitude: string;
    fCameraModel: string;
    fDatum: string;
    fOrientation: string;
    fCameraMarke: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Id: string read fId write fId;
    property Pfad: string read fPfad write fPfad;
    property Bildname: string read fBildname write fBildname;
    property LastWriteTimeUtc: string read fLastWriteTimeUtc write fLastWriteTimeUtc;
    property Datum: string read fDatum write fDatum;
    property CameraMarke: string read fCameraMarke write fCameraMarke;
    property CameraModel: string read fCameraModel write fCameraModel;
    property Orientation: string read fOrientation write fOrientation;
    property Latitude: string read fLatitude write fLatitude;
    property Longitude: string read fLongitude write fLongitude;
    function Stream: TMemoryStream;
    procedure setStream(aStream: TStream);
    procedure setBitmap(aBitmap: TBitmap);
    function getBitmap: TBitmap;
    procedure Init;
  end;

implementation

{ TBild }

constructor TBild.Create;
begin
  fMS := nil;
  fBitmap := nil;
  Init;
end;

destructor TBild.Destroy;
begin
  if fMS <> nil then
    FreeAndNil(fMS);
  if fBitmap <> nil then
    FreeAndNil(fBitmap);
  inherited;
end;

function TBild.getBitmap: TBitmap;
begin
  Result := nil;
  if fBitmap <> nil then
  begin
    Result := fBitmap;
    exit;
  end;
  if fMS = nil then
    exit;
  fMS.Position := 0;
  fBitmap := TBitmap.Create;
  fBitmap.LoadFromStream(fMS);
  fMS.Position := 0;
  Result := fBitmap;
end;

procedure TBild.Init;
begin
  if fMS <> nil then
    FreeAndNil(fMS);
  if fBitmap <> nil then
    FreeAndNil(fBitmap);
  fId := '';
  fLastWriteTimeUtc := '';
  fPfad := '';
  fBildname := '';
  fCameraModel := '';
  fCameraMarke := '';
  fDatum := '';
  fOrientation := '';
  fLongitude := '';
  fLatitude := '';
end;

procedure TBild.setBitmap(aBitmap: TBitmap);
begin
  if fMS = nil then
    exit;
  if aBitmap = nil then
    exit;
  fMS.Position := 0;
  aBitmap.LoadFromStream(fMS);
end;

procedure TBild.setStream(aStream: TStream);
begin
  if fMS <> nil then
    FreeAndNil(fMS);
  if fBitmap <> nil then
    FreeAndNil(fBitmap);
  if aStream = nil then
    exit;
  if aStream.Size < 100 then
    exit;
  aStream.Position := 0;
  //fMS := TMemoryStream.Create;
  //fMS.LoadFromStream(aStream);
   fBitmap := TBitmap.Create;
   try
     fBitmap.LoadFromStream(aStream);
   except
     if fBitmap <> nil then
       FreeAndNil(fBitmap);
   end;
end;

function TBild.Stream: TMemoryStream;
begin
  Result := fMS;
end;

end.
