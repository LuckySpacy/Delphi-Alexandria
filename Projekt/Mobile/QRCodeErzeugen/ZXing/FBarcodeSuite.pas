// ---------------------------------------------------------------------
//
// Barcode Suite for FireMonkey 2.2
//
// Copyright (c) 2022-2023 WINSOFT
//
// ---------------------------------------------------------------------

//{$define TRIAL} // trial version, comment this line for full version

unit FBarcodeSuite;

{$WARN SYMBOL_PLATFORM OFF}

{$if CompilerVersion >= 24} // Delphi XE3 or higher
  {$LEGACYIFEND ON}
{$ifend}

{$if CompilerVersion = 23} // Delphi XE2
  {$define DXE2}
{$ifend}

{$if CompilerVersion >= 26} // Delphi XE5 or higher
  {$define DXE5PLUS}
{$ifend}

{$if CompilerVersion >= 27} // Delphi XE6 or higher
  {$define DXE6PLUS}
{$ifend}

{$if CompilerVersion >= 35} // Delphi 11 or higher
  {$define D11PLUS}
{$ifend}

{$ifdef NEXTGEN}
  {$MESSAGE Error 'NEXTGEN compilers are not supported'}
{$endif NEXTGEN}

{$ifdef IOS}
  {$ifdef CPUARM}
    {$define IOS_DEVICE}
  {$endif CPUARM}
{$endif IOS}

interface

uses {$ifdef MSWINDOWS} Winapi.Windows, {$endif MSWINDOWS} System.Types, System.SysUtils,
  System.UITypes {$ifdef DXE5PLUS}, FMX.Graphics {$else}, FMX.Types {$endif DXE5PLUS};

type
  TBinarizer = (biLocalAverage, biGlobalHistogram, biFixedThreshold, biCast);

  TCharacterSet = (csUnknown, csAscii, csIso8859_1, csIso8859_2,
    csIso8859_3, csIso8859_4, csIso8859_5, csIso8859_6, csIso8859_7,
    csIso8859_8, csIso8859_9, csIso8859_10, csIso8859_11, csIso8859_13,
    csIso8859_14, csIso8859_15, csIso8859_16,
    csCp437, csCp1250, csCp1251, csCp1252, csCp1256,
    csShiftJis, csBig5, csGb2312, csGb18030, csEucJp, csEucKr,
    csUnicodeBig, csUtf8, csBinary
  );

  TContentType = (ctText, ctBinary, ctMixed, ctGS1, ctISO15434, ctUnknownECI);

  TEanAddOn = (eqIgnore, eaRead, eaRequire);

  TEccLevel = (ecUnused, ec0, ec1, ec2, ec3, ec4, ec5, ec6, ec7, ec8);

  TErrorType = (etNone, etFormat, etChecksum, etUnsupported);

  TFormat = (foUnknown, foAztec, foCodabar, foCode39, foCode93,
    foCode128, foDataBar, foDataBarExpanded, foDataMatrix, foEan8, foEan13,
    foItf, foMaxiCode, foPdf417, foQrCode, foUpcA, foUpcE, foMicroQrCode);
  TFormats = set of TFormat;

  TTextMode = (tmPlain, tmECI, tmHumanReadable, tmHex, tmEscaped);

  TDecodeResult = record
    ErrorType: TErrorType;
    ErrorMessage: AnsiString;
    Format: TFormat;
    FormatName: string;
    Data: TBytes;
    Text: string;
    TextUtf8: AnsiString;
    RenderedText: AnsiString;
    EccLevel: string;
    EccLevelUtf8: AnsiString;
    ContentType: TContentType;
    Version: AnsiString;

    HasEci: Boolean;
    EciData: TBytes;

    TopLeft: TPoint;
    TopRight: TPoint;
    BottomLeft: TPoint;
    BottomRight: TPoint;

    LineCount: Integer;
    Orientation: Integer;
    Inverted: Boolean;
    Mirrored: Boolean;
    SymbologyIdentifier: AnsiString;
    SequenceSize: Integer;
    SequenceIndex: Integer;
    SequenceId: AnsiString;
    ReaderInit: Boolean;
  end;
  TDecodeResults = array of TDecodeResult;

  TEncodeResult = record
    Width: Integer;
    Height: Integer;
    Data: TBytes;
    ErrorMessage: AnsiString;
  end;

  EBarcodeError = class(Exception);

  TBarcodeDecoder = class
  private
    FBinarizer: TBinarizer;
    FCharacterSet: string;
    FEanAddOn: TEanAddOn;
    FFormats: TFormats;
    FMaxBarcodeCount: Byte;
    FMinLineCount: Integer;
    FPureBarcode: Boolean;
    FReturnCodabarStartEnd: Boolean;
    FReturnErrors: Boolean;
    FTextMode: TTextMode;
    FTryCode39ExtendedMode: Boolean;
    FTryDownscale: Boolean;
    FTryHarder: Boolean;
    FTryRotate: Boolean;
    FTryInvert: Boolean;
    FValidateCode39: Boolean;
    FValidateITF: Boolean;
  public
    constructor Create;
    function Decode(Bitmap: TBitmap): TDecodeResults; overload;
    function Decode(Bitmap: TBitmap; Rect: TRect): TDecodeResults; overload;

    property Binarizer: TBinarizer read FBinarizer write FBinarizer;
    property CharacterSet: string read FCharacterSet write FCharacterSet;
    property EanAddOn: TEanAddOn read FEanAddOn write FEanAddOn;
    property Formats: TFormats read FFormats write FFormats;
    property MaxBarcodeCount: Byte read FMaxBarcodeCount write FMaxBarcodeCount;
    property MinLineCount: Integer read FMinLineCount write FMinLineCount;
    property PureBarcode: Boolean read FPureBarcode write FPureBarcode;
    property ReturnCodabarStartEnd: Boolean read FReturnCodabarStartEnd write FReturnCodabarStartEnd;
    property ReturnErrors: Boolean read FReturnErrors write FReturnErrors;
    property TextMode: TTextMode read FTextMode write FTextMode;
    property TryCode39ExtendedMode: Boolean read FTryCode39ExtendedMode write FTryCode39ExtendedMode;
    property TryDownscale: Boolean read FTryDownscale write FTryDownscale;
    property TryHarder: Boolean read FTryHarder write FTryHarder;
    property TryInvert: Boolean read FTryInvert write FTryInvert;
    property TryRotate: Boolean read FTryRotate write FTryRotate;
    property ValidateCode39: Boolean read FValidateCode39 write FValidateCode39;
    property ValidateITF: Boolean read FValidateITF write FValidateITF;
  end;

  TBarcodeEncoder = class
  private
    FBackColor: TAlphaColor;
    FCharacterSet: TCharacterSet;
    FEccLevel: TEccLevel;
    FForeColor: TAlphaColor;
    FFormat: TFormat;
    FMargin: Integer;
    FText: string;
    FWidth: Integer;
    FHeight: Integer;
  public
    constructor Create;
    function Encode(Bitmap: TBitmap): TEncodeResult;

    property BackColor: TAlphaColor read FBackColor write FBackColor;
    property CharacterSet: TCharacterSet read FCharacterSet write FCharacterSet;
    property EccLevel: TEccLevel read FEccLevel write FEccLevel;
    property ForeColor: TAlphaColor read FForeColor write FForeColor;
    property Format: TFormat read FFormat write FFormat;
    property Height: Integer read FHeight write FHeight;
    property Margin: Integer read FMargin write FMargin;
    property Text: string read FText write FText;
    property Width: Integer read FWidth write FWidth;
  end;

