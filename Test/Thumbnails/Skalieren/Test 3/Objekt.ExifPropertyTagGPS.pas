unit Objekt.ExifPropertyTagGPS;

interface

uses
  System.SysUtils, System.Types,  System.Classes, System.Variants;


type
  TExifPropertyTagGPS = class
  private
    fAltitude: string;
    fAltitudeRef: string;
    fAreaInformation: string;
    fDatestamp: string;
    fDestBearing: string;
    fDestBearingRef: string;
    fDestDistance: string;
    fDistanceRef: string;
    fDestLatitude: string;
    fDestLatitudeRef: string;
    fDestLongitude: string;
    fDestLongitudeRef: string;
    fDifferential: string;
    fDop: string;
    fImgDirection: string;
    fImgDirectionRef: string;
    fLatitude: string;
    fLatitudeRef: string;
    fLongitude: string;
    fLongitudeRef: string;
    fMapDatum: string;
    fMeasureMode: string;
    fProcessingMethod: string;
    fSatellites: string;
    fSpeed: string;
    fSpeedRef: string;
    fStatus: string;
    fTimestamp: string;
    fTrack: string;
    fTrackRef: string;
    fVersionId: string;
public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Altitude: string read fAltitude write fAltitude;
    property AltitudeRef: string read fAltitudeRef write fAltitudeRef;
    property AreaInformation: string read fAreaInformation write fAreaInformation;
    property Datestamp: string read fDatestamp write fDatestamp;
    property DestBearing: string read fDestBearing write fDestBearing;
    property DestBearingRef: string read fDestBearingRef write fDestBearingRef;
    property DestDistance: string read fDestDistance write fDestDistance;
    property DistanceRef: string read fDistanceRef write fDistanceRef;
    property DestLatitude: string read fDestLatitude write fDestLatitude;
    property DestLatitudeRef: string read fDestLatitudeRef write fDestLatitudeRef;
    property DestLongitude: string read fDestLongitude write fDestLongitude;
    property DestLongitudeRef: string read fDestLongitudeRef write fDestLongitudeRef;
    property Differential: string read fDifferential write fDifferential;
    property Dop: string read fDop write fDop;
    property ImgDirection: string read fImgDirection write fImgDirection;
    property ImgDirectionRef: string read fImgDirectionRef write fImgDirectionRef;
    property Latitude: string read fLatitude write fLatitude;
    property LatitudeRef: string read fLatitudeRef write fLatitudeRef;
    property Longitude: string read fLongitude write fLongitude;
    property LongitudeRef: string read fLongitudeRef write fLongitudeRef;
    property MapDatum: string read fMapDatum write fMapDatum;
    property MeasureMode: string read fMeasureMode write fMeasureMode;
    property ProcessingMethod: string read fProcessingMethod write fProcessingMethod;
    property Satellites: string read fSatellites write fSatellites;
    property Speed: string read fSpeed write fSpeed;
    property SpeedRef: string read fSpeedRef write fSpeedRef;
    property Status: string read fStatus write fStatus;
    property Timestamp: string read fTimestamp write fTimestamp;
    property Track: string read fTrack write fTrack;
    property TrackRef: string read fTrackRef write fTrackRef;
    property VersionId: string read fVersionId write fVersionId;
    procedure LoadToStrings(aStrings: TStrings);
  end;

implementation

{ TExifPropertyTagGPS }

constructor TExifPropertyTagGPS.Create;
begin
  init;
end;

destructor TExifPropertyTagGPS.Destroy;
begin

  inherited;
end;

procedure TExifPropertyTagGPS.Init;
begin
  fAltitude := '';
  fAltitudeRef := '';
  fAreaInformation := '';
  fDatestamp := '';
  fDestBearing := '';
  fDestBearingRef := '';
  fDestDistance := '';
  fDestLatitude := '';
  fDestLatitudeRef := '';
  fDestLongitude := '';
  fDestLongitudeRef := '';
  fDifferential := '';
  fDop := '';
  fImgDirection := '';
  fImgDirectionRef := '';
  fLatitude := '';
  fLatitudeRef := '';
  fLongitude := '';
  fLongitudeRef := '';
  fMapDatum := '';
  fMeasureMode := '';
  fProcessingMethod := '';
  fSatellites := '';
  fSpeed := '';
  fSpeedRef := '';
  fStatus := '';
  fTimestamp := '';
  fTrack := '';
  fTrackRef := '';
  fVersionId := '';
end;

procedure TExifPropertyTagGPS.LoadToStrings(aStrings: TStrings);
begin
  aStrings.Add('Altitude: ' + fAltitude);
  aStrings.Add('AltitudeRef: ' + fAltitudeRef);
  aStrings.Add('AreaInformation: ' + fAreaInformation);
  aStrings.Add('Datestamp: ' + fDatestamp);
  aStrings.Add('DestBearing: ' + fDestBearing);
  aStrings.Add('DestBearingRef: ' + fDestBearingRef);
  aStrings.Add('DestDistance: ' + fDestDistance);
  aStrings.Add('DestLatitude: ' + fDestLatitude);
  aStrings.Add('DestLatitudeRef: ' + fDestLatitudeRef);
  aStrings.Add('DestLongitude: ' + fDestLongitude);
  aStrings.Add('DestLongitudeRef: ' + fDestLongitudeRef);
  aStrings.Add('Differential: ' + fDifferential);
  aStrings.Add('Dop: ' + fDop);
  aStrings.Add('ImgDirection: ' + fImgDirection);
  aStrings.Add('ImgDirectionRef: ' + fImgDirectionRef);
  aStrings.Add('Latitude: ' + fLatitude);
  aStrings.Add('LatitudeRef: ' + fLatitudeRef);
  aStrings.Add('Longitude: ' + fLongitude);
  aStrings.Add('LongitudeRef: ' + fLongitudeRef);
  aStrings.Add('MapDatum: ' + fMapDatum);
  aStrings.Add('MeasureMode: ' + fMeasureMode);
  aStrings.Add('ProcessingMethod: ' + fProcessingMethod);
  aStrings.Add('Satellites: ' + fSatellites);
  aStrings.Add('Speed: ' + fSpeed);
  aStrings.Add('SpeedRef: ' + fSpeedRef);
  aStrings.Add('Status: ' + fStatus);
  aStrings.Add('Timestamp: ' + fTimestamp);
  aStrings.Add('Track: ' + fTrack);
  aStrings.Add('TrackRef: ' + fTrackRef);
  aStrings.Add('VersionId: ' + fVersionId);
end;

end.
