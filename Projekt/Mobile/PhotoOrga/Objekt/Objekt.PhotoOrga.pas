unit Objekt.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  {$IFDEF ANDROID}
  Objekt.Android.PhotoOrga,
  {$ENDIF ANDROID}
  {$IFDEF WIN32}
  Objekt.Win.PhotoOrga,
  {$ENDIF WIN32}
  FMX.Types, Objekt.QueueList, Objekt.BildList, Objekt.Alben;

type
  TPhotoOrga = class
  private
    {$IFDEF ANDROID}
    fAndroid: TAndroidPhotoOrga;
    {$ENDIF ANDROID}
    {$IFDEF WIN32}
    fWin: TWinPhotoOrga;
    {$ENDIF WIN32}
    fQueueList: TQueueList;
    fBildList: TBildList;
    fAlben: TAlben;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF ANDROID}
    property Android: TAndroidPhotoOrga read fAndroid write fAndroid;
    {$ENDIF ANDROID}
    procedure RequestPermissions;
    procedure sendNotification(aMessage: string);
    property QueueList: TQueueList read fQueueList;
    property BildList: TBildList read fBildList;
    property Alben: TAlben read fAlben;
  end;


var
  PhotoOrga: TPhotoOrga;


implementation

{ TPhotoOrga }


constructor TPhotoOrga.Create;
begin
  {$IFDEF ANDROID}
  fAndroid := TAndroidPhotoOrga.Create;
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  fWin := TWinPhotoOrga.Create;
  {$ENDIF MSWINDOWS}
  fQueueList := TQueueList.Create;
  fBildList  := TBildList.Create;
  fAlben     := TAlben.Create;
end;

destructor TPhotoOrga.Destroy;
begin
  {$IFDEF ANDROID}
  FreeAndNil(fAndroid);
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  FreeAndNil(fWin);
  {$ENDIF MSWINDOWS}
  FreeAndNil(fQueueList);
  FreeAndNil(fBildList);
  FreeAndNil(fAlben);
  inherited;
end;

procedure TPhotoOrga.RequestPermissions;
begin
  {$IFDEF ANDROID}
    fAndroid.Permissions.Request;
  {$ENDIF ANDROID}
end;

procedure TPhotoOrga.sendNotification(aMessage: string);
begin
  {$IFDEF ANDROID}
    fAndroid.Notification.sendNotification(aMessage);
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  fWin.Notification.sendNotification(aMessage);
  {$ENDIF MSWINDOWS}
end;

end.
