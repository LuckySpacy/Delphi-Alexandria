unit Objekt.Bild;

interface

uses
  System.SysUtils, System.Classes, FMX.Graphics, Objekt.DatumZeit
  {$IFDEF ANDROID}
  ,Objekt.Android.ExifProperty
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  ,Objekt.Win.ExifProperty
  {$ENDIF MSWINDOWS}
  ;

type
  TBild = class
  private
    fId: string;
    fPfad: string;
    fBildname: string;
    fLastWriteTimeUtc: string;
    fLatitute: string;
    fLongitude: string;
    fOrientation: string;
    fCameraMarke: string;
    fCameraModel: string;
    fThumb: TBitmap;
    fExifProperty : TExifProperty;
    fDatumZeit: TDatumZeit;
    procedure Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Id: string read fId write fId;
    property Pfad: string read fPfad write fPfad;
    property Bildname: string read fBildname write fBildname;
    property LastWriteTimeUtc: string read fLastWriteTimeUtc write fLastWriteTimeUtc;
    property CameraMarke: string read fCameraMarke write fCameraMarke;
    property CameraModel: string read fCameraModel write fCameraModel;
    property Orientation: string read fOrientation write fOrientation;
    property Latitude: string read fLatitute write fLatitute;
    property Longitude: string read fLongitude write fLongitude;
    function Thumb: TBitmap;
    procedure LoadThumbFromStream(aStream: TStream);
    procedure LoadFromFile(aFullFilename: string);
    property Exif: TExifProperty read fExifProperty;
    function ErzeugeGuid: string;
    function FullFilename: string;
  end;


implementation

{ TBild }

uses
  System.IOUtils, FMX.DialogService;

constructor TBild.Create;
begin
  fThumb := nil;
  fExifProperty := TExifProperty.Create;
  fDatumZeit := TDatumZeit.Create;
end;

destructor TBild.Destroy;
begin
  if fThumb <> nil then
    FreeAndNil(fThumb);
  FreeAndNil(fExifProperty);
  FreeAndNil(fDatumZeit);
  inherited;
end;

procedure TBild.Init;
begin
  fId               := ErzeugeGuid;
  fPfad             := '';
  fBildname         := '';
  fLastWriteTimeUtc := '';
  fLatitute    := '';
  fLongitude   := '';
  fOrientation := '';
  fCameraMarke := '';
  fCameraModel := '';
end;




procedure TBild.LoadThumbFromStream(aStream: TStream);
begin
  try
    if fThumb <> nil then
      FreeAndNil(fThumb);
    if aStream.Size <= 100 then
      exit;
    fThumb := TBitmap.Create;
    aStream.Position := 0;
    fThumb.LoadFromStream(aStream);
  except
     on E: Exception do
     begin
       TDialogService.ShowMessage(E.Message);
     end;
  end;
end;

function TBild.Thumb: TBitmap;
begin
  Result := fThumb;
end;



procedure TBild.LoadFromFile(aFullFilename: string);
var
  Zahl1: Integer;
  Zahl2: Integer;
  DateiDatum: TDateTime;
begin
  try
    try
      fExifProperty.Load(aFullFilename);   <-- Fehler hier drin
    except
       on E: Exception do
       begin
         TDialogService.ShowMessage(E.Message);
       end;
    end;
    TryStrToInt(fExifProperty.Tag.ImageLength, Zahl2);
    TryStrToInt(fExifProperty.Tag.ImageWidth, Zahl1);
    Shrink2(100, Zahl1, Zahl2);

    if fThumb <> nil then
      FreeAndNil(fThumb);
    fThumb := TBitmap.Create;
    fThumb.LoadThumbnailFromFile(aFullFilename, Zahl1, Zahl2, false);
    if fExifProperty.OrientationStr = 'Rotate270' then
      fThumb.Rotate(-270);
    if fExifProperty.OrientationStr = 'Rotate180' then
      fThumb.Rotate(180);

    DateiDatum := TFile.GetLastWriteTimeUtc(aFullFilename);
    fLastWriteTimeUtc := fDatumZeit.DatumZuString(DateiDatum);
    fOrientation := fExifProperty.OrientationStr;
  except
     on E: Exception do
     begin
       TDialogService.ShowMessage(E.Message);
     end;
  end;

end;


procedure TBild.Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
var
  Faktor: real;
begin
  try
    if (aZahl1 < aShrinkValue) and (aZahl2 < aShrinkvalue) then
      exit;

   if (aZahl1 = aZahl2) then
   begin
     aZahl1 := aShrinkValue;
     aZahl2 := aShrinkValue;
     exit;
   end;

    if (aZahl1 > aZahl2) and (aZahl1 >= aShrinkValue) then
    begin
      Faktor  := aZahl2 / aShrinkValue;
      aZahl2  := aShrinkValue;
      aZahl1  := trunc(aZahl1 / Faktor);
    end;

    if (aZahl2 >= aZahl1) and (aZahl2 >= aShrinkValue) then
    begin
      Faktor  := aZahl1 / aShrinkValue;
      aZahl1  := aShrinkValue;
      aZahl2  := trunc(aZahl2 / Faktor);
    end;
  except
     on E: Exception do
     begin
       TDialogService.ShowMessage(E.Message);
     end;
  end;

end;

function TBild.ErzeugeGuid: string;
var
  GuId: TGUid;
begin //
  CreateGUID(GuId);
  Result := GUIDToString(GuId);
  Result := StringReplace(Result , '{', '', [rfReplaceAll]);
  Result := StringReplace(Result , '}', '', [rfReplaceAll]);
end;


function TBild.FullFilename: string;
begin
  Result := TPath.Combine(fPfad, fBildname);
end;

end.
