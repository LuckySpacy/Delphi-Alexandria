unit Objekt.Zaehlerstand;

interface

uses
  System.SysUtils, FMX.Objects, System.UITypes, System.Classes;

type
  TZaehlerstand = class
  private
    fImage: TImage;
    fZaehlerstand: Currency;
    fDatum: TDateTime;
    fId: string;
    fEingelesen: Boolean;
    fEingelesenErfolgreich: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Id: string read fId write fId;
    property Image: TImage read fImage write fImage;
    property Zaehlerstand: Currency read fZaehlerstand write fZaehlerstand;
    property Eingelesen: Boolean read fEingelesen write fEingelesen;
    property EingelesenErfolgreich: Boolean read fEingelesenErfolgreich write fEingelesenErfolgreich;
    property Datum: TDateTime read fDatum write fDatum;
    function ReadingImage: Boolean;
    procedure LoadBitmapFromStream(aStream: TMemoryStream);
    procedure ClearImage;
    procedure CreateImage;
    procedure SaveImageToStream(aStream: TMemoryStream);
    procedure Copy(aZaehlerstand: TZaehlerstand);
  end;

implementation

{ TZaehlerstand }

uses
  Objekt.JBasCloud, Objekt.BasCloud, fmx.Types;




constructor TZaehlerstand.Create;
begin
  fImage := nil;
  Init;
end;


destructor TZaehlerstand.Destroy;
begin
  ClearImage;
  inherited;
end;


procedure TZaehlerstand.Init;
begin
  fZaehlerstand := -1;
  fDatum        := 0;
  fId           := '';
  fEingelesen   := false;
  fEingelesenErfolgreich := false;
end;

procedure TZaehlerstand.ClearImage;
begin
  if fImage <> nil then
    FreeAndNil(fImage);
end;

procedure TZaehlerstand.CreateImage;
begin
  ClearImage;
  fImage := TImage.Create(nil);
end;



procedure TZaehlerstand.LoadBitmapFromStream(aStream: TMemoryStream);
begin
  try
    if fImage <> nil then
      FreeAndNil(fImage);
    fImage := TImage.Create(nil);
    aStream.Position := 0;
    if aStream.Size > BasCloud.ImageMinSize then
      fImage.Bitmap.LoadFromStream(aStream);
    //fImage.Bitmap.SaveToFile('c:\temp\DBTest\TZaehlerstandLoadBitmapFromStream.bmp');
    aStream.Position := 0;
  except
    on E: Exception do
    begin
      log.d('TZaehlerstand.LoadBitmapFromStream: ' + E.Message);
    end;
  end;
end;

function TZaehlerstand.ReadingImage: Boolean;
var
  ms : TMemoryStream;
begin
  Result := true;
  try
    ClearImage;
    fImage := TImage.Create(nil);
    fImage.Bitmap.Clear(TalphaColors.White);
    if not fEingelesenErfolgreich then
      exit;
    ms := TMemoryStream.Create;
    try
      if not JBasCloud.ReadingImages(fId, 'image/jpeg', TStream(ms)) then
        exit;
      ms.Position := 0;
      try
        if ms.Size > BasCloud.ImageMinSize then
          fImage.Bitmap.LoadFromStream(ms);
        ms.Position := 0;
      except
        Result := false;
      end;
    finally
      FreeAndNil(ms);
    end;
  except
    on E: Exception do
    begin
      log.d('TZaehlerstand.ReadingImage:' + E.Message)
    end;
  end;
end;



procedure TZaehlerstand.SaveImageToStream(aStream: TMemoryStream);
begin
  aStream.Clear;
  aStream.Position := 0;
  if fImage = nil then
    exit;
  //if fImage.Bitmap.IsEmpty then
  //  exit; 20.06.2022 Habe ich entfernt, verstehe ich im moment nicht.
  try
    fImage.Bitmap.SaveToStream(aStream);
  except
  end;
  aStream.Position := 0;
end;

procedure TZaehlerstand.Copy(aZaehlerstand: TZaehlerstand);
var
///  Zaehlerstand: TZaehlerstand;
  ms : TMemoryStream;
begin
  try
    aZaehlerstand.Zaehlerstand          := fZaehlerstand;
    aZaehlerstand.Eingelesen            := fEingelesen;
    aZaehlerstand.EingelesenErfolgreich := fEingelesenErfolgreich;
    aZaehlerstand.Datum                 := fDatum;
    aZaehlerstand.Id                    := fId;

    aZaehlerstand.ClearImage;
    if fImage <> nil  then
    begin
      ms := TMemoryStream.Create;
      try
        fImage.Bitmap.SaveToStream(ms);
        ms.Position := 0;
        if (ms.Size > BasCloud.ImageMinSize) then
        begin
          aZaehlerstand.CreateImage;
          aZaehlerstand.Image.Bitmap.LoadFromStream(ms);
        end;
      finally
        FreeAndNil(ms);
      end;
    end;
  except
    on E: Exception do
    begin
      log.d('TZaehlerstand.Copy:' + E.Message);
    end;
  end;

end;


end.
