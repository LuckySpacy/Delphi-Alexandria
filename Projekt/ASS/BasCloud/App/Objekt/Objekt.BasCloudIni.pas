unit Objekt.BasCloudIni;

interface

uses
  System.SysUtils, Objekt.Ini, Objekt.Funktionen, Objekt.KonnektivitaetStatus, Objekt.Mitteilungseinstellung;

type
  TBasCloudIni = class
  private
    fIni: TIni;
    fIniPath: string;
    fIniFilename: string;
    fFunktion: TFunktionen;
    fKonnektivitaetStatus: TKonnektivitaetStatus;
    fMitteilungseinstellung: TIniMitteilungseinstellung;
    function getLoginMail: string;
    procedure setLoginMail(const Value: string);
    function getLoginPasswort: string;
    procedure setLoginPasswort(const Value: string);
    function getLetzteAnmeldung: string;
    procedure setLetzteAnmeldung(const Value: string);
    function getLoginToken: string;
    procedure setLoginToken(const Value: string);
    function getLoginExpires: string;
    procedure setLoginExpires(const Value: string);
    procedure ChangedKonnektivitaetStatus(Sender: TObject);
    procedure ReadKonnetivitaetStatus;
    function getLoginUserId: string;
    procedure setLoginUserId(const Value: string);
    function getLoginTenantId: string;
    procedure setLoginTenantId(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property LoginMail: string read getLoginMail write setLoginMail;
    property LoginPasswort: string read getLoginPasswort write setLoginPasswort;
    property LoginUserId: string read getLoginUserId write setLoginUserId;
    property LetzteAnmeldung: string read getLetzteAnmeldung write setLetzteAnmeldung;
    property LoginToken: string read getLoginToken write setLoginToken;
    property LoginExpires: string read getLoginExpires write setLoginExpires;
    property LoginTenantId: string read getLoginTenantId write setLoginTenantId;
    property KonnektivitaetStatus: TKonnektivitaetStatus read fKonnektivitaetStatus write fKonnektivitaetStatus;
    property Mitteilungseinstellung: TIniMitteilungseinstellung read fMitteilungseinstellung write fMitteilungseinstellung;
  end;

implementation

{ TBasCloudIni }


constructor TBasCloudIni.Create;
begin
  fKonnektivitaetStatus := TKonnektivitaetStatus.Create;
  fKonnektivitaetStatus.OnChanged := ChangedKonnektivitaetStatus;
  fIni := TIni.Create;
  fIniPath := GetHomePath + PathDelim + 'Documents' + PathDelim;
  if not DirectoryExists(fIniPath) then
    ForceDirectories(fIniPath);
  fIniFilename := fIniPath  +  'BasCloud.ini';
  fFunktion := TFunktionen.Create;
  ReadKonnetivitaetStatus;

  fMitteilungseinstellung := TIniMitteilungseinstellung.Create;
  fMitteilungseinstellung.Ini := fIni;
  fMitteilungseinstellung.IniPath := fIniPath;
  fMitteilungseinstellung.IniFilename := fIniFilename;

end;

destructor TBasCloudIni.Destroy;
begin
  FreeAndNil(fIni);
  FreeAndNil(fFunktion);
  FreeAndNil(fKonnektivitaetStatus);
  FreeAndNil(fMitteilungseinstellung);
  inherited;
end;

function TBasCloudIni.getLetzteAnmeldung: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'LetzteAnmeldung', '');
end;

function TBasCloudIni.getLoginExpires: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'TokenExpires', '');
end;

function TBasCloudIni.getLoginMail: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'EMail', '');
end;

function TBasCloudIni.getLoginPasswort: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'Password', '');
end;

function TBasCloudIni.getLoginTenantId: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'TenantId', '');
end;

function TBasCloudIni.getLoginToken: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'Token', '');
end;


function TBasCloudIni.getLoginUserId: string;
begin
  Result := fIni.ReadIni(fIniFilename, 'Anmeldung', 'UserId', '');
end;

procedure TBasCloudIni.setLetzteAnmeldung(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'LetzteAnmeldung', Value);
end;

procedure TBasCloudIni.setLoginExpires(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'TokenExpires', Value);
end;

procedure TBasCloudIni.setLoginMail(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'EMail', Value);
end;

procedure TBasCloudIni.setLoginPasswort(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'Password', Value);
end;

procedure TBasCloudIni.setLoginTenantId(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'TenantId', Value);
end;

procedure TBasCloudIni.setLoginToken(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'Token', Value);
end;


procedure TBasCloudIni.setLoginUserId(const Value: string);
begin
  fIni.WriteIni(fIniFilename, 'Anmeldung', 'UserId', Value);
end;

procedure TBasCloudIni.ReadKonnetivitaetStatus;
begin
  if fIni.ReadIni(fIniFilename, 'Optionen', 'WiFiDirect', '0') <> '-1' then
  begin
    fIni.WriteIni(fIniFilename, 'Optionen', 'WiFiDirect', '-1'); // Nicht mehr über diesen Eintrag
    fKonnektivitaetStatus.Wifi := true;
    exit;
  end;
  fKonnektivitaetStatus.MobileDaten := fIni.ReadIni(fIniFilename, 'KonnektivitaetStatus', 'MobileDaten', '0') = '1';
  fKonnektivitaetStatus.Offline     := fIni.ReadIni(fIniFilename, 'KonnektivitaetStatus', 'Offline', '0') = '1';
  fKonnektivitaetStatus.Wifi       := fIni.ReadIni(fIniFilename, 'KonnektivitaetStatus', 'WiFi', '0') = '1';
end;


procedure TBasCloudIni.ChangedKonnektivitaetStatus(Sender: TObject);
begin
  fIni.WriteIni(fIniFilename, 'KonnektivitaetStatus', 'WiFi', fFunktion.BoolToStr(fKonnektivitaetStatus.Wifi));
  fIni.WriteIni(fIniFilename, 'KonnektivitaetStatus', 'Offline', fFunktion.BoolToStr(fKonnektivitaetStatus.Offline));
  fIni.WriteIni(fIniFilename, 'KonnektivitaetStatus', 'MobileDaten', fFunktion.BoolToStr(fKonnektivitaetStatus.MobileDaten));
end;

end.
