unit Objekt.JBasCloud;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Graphics,
  Communication.BasCloud, Json.Error, Json.Login, Json.Token, Json.Tenants,
  Json.Properties, Json.Devices, Json.EventsCollection, Json.Readings, Json.ReadingImageUpload,
  Json.PropertyAssociatedDevices, Json.CreateReading, Json.CreatedReading, Json.ResetPassword,
  Json.Device, Json.Reading, Json.CurrentUser, Objekt.ErrorList;

type
  TJBasCloud = class
  protected
  private
    fBasCloudCommunication: TCommunicationBaseCloud;
    fJError: TJError;
    fToken: string;
    fTenantId: string;
    fTokenExpire: TDateTime;
    fEMail: string;
    fPassword: string;
    //procedure Read_Error(aValue: string);
    function GetImageUploadURL(aReadingId: string): TJReadingImageUpload;
    function CheckBevor: Boolean;
    procedure setToken(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Login(aEMail, aPassword: string): TJToken;
    function Read_Tenants: TJTenants;
    function Read_Properties: TJProperties;
    function Read_AllDevices: TJDevices;
    function Read_Device(aDeviceId: string): TJDevice;
    function Read_EventsCollection(aUntil: string): TJEventsCollection;
    function Read_Readings(aDeviceId: string): TJReadings;
    function Read_Reading(aReadingId: string): TJReading;
    function Read_PropertieAssociatedDevices(aPropertieId: string): TPropertyAssociatedDevices;
    function Read_CurrentUser: TJCurrentUser;
    function setEventAsDone(aEventId: string): string;
    function Create_ReadingImages(aReadingId, aContentType: String; aBitmap: TBitmap): Boolean;
    function ReadingImages(aReadingId, aContentType: String; aStream: TStream): Boolean;
    function Create_Reading(aDeviceId: String; aZaehlerstand: Extended; aZaehlerdatum: TDateTime): string;
    property Token: string read fToken write setToken;
    property TokenExpire: TDateTime read fTokenExpire write fTokenExpire;
    property TenantId: string read fTenantId write fTenantId;
    //property JError: TJError read fJError;
    function getErrorString: string;
    function resetPassword(aEmail: string): string;
    function CheckInternet: Boolean;
    property EMail: string read fEMail write fEMail;
    property Password: string read fPassword write fPassword;
    function ErrorList: TErrorList;
  end;

var
  JBasCloud: TJBasCloud;

implementation



uses
  Objekt.BasCloud, DateUtils;

{ TCommunicationBaseCloud }

constructor TJBasCloud.Create;
begin
  fBasCloudCommunication := TCommunicationBaseCloud.Create;
  fJError := nil;
  fToken  := '';
  fTenantId := '';
  fPassword := '';
  fTokenExpire := IncDay(now, -1);
  fEMail    := '';
end;

destructor TJBasCloud.Destroy;
begin
  FreeAndNil(fBasCloudCommunication);
  if fJError <> nil then
    FreeAndNil(fJError);
  inherited;
end;


function TJBasCloud.ErrorList: TErrorList;
begin
  Result := fBasCloudCommunication.BasCloudAPI.ErrorList;
end;


function TJBasCloud.Login(aEMail, aPassword: string): TJToken;
var
  Login: TJLogin;
  s: string;
begin
  Result := nil;
  BasCloud.Error := '';

  Login := TJLogin.Create;
  try
    Login.data.attributes.email    := aEMail;
    Login.data.attributes.password := aPassword;
   Login.data.&type := 'credentials';
    s  := Login.ToJsonString;
  finally
    FreeAndNil(Login);
  end;

  fBasCloudCommunication.BasCloudAPI.Post('login', s);
  if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
  begin
    BasCloud.Error := getErrorString;
    exit;
  end;

  s := fBasCloudCommunication.BasCloudAPI.ReturnValue;

  fEMail := aEMail;
  fPassword := aPassword;
  Result := TJToken.FromJsonString(s);
  setToken(Result.data.attributes.token);
  //fTokenExpire := UnixToDateTime(Result.data.attributes.expires); geht nicht.
  //fTokenExpire := IncHour(now, 12);
  fTokenExpire := BasCloud.getExpireDate(Result.data.attributes.expires);

end;

procedure TJBasCloud.setToken(const Value: string);
begin
  fToken := Value;
  fBasCloudCommunication.Token := fToken;
end;



function TJBasCloud.Read_Tenants: TJTenants;
var
  s: string;
begin
  Result := nil;
  //fBasCloudCommunication.setToken(fToken);
  if (fToken = '') or (now > fTokenExpire) then
  begin
    if (Trim(fEMail) > '') and (Trim(fPassword) > '') then
    begin
      Login(fEMail, fPassword);
      if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
        exit;
    end;
  end;
  try
    fBasCloudCommunication.BasCloudAPI.Get('tenants');
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJTenants.FromJsonString(s);
    fTenantId := Result.data[0].id;
    BasCloud.Ini.LoginTenantId := fTenantId;
    //fBasCloudCommunication.Read_ErrorString(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;

function TJBasCloud.resetPassword(aEmail: string): string;
var
  resetPW: TJresetPassword;
  s: string;
begin
  try
    resetPW := TJresetPassword.Create;
    try
      resetPW.data.&type := 'resetPassword';
      resetPW.data.attributes.email := aEMail;
      s  := resetPW.ToJsonString;
    finally
      FreeAndNil(resetPW);
    end;

    fBasCloudCommunication.BasCloudAPI.Post('resetPassword', s);
    Result := Trim(fBasCloudCommunication.BasCloudAPI.ReturnValue);

    if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
    begin
      Result :=  fBasCloudCommunication.BasCloudAPI.ErrorList.Item[0].status;
      BasCloud.Error := getErrorString;
    end;


    {
    if Result > '' then
    begin
      Read_Error(Result);
      Result :=  ErrorList.Item[0].status;
      BasCloud.Error := getErrorString;
    end;
    }
    Result := Trim(Result);
  except
    on E: Exception do
    begin
      BasCloud.Error := e.Message;
    end;
  end;

end;

function TJBasCloud.setEventAsDone(aEventId: string): string;
var
  Url: string;
  s: string;
begin
  Result := '';
  //exit;
  if not CheckBevor then
    exit;
  try
    Url := 'tenants/' + fTenantId + '/events/' + aEventId + '/done';
    fBasCloudCommunication.MeteringServiceAPI.Post(Url, '');
    s := fBasCloudCommunication.MeteringServiceAPI.ReturnValue;
    fBasCloudCommunication.BasCloudAPI.Read_ErrorString(s);
    //fBasCloudCommunication.Read_Error(s);
    BasCloud.Error := getErrorString;
  except
    on E: Exception do
    begin
      BasCloud.Error := E.Message;
    end;
  end;
end;



function TJBasCloud.Read_Properties: TJProperties;
var
  s: string;
  Url: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    Url := 'tenants/' + fTenantId + '/properties';
    fBasCloudCommunication.BasCloudAPI.Get(url);
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJProperties.FromJsonString(s);
    //Read_Error(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;



function TJBasCloud.CheckInternet: Boolean;
var
  Url: string;
begin
  Result := false;
  if not CheckBevor then
    exit;
  try
    Url := 'tenants/' + fTenantId + '/properties';
    if not fBasCloudCommunication.BasCloudAPI.Get(url) then
      Result := false
    else
      Result := true;
  except
    try
      Result := false
    except
      Result := false
    end;
  end;
end;

function TJBasCloud.Read_AllDevices: TJDevices;
var
  Url: string;
  s: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    url := 'tenants/' + fTenantId + '/devices';
    fBasCloudCommunication.BasCloudAPI.Get(url);
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJDevices.FromJsonString(s);
    //Read_Error(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;



function TJBasCloud.Read_Device(aDeviceId: string): TJDevice;
var
  Url: string;
  s: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    url := 'tenants/' + fTenantId + '/devices/'+ aDeviceId;
    fBasCloudCommunication.BasCloudAPI.Get(url);
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJDevice.FromJsonString(s);
    //Read_Error(s);
    BasCloud.Error := getErrorString;
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;

function TJBasCloud.Read_EventsCollection(aUntil: string): TJEventsCollection;
var
  Url: string;
  s: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    Url := 'tenants/' + fTenantId + '/events?limitPerTask=1&until=' + aUntil ;
    if not fBasCloudCommunication.MeteringServiceAPI.Get(url) then
      exit;
    s := fBasCloudCommunication.MeteringServiceAPI.ReturnValue;
    Result := TJEventsCollection.FromJsonString(s);
    fBasCloudCommunication.BasCloudAPI.Read_ErrorString(s);
    BasCloud.Error := getErrorString;
  except
    on E: Exception do
    begin
      try
        if Result <> nil then
          FreeAndNil(Result);
        BasCloud.Error := E.Message;
      except
        on E: Exception do
        begin
          Result := nil;
          BasCloud.Error := E.Message;
        end;
      end;
    end;
  end;
end;

function TJBasCloud.Read_Reading(aReadingId: string): TJReading;
var
  s: string;
  Url: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    Url := '/tenants/'+ fTenantId + '/readings/' + aReadingId;
    if not fBasCloudCommunication.BasCloudAPI.Get(Url) then
      exit;
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    fBasCloudCommunication.BasCloudAPI.Read_ErrorString(s);
    Result := TJReading.FromJsonString(s);
    //Read_Error(s);
    BasCloud.Error := getErrorString;
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;

function TJBasCloud.Read_Readings(aDeviceId: string): TJReadings;
var
  s: string;
  Url: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    Url := '/tenants/'+ fTenantId + '/devices/' + aDeviceId + '/readings?page[size]=1';
    if not fBasCloudCommunication.BasCloudAPI.Get(Url) then
      exit;
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJReadings.FromJsonString(s);
    //Read_Error(s);
    BasCloud.Error := getErrorString;
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;

function TJBasCloud.Read_PropertieAssociatedDevices(aPropertieId: string): TPropertyAssociatedDevices;
var
  Url: string;
  s: string;
begin //
  Result := nil;
  if not CheckBevor then
    exit;
  try
    Url := 'tenants/' + fTenantId + '/properties/' + aPropertieId+ '/devices/';
    if not fBasCloudCommunication.BasCloudAPI.Get(url) then
      exit;
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TPropertyAssociatedDevices.FromJsonString(s);
    //Read_Error(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;


{
procedure TJBasCloud.Read_Error(aValue: string);
begin
  try
    if fJError <> nil then
      FreeAndNil(fJError);

    fJError := TJError.FromJsonString(aValue);
    if (fJError <> nil) and (Length(fJError.errors) > 0) then
      exit;

    //if fJError <> nil then
    //  FreeAndNil(fJError);
  except
  end;
end;
}

function TJBasCloud.getErrorString: string;
begin
  Result := '';
  if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
    Result := fBasCloudCommunication.BasCloudAPI.ErrorList.getErrorString;
end;




function TJBasCloud.GetImageUploadURL(aReadingId: string): TJReadingImageUpload;
var
  Url: string;
  s: string;
begin
  Result := nil;
  if not CheckBevor then
    exit;
  try
    url := aReadingId + '/upload';
    if not fBasCloudCommunication.ImageServiceAPI.GetImageUploadURL(url) then
      exit;
    s := fBasCloudCommunication.ImageServiceAPI.ReturnValue;
    fBasCloudCommunication.BasCloudAPI.Read_ErrorString(s);
    if fBasCloudCommunication.BasCloudAPI.ErrorList.Count = 0 then
      Result := TJReadingImageUpload.FromJsonString(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;


function TJBasCloud.Create_ReadingImages(aReadingId, aContentType: String; aBitmap: TBitmap): Boolean;
var
  s: string;
  Url: string;
  ReadingImageUpload: TJReadingImageUpload;
begin
  Result := false;
  if not CheckBevor then
    exit;
  Result := true;
  try
    ReadingImageUpload := GetImageUploadURL(aReadingId);
    if (ReadingImageUpload = nil) or (ReadingImageUpload.data.attributes.url = '') then
    begin
      BasCloud.Error := getErrorString;
      if BasCloud.Error = '' then
        BasCloud.Error := 'Bilder konnte nicht hochgeladen werden.';
      Result := false;
      exit;
    end;
    try
      Url := ReadingImageUpload.data.attributes.Url;
      fBasCloudCommunication.ImageServiceAPI.Post(Url, aContentType, aBitmap);
      s := fBasCloudCommunication.ImageServiceAPI.ReturnValue;
      fBasCloudCommunication.BasCloudAPI.Read_ErrorString(s);
      //Read_Error(s);
      BasCloud.Error := getErrorString;
    finally
      if ReadingImageUpload <> nil then
        FreeAndNil(ReadingImageUpload);
    end;
  except
    on E: Exception do
    begin
      BasCloud.Error := E.Message;
      Result := false;
    end;
  end;
end;

function TJBasCloud.ReadingImages(aReadingId, aContentType: String; aStream: TStream): Boolean;
var
  Url: string;
begin
  Result := false;
  if not CheckBevor then
    exit;
  Url := aReadingId ;
  Result := fBasCloudCommunication.ImageServiceAPI.Get(Url, aContentType, aStream);
end;


function TJBasCloud.Create_Reading(aDeviceId: String; aZaehlerstand: Extended; aZaehlerdatum: TDateTime): string;
var
  CreateReading: TJCreateReading;
  CreatedReading: TJCreatedReading;
  s: string;
  Url: string;
begin
  Result := '';
  if not CheckBevor then
    exit;
  try
    CreateReading := TJCreateReading.Create;
    try
      CreateReading.data.&type := 'readings';
      CreateReading.data.attributes.value := aZaehlerstand;
      CreateReading.data.attributes.timestamp := BasCloud.DatumObj.getUTCTimestampDatum(aZaehlerdatum);
      CreateReading.data.relationships.device.data.&type := 'devices';
      CreateReading.data.relationships.device.data.id := aDeviceId;
      s := CreateReading.ToJsonString;
      Url := 'tenants/' + fTenantId + '/readings';
      if not fBasCloudCommunication.BasCloudAPI.Post(Url, s) then
        exit;
      s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
      //Read_Error(s);
      //if fJError <> nil then
      if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
      begin
        BasCloud.Error := getErrorString;
        exit;
      end;
      if fJError = nil then
      begin
        CreatedReading := TJCreatedReading.FromJsonString(s);
        if CreatedReading <> nil then
        begin
          Result := CreatedReading.data.id;
          FreeAndNil(CreatedReading)
        end;
      end
    finally
      FreeAndNil(CreateReading);
    end;
  except
    on E: Exception do
    begin
      BasCloud.Error := e.Message;
      Result := '';
    end;
  end;
end;


function TJBasCloud.CheckBevor: Boolean;
begin
  Result := false;
  if fTenantId = '' then
    Read_Tenants;
  if fTenantId = '' then
    exit;
  if (fToken = '') or (now > fTokenExpire) then
    Login(fEMail, fPassword);
  if (fToken = '') or (now > fTokenExpire) then
    exit;
  Result := true;
end;


function TJBasCloud.Read_CurrentUser: TJCurrentUser;
var
  s: string;
begin
  Result := nil;
  if (fToken = '') or (now > fTokenExpire) then
  begin
    if (fEMail > '') and (fPassword > '') then
    begin
      Login(fEMail, fPassword);
      if BasCloud.Error > '' then
        exit;
    end;
  end;
  try
    fBasCloudCommunication.BasCloudAPI.Get('users/self');
    if fBasCloudCommunication.BasCloudAPI.ErrorList.Count > 0 then
    begin
      BasCloud.Error := getErrorString;
      exit;
    end;
    s := fBasCloudCommunication.BasCloudAPI.ReturnValue;
    Result := TJCurrentUser.FromJsonString(s);
  except
    try
      if Result <> nil then
        FreeAndNil(Result);
    except
      Result := nil;
    end;
  end;
end;



end.
