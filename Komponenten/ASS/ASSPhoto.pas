unit ASSPhoto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Media, FMX.Platform, FMX.Graphics,
  System.Permissions, FMX.Objects, FMX.MediaLibrary.Actions;

type
  TAfterFinishTakenEvent = procedure(aBitmap: TBitmap) of object;
  TASSPhoto = class
  private
    fTakePhotoFromCamera: TTakePhotoFromCameraAction;
    fPermissionCamera: string;
    FPermissionReadExternalStorage: string;
    FPermissionWriteExternalStorage: string;
    fCameraImage: TImage;
    fOnAfterFinishTaken: TAfterFinishTakenEvent;
    //procedure MakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    procedure MakePicturePermissionRequestResult2(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    //procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure ExplainReason2(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure TakePhotoFromCameraDidFinishTaking(Image: TBitmap);
   // function BitmapToString(InputBmp: TBitmap; var outString: String): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property CameraImage: TImage read fCameraImage write fCameraImage;
    procedure MakePhoto;
    property OnAfterFinishTaken: TAfterFinishTakenEvent read fOnAfterFinishTaken write fOnAfterFinishTaken;
  end;

implementation

{ TASSPhoto }

uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  Androidapi.JNI.App,
  Androidapi.JNI.Dalvik,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Hardware,
  Androidapi.JNI.InputMethodService,
  Androidapi.JNI.Java.Security,
  Androidapi.JNI.Location,
  Androidapi.JNI.Media,
  Androidapi.JNI.Net,
  Androidapi.JNI.OpenGL,
  Androidapi.JNI.Provider,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Util,
  Androidapi.JNI.VideoView,
  Androidapi.JNI.Webkit,
  Androidapi.JNI.Widget,
  Androidapi.JNI.Support,
  Androidapi.JNI.Embarcadero,
{$ENDIF}
FMX.DialogService;

constructor TASSPhoto.Create;
begin
  fCameraImage := nil;
  fTakePhotoFromCamera := TTakePhotoFromCameraAction.Create(nil);
  fTakePhotoFromCamera.OnDidFinishTaking := TakePhotoFromCameraDidFinishTaking;
 {$IFDEF ANDROID}
   fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
   FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
   FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
 {$ENDIF}
end;

destructor TASSPhoto.Destroy;
begin
  FreeAndNil(fTakePhotoFromCamera);
  inherited;
end;

{
procedure TASSPhoto.ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage
    ('Die App braucht die Genehmigung die Kamera nutzen zu dürfen.',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end);
end;
}


procedure TASSPhoto.ExplainReason2(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage
    ('Die App braucht die Genehmigung die Kamera nutzen zu dürfen.',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end);
end;

{
procedure TASSPhoto.MakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
 if  (Length(AGrantResults) = 3)
 and (AGrantResults[0] = TPermissionStatus.Granted)
 and (AGrantResults[1] = TPermissionStatus.Granted)
 and (AGrantResults[2] = TPermissionStatus.Granted) then
   fTakePhotoFromCamera.Execute
 else
   TDialogService.ShowMessage('Kein Zugriff auf die Kamera gewährt.')
end;
}

procedure TASSPhoto.MakePicturePermissionRequestResult2(Sender: TObject;
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
begin
 if  (Length(AGrantResults) = 3)
 and (AGrantResults[0] = TPermissionStatus.Granted)
 and (AGrantResults[1] = TPermissionStatus.Granted)
 and (AGrantResults[2] = TPermissionStatus.Granted) then
 begin
   fTakePhotoFromCamera.OnDidFinishTaking := TakePhotoFromCameraDidFinishTaking;
   fTakePhotoFromCamera.Execute;
 end
 else
   TDialogService.ShowMessage('Kein Zugriff auf die Kamera gewährt.')
end;

procedure TASSPhoto.TakePhotoFromCameraDidFinishTaking(Image: TBitmap);
begin
  if fCameraImage = nil then
    exit;
  fCameraImage.Bitmap.Assign(Image);
  if Assigned(fOnAfterFinishTaken) then
    fOnAfterFinishTaken(Image);
end;


procedure TASSPhoto.MakePhoto;
begin
//  PermissionsService.RequestPermissions(
//          [FPermissionReadExternalStorage, FPermissionWriteExternalStorage, FPermissionCamera],
//          MakePicturePermissionRequestResult2, ExplainReason);

  PermissionsService.RequestPermissions(
          [FPermissionReadExternalStorage, FPermissionWriteExternalStorage, FPermissionCamera],
          MakePicturePermissionRequestResult2, ExplainReason2);
//  PermissionsService.RequestPermissions([FPermissionReadExternalStorage, FPermissionWriteExternalStorage, FPermissionCamera], MakePicturePermissionRequestResult, ExplainReason);
end;


end.
