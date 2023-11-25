unit Form.BarcodeScannerTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, ASSQRCodeScanner,
  Objekt.ScannerView, FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation;

type
  TForm3 = class(TForm)
    Lay_Image: TLayout;
    Ani_Wait: TAniIndicator;
    Layout1: TLayout;
    btn_Scanner: TButton;
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
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  FMX.DialogService;


procedure TForm3.FormCreate(Sender: TObject);
begin
  fScanner := TASSQRCodeScanner.Create;
  fScanner.OnBitmapSize := NewBitmapSize;
  fScanner.OnScanned := Scanned;
  fScanner.BarcodeFormat := bfEAN_13;
  //fScanner.BarcodeFormat := bfQR_CODE;
  fScannerView := TScannerView.Create(Lay_Image);
  fScannerView.LineColor := TAlphaColor($FF005686);
  fScannerView.LineColor := TAlphacolors.Blue;
  fScannerView.ScannerHeight := 400;
  fScannerView.ScannerWidth  := 300;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScanner);
  FreeAndNil(fScannerView);
end;

procedure TForm3.NewBitmapSize(aHeight, aWidth: Single);
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

procedure TForm3.Scanned(aValue: string);
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


procedure TForm3.StartScanner;
//var
//  List: TStringList;
begin
    {
  List := TStringList.Create;
  List.LoadFromFile('c:\Users\tbachmann.GB\AppData\Roaming\Documents\token_StefanSchaffner.txt');
  //List.LoadFromFile('c:\Users\tbachmann.GB\AppData\Roaming\Documents\token_bachmann.txt');
  Scanned(Trim(List.Text));
  FreeAndNil(List);
  exit;
  }
  fScanner.CameraImage := fScannerView.Image;
  fScanner.Start;
  fScannerView.Aktual;
end;

procedure TForm3.btn_ScannerClick(Sender: TObject);
begin
  StartScanner;
end;



end.