{$ifdef IOS_DEVICE}
{$define STATIC_LIBRARY}
{$endif IOS_DEVICE}

{$ifdef ANDROID}
{$define STATIC_LIBRARY}
{$endif ANDROID}

{$ifndef STATIC_LIBRARY}
var
  ZXingLibraryName: string = '';
  ZXingLibrary: HMODULE;
{$endif STATIC_LIBRARY}

function LoadedLibrary: Boolean;
procedure LoadLibrary;
procedure UnloadLibrary;

implementation

{$ifdef TRIAL} uses System.Classes, FMX.Dialogs; {$endif TRIAL}

{$ifdef MSWINDOWS}
type
  TArithmeticMask = record
    Fpu: Word;
    Sse: Word;
  end;

function SetArithmeticMask: TArithmeticMask;
var ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Result.Fpu := ControlWord and $3F;
  Set8087CW(ControlWord or $3F);

  {$ifdef CPUX64}
  ControlWord := GetMXCSR;
  Result.Sse := ControlWord and $1F80;
  SetMXCSR(ControlWord or $1F80);
  {$endif CPUX64}
end;

procedure RestoreArithmeticMask(Mask: TArithmeticMask);
var ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Set8087CW((ControlWord and (not $3F)) or Mask.Fpu);

  {$ifdef CPUX64}
  ControlWord := GetMXCSR;
  SetMXCSR((ControlWord and (not $1F80)) or Mask.Sse);
  {$endif CPUX64}
end;
{$endif MSWINDOWS}

function ToInteger(Value: Boolean): Integer;
begin
  if Value then
    Result := -1
  else
    Result := 0
end;

function ToBoolean(Value: Integer): Boolean;
begin
  Result := Value <> 0;
end;

function EncodeTextMode(TextMode: TTextMode): Integer;
begin
  Result := Ord(TextMode);
