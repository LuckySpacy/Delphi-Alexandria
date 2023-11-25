unit Objekt.Android.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Objekt.Android.Permissions, Objekt.Android.Notification;

type
  TAndroidPhotoOrga = class
  private
    fPermissions: TAndroidPermission;
    fNotification: TAndroidNotification;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Permissions: TAndroidPermission read fPermissions;
    property Notification: TAndroidNotification read fNotification;
  end;

implementation

{ TAndroidPhotoOrga }

constructor TAndroidPhotoOrga.Create;
begin
  fPermissions  := TAndroidPermission.Create;
  fNotification := TAndroidNotification.Create;
end;

destructor TAndroidPhotoOrga.Destroy;
begin
  FreeAndNil(fPermissions);
  FreeAndNil(fNotification);
  inherited;
end;


end.
