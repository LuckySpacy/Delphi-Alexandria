unit Objekt.Win.Notification;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, System.Notification;

type
  TWinNotification = class
  private
    fNotificationC: TNotificationCenter;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure sendNotification(aMessage: string);
  end;

implementation

{ TWinNotification }

constructor TWinNotification.Create;
begin
  fNotificationC := TNotificationCenter.Create(nil);
end;

destructor TWinNotification.Destroy;
begin
  FreeAndNil(fNotificationC);
  inherited;
end;

procedure TWinNotification.sendNotification(aMessage: string);
var
  Notification: TNotification;
begin

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