end;

function EncodeFormat(Format: TFormat): Integer;
begin
  if Format = foUnknown then
    Result := 0
  else
    Result := 1 shl (Ord(Format) - 1);
end;

function EncodeFormats(Formats: TFormats): Integer;
begin
  Result := 0;
  if foAztec in Formats then
    Result := Result or EncodeFormat(foAztec);
  if foCodabar in Formats then
    Result := Result or EncodeFormat(foCodabar);
  if foCode39 in Formats then
    Result := Result or EncodeFormat(foCode39);
  if foCode93 in Formats then
    Result := Result or EncodeFormat(foCode93);
  if foCode128 in Formats then
    Result := Result or EncodeFormat(foCode128);
  if foDataBar in Formats then
    Result := Result or EncodeFormat(foDataBar);
  if foDataBarExpanded in Formats then
    Result := Result or EncodeFormat(foDataBarExpanded);
  if foDataMatrix in Formats then
    Result := Result or EncodeFormat(foDataMatrix);
  if foEan8 in Formats then
    Result := Result or EncodeFormat(foEan8);
  if foEan13 in Formats then
    Result := Result or EncodeFormat(foEan13);
  if foItf in Formats then
    Result := Result or EncodeFormat(foItf);
  if foMaxiCode in Formats then
    Result := Result or EncodeFormat(foMaxiCode);
  if foPdf417 in Formats then
    Result := Result or EncodeFormat(foPdf417);
  if foQrCode in Formats then
    Result := Result or EncodeFormat(foQrCode);
  if foUpcA in Formats then
    Result := Result or EncodeFormat(foUpcA);
  if foUpcE in Formats then
    Result := Result or EncodeFormat(foUpcE);
  if foMicroQrCode in Formats then
    Result := Result or EncodeFormat(foMicroQrCode);
end;

function DecodeFormat(Value: Integer): TFormat;
begin
  if Value = EncodeFormat(foAztec) then
    Result := foAztec
  else if Value = EncodeFormat(foCodabar) then
    Result := foCodabar
  else if Value = EncodeFormat(foCode39) then
    Result := foCode39
  else if Value = EncodeFormat(foCode93) then
    Result := foCode93
  else if Value = EncodeFormat(foCode128) then
    Result := foCode128
  else if Value = EncodeFormat(foDataBar) then
    Result := foDataBar
  else if Value = EncodeFormat(foDataBarExpanded) then
    Result := foDataBarExpanded
  else if Value = EncodeFormat(foDataMatrix) then
    Result := foDataMatrix
  else if Value = EncodeFormat(foEan8) then
    Result := foEan8
  else if Value = EncodeFormat(foEan13) then
    Result := foEan13
  else if Value = EncodeFormat(foItf) then
    Result := foItf
  else if Value = EncodeFormat(foMaxiCode) then
    Result := foMaxiCode
  else if Value = EncodeFormat(foPdf417) then
    Result := foPdf417
  else if Value = EncodeFormat(foQrCode) then
    Result := foQrCode
  else if Value = EncodeFormat(foUpcA) then
    Result := foUpcA
  else if Value = EncodeFormat(foUpcE) then
    Result := foUpcE
  else if Value = EncodeFormat(foMicroQrCode) then
    Result := foMicroQrCode
  else
    Result := foUnknown;
end;

function DecodeFormats(Value: Integer): TFormats;
begin
  Result := [];
  if (Value and EncodeFormat(foAztec)) <> 0 then
    Result := Result + [foAztec];
  if (Value and EncodeFormat(foCodabar)) <> 0 then
    Result := Result + [foCodabar];
  if (Value and EncodeFormat(foCode39)) <> 0 then
    Result := Result + [foCode39];
  if (Value and EncodeFormat(foCode93)) <> 0 then
    Result := Result + [foCode93];
  if (Value and EncodeFormat(foCode128)) <> 0 then
    Result := Result + [foCode128];
  if (Value and EncodeFormat(foDataBar)) <> 0 then
    Result := Result + [foDataBar];
  if (Value and EncodeFormat(foDataBarExpanded)) <> 0 then
    Result := Result + [foDataBarExpanded];
  if (Value and EncodeFormat(foDataMatrix)) <> 0 then
    Result := Result + [foDataMatrix];
  if (Value and EncodeFormat(foEan8)) <> 0 then
    Result := Result + [foEan8];
  if (Value and EncodeFormat(foEan13)) <> 0 then
    Result := Result + [foEan13];
  if (Value and EncodeFormat(foItf)) <> 0 then
    Result := Result + [foItf];
  if (Value and EncodeFormat(foMaxiCode)) <> 0 then
    Result := Result + [foMaxiCode];
  if (Value and EncodeFormat(foPdf417)) <> 0 then
    Result := Result + [foPdf417];
  if (Value and EncodeFormat(foQrCode)) <> 0 then
    Result := Result + [foQrCode];
  if (Value and EncodeFormat(foUpcA)) <> 0 then
    Result := Result + [foUpcA];
  if (Value and EncodeFormat(foUpcE)) <> 0 then
    Result := Result + [foUpcE];
  if (Value and EncodeFormat(foMicroQrCode)) <> 0 then
    Result := Result + [foMicroQrCode];
