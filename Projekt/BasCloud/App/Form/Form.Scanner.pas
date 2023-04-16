unit Form.Scanner;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, ASSQRCodeScanner, Objekt.ScannerView,
  Objekt.Aufgabe, Objekt.Zaehler, Datenmodul.Style, FMX.ImgList;

type
  TAufgabeScannedEvent=procedure(aAufgabe: TAufgabe) of object;
  TZaehlerScannedEvent=procedure(aZaehler: TZaehler) of object;
  Tfrm_Scanner = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    btn_Scannen: TSpeedButton;
    gly_Return: TGlyph;
    gly_FlashLight: TGlyph;
    Lay_Image: TLayout;
    Ani_Wait: TAniIndicator;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fScanner: TASSQRCodeScanner;
    fScannerView: TScannerView;
    fOnZaehlerScanned: TZaehlerScannedEvent;
    fOnAufgabeScanned: TAufgabeScannedEvent;
    fOnScanned: TScannedEvent;
    fOnZurueck: TNotifyEvent;
    fFlashLight: Boolean;
    fScannedDeviceId: string;
    procedure NewBitmapSize(aHeight, aWidth: Single);
    procedure Scanned(aValue: string);
    procedure btn_FlashLightClick(Sender: TObject);
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    property OnScanned: TScannedEvent read fOnScanned write fOnScanned;
    property OnAufgabeScanned: TAufgabeScannedEvent read fOnAufgabeScanned write fOnAufgabeScanned;
    property OnZaehlerScanned: TZaehlerScannedEvent read fOnZaehlerScanned write fOnZaehlerScanned;
    procedure StartScanner;
  end;

var
  frm_Scanner: Tfrm_Scanner;

implementation

{$R *.fmx}

{ Tfrm_Scanner }

uses
  FMX.DialogService, Objekt.BasCloud, FMX.Media;

procedure Tfrm_Scanner.FormCreate(Sender: TObject);
begin //
  fScanner := TASSQRCodeScanner.Create;
  fScanner.OnBitmapSize := NewBitmapSize;
  fScanner.OnScanned := Scanned;
  fScannerView := TScannerView.Create(lay_Image);
  fScannerView.LineColor := TAlphaColor($FF005686);
  fScannerView.LineColor := TAlphacolors.Blue;
  fScannerView.ScannerHeight := 400;
  fScannerView.ScannerWidth  := 300;

  fFlashLight := false;

  Ani_Wait.Visible := false;
  fScannedDeviceId := '';

  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  gly_FlashLight.HitTest := true;
  gly_FlashLight.OnClick := btn_FlashLightClick;


end;

procedure Tfrm_Scanner.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScanner);
end;

procedure Tfrm_Scanner.StartScanner;
begin
  try
    //Scanned('dd26c760-e6d5-4424-bf4c-dc1ef76f6ba4');
    //Scanned('83a95ed5-61f3-4e15-8989-c4c66987ee1a');
    //Scanned('8f377cf9-fc89-499f-b816-566482dc4f00'); // Dachs 46
    //Scanned('796a5313-a69d-4ec2-9f46-9ca79e579a99'); ASS-002
    //exit;
    fScanner.CameraImage := fScannerView.Image;
    fScanner.Start;
    fScannerView.Aktual;
  except
    on E: Exception do
    begin
      log.d('Tfrm_Scanner.StartScanner Error:' + e.Message);
    end;
  end;
end;

procedure Tfrm_Scanner.NewBitmapSize(aHeight, aWidth: Single);
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


procedure Tfrm_Scanner.Scanned(aValue: string);
var
//  i1: Integer;
//  Device: TDevice;
{$IFDEF WIN32}
  List: TStringList;
{$ENDIF WIN32}
 Aufgabe: TAufgabe;
begin

  fScannedDeviceId := '';
  if Trim(aValue) = '' then
    exit;
  fScanner.Stop;

  {$IFDEF WIN32}
  List := TStringList.Create;
  try
    if DirectoryExists('c:\temp\') then
    begin
      List.Text := aValue;
      List.SaveToFile('c:\temp\Scanned.txt');
    end;
  finally
    FreeAndNil(List);
  end;
 {$ENDIF WIN32}


  Aufgabe := BasCloud.AufgabeList.LastAufgabeFromNow(aValue);
  if (Aufgabe <> nil) and (Assigned(fOnAufgabeScanned)) then
  begin
    Log.d(FormatDateTime('dd.mm.yyyy', Aufgabe.Datum));
    fOnAufgabeScanned(Aufgabe);
    exit;
  end;

  if BasCloud.ZaehlerList.getById(aValue) <> nil then
  begin
     if Assigned(fOnZaehlerScanned) then
       fOnZaehlerScanned(BasCloud.ZaehlerList.getById(aValue));
    exit;
  end;

  TDialogService.ShowMessage('Zähler nicht gefunden');

end;


procedure Tfrm_Scanner.btn_FlashLightClick(Sender: TObject);
begin
  fFlashLight := not fFlashLight;
  fScanner.setFlashLight(fFlashLight);
end;

procedure Tfrm_Scanner.btn_ReturnClick(Sender: TObject);
begin
  fScanner.Stop;
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

end.
