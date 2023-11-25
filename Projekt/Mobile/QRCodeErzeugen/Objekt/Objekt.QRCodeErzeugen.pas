unit Objekt.QRCodeErzeugen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  fmx.Graphics, fmx.Types, fmx.Objects;

type
  TQRCodeErzeugen = class
  private
    fData: string;
    fPaintbox: TPaintbox;
    fBitmap: TBitmap;
    fPixelsize: Integer;
    procedure PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DoIt;
    property Data: string read fData write fData;
    property Paintbox: TPaintbox read fPaintbox write fPaintbox;
    property Bitmap: TBitmap read fBitmap;
    property Pixelsize: Integer read fPixelsize write fPixelsize;
  end;

implementation

{ TQRCodeErzeugen }

uses
  DelphiZXingQRCode;


constructor TQRCodeErzeugen.Create;
begin
  fPaintbox := nil;
  fBitmap   := nil;
  fData := 'Hello World!';
  fPixelsize := 10;
end;

destructor TQRCodeErzeugen.Destroy;
begin
  if Assigned(fBitmap) then
    FreeAndNil(fBitmap);
  inherited;
end;


procedure TQRCodeErzeugen.DoIt;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
  PixelColor: TAlphaColor;
  PixelSize: Integer;
begin
  if Assigned(fPaintbox) then
    fPaintbox.OnPaint := nil;
  if Assigned(fBitmap) then
    FreeAndNil(fBitmap);
  fBitmap := TBitmap.Create;
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := fData;
    QRCode.Encoding := TQRCodeEncoding(0);
    QRCode.QuietZone := 0;
    PixelSize := fPixelsize; // Größe des "Pixels"
    fBitmap.SetSize(QRCode.Rows* PixelSize, QRCode.Columns * PixelSize);
    if fPaintbox <> nil then
    begin
      fPaintbox.Width := QRCode.Columns * PixelSize;
      fPaintbox.Height := QRCode.Rows* PixelSize;
    end;

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          PixelColor := TAlphaColors.Black // Wenn true, dann Schwarz
        else
          PixelColor := TAlphaColors.White; // Wenn false, dann Weiß
        fBitmap.Canvas.BeginScene;
        try
          fBitmap.Canvas.Fill.Color := PixelColor;
          fBitmap.Canvas.FillRect(RectF(Column * PixelSize, Row * PixelSize, (Column + 1) * PixelSize, (Row + 1) * PixelSize), 0, 0, AllCorners, 1);
        finally
          fBitmap.Canvas.EndScene;
        end;
      end;
    end;
    //aBitmap.SaveToFile('d:\Eigene Dateien\Downloads\Test.bmp');
  finally
    QRCode.Free;
    if Assigned(fPaintbox) then
      fPaintbox.OnPaint := PaintBoxPaint;
  end;
end;

procedure TQRCodeErzeugen.PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
begin
  if Assigned(fBitmap) then
  begin
    Canvas.Clear(TAlphaColors.White);

    // Draw the TBitmap onto the canvas at the desired position (e.g., (0,0)).
    Canvas.DrawBitmap(fBitmap, RectF(0, 0, fBitmap.Width, fBitmap.Height),
      RectF(0, 0, fPaintBox.Width, fPaintBox.Height), 1);
  end;
end;

end.