end;

function FormatName(Format: TFormat): string;
const Names: array [TFormat] of string =
(
  'Unknown', 'Aztec', 'Codabar', 'Code 39', 'Code 93',
  'Code 128', 'DataBar', 'DataBar Expanded', 'Data Matrix', 'EAN-8', 'EAN-13',
  'ITF', 'MaxiCode', 'PDF417', 'QR Code', 'UPC-A', 'UPC-E', 'Micro QR Code'
);
begin
  Result := Names[Format];
end;

type
  TImage = record
    Data: Pointer; // RGB data
    Width: Integer;
    Height: Integer;
  end;

  THints = record
    Formats: Integer;
    TryHarder: Integer;
    TryRotate: Integer;
    TryInvert: Integer;
    TryDownscale: Integer;
    Binarizer: Integer;
    IsPure: Integer;
    MinLineCount: Integer;
    MaxNumberOfSymbols: Integer;
    CharacterSet: PAnsiChar;
    TryCode39ExtendedMode: Integer;
    ValidateCode39CheckSum: Integer;
    ValidateITFCheckSum: Integer;
    ReturnCodabarStartEnd: Integer;
    ReturnErrors: Integer;
    EanAddOnSymbol: Integer;
    TextMode: Integer;
  end;

  TResult = record
    ErrorType: Integer;
    ErrorMessageSize: Integer;
    ErrorMessage: PAnsiChar;
    Format: Integer;
    BytesSize: Integer;
    Bytes: Pointer;

    TextSize: Integer;
    Text: PAnsiChar;
    RenderedTextSize: Integer;
    RenderedText: PAnsiChar;
    EcLevelSize: Integer;
    EcLevel: PAnsiChar;

    // ECI
    HasEci: Integer;
    EciBytesSize: Integer;
    EciBytes: Pointer;

    ContentType: Integer;

    // position
    TopLeftX: Integer;
    TopLeftY: Integer;
    TopRightX: Integer;
    TopRightY: Integer;
    BottomLeftX: Integer;
    BottomLeftY: Integer;
    BottomRightX: Integer;
    BottomRightY: Integer;

    Orientation: Integer;
    IsMirrored: Integer;
    IsInverted: Integer;
    SymbologyIdentifierSize: Integer;
    SymbologyIdentifier: PAnsiChar;
    SequenceSize: Integer;
    SequenceIndex: Integer;
    SequenceIdSize: Integer;
    SequenceId: PAnsiChar;
    ReaderInit: Integer;
    LineCount: Integer;
    VersionSize: Integer;
    Version: PAnsiChar;
  end;
  PResult = ^TResult;

  TBarcode = record
    Data: Pointer;
    Width: Integer;
    Height: Integer;
    ErrorMessageSize: Integer;
    ErrorMessage: PAnsiChar;
  end;
  PBarcode = ^TBarcode;

{$ifdef STATIC_LIBRARY}
const
  LibZXingCpp = 'libzxingcpp.a';

  function ZXingGetVersion(ImageSize, HintSize, ResultSize, BarcodeSize: Integer): Integer; cdecl; external LibZXingCpp name 'GetVersion' {$ifdef IOS_DEVICE} dependency 'c++' {$else} dependency 'c++_static' dependency 'c++abi' {$endif IOS_DEVICE};
  function ZXingReadBarcode(var Image: TImage; var Hints: THints; out ResultCount: Integer): PResult; cdecl; external LibZXingCpp name 'ReadBarcode';
  procedure ZXingDeleteResults(ResultCount: Integer; Results: PResult); cdecl; external LibZXingCpp name 'DeleteResults';
  procedure ZXingWriteBarcode(BarcodeFormat, Encoding, EccLevel, Margin: Integer; Contents: Pointer;
    Width, Height: Integer; out Barcode: TBarcode); cdecl; external LibZXingCpp name 'WriteBarcode';
  procedure ZXingDeleteBarcode(Barcode: PBarcode); cdecl; external LibZXingCpp name 'DeleteBarcode';
{$else}
var
  ZXingGetVersion: function(ImageSize, HintSize, ResultSize, BarcodeSize: Integer): Integer; cdecl;
  ZXingReadBarcode: function(var Image: TImage; var Hints: THints; out ResultCount: Integer): PResult; cdecl;
  ZXingDeleteResults: procedure(ResultCount: Integer; Results: PResult); cdecl;
  ZXingWriteBarcode: procedure(BarcodeFormat, Encoding, EccLevel, Margin: Integer; Contents: Pointer;
    Width, Height: Integer; out Barcode: TBarcode); cdecl;
  ZXingDeleteBarcode: procedure(Barcode: PBarcode); cdecl;

  {$IFDEF LINUX}
    procedure _Unused(exception_object: Pointer); cdecl; external 'libgcc_s.so.1' name '__Unwind_Resume' dependency 'stdc++'; // -lstdc++ is needed so dependency 'stdc++' is used for this purpose
  {$ENDIF LINUX}
{$endif STATIC_LIBRARY}

