unit Objekt.ExifProperty;

interface

uses
  System.SysUtils, System.Types,  System.Classes, System.Variants, Objekt.ExifPropertyTag;

type
  TEXIFOrientations = (Unknown, Normal, FlipHorizontal, Rotate180, FlipVertical, Transpose, Rotate90, Transverse, Rotate270);

type
  TExifProperty = class
  private
    fLatitude: string;
    fCameraMarke: string;
    fLongitude: string;
    fCameraModel: string;
    fDatum: string;
    fOrientation: TEXIFOrientations;
    fAltitude: Double;
    fOrientationStr: string;
    fTag: TExifPropertyTag;
    function GetEXIF(const AFileName: string): Boolean;
    function GetOrientation(const AValue: Integer): TEXIFOrientations;
public
    property CameraMarke: string read fCameraMarke write fCameraMarke;
    property CameraModel: string read fCameraModel write fCameraModel;
    property Datum: string read fDatum write fDatum;
    property Latitude: string read fLatitude write fLatitude;
    property Longitude: string read fLongitude write fLongitude;
    property Orientation: TEXIFOrientations read fOrientation write fOrientation;
    property OrientationStr: string read fOrientationStr write fOrientationStr;
    property Altitude: Double read fAltitude write fAltitude;
    property Tag: TExifPropertyTag read fTag write fTag;
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    function Load(aFullFilename: string): Boolean;
    procedure LoadInfoToStrings(aStrings: TStrings);
  end;

implementation

{ TExifProperty }

 uses
    System.TypInfo

{$IFDEF ANDROID}
   ,Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os,
   DW.EXIF, DW.UIHelper,
   Androidapi.Jni.Media, Androidapi.JNIBridge
{$ENDIF}
;


constructor TExifProperty.Create;
begin
  fTag := TExifPropertyTag.Create;
  Init;
end;

destructor TExifProperty.Destroy;
begin
  FreeAndNil(fTag);
  inherited;
end;

procedure TExifProperty.Init;
begin
  fLatitude    := '';
  fCameraMarke := '';
  fLongitude   := '';
  fCameraModel := '';
  fDatum       := '';
  fOrientation := Unknown;
  fAltitude    := 0;
  fOrientationStr := '';
end;

function TExifProperty.Load(aFullFilename: string): Boolean;
  {$IFDEF ANDROID}
var
  LProperties: TEXIFProperties;
  {$ENDIF}
begin
  Result := false;
  Init;
  {$IFDEF ANDROID}
  getEXIF(aFullFilename);
  {
  if TEXIF.GetEXIF(aFullFilename, LProperties) then
  begin
    fCameraMarke := LProperties.CameraMake;
    fCameraModel := LProperties.CameraModel;
    fDatum       := StringReplace(LProperties.DateTaken, ':', '-', [rfReplaceAll]);
    fLatitude    := LProperties.Longitude.ToString;
    fLongitude   := LProperties.Latitude.ToString;
    fOrientationStr := GetEnumName(TypeInfo(TEXIFOrientation), Ord(LProperties.Orientation));
  end;
   }
  {$ENDIF ANDROID}

end;






function TExifProperty.GetEXIF(const AFileName: string): Boolean;
var
  LEXIF: JExifInterface;
  LLatLong: TJavaArray<Single>;
  DateTaken: string;
