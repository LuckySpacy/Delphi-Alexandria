unit Objekt.BasCloudPlattform;

interface

uses
  System.SysUtils
  , ASSConnectivity
  ;

type
  TBasCloudPlattform = class
  private
    fASSConnectivity: TASSConnectivity;
  public
    constructor Create;
    destructor Destroy; override;
    function Version: string;
    function WifiEnabled: Boolean;
    function InternetEnabled: Boolean;
    property Connectivity: TASSConnectivity read fASSConnectivity;

  end;

implementation

{ TBasCloudPlattform }

uses
  FMX.DialogService
  {$IFDEF ANDROID}
  ,Androidapi.Jni.GraphicsContentViewText, Androidapi.Helpers, AndroidApi.JNI.JavaTypes,
  FMX.Platform.Android, Androidapi.JNI.Net, FMX.Helpers.Android, Androidapi.JNI.Net.Wifi, Androidapi.JNIBridge
  {$ENDIF ANDROID}
  {$IFDEF iOS}
  ,iOSapi.Foundation, Macapi.ObjectiveC, Macapi.Helpers
  ,Posix.Base, Posix.NetIf, Macapi.ObjCRuntime
  {$ENDIF iOS}
  ;

(*
{$IFDEF iOS}
const
  cWifiInterfaceName = 'awdl0';

  function getifaddrs(var ifap: pifaddrs): Integer; cdecl; external libc name _PU + 'getifaddrs';
  procedure freeifaddrs(ifap: pifaddrs); cdecl; external libc name _PU + 'freeifaddrs';

  function StrToNSStringPtr(const AValue: string): Pointer;
  begin
    Result := (StrToNSStr(AValue) as ILocalObject).GetObjectID;
  end;
{$ENDIF iOS}
*)

constructor TBasCloudPlattform.Create;
begin
  fASSConnectivity := nil;
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  fASSConnectivity := TASSConnectivity.Create;
  {$ENDIF}
end;

destructor TBasCloudPlattform.Destroy;
begin
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  FreeAndNil(fASSConnectivity);
  {$ENDIF}
  inherited;
end;




{$IFDEF ANDROID}
function TBasCloudPlattform.Version: string;
var
  PackageManager: JPackageManager;
  PackageInfo: JPackageInfo;
begin
  //PackageManager := SharedActivityContext.getPackageManager;
  //PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName, 0);
  PackageManager := TAndroidHelper.Context.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName, 0);
  Result := JStringToString(PackageInfo.versionName);
end;
{$ENDIF ANDROID}

{$IFDEF iOS}
function TBasCloudPlattform.Version: string;
var
   AppKey: Pointer;
   AppBundle: NSBundle;
   BuildStr : NSString;
begin
   //AppKey := (NSSTR('CFBundleVersion') as ILocalObject).GetObjectID;
   AppKey := (StrToNSStr('CFBundleVersion') as ILocalObject).GetObjectID;
   AppBundle := TNSBundle.Wrap(TNSBundle.OCClass.mainBundle);
   BuildStr := TNSString.Wrap(AppBundle.infoDictionary.objectForKey(AppKey));
   Result := UTF8ToString(BuildStr.UTF8String);
end;

{$ENDIF iOS}

{$IF Defined(WIN32) or Defined(WIN64)}
function TBasCloudPlattform.Version: string;
begin
  Result := '';
end;
{$IFEND}

(*
{$IF Defined(WIN32) or Defined(WIN64)}
function TBasCloudPlattform.WifiEnabled: Boolean;
begin
  Result := true;
end;
{$IFEND}



{$IFDEF ANDROID}
function TBasCloudPlattform.WifiEnabled: Boolean;
var
  WifiManagerObj: JObject;
  WifiManager: JWifiManager;
  WifiInfo: JWifiInfo;
begin
  //WifiManagerObj := SharedActivityContext.getSystemService(TJContext.JavaClass.WIFI_SERVICE);
  WifiManagerObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.WIFI_SERVICE);
  WifiManager := TJWifiManager.Wrap((WifiManagerObj as ILocalObject).GetObjectID);
  WifiInfo := WifiManager.getConnectionInfo();
  Result := WifiManager.isWifiEnabled;
end;
{$ENDIF ANDROID}


{$IFDEF iOS}
function TBasCloudPlattform.WifiEnabled: Boolean;
var
  LAddrList, LAddrInfo: pifaddrs;
  LSet: NSCountedSet;
begin
  Result := false;
  if getifaddrs(LAddrList) = 0 then
  try
    LSet := TNSCountedSet.Create;
    LAddrInfo := LAddrList;
    repeat
      if (LAddrInfo.ifa_flags and IFF_UP) = IFF_UP then
        LSet.addObject(TNSString.OCClass.stringWithUTF8String(LAddrInfo.ifa_name));
      LAddrInfo := LAddrInfo^.ifa_next;
    until LAddrInfo = nil;
    //Result := LSet.countForObject(StrToNSStringPtr(cWifiInterfaceName))&gt; 1;
    Result := LSet.countForObject(StrToNSStringPtr(cWifiInterfaceName)) = 2;
  finally
    freeifaddrs(LAddrList);
  end;
end;


function TBasCloudPlattform.WifiEnabled2: Integer;
var
  LAddrList, LAddrInfo: pifaddrs;
  LSet: NSCountedSet;
begin
  Result := -999;
  if getifaddrs(LAddrList) = 0 then
  try
    LSet := TNSCountedSet.Create;
    LAddrInfo := LAddrList;
    repeat
      if (LAddrInfo.ifa_flags and IFF_UP) = IFF_UP then
        LSet.addObject(TNSString.OCClass.stringWithUTF8String(LAddrInfo.ifa_name));
      LAddrInfo := LAddrInfo^.ifa_next;
    until LAddrInfo = nil;
    Result := LSet.countForObject(StrToNSStringPtr(cWifiInterfaceName));
  finally
    freeifaddrs(LAddrList);
  end;
end;


{$ENDIF iOS}

  *)


function TBasCloudPlattform.WifiEnabled: Boolean;
begin
  {$HINTS OFF}
  Result := false;
 // {$HINTS ON}
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
   Result := true;
  {$ENDIF}
  if fASSConnectivity = nil then
    exit;
  Result := fASSConnectivity.WifiInternetConnection;
end;

function TBasCloudPlattform.InternetEnabled: Boolean;
begin
  Result := false;
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
   Result := true;
  {$ENDIF}
  if fASSConnectivity = nil then
    exit;
  Result := fASSConnectivity.ConnectedToInternet;
end;




end.
