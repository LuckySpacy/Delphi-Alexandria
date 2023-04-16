unit ASSQRCodeScanner;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Media, FMX.Platform, FMX.Graphics,
  System.Permissions, ZXing.BarcodeFormat, ZXing.ReadResult, ZXing.ScanManager, FMX.Objects {$IFDEF ios}, fmx.Media.AVFoundation{$ENDIF ios};

type
  TScannedEvent=procedure(aValue: string) of object;
  TBitmapSizeEvent=procedure(aHeight, aWidth: Single) of object;
  TASSBarcodeFormat = (bfAuto, bfAZTEC, bfCODABAR, bfCODE_39, bfCODE_93, bfCODE_128, bfDATA_MATRIX, bfEAN_8, bfEAN_13, bfITF, bfMAXICODE,
                       bfPDF_417, bfQR_CODE, bfRSS_14, bfRSS_EXPANDED, bfUPC_A, bfUPC_E, bfUPC_EAN_EXTENSION, bfMSI, bfPLESSEY);
  TASSQRCodeScanner = class
  private
    FCamera: TCameraComponent;
    fPermissionCamera: String;
    fScanBitmap: TBitmap;
    fScanInProgress: Boolean;
    fCameraImage: TImage;
    fFrameTake: Integer;
    fOnScanned: TScannedEvent;
    fBarcodeFormat: TASSBarcodeFormat;
    fZXingBarcodeFormat: TBarcodeFormat;
    fOnBitmapSize: TBitmapSizeEvent;
    fBitmapSizeTransmitted: Boolean;
    function AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    //procedure CameraPermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    procedure CameraPermissionRequestResult2(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    //procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure ExplainReason2(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure CameraSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    procedure ParseImage();
    procedure setBarcodeFormat(const Value: TASSBarcodeFormat);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property CameraImage: TImage read fCameraImage write fCameraImage;
    property OnScanned: TScannedEvent read fOnScanned write fOnScanned;
    property BarcodeFormat: TASSBarcodeFormat read fBarcodeFormat write setBarcodeFormat default bfAuto;
    property OnBitmapSize: TBitmapSizeEvent read fOnBitmapSize write fOnBitmapSize;
    property Camera: TCameraComponent read FCamera;
    procedure setFlashLight(aOn: Boolean);
  end;


implementation

{ TASSQRCodeScanner }

uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  FMX.DialogService;



constructor TASSQRCodeScanner.Create;
var
  AppEventSvc: IFMXApplicationEventService;
begin
  FCamera := TCameraComponent.Create(nil);
  FCamera.OnSampleBufferReady := CameraSampleBufferReady;
  fScanBitmap := nil;
  fCameraImage := nil;
  fBitmapSizeTransmitted := false;
  fFrameTake := 0;
  fZXingBarcodeFormat := Auto;
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end;
 {$IFDEF ANDROID}
   fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
 {$ENDIF}
end;

destructor TASSQRCodeScanner.Destroy;
begin
  FreeAndNil(fCamera);
  if Assigned(fScanBitmap) then
    FreeAndNil(fScanBitmap);
  inherited;
end;



procedure TASSQRCodeScanner.Start;
begin
   PermissionsService.RequestPermissions([fPermissionCamera],
     CameraPermissionRequestResult2, ExplainReason2);
end;

procedure TASSQRCodeScanner.Stop;
begin
  FCamera.Active := false;
end;

function TASSQRCodeScanner.AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
begin
  Result := true;
  case AAppEvent of
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground,
      TApplicationEvent.WillTerminate:
      FCamera.Active := false;
  end;
end;

