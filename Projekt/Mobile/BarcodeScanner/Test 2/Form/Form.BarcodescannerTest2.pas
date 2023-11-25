unit Form.BarcodescannerTest2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, ASSQRCodeScanner,
  Objekt.ScannerView;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    btn_Scanner: TButton;
    Lay_Image: TLayout;
    Ani_Wait: TAniIndicator;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_ScannerClick(Sender: TObject);
  private
    fScanner : TASSQRCodeScanner;
    fScannerView : TScannerView;
    procedure Scanned(aValue: string);
    procedure NewBitmapSize(aHeight, aWidth: Single);
  public
    procedure StartScanner;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  FMX.DialogService;



procedure TForm2.FormCreate(Sender: TObject);
begin //
  fScanner := TASSQRCodeScanner.Create;
  fScanner.OnBitmapSize := NewBitmapSize;
  fScanner.OnScanned := Scanned;
 // fScanner.BarcodeFormat := bfEAN_13;
  fScanner.BarcodeFormat := bfQR_CODE;
  fScannerView := TScannerView.Create(Lay_Image);
  fScannerView.LineColor := TAlphaColor($FF005686);
  fScannerView.LineColor := TAlphacolors.Blue;
  fScannerView.ScannerHeight := 400;
  fScannerView.ScannerWidth  := 300;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fScanner);
  FreeAndNil(fScannerView);
end;

procedure TForm2.NewBitmapSize(aHeight, aWidth: Single);
var
  Faktor: real;
  NewWidth: single;
begin
  Faktor := aHeight / fScannerView.ScannerHeight;
  NewWidth := aWidth/Faktor;
  fScannerView.ScannerHeight := fScannerView.ScannerHeight;
  fScannerView.ScannerWidth  := NewWidth;
  fScannerView.Aktual;
end;

procedure TForm2.Scanned(aValue: string);
  {$IFDEF WIN32}
var
  List: TStringList;
 {$ENDIF WIN32}
begin

  TDialogService.ShowMessage('QR-Code = ' + aValue);
  {$IFDEF WIN32}
  List := TStringList.Create;
  try
    if DirectoryExists('c:\temp\') then
    begin
      List.Text := aValue;
      List.SaveToFile('c:\temp\LoginScanned.txt');
    end;
  finally
    FreeAndNil(List);
  end;
 {$ENDIF WIN32}

end;

procedure TForm2.StartScanner;
begin
  fScanner.CameraImage := fScannerView.Image;
  fScanner.Start;
  fScannerView.Aktual;
end;

procedure TForm2.btn_ScannerClick(Sender: TObject);
begin
  StartScanner;
end;

end.
