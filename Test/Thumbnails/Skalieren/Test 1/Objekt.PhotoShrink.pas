unit Objekt.PhotoShrink;

interface

uses
   System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
   FMX.Objects, System.IOUtils, Fmx.Graphics;

type
  TPhotoShrink = class
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
    procedure Bitmapsize(aFullFilename: string; var aWidth, aHeight: Integer);
    procedure DoIt(aFullFilename, aZielPfad: string; aShrinkValue: Integer);
  end;

implementation

{ TPhotoShrink }

constructor TPhotoShrink.Create;
begin

end;

destructor TPhotoShrink.Destroy;
begin

  inherited;
end;



procedure TPhotoShrink.Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
var
  Faktor: real;
begin
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


end;

procedure TPhotoShrink.Bitmapsize(aFullFilename: string; var aWidth, aHeight: Integer);
var
  Bitmap: TBitmap;
begin
  aWidth := 0;
  aHeight := 0;
  Bitmap := TBitmap.Create;
  try
    if TFile.Exists(aFullFilename) then
    begin
      Bitmap.LoadFromFile(aFullFilename);
      aWidth  := Bitmap.Width;
      aHeight := Bitmap.Height;
    end;
  finally
    FreeAndNil(Bitmap);
  end;
end;


procedure TPhotoShrink.DoIt(aFullFilename, aZielPfad: string; aShrinkValue: Integer);
var
  Filename: string;
  FullFilenameZiel: string;
  iWidth, iHeight: Integer;
  Bitmap : TBitmap;
begin
  Filename := ExtractFileName(aFullFilename);
  FullFilenameZiel := IncludeTrailingPathDelimiter(aZielPfad) + Filename;
  if not TFile.Exists(aFullFilename) then
    exit;
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromFile(aFullFilename);
    iWidth  := Bitmap.Width;
    iHeight := Bitmap.Height;
    Shrink2(aShrinkValue, iWidth, iHeight);
    Bitmap.LoadThumbnailFromFile(aFullFilename, iWidth, iHeight);
    Bitmap.SaveToFile(FullFilenameZiel);
  finally
    FreeAndNil(Bitmap);
  end;
end;



end.