{
procedure TASSQRCodeScanner.CameraPermissionRequestResult(Sender: TObject; const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 1) and
    (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    FCamera.Active := false;
    FCamera.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
    FCamera.Kind := FMX.Media.TCameraKind.BackCamera;
    FCamera.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
    FCamera.Active := True;
    //lblScanStatus.Text := '';
    //Memo1.Lines.Clear;
  end
  else
    TDialogService.ShowMessage
      ('Kein Zugriff auf die Kamera gewährt.')

end;
}

procedure TASSQRCodeScanner.CameraPermissionRequestResult2(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  if (Length(AGrantResults) = 1) and
    (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    FCamera.Active := false;
    FCamera.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
    FCamera.Kind := FMX.Media.TCameraKind.BackCamera;
    FCamera.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
    FCamera.Active := True;
    //lblScanStatus.Text := '';
    //Memo1.Lines.Clear;
  end
  else
    TDialogService.ShowMessage
      ('Kein Zugriff auf die Kamera gewährt.')

end;

{
procedure TASSQRCodeScanner.ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage
    ('Die App braucht die Genehmigung die Kamera nutzen zu dürfen.',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;
}

procedure TASSQRCodeScanner.ExplainReason2(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage
    ('Die App braucht die Genehmigung die Kamera nutzen zu dürfen.',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;


procedure TASSQRCodeScanner.ParseImage();
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      ReadResult: TReadResult;
      ScanManager: TScanManager;
    begin
      ScanManager := nil;
      try
        if fScanBitmap = nil then
          exit;
        fScanInProgress := True;
        //ScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
        ScanManager := TScanManager.Create(fZXingBarcodeFormat, nil);
        try
          ReadResult := ScanManager.Scan(fScanBitmap);
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                //lblScanStatus.Text := E.Message;
              end);
            exit;
          end;
        end;
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            {
            if (Length(lblScanStatus.Text) > 10) then
            begin
              lblScanStatus.Text := '*';
            end;
            lblScanStatus.Text := lblScanStatus.Text + '*';
            if (ReadResult <> nil) then
            begin
              Memo1.Lines.Insert(0, ReadResult.Text);
              FCamera.Active := false;
            end;
            }
            if (ReadResult <> nil) and (Trim(ReadResult.Text) > '') then
            begin
              if Assigned(fOnScanned) then
                fOnScanned(ReadResult.Text);
              FCamera.Active := false;
            end;
          end);
      finally
        if ReadResult <> nil then
          FreeAndNil(ReadResult);
        ScanManager.Free;
        fScanInProgress := false;
      end;
    end).Start();
end;



procedure TASSQRCodeScanner.setBarcodeFormat(const Value: TASSBarcodeFormat);
begin
  fBarcodeFormat := Value;
  if Value = bfAuto then
    fZXingBarcodeFormat := Auto;
  if Value = bfAZTEC then
    fZXingBarcodeFormat := AZTEC;
  if Value = bfCODABAR then
    fZXingBarcodeFormat := CODABAR;
  if Value = bfCODE_39 then
    fZXingBarcodeFormat := CODE_39;
  if Value = bfCODE_93 then
    fZXingBarcodeFormat := CODE_93;
  if Value = bfCODE_128 then
    fZXingBarcodeFormat := CODE_128;
  if Value = bfDATA_MATRIX then
    fZXingBarcodeFormat := DATA_MATRIX;
  if Value = bfEAN_8 then
    fZXingBarcodeFormat := EAN_8;
  if Value = bfEAN_13 then
    fZXingBarcodeFormat := EAN_13;
  if Value = bfITF then
    fZXingBarcodeFormat := ITF;
  if Value = bfMAXICODE then
    fZXingBarcodeFormat := MAXICODE;
  if Value = bfPDF_417 then
    fZXingBarcodeFormat := PDF_417;
  if Value = bfQR_CODE then
    fZXingBarcodeFormat := QR_CODE;
  if Value = bfRSS_14 then
    fZXingBarcodeFormat := RSS_14;
  if Value = bfRSS_EXPANDED then
    fZXingBarcodeFormat := RSS_EXPANDED;
  if Value = bfUPC_A then
    fZXingBarcodeFormat := UPC_A;
  if Value = bfUPC_E then
    fZXingBarcodeFormat := UPC_E;
  if Value = bfUPC_EAN_EXTENSION then
    fZXingBarcodeFormat := UPC_EAN_EXTENSION;
  if Value = bfMSI then
    fZXingBarcodeFormat := MSI;
  if Value = bfPLESSEY then
    fZXingBarcodeFormat := PLESSEY;
end;

procedure TASSQRCodeScanner.setFlashLight(aOn: Boolean);
begin
  if aOn then
    fCamera.TorchMode := TTorchMode.ModeOn
  else
    fCamera.TorchMode := TTorchMode.ModeOff;
end;

procedure TASSQRCodeScanner.CameraSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
begin
  if fCameraImage = nil then
    exit;

  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    FCamera.SampleBufferToBitmap(fCameraImage.Bitmap, True);
    if (fScanInProgress) then
    begin
      exit;
    end;
    { This code will take every 4 frame. }
    inc(fFrameTake);
    if (fFrameTake mod 4 <> 0) then
    begin
      exit;
    end;
    if Assigned(fScanBitmap) then
      FreeAndNil(fScanBitmap);
    fScanBitmap := TBitmap.Create();
    fScanBitmap.Assign(fCameraImage.Bitmap);
    if (not fBitmapSizeTransmitted) and (Assigned(fOnBitmapSize)) then
    begin
      fBitmapSizeTransmitted := true;
      fOnBitmapSize(fScanBitmap.Height, fScanBitmap.Width);
    end;

    ParseImage();
  end);
end;


end.
