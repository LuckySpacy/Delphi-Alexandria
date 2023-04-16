unit Thread.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Dialogs;

type
  TThreadLogin = class
  private
    fOnLoginSuccess: TNotifyEvent;
    fOnLoginFailed: TNotifyEvent;
    procedure EndLogin(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Login(aEMail, aPassword: String);
    property OnLoginSuccess: TNotifyEvent read fOnLoginSuccess write fOnLoginSuccess;
    property OnLoginFailed: TNotifyEvent read fOnLoginFailed write fOnLoginFailed;
  end;

implementation


uses
  Objekt.JBasCloud, Objekt.BasCloud, Json.Tenants;


{ TLoginThread }

constructor TThreadLogin.Create;
begin

end;

destructor TThreadLogin.Destroy;
begin

  inherited;
end;

procedure TThreadLogin.EndLogin(Sender: TObject);
var
  JTenants: TJTenants;
begin
  if (BasCloud.JToken = nil) and (JBasCloud.ErrorList.Count > 0) then
  begin
    if JBasCloud.ErrorList.Item[0].title = 'Unauthorized' then
    begin
       //ShowMessage('E-Mail oder Passwort ist falsch');
       if Assigned(fOnLoginFailed) then
         fOnLoginFailed(Self);
       exit;
    end;
    if Assigned(fOnLoginFailed) then
      fOnLoginFailed(Self);
    exit;
  end;
  if not Bascloud.OfflineLogin then
  begin
    JTenants := JBasCloud.Read_Tenants;
    FreeAndNil(JTenants);
  end;
  if Assigned(fOnLoginSuccess) then
    fOnLoginSuccess(Self);
end;


procedure TThreadLogin.Login(aEMail, aPassword: String);
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(
  procedure
  begin
    BasCloud.JToken := JBasCloud.Login(aEMail, aPassword);
  end
  );
  t.OnTerminate := EndLogin;
  t.Start;

end;


end.