(*
function WStringToString(Size: Integer; Data: Pointer): string;
{$ifndef MSWINDOWS}
var
  I: Integer;
  Ptr: PByte;
{$endif MSWINDOWS}
begin
  if Size <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, Size);
    {$ifdef MSWINDOWS}
       Move(Data^, Result[1], 2 * Size);
    {$else}
      for I := 0 to Size - 1 do
      begin
        Ptr := PByte(Data) + 4 * I;
        PWord(@Result[I + 1])^ := PWord(Ptr)^;
      end;
    {$endif MSWINDOWS}
  end;
end;
*)

function PictureData(Bitmap: TBitmap; var Rect: TRect): TBytes;
var
{$ifndef DXE2}
  Data: TBitmapData;
{$endif DXE2}
  Width, Height: Integer;
  I, X, Y: Integer;
  Color: TAlphaColor;
begin
  Result := nil;

  if Rect.Left < 0 then
    Rect.Left := 0;
  if Rect.Top < 0 then
    Rect.Top := 0;
  if Rect.Right > Bitmap.Width then
    Rect.Right := Bitmap.Width;
  if Rect.Bottom > Bitmap.Height then
    Rect.Bottom := Bitmap.Height;

  Width := Rect.Right - Rect.Left;
  Height := Rect.Bottom - Rect.Top;
  if (Width <= 0) or (Height <= 0) then
    Exit;

{$ifndef DXE2}
  {$ifdef DXE6PLUS}
  if Bitmap.Map(TMapAccess.Read, Data) then
  {$else}
  if Bitmap.Map(TMapAccess.maRead, Data) then
  {$endif DXE6PLUS}
  try
{$endif DXE2}
    SetLength(Result, 3 * Width * Height);

    I := 0;
    for Y := Rect.Top to Rect.Bottom - 1 do
      for X := Rect.Left to Rect.Right - 1 do
      begin
{$ifndef DXE2}
        Color := Data.GetPixel(X, Y);
{$else}
        Color := Bitmap.Pixels[X, Y];
{$endif DXE2}
        Result[I] := TAlphaColorRec(Color).R;
        Inc(I);
        Result[I] := TAlphaColorRec(Color).G;
        Inc(I);
        Result[I] := TAlphaColorRec(Color).B;
        Inc(I);
      end;

{$ifndef DXE2}
  finally
    Bitmap.Unmap(Data);
  end;
{$endif DXE2}
end;

// TBarcodeDecoder

constructor TBarcodeDecoder.Create;
begin
  inherited;
  FFormats := [foAztec, foCodabar, foCode39, foCode93,
    foCode128, foDataBar, foDataBarExpanded, foDataMatrix, foEan8, foEan13,
    foItf, foMaxiCode, foPdf417, foQrCode, foUpcA, foUpcE, foMicroQrCode];
  FMaxBarcodeCount := 255;
  FMinLineCount := 2;
  FReturnErrors := True;
  FTextMode := tmHumanReadable;
  FTryHarder := True;
  FTryRotate := True;
  FTryInvert := True;
end;

function TBarcodeDecoder.Decode(Bitmap: TBitmap; Rect: TRect): TDecodeResults;
var
{$ifdef MSWINDOWS}
  ArithmeticMask: TArithmeticMask;
{$endif MSWINDOWS}
  Data: TBytes;
  Image: TImage;
  Hints: THints;
  Results: PResult;
  ResultItem: PResult;
  ResultCount: Integer;
  I: Integer;
begin
  Result := nil;
  Data := nil; // to avoid warning

  LoadLibrary;

  if Formats = [] then
    Exit;

