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

{ TThreadLogin }

uses
  Objekt.JFPZ, Json.User, Objekt.FPZ, Objekt.Error, Objekt.ErrorList;

constructor TThreadLogin.Create;
begin

end;

destructor TThreadLogin.Destroy;
begin

  inherited;
end;

procedure TThreadLogin.EndLogin(Sender: TObject);
begin
  if (JFPZ.ErrorList.Count > 0) and (Assigned(fOnLoginFailed)) then
    fOnLoginFailed(Self);
  if (JFPZ.ErrorList.Count = 0) and (Assigned(fOnLoginSuccess)) then
  begin
    fOnLoginSuccess(Self);
  end;
end;

procedure TThreadLogin.Login(aEMail, aPassword: String);
var
  t: TThread;
  s: string;
  JUser: TJUser;
begin

  t := TThread.CreateAnonymousThread(
  procedure
  var
    Error: TError;
  begin
    fpz.User.Init;
    s := JFPZ.Login(aEMail, aPassword);
    if JFPZ.ErrorList.Count = 0 then
    begin
      try
        JUser :=  TJUser.FromJsonString(s);
        fpz.User.Vorname  := JUser.Vorname;
        fpz.User.Nachname := JUser.Nachname;
        fpz.User.MaId     := StrToInt(JUser.MaId);
      except
        on E: Exception do
        begin
          Error := JFPZ.ErrorList.Add;
          Error.Title  := s;
          Error.Detail := E.Message;
        end;
      end;
    end;
  end
  );
  t.OnTerminate := EndLogin;
  t.Start;
end;

end.
