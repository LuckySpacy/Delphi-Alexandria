unit Objekt.Win.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, Objekt.Win.Notification;

type
  TWinPhotoOrga = class
  private
    fNotification: TWinNotification;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Notification: TWinNotification read fNotification;
  end;

implementation

{ TWinPhotoOrga }

constructor TWinPhotoOrga.Create;
begin
  fNotification := TWinNotification.Create;
end;

destructor TWinPhotoOrga.Destroy;
begin
  FreeAndNil(fNotification);
  inherited;
end;

end.