{$ifdef MSWINDOWS}
  ArithmeticMask := SetArithmeticMask;
  try
{$endif MSWINDOWS}

    Data := PictureData(Bitmap, Rect);
    if Data <> nil then
    begin
      Image.Data := Data;
      Image.Width := Rect.Right - Rect.Left;
      Image.Height := Rect.Bottom - Rect.Top;

      Hints.Formats := EncodeFormats(Formats);
      Hints.TryHarder := ToInteger(TryHarder);
      Hints.TryRotate := ToInteger(TryRotate);
      Hints.TryInvert := ToInteger(TryInvert);
      Hints.TryDownscale := ToInteger(TryDownscale);
      Hints.Binarizer := Ord(Binarizer);
      Hints.IsPure := ToInteger(PureBarcode);
      Hints.MinLineCount := MinLineCount;
      Hints.MaxNumberOfSymbols := MaxBarcodeCount;
      Hints.CharacterSet := PAnsiChar(AnsiString(FCharacterSet));
      Hints.TryCode39ExtendedMode := ToInteger(TryCode39ExtendedMode);
      Hints.ValidateCode39CheckSum := ToInteger(ValidateCode39);
      Hints.ValidateITFCheckSum := ToInteger(ValidateITF);
      Hints.ReturnCodabarStartEnd := ToInteger(ReturnCodabarStartEnd);
      Hints.ReturnErrors := ToInteger(ReturnErrors);
      Hints.EanAddOnSymbol := Ord(EanAddOn);
      Hints.TextMode := EncodeTextMode(TextMode);

      Results := ZXingReadBarcode(Image, Hints, ResultCount);
      try
        SetLength(Result, ResultCount);
        ResultItem := Results;
        for I := 0 to ResultCount - 1 do
        begin
          Result[I].ErrorType := TErrorType(ResultItem.ErrorType);

          if ResultItem.ErrorMessage <> nil then
          begin
            SetLength(Result[I].ErrorMessage, ResultItem.ErrorMessageSize);
            Move(ResultItem.ErrorMessage^, Result[I].ErrorMessage[1], ResultItem.ErrorMessageSize);
          end;

          Result[I].Format := DecodeFormat(ResultItem.Format);
          Result[I].FormatName := FormatName(Result[I].Format);

          if ResultItem.Bytes <> nil then
          begin
            SetLength(Result[I].Data, ResultItem.BytesSize);
            Move(ResultItem.Bytes^, Result[I].Data[0], ResultItem.BytesSize);
          end;

          if ResultItem.Text <> nil then
          begin
            SetLength(Result[I].TextUtf8, ResultItem.TextSize);
            Move(ResultItem.Text^, Result[I].TextUtf8[1], ResultItem.TextSize);

            try
              Result[I].Text := UTF8ToString(Result[I].TextUtf8);
            except
            end;
          end;

          if ResultItem.RenderedText <> nil then
          begin
            SetLength(Result[I].RenderedText, ResultItem.RenderedTextSize);
            Move(ResultItem.RenderedText^, Result[I].RenderedText[1], ResultItem.RenderedTextSize);
          end;

          if ResultItem.EcLevel <> nil then
          begin
            SetLength(Result[I].EccLevelUtf8, ResultItem.EcLevelSize);
            Move(ResultItem.EcLevel^, Result[I].EccLevelUtf8[1], ResultItem.EcLevelSize);

            try
              Result[I].EccLevel := UTF8ToString(Result[I].EccLevelUtf8);
            except
            end;
          end;

          Result[I].ContentType := TContentType(ResultItem.ContentType);

          Result[I].HasEci := ToBoolean(ResultItem.HasEci);

          if ResultItem.EciBytes <> nil then
          begin
            SetLength(Result[I].EciData, ResultItem.EciBytesSize);
            Move(ResultItem.EciBytes^, Result[I].EciData[0], ResultItem.EciBytesSize);
          end;

          Result[I].TopLeft.X := ResultItem.TopLeftX + Rect.Left;
          Result[I].TopLeft.Y := ResultItem.TopLeftY + Rect.Top;
          Result[I].TopRight.X := ResultItem.TopRightX + Rect.Left;
          Result[I].TopRight.Y := ResultItem.TopRightY + Rect.Top;
          Result[I].BottomLeft.X := ResultItem.BottomLeftX + Rect.Left;
          Result[I].BottomLeft.Y := ResultItem.BottomLeftY + Rect.Top;
          Result[I].BottomRight.X := ResultItem.BottomRightX + Rect.Left;
          Result[I].BottomRight.Y := ResultItem.BottomRightY + Rect.Top;

          Result[I].LineCount := ResultItem.LineCount;

          if ResultItem.Version <> nil then
          begin
            SetLength(Result[I].Version, ResultItem.VersionSize);
            Move(ResultItem.Version^, Result[I].Version[1], ResultItem.VersionSize);
          end;

          Result[I].Orientation := ResultItem.Orientation;
          Result[I].Mirrored := ToBoolean(ResultItem.IsMirrored);
          Result[I].Inverted := ToBoolean(ResultItem.IsInverted);

          if ResultItem.SymbologyIdentifier <> nil then
          begin
            SetLength(Result[I].SymbologyIdentifier, ResultItem.SymbologyIdentifierSize);
            Move(ResultItem.SymbologyIdentifier^, Result[I].SymbologyIdentifier[1], ResultItem.SymbologyIdentifierSize);
          end;

          Result[I].SequenceSize := ResultItem.SequenceSize;
          Result[I].SequenceIndex := ResultItem.SequenceIndex;

          if ResultItem.SequenceId <> nil then
          begin
            SetLength(Result[I].SequenceId, ResultItem.SequenceIdSize);
            Move(ResultItem.SequenceId^, Result[I].SequenceId[1], ResultItem.SequenceIdSize);
          end;

          Result[I].ReaderInit := ToBoolean(resultItem.ReaderInit);

          Inc(PByte(ResultItem), SizeOf(TResult));
        end;
      finally
        ZXingDeleteResults(ResultCount, Results);
      end;
    end;

