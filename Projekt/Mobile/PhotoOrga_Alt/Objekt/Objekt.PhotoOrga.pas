unit Objekt.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Notification,
  FireDAC.Comp.Client, Objekt.QueueList, Objekt.BilderList;

type
  TPhotoOrga = class
  private
    fNotificationC: TNotificationCenter;
    fConnection: TFDConnection;
    fQueueList: TQueueList;
    fBilderList: TBilderList;
    fAktBilderList: TList;
    procedure NotificationPermissionRequestResult(Sender: TObject; const AIsGranted: Boolean);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure sendNotification(aMessage: string);
    property Connection: TFDConnection read fConnection write fConnection;
    function QueueList: TQueueList;
    function BilderList: TBilderList;
    property AktBilderList: TList read fAktBilderList write fAktBilderList;
  end;


var
  PhotoOrga: TPhotoOrga;

implementation

{ TPhotoOrga }



constructor TPhotoOrga.Create;
begin
  fNotificationC := TNotificationCenter.Create(nil);
  fNotificationC.OnPermissionRequestResult := NotificationPermissionRequestResult;
  fQueueList := TQueueList.Create;
  fBilderList  := TBilderList.Create;
  fAktBilderList := nil;
end;

destructor TPhotoOrga.Destroy;
begin
  FreeAndNil(fQueueList);
  FreeAndNil(fBilderList);
  FreeAndNil(fNotificationC);
  inherited;
end;



procedure TPhotoOrga.sendNotification(aMessage: string);
var
  Notification: TNotification;
begin
  {$IF Defined(WIN32) or Defined(WIN64)}
  //exit;
  {$IFEND}

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

procedure TPhotoOrga.NotificationPermissionRequestResult(Sender: TObject;
  const AIsGranted: Boolean);
begin

end;

function TPhotoOrga.QueueList: TQueueList;
begin
  Result := fQueueList;
end;

function TPhotoOrga.BilderList: TBilderList;
begin
  Result := fBilderList;
end;


end.
