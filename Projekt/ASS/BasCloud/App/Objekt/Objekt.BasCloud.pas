unit Objekt.BasCloud;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Objekt.BasCloudStyle, Objekt.BasCloudLog, Objekt.BasCloudIni, Objekt.BasCloudInternetCheck,
  Json.Token, Objekt.GebaudeList, Objekt.ZaehlerList, Objekt.Datum, Objekt.AufgabeList,
  Objekt.BasCloudPlattform, Objekt.TimerIntervalCheck, System.Notification;

type
  TBasCloud = class
  private
    fBasCloudStyle: TBasCloudStyle;
    fLog: TBasCloudLog;
    fIni: TBasCloudIni;
    fInternetCheck: TBasCloudInternetCheck;
    fJToken: TJToken;
    fGebaudeList: TGebaudeList;
    fZaehlerList: TZaehlerList;
    fDatumObj: TDatum;
    fUntilDateForEventsCollectionBackwardsInMonth: Integer;
    fAufgabeList: TAufgabeList;
    fError: string;
    fPlattform: TBasCloudPlattform;
    fBreakUpload: Boolean;
    fOfflineLogin: Boolean;
    fImageMinSize: Integer;
    fAufgabeKarrenztage: Integer;
    fUploadBusy: Boolean;
    fAufgabenListViewAktualisieren: Boolean;
    fTimerIntervalCheck : TTimerIntervalCheck;
    fCloseAPP: Boolean;
    fNotificationC: TNotificationCenter;
    fOnCheckTimer: TNotifyEvent;
    procedure setJToken(const Value: TJToken);
    procedure setError(const Value: string);
    procedure setBreakUpload(const Value: Boolean);
    procedure NotificationPermissionRequestResult(Sender: TObject; const AIsGranted: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property Style: TBasCloudStyle read fBasCloudStyle;
    property Ini: TBasCloudIni read fIni;
    property InternetCheck: TBasCloudInternetCheck read fInternetCheck;
    property Plattform: TBasCloudPlattform read fPlattform write fPlattform;
    procedure Log(const Msg: string);
    property JToken: TJToken read fJToken write setJToken;
    property GebaudeList: TGebaudeList read fGebaudeList;
    property ZaehlerList: TZaehlerList read fZaehlerList;
    property AufgabeList: TAufgabeList read fAufgabeList;
    function UntilDateForEventsCollection: string;
    property DatumObj: TDatum read fDatumObj;
    property Error: string read fError write setError;
    property BreakUpload: Boolean read fBreakUpload write setBreakUpload;
    procedure InitError;
    function getAlphaColor(aColor: Cardinal): TAlphaColor;
    property OfflineLogin: Boolean read fOfflineLogin write fOfflineLogin;
    property ImageMinSize: Integer read fImageMinSize;
    function getExpireDate(aValue: Extended): TDateTime;
    function StringToDate(aValue: string): TDateTime;
    property AufgabeKarrenztage: Integer read fAufgabeKarrenztage write fAufgabeKarrenztage;
    property UploadBusy: Boolean read fUploadBusy write fUploadBusy;
    function CanConnectToBAScloud: Boolean;
    property AufgabenListViewAktualisieren: Boolean read fAufgabenListViewAktualisieren write fAufgabenListViewAktualisieren;
    function CanLoadBAScloudData: Boolean;
    function TimerIntervalCheck: TTimerIntervalCheck;
    procedure sendNotification(aMessage: string);
    property CloseAPP: Boolean read fCloseAPP write fCloseAPP;
    procedure CheckNotificationPermission;
    property OnCheckTimer: TNotifyEvent read fOnCheckTimer write fOnCheckTimer;
    procedure CheckTimer;
  end;

var
  BasCloud : TBasCloud;

implementation

{ TBasCloud }

uses
  DateUtils, FMX.Forms, FMX.DialogService;



constructor TBasCloud.Create;
begin
  fBasCloudStyle := TBasCloudStyle.Create;
  fLog := TBasCloudLog.Create;
  fIni := TBasCloudIni.Create;
  fInternetCheck := TBasCloudInternetCheck.Create;
  fJToken := nil;
  fGebaudeList := TGebaudeList.Create;
  fZaehlerList := TZaehlerList.Create;
  fAufgabeList := TAufgabeList.Create;
  fDatumObj    := TDatum.Create;
  fUntilDateForEventsCollectionBackwardsInMonth := 6;
  fError := '';
  fPlattForm := TBasCloudPlattform.Create;
  fImageMinSize := 100;
  fAufgabeKarrenztage := 3;
  fUploadBusy := false;
  fAufgabenListViewAktualisieren := false;
  fTimerIntervalCheck := TTimerIntervalCheck.Create;
  fCloseAPP := false;
  fNotificationC := TNotificationCenter.Create(nil);
  fNotificationC.OnPermissionRequestResult := NotificationPermissionRequestResult;
end;

destructor TBasCloud.Destroy;
begin
  FreeAndNil(fBasCloudStyle);
  FreeAndNil(fIni);
  FreeAndNil(fLog);
  FreeAndNil(fInternetCheck);
  FreeAndNil(fGebaudeList);
  FreeAndNil(fZaehlerList);
  FreeAndNil(fDatumObj);
  FreeAndNil(fAufgabeList);
  FreeAndNil(fPlattForm);
  if fJToken <> nil then
    FreeAndNil(fJToken);
  FreeAndNil(fTimerIntervalCheck);
  FreeAndNil(fNotificationC);
  inherited;
end;


function TBasCloud.getAlphaColor(aColor: Cardinal): TAlphaColor;
var
  Alpha: TAlphaColor;
begin
  Alpha := TAlphaColor($FF000000);
  Result := Alpha or TAlphaColor(aColor);
end;


procedure TBasCloud.Log(const Msg: string);
begin
  fLog.Log(Msg);
end;


procedure TBasCloud.InitError;
begin
  fError := '';
end;


procedure TBasCloud.setBreakUpload(const Value: Boolean);
begin
  fBreakUpload := Value;
  if fBreakUpload then
   setError('Upload wird abgebrochen');
end;

procedure TBasCloud.setError(const Value: string);
begin
  if fError = '' then
    fError := Value;
end;

procedure TBasCloud.setJToken(const Value: TJToken);
begin
  if fJToken <> nil then
    FreeAndNil(fJToken);
  fJToken := Value;
end;


function TBasCloud.UntilDateForEventsCollection: string;
var
  Datum: TDateTime;
begin
  Datum := IncMonth(now, fUntilDateForEventsCollectionBackwardsInMonth);
  Result := fDatumObj.getTimestampFromDateTime(Datum);
end;


function TBasCloud.getExpireDate(aValue: Extended): TDateTime;
var
  sTokenExpire: string;
  iTokenExpire: Int64;
begin

  if aValue < 1 then
  begin // Kein Ablaufdatum gesetzt.
    Result := trunc(IncYear(now, 100));
    exit;
  end;


  sTokenExpire := FloatToStr(aValue);
  if Length(sTokenExpire) > 10 then
    sTokenExpire := copy(sTokenExpire, 1, 10);

  try
    iTokenExpire := trunc(StrToFloat(sTokenExpire));
  except
    Result := 0;
    exit;
  end;

  try
    Result := System.DateUtils.UnixToDateTime(iTokenExpire, true);
  except
    Result := 0;
  end;

end;

function TBasCloud.StringToDate(aValue: string): TDateTime;
var
  sTag, sMonat, sJahr, sStunde, sMinute, sSekunde: string;
  iTag, iMonat, iJahr, iStunde, iMinute, iSekunde: Integer;
begin
  Result := 0;
  sStunde  := '00';
  sMinute  := '00';
  sSekunde := '00';

  if Length(aValue) < 10  then
  begin
    Result := 0;
    exit;
  end;


  sTag   := copy(aValue, 1, 2);
  sMonat := copy(aValue, 4, 2);
  sJahr  := copy(aValue, 7, 4);
  if Length(aValue) = 19 then
  begin
    sStunde  := copy(aValue, 12, 2);
    sMinute  := copy(aValue, 15, 2);
    sSekunde  := copy(aValue, 18, 2);
  end;

  if not TryStrToInt(sTag, iTag) then
    exit;
  if not TryStrToInt(sMonat, iMonat) then
    exit;
  if not TryStrToInt(sJahr, iJahr) then
    exit;
  if not TryStrToInt(sStunde, iStunde) then
    exit;
  if not TryStrToInt(sMinute, iMinute) then
    exit;
  if not TryStrToInt(sSekunde, iSekunde) then
    exit;

  Result := EncodeDateTime(iJahr, iMonat, iTag, iStunde, iMinute, iSekunde, 0);
end;


function TBasCloud.TimerIntervalCheck: TTimerIntervalCheck;
begin
  Result := fTimerIntervalCheck;
end;

function TBasCloud.CanConnectToBAScloud: Boolean;
begin
  Result := false;

  if (Ini.KonnektivitaetStatus.MobileDaten) and (Plattform.InternetEnabled) then
    Result := true;

  if (not Result) and (BasCloud.Ini.KonnektivitaetStatus.Wifi) and (BasCloud.Plattform.WifiEnabled) then
    Result := true;
end;


function TBasCloud.CanLoadBAScloudData: Boolean;
begin
  Result := false;

  if BasCloud.Ini.KonnektivitaetStatus.Offline then
    exit;

  if not BasCloud.Plattform.InternetEnabled then
    exit;

  if BasCloud.Ini.KonnektivitaetStatus.MobileDaten then
  begin
    Result := true;
    exit;
  end;

  if  (BasCloud.Ini.KonnektivitaetStatus.Wifi)
  and (not BasCloud.Plattform.WifiEnabled) then
      exit;

  Result := true;
end;


procedure TBasCloud.CheckNotificationPermission;
begin
  if fNotificationC.AuthorizationStatus <> TAuthorizationStatus.Authorized then
  begin
    fNotificationC.RequestPermission;
    exit;
  end;
end;


procedure TBasCloud.CheckTimer;
begin
  if Assigned(fOnCheckTimer) then
    fOnCheckTimer(Self);
end;

procedure TBasCloud.sendNotification(aMessage: string);
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
    Notification.Title := 'BAScloud';
    Notification.AlertBody := aMessage;
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    fNotificationC.PresentNotification(Notification);
  finally
    Notification.Free;
  end;
end;

procedure TBasCloud.NotificationPermissionRequestResult(Sender: TObject; const AIsGranted: Boolean);
begin
         {

  if AIsGranted and (FPendingAction <> nil) then
  begin
    FPendingAction.Execute;
  end;

  FPendingAction := nil;
  }
end;



end.