{$ifdef MSWINDOWS}
  finally
    RestoreArithmeticMask(ArithmeticMask);
  end;
{$endif MSWINDOWS}
end;

function TBarcodeDecoder.Decode(Bitmap: TBitmap): TDecodeResults;
begin
  Result := Decode(Bitmap, Rect(0, 0, MaxInt, MaxInt));
end;

// TBarcodeEncoder

constructor TBarcodeEncoder.Create;
begin
  inherited Create;
  FBackColor := TAlphaColorRec.White;
  FEccLevel := ecUnused;
  FForeColor := TAlphaColorRec.Black;
  FFormat := foQrCode;
  FMargin := -1;
end;

function TBarcodeEncoder.Encode(Bitmap: TBitmap): TEncodeResult;
var
{$ifdef MSWINDOWS}
  ArithmeticMask: TArithmeticMask;
{$endif MSWINDOWS}
  I, J, Bit: Integer;
  SourcePtr: PByte;
{$ifndef DXE2}
  BitmapData: TBitmapData;
{$endif DXE2}
  TextPtr: Pointer;
{$ifndef MSWINDOWS}
  TextData: TBytes;
{$endif MSWINDOWS}
  Barcode: TBarcode;
begin
  Result.Width := 0;
  Result.Height := 0;
  Result.Data := nil;
  Result.ErrorMessage := '';

  LoadLibrary;

{$ifdef MSWINDOWS}
  ArithmeticMask := SetArithmeticMask;
  try
{$endif MSWINDOWS}

    {$ifdef MSWINDOWS}
    TextPtr := PWideChar(FText); // wchar_t is 16 bit on Windows32/Windows64
    {$else}
    SetLength(TextData, 4 * Length(FText) + 4); // wchar_t is 32 bit on macOS/iOS/Linux
    for I := 0 to Length(FText) - 1 do
      PWord(@TextData[I * 4])^ := PWord(@Text[I + 1])^;
    TextPtr := @TextData[0];
    {$endif MSWINDOWS}

    ZXingWriteBarcode(EncodeFormat(Format), Ord(CharacterSet), Ord(EccLevel) - 1,
      Margin, TextPtr, Width, Height, Barcode);
    try
      Result.Width := Barcode.Width;
      Result.Height := Barcode.Height;

      if Barcode.Data <> nil then
      begin
        SetLength(Result.Data, (Result.Width * Result.Height + 7) div 8);
        Move(Barcode.Data^, Result.Data[0], Length(Result.Data));
      end;

      if Barcode.ErrorMessage <> nil then
      begin
        SetLength(Result.ErrorMessage, Barcode.ErrorMessageSize);
        Move(Barcode.ErrorMessage^, Result.ErrorMessage[1], Barcode.ErrorMessageSize);
      end;
    finally
      ZXingDeleteBarcode(@Barcode);
    end;

{$ifdef MSWINDOWS}
  finally
    RestoreArithmeticMask(ArithmeticMask);
  end;
{$endif MSWINDOWS}

  if Bitmap <> nil then
    if Result.Data = nil then
      Bitmap.SetSize(0, 0)
    else
    begin
      Bitmap.SetSize(Result.Width, Result.Height);

      Bit := 0;
      SourcePtr := @Result.Data[0];

    {$ifndef DXE2}
      {$ifdef DXE6PLUS}
      Bitmap.Map(TMapAccess.Write, BitmapData);
      {$else}
      Bitmap.Map(TMapAccess.maWrite, BitmapData);
      {$endif DXE6PLUS}
      try
    {$endif DXE2}

        for I := 0 to Result.Height - 1 do
          for J := 0 to Result.Width - 1 do
          begin
            if (SourcePtr^ and (1 shl Bit)) <> 0 then
            begin
              {$ifndef DXE2}
                BitmapData.SetPixel(J, I, ForeColor);
              {$else}
                Bitmap.Pixels[J, I] := ForeColor;
              {$endif DXE2}
            end
            else
            begin
              {$ifndef DXE2}
                BitmapData.SetPixel(J, I, BackColor);
              {$else}
                Bitmap.Pixels[J, I] := BackColor;
              {$endif DXE2}
            end;

            Inc(Bit);
            if Bit = 8 then
            begin
              Bit := 0;
              Inc(SourcePtr);
            end;
          end;

    {$ifndef DXE2}
      finally
        Bitmap.Unmap(BitmapData);
      end;
    {$endif DXE2}
    end;