begin
  LEXIF := TJExifInterface.JavaClass.init(StringToJString(AFileName));
  DateTaken := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DATETIME));
  fCameraMarke := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MAKE));
  fCameraModel := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MODEL));
  fOrientation := GetOrientation(StrToIntDef(JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORIENTATION)), -1));
  fAltitude := LEXIF.getAltitude(0);
  fDatum    := StringReplace(DateTaken, ':', '-', [rfReplaceAll]);
  fOrientationStr := GetEnumName(TypeInfo(TEXIFOrientations), Ord(fOrientation));
  fTag.Aperture        := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_APERTURE));
  fTag.ApertureValue   := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_APERTURE_VALUE));
  fTag.Artist          := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ARTIST));
  fTag.BitsPerSample   := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_BITS_PER_SAMPLE));
  fTag.BrightnessValue := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_BRIGHTNESS_VALUE));
  fTag.CfaPattern      := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_CFA_PATTERN));
  fTag.ColorSpace      := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_COLOR_SPACE));
  fTag.CompressedBitsPerSample := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_COMPRESSED_BITS_PER_PIXEL));
  fTag.ComponentsConfiguration := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_COMPONENTS_CONFIGURATION));
  fTag.Compression := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_COMPRESSION));
  fTag.Contrast    := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_CONTRAST));
  fTag.Copyright   := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_COPYRIGHT));
  fTag.CustomRendered := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_CUSTOM_RENDERED));
  fTag.DateTime := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DATETIME));
  fTag.DateTimeDigitized := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DATETIME_DIGITIZED));
  fTag.DateTimeOriginal := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DATETIME_ORIGINAL));
  fTag.DefaultCropSize := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DEFAULT_CROP_SIZE));
  fTag.DeviceSettingDescription := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DEVICE_SETTING_DESCRIPTION));
  fTag.DigitalZoomRatio := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DIGITAL_ZOOM_RATIO));
  fTag.DngVersion := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_DNG_VERSION));
  fTag.ExifVersion := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXIF_VERSION));
  fTag.ExposureBiasValue := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXPOSURE_BIAS_VALUE));
  fTag.ExposureIndex := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXPOSURE_INDEX));
  fTag.ExposureMode := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXPOSURE_MODE));
  fTag.ExposureProgram := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXPOSURE_PROGRAM));
  fTag.ExposureTime := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_EXPOSURE_TIME));
  fTag.FileSource := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FILE_SOURCE));
  fTag.Flash := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FLASH));
  fTag.FlashPixVersion := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FLASHPIX_VERSION));
  fTag.FlashEnergy := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FLASH_ENERGY));
  fTag.FocalLength := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FOCAL_LENGTH));
  fTag.FocalLengthIn35mmFilm := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FOCAL_LENGTH_IN_35MM_FILM));
  fTag.FocalPlaneResolutionUnit := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FOCAL_PLANE_RESOLUTION_UNIT));
  fTag.FocalPlaneXResolution := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FOCAL_PLANE_X_RESOLUTION));
  fTag.FocalPlaneYResolution := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_FOCAL_PLANE_Y_RESOLUTION));
  fTag.FNumber := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_F_NUMBER));
  fTag.GainControl := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GAIN_CONTROL));
  fTag.GPS.Altitude := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_ALTITUDE));
  fTag.GPS.AltitudeRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_ALTITUDE_REF));
  fTag.GPS.AreaInformation := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_AREA_INFORMATION));
  fTag.GPS.Datestamp := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DATESTAMP));
  fTag.GPS.DestBearing := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_BEARING));
  fTag.GPS.DestBearingRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_BEARING_REF));
  fTag.GPS.DestDistance := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_DISTANCE));
  fTag.GPS.DestBearingRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_BEARING_REF));
  fTag.GPS.DestLatitude := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_LATITUDE));
  fTag.GPS.DestLatitudeRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_LATITUDE_REF));
  fTag.GPS.DestLongitude := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_LONGITUDE));
  fTag.GPS.DestLongitudeRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_LONGITUDE_REF));
  fTag.GPS.Differential := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DIFFERENTIAL));
  fTag.GPS.Dop := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DOP));
  fTag.GPS.ImgDirection := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_IMG_DIRECTION));
  fTag.GPS.ImgDirectionRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_IMG_DIRECTION_REF));
  fTag.GPS.Latitude := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_LATITUDE));
  fTag.GPS.LatitudeRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_LATITUDE_REF));
  fTag.GPS.Longitude := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_LONGITUDE));
  fTag.GPS.LongitudeRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_DEST_LONGITUDE_REF));
  fTag.GPS.MapDatum := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_MAP_DATUM));
  fTag.GPS.MeasureMode := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_MEASURE_MODE));
  fTag.GPS.ProcessingMethod := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_PROCESSING_METHOD));
  fTag.GPS.Satellites := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_SATELLITES));
  fTag.GPS.Speed := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_SPEED));
  fTag.GPS.SpeedRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_SPEED_REF));
  fTag.GPS.Status := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_STATUS));
  fTag.GPS.Timestamp := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_TIMESTAMP));
  fTag.GPS.Track := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_TRACK));
  fTag.GPS.TrackRef := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_TRACK_REF));
  fTag.GPS.VersionId := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_GPS_VERSION_ID));
  fTag.ImageDescription := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_IMAGE_DESCRIPTION));
  fTag.ImageLength := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_IMAGE_LENGTH));
  fTag.ImageUniqueId := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_IMAGE_UNIQUE_ID));
  fTag.ImageWidth := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_IMAGE_WIDTH));
  fTag.InteroperabilityIndex := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_INTEROPERABILITY_INDEX));
  fTag.ISO := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ISO));
  fTag.ISOSpeedRatings := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ISO_SPEED_RATINGS));
  fTag.JpegInterchangeFormat := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_JPEG_INTERCHANGE_FORMAT));
  fTag.JpegInterchangeFormatLength := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_JPEG_INTERCHANGE_FORMAT_LENGTH));
  fTag.LightSource := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_LIGHT_SOURCE));
  fTag.Make := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MAKE));
  fTag.MakerNote := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MAKER_NOTE));
  fTag.MaxApertureValue := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MAX_APERTURE_VALUE));
  fTag.MeteringMode := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_METERING_MODE));
  fTag.Model := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_MODEL));
  fTag.NewSubfileType := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_NEW_SUBFILE_TYPE));
  fTag.Oecf := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_OECF));
  fTag.OrfAspectFrame := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORF_ASPECT_FRAME));
  fTag.OrfPreviewImageLength := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORF_PREVIEW_IMAGE_LENGTH));
  fTag.OrfPreviewImageStart := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORF_PREVIEW_IMAGE_START));
  fTag.OrfThumbnailImage := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORF_THUMBNAIL_IMAGE));
  fTag.Orientation := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ORIENTATION));
  fTag.PhotometricInterpretation := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_PHOTOMETRIC_INTERPRETATION));
  fTag.PixelXDimension := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_PIXEL_X_DIMENSION));
  fTag.PixelYDimension := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_PIXEL_Y_DIMENSION));
  fTag.PlanarConfiguration := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_PLANAR_CONFIGURATION));
  fTag.PrimaryChromaticities := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_PRIMARY_CHROMATICITIES));
  fTag.ReferenceBlackWhite := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_REFERENCE_BLACK_WHITE));
  fTag.RelatedSoundFile := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RELATED_SOUND_FILE));
  fTag.ResolutionUnit := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RESOLUTION_UNIT));
  fTag.RowsPerStrip := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_ROWS_PER_STRIP));
  fTag.RW2ISO := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_ISO));
  fTag.RW2JpgFromRaw := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_JPG_FROM_RAW));
  fTag.RW2SensorBottomBorder := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_SENSOR_BOTTOM_BORDER));
  fTag.RW2SensorLeftBorder := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_SENSOR_LEFT_BORDER));
  fTag.RW2SensorRightBorder := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_SENSOR_RIGHT_BORDER));
  fTag.RW2SensorTopBorder := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_RW2_SENSOR_TOP_BORDER));
  fTag.SamplesPerPixel := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SAMPLES_PER_PIXEL));
  fTag.Saturation := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SATURATION));
  fTag.SceneCaptureType := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SCENE_CAPTURE_TYPE));
  fTag.SceneType := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SCENE_TYPE));
  fTag.SensingMethod := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SENSING_METHOD));
  fTag.Sharpness := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SHARPNESS));
  fTag.ShutterSpeedValue := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SHUTTER_SPEED_VALUE));
  fTag.Software := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SOFTWARE));
  fTag.SpatialFrequencyResponse := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SPATIAL_FREQUENCY_RESPONSE));
  fTag.SpectralSenitivity := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SPECTRAL_SENSITIVITY));
  fTag.StripByteCounts := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_STRIP_BYTE_COUNTS));
  fTag.StripOffsets := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_STRIP_OFFSETS));
  fTag.SubfileType := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBFILE_TYPE));
  fTag.SubjectArea := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBJECT_AREA));
  fTag.SubjectDistance := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBJECT_DISTANCE));
  fTag.SubjectDistanceRange := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBJECT_DISTANCE_RANGE));
  fTag.SubjectLocation := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBJECT_LOCATION));
  fTag.SubsecTime := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBSEC_TIME));
  fTag.SubsecTimeDig := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBSEC_TIME_DIG));
  fTag.SubsecTimeDigitized := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBSEC_TIME_DIGITIZED));
  fTag.SubsecTimeOrig := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBSEC_TIME_ORIG));
  fTag.SubsecTimeOriginal := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_SUBSEC_TIME_ORIGINAL));
  fTag.ThumbnailImageLength := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_THUMBNAIL_IMAGE_LENGTH));
  fTag.ThumbnailImageWidth := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_THUMBNAIL_IMAGE_WIDTH));
  fTag.TransferFunction := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_TRANSFER_FUNCTION));
  fTag.UserComment := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_USER_COMMENT));
  fTag.WhiteBalance := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_WHITE_BALANCE));
  fTag.WhitePoint := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_WHITE_POINT));
  fTag.XResolution := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_X_RESOLUTION));
  fTag.YCbCrCoefficients := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_Y_CB_CR_COEFFICIENTS));
  fTag.YCbCrPositioning := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_Y_CB_CR_POSITIONING));
  fTag.YCbCrSubSampling := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_Y_CB_CR_SUB_SAMPLING));
  fTag.YResolution := JStringToString(LEXIF.getAttribute(TJExifInterface.JavaClass.TAG_Y_RESOLUTION));
 // LEXIF.setAttribute(TJExifInterface.JavaClass.TAG_ARTIST, StringToJString('Thomas Bachmann'));
  //LEXIF.saveAttributes;
  try
    LLatLong := TJavaArray<Single>.Create(2);
    try
      if LEXIF.getLatLong(LLatLong) then
      begin
        fLatitude := LLatLong.Items[0].ToString;
        fLongitude := LLatLong.Items[1].ToString;
      end;
    finally
      LLatLong.Free;
    end;
  except
  end;

  Result := True;
end;

function TExifProperty.GetOrientation(const AValue: Integer): TEXIFOrientations;
begin
  if AValue = 0 then
    Result := TEXIFOrientations.Normal
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_NORMAL then
    Result := TEXIFOrientations.Normal
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_FLIP_HORIZONTAL then
    Result := TEXIFOrientations.FlipHorizontal
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_ROTATE_180 then
    Result := TEXIFOrientations.Rotate180
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_FLIP_VERTICAL then
    Result := TEXIFOrientations.FlipVertical
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_TRANSPOSE then
    Result := TEXIFOrientations.Transpose
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_ROTATE_270 then
    Result := TEXIFOrientations.Rotate90
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_TRANSVERSE then
    Result := TEXIFOrientations.Transverse
  else if AValue = TJExifInterface.JavaClass.ORIENTATION_ROTATE_90 then
    Result := TEXIFOrientations.Rotate270
  else
    Result := TEXIFOrientations.Unknown;

end;


procedure TExifProperty.LoadInfoToStrings(aStrings: TStrings);
begin
  aStrings.Clear;
  fTag.LoadTAGToStrings(aStrings);
  aStrings.Add('Latitude' + fLatitude);
  aStrings.Add('Longitude: ' + fLongitude);

end;


end.
