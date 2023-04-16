unit Objekt.Exif;


interface

uses
  Classes, SysUtils;

type
  TExif = class(TObject)
    private
      FImageDesc          : String;     //Picture description
      FMake               : String;     //Camera manufacturer
      FModel              : String;     //Camere model
      FOrientation        : Byte;       //Image orientation - 1 normal
      FOrientationDesk    : String;     //Image orientation description
      FCopyright          : String;     //Copyright
      FValid              : Boolean;    //Has valid Exif header
      FDateTime           : String;     //Date and Time of Change
      FDateTimeOriginal   : String;     //Original Date and Time
      FDateTimeDigitized  : String;     //Camshot Date and Time
      FUserComments       : String;     //User Comments

      f                   : File;
      idfp                : Cardinal;
      function ReadValue(const Offset, Count: Cardinal): String;
      procedure Init;
    public
      constructor Create;
      procedure ReadFromFile(const FileName: AnsiString);

      property ImageDesc: String read FImageDesc;
      property Make: String read FMake;
      property Model: String read FModel;
      property Orientation: Byte read FOrientation;
      property OrientationDesk: String read FOrientationDesk;
      property Copyright: String read FCopyright;
      property Valid: Boolean read FValid;
      property DateTime: String read FDateTime;
      property DateTimeOriginal: String read FDateTimeOriginal;
      property DateTimeDigitized: String read FDateTimeDigitized;
      property UserComments: String read FUserComments;
  end;

implementation


type
  TMarker = record
    Marker   : Word;      //Section marker
    Len      : Word;      //Length Section
    Indefin  : Array [0..4] of Char; //Indefiner - "Exif" 00, "JFIF" 00 and ets
    Pad      : Char;      //0x00
  end;

  TTag = record
    TagID   : Word;       //Tag number
    TagType : Word;       //Type tag
    Count   : Cardinal;   //tag length
    OffSet  : Cardinal;   //Offset / Value
  end;

  TIFDHeader = record
    pad          : Byte; //00h
    ByteOrder    : Word; //II (4D4D)
    i42          : Word; //2A00
    IFD0offSet   : Cardinal; //0th offset IFD
    Interoperabil: Byte;
  end;

function TExif.ReadValue(const Offset, Count: Cardinal): String;
var fp: LongInt;
     i: Word;
begin
  SetLength(Result,Count);
  fp:=FilePos(f); //Save file offset
  Seek(f, Offset);
  try
    i:=1;
    repeat
      BlockRead(f,Result[i],1);
      inc(i);
    until (i>=Count) or (Result[i-1]=#0);
    if i<=Count then Result:=Copy(Result,1,i-1);
  except
    Result:='';
  end;
//  Result:=TrimRight(Result);
  Seek(f,fp);     //Restore file offset
end;

procedure TExif.Init;
begin

  idfp:=0;

  FImageDesc:='';
  FMake:='';
  FModel:='';
  FOrientation:=1;
  FOrientationDesk:='Normal';
  FDateTime:='';
  FCopyright:='';
  FValid:=False;
  FDateTimeOriginal:='';
  FDateTimeDigitized:='';
  FUserComments:='';
end;

constructor TExif.Create;
begin
  Init;
end;

procedure TExif.ReadFromFile(const FileName: AnsiString);
const ori: Array[1..8] of String=('Normal','Mirrored','Rotated 180','Rotated 180, mirrored','Rotated 90 left, mirrored','Rotated 90 right','Rotated 90 right, mirrored','Rotated 90 left');
var j: TMarker;
  idf: TIFDHeader;
 off0: Cardinal; //Null Exif Offset
  tag: TTag;
    i: Integer;
  SOI: Word; //2 bytes SOI marker. FF D8 (Start Of Image)

begin
  if not FileExists(FileName) then exit;
  Init;

  AssignFile(f,FileName);
  reset(f,1);

  BlockRead(f,SOI,2);
  if SOI=$D8FF then begin //Is this Jpeg
    BlockRead(f,j,9);

    if j.Marker=$E0FF then begin //JFIF Marker Found
      Seek(f,20); //Skip JFIF Header
      BlockRead(f,j,9);
    end;

    if j.Marker=$E1FF then begin //If we found Exif Section. j.Indefin='Exif'.
      FValid:=True;
      off0:=FilePos(f)+1;   //0'th offset Exif header
      BlockRead(f,idf,11);  //Read IDF Header

      i:=0;
      repeat
        inc(i);
        BlockRead(f,tag,12);
        //0E01 ImageDescription
        if tag.TagID=$010E then
          FImageDesc:=ReadValue(tag.OffSet+off0,tag.Count);
        //0F01 Make
        if tag.TagID=$010F then
          FMake:=ReadValue(tag.OffSet+off0,tag.Count);
        //1001 Model
        if tag.TagID=$0110 then
          FModel:=ReadValue(tag.OffSet+off0,tag.Count);
        //6987 Exif IFD Pointer
        if tag.TagID=$8769 then
          idfp:=Tag.OffSet; //Read Exif IDF offset
        //1201 Orientation
        if tag.TagID=$0112 then begin
           FOrientation:=tag.OffSet;
           if tag.OffSet in [1..8] then
             FOrientationDesk:=ori[tag.OffSet] else FOrientationDesk:='Unknown';
        end;
        //3201 DateTime
        if tag.TagID=$0132 then
          FDateTime:=ReadValue(tag.OffSet+off0,tag.Count);
        //9882 CopyRight
        if tag.TagID=$8298 then
          FCopyright:=ReadValue(tag.OffSet+off0,tag.Count);
      until (i>11);

      if idfp>0 then begin
        Seek(f,idfp+12+2);//12 - Size header before Exif, 2 - size Exif IFD Number
        i:=0;
        repeat
          inc(i);
          BlockRead(f,tag,12);
  {
          You may simple realize read this info:

          tag |Name of tag

          9A82 ExposureTime
          9D82 FNumber
          0090 ExifVersion
          0390 DateTimeOriginal
          0490 DateTimeDigitized
          0191 ComponentsConfiguration
          0292 CompressedBitsPerPixel
          0192 ShutterSpeedValue
          0292 ApertureValue
          0392 BrightnessValue
          0492 ExposureBiasValue
          0592 MaxApertureRatioValue
          0692 SubjectDistance
          0792 MeteringMode
          0892 LightSource
          0992 Flash
          0A92 FocalLength
          8692 UserComments
          9092 SubSecTime
          9192 SubSecTimeOriginal
          9292 SubSecTimeDigitized
          A000 FlashPixVersion
          A001 Colorspace
          A002 Pixel X Dimension
          A003 Pixel Y Dimension
  }

          //0390 FDateTimeOriginal
          if tag.TagID=$9003 then FDateTimeOriginal:=ReadValue(tag.OffSet+off0,tag.Count);
          //0490 DateTimeDigitized
          if tag.TagID=$9004 then FDateTimeDigitized:=ReadValue(tag.OffSet+off0,tag.Count);
          //8692 UserComments
          if tag.TagID=$9286 then FUserComments:=ReadValue(tag.OffSet+off0,tag.Count);
        until (i>23);
      end;
    end;
  end;
  CloseFile(f);
end;


end.