end;

// ZXing-C++ library

function LoadedLibrary: Boolean;
begin
{$ifdef STATIC_LIBRARY}
  Result := True;
{$else}
  Result := ZXingLibrary <> 0;
{$endif STATIC_LIBRARY}
end;

procedure UnloadLibrary;
begin
{$ifndef STATIC_LIBRARY}
  if LoadedLibrary then
  begin
    FreeLibrary(ZXingLibrary);
    ZXingLibrary := 0;
  end;
{$endif STATIC_LIBRARY}
end;

{$ifndef STATIC_LIBRARY}
procedure CheckLoadLibrary(const Name: string; out Handle: HMODULE);
begin
  Handle := SafeLoadLibrary(PChar(Name));
  if Handle = 0 then
    raise EBarcodeError.Create(SysErrorMessage(GetLastError) + ': ' + Name);
end;

function CheckGetProcAddress(const Name: string): Pointer;
var ErrorMessage: string;
begin
  Result := GetProcAddress(ZXingLibrary, PChar(Name));
  if Result = nil then
  begin
    ErrorMessage := SysErrorMessage(GetLastError) + ': ' + Name;
    UnloadLibrary;
    raise EBarcodeError.Create(ErrorMessage);
  end;
end;
{$endif STATIC_LIBRARY}

{$IFDEF TRIAL}
var WasTrial: Boolean;
{$ENDIF TRIAL}

procedure LoadLibrary;
{$ifdef MSWINDOWS}
const DefaultLibraryName = 'zxingcpp.dll';
{$endif MSWINDOWS}

{$ifdef MACOS}
const DefaultLibraryName = 'libzxingcpp.dylib';
{$endif MACOS}

{$ifdef LINUX}
const DefaultLibraryName = 'libzxingcpp.so';
{$endif LINUX}
begin
{$ifndef STATIC_LIBRARY}
  if not LoadedLibrary then
  try
{$endif STATIC_LIBRARY}
    {$IFDEF TRIAL}
    if not WasTrial then
    begin
      // execute in main (UI) thread
      TThread.Queue(nil,
      procedure
      begin
	  WasTrial := True;
        ShowMessage(
          'Barcode Suite for FireMonkey 2.2, Copyright (c) 2022-2023 WINSOFT' + #13#10#13#10 +
          'A trial version of Barcode Suite for FireMonkey started.' + #13#10#13#10 +
          'Please note that trial version is supposed to be used for evaluation only. ' +
          'If you wish to distribute Barcode Suite for FireMonkey as part of your ' +
          'application, you must register from website at https://www.winsoft.sk.' + #13#10#13#10 +
          'Thank you for trialing Barcode Suite for FireMonkey.');
      end);
    end;
    {$ENDIF TRIAL}

{$ifndef STATIC_LIBRARY}
    if ZXingLibraryName = '' then
      ZXingLibraryName := DefaultLibraryName;
    CheckLoadLibrary(ZXingLibraryName, ZXingLibrary);

    ZXingGetVersion := CheckGetProcAddress('GetVersion');
    if ZXingGetVersion(SizeOf(TImage), SizeOf(THints), SizeOf(TResult), SizeOf(TBarcode)) <> $02020000 then
      raise EBarcodeError.Create('Incorrect version of ' + ZXingLibraryName + ' library');

    ZXingReadBarcode := CheckGetProcAddress('ReadBarcode');
    ZXingDeleteResults := CheckGetProcAddress('DeleteResults');
    ZXingWriteBarcode := CheckGetProcAddress('WriteBarcode');
    ZXingDeleteBarcode := CheckGetProcAddress('DeleteBarcode');
  except
    UnloadLibrary;
    raise;
  end;
{$else}
  if ZXingGetVersion(SizeOf(TImage), SizeOf(THints), SizeOf(TResult), SizeOf(TBarcode)) <> $02020000 then
    raise EBarcodeError.Create('Incorrect version of ' + LibZXingCpp + ' library');
{$endif STATIC_LIBRARY}
end;

end.