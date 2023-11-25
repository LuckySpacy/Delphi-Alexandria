unit Objekt.Android.Notification;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, System.Notification;

type
  TAndroidNotification = class
  private
    fNotificationC: TNotificationCenter;
    procedure NotificationPermissionRequestResult(Sender: TObject; const AIsGranted: Boolean);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure sendNotification(aMessage: string);
  end;

implementation

{ TAndroidNotification }

constructor TAndroidNotification.Create;
begin
  fNotificationC := TNotificationCenter.Create(nil);
  fNotificationC.OnPermissionRequestResult := NotificationPermissionRequestResult;
end;

destructor TAndroidNotification.Destroy;
begin
  FreeAndNil(fNotificationC);
  inherited;
end;

procedure TAndroidNotification.NotificationPermissionRequestResult(
  Sender: TObject; const AIsGranted: Boolean);
begin

end;

procedure TAndroidNotification.sendNotification(aMessage: string);
var
  Notification: TNotification;
begin
  if fNotificationC.AuthorizationStatus <> TAuthorizationStatus.Authorized then
  begin
    fNotificationC.RequestPermission;
    exit;
  end;


  Notification := fNotificationC.CreateNotification;
  try
    Notification.Title := 'PhotoOrga';
    Notification.AlertBody := aMessage;
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    fNotificationC.PresentNotification(Notification);
  finally
    Notification.Free;
  end;
end;

end.
