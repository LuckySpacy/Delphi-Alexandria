unit Objekt.iOsPermission;

interface

uses
  System.Classes, System.SysUtils, iOSapi.AVFoundation, FMX.consts, FMX.Media.AVFoundation;

type
  TPermissionRequestEvent = procedure (ASender: TObject; const AMessage: string; const AAccessGranted: Boolean) of object;
  TiOsPermission = class
  private
    FOnPermissionRequest: TPermissionRequestEvent;
    procedure RecordingRequestAccessForMediaTypeCompletionHandler(granted: Boolean);
    procedure DoPermissionRequest(const AMessage: string; const AAccessGranted: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure doRequestVideoPermission;
    property OnPermissionRequest: TPermissionRequestEvent read FOnPermissionRequest write FOnPermissionRequest;
  end;

implementation

{ TiOsPermission }

constructor TiOsPermission.Create;
begin

end;

destructor TiOsPermission.Destroy;
begin

  inherited;
end;


procedure TiOsPermission.doRequestVideoPermission;
begin
  TAVCaptureDevice.OCClass.requestAccessForMediaType(AVMediaTypeVideo, RecordingRequestAccessForMediaTypeCompletionHandler);
end;

procedure TiOsPermission.RecordingRequestAccessForMediaTypeCompletionHandler(granted: Boolean);
var
  LMessage: string;
begin
  if granted then
    LMessage := string.Empty
  else
    LMessage := SUserRejectedCaptureDevicePermission;

  TThread.Synchronize(nil,
    procedure
    begin
      DoPermissionRequest(LMessage, granted);
    end);
end;


procedure TiOsPermission.DoPermissionRequest(const AMessage: string; const AAccessGranted: Boolean);
begin
  if Assigned(FOnPermissionRequest) then
    FOnPermissionRequest(Self, AMessage, AAccessGranted);
end;


end.
