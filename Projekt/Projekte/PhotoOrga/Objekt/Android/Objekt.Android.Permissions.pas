unit Objekt.Android.Permissions;

interface

uses
  System.Permissions, System.Types;

type
  TAndroidPermission = class
  private
    fOK : Boolean;
    procedure PermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
  public
    procedure Request;
  end;

implementation

{ TAndroidPermission }

uses
   Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os;


procedure TAndroidPermission.PermissionsResult(Sender: TObject;
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
var
  n:integer;
begin
  if length(AGrantResults)>0 then
   for n:=0 to length(AGrantResults)-1 do
    if not (AGrantResults[n] = TPermissionStatus.Granted) then fOK:=false;
end;

procedure TAndroidPermission.Request;
var
  p:Tarray<string>;
begin
  p:=[JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_SETTINGS),
        JStringToString(TJManifest_permission.JavaClass.CAMERA),
        JStringToString(TJManifest_permission.JavaClass.MANAGE_DOCUMENTS)];
   PermissionsService.RequestPermissions(p,PermissionsResult,nil);
end;

end.
