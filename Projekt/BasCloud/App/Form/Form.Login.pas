unit Form.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ImgList, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, Thread.Login,
  db.ToDoList;

type
  Tfrm_Login = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    lbl_Login_Mail: TLabel;
    edt_Login_Mail: TEdit;
    lbl_Login_Passwort: TLabel;
    edt_Login_Passwort: TEdit;
    gly_Eye: TGlyph;
    lay_Top: TLayout;
    Image2: TImage;
    Image1: TImage;
    lay_Anmelden: TLayout;
    btn_Anmelden: TCornerButton;
    lbl_PasswortZuruecksetzen: TLabel;
    Ani_Wait: TAniIndicator;
    lbl_Version: TLabel;
    lbl_LoginStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_AnmeldenClick(Sender: TObject);
  private
    fThreadLogin: TThreadLogin;
    fOnLoginSuccess: TNotifyEvent;
    fOnLoginPerQRCode: TNotifyEvent;
    fOnDatenschutzbestimmung: TNotifyEvent;
    fDBToDoList: TDBToDoList;
    procedure LoginSuccess(Sender: TObject);
    procedure LoginFailed(Sender: TObject);
    procedure CornerButtonApplyStyleLookup(Sender: TObject);
    procedure EyeClick(Sender: TObject);
    procedure Einloggen;
  public
    property OnLoginSuccess: TNotifyEvent read fOnLoginSuccess write fOnLoginSuccess;
    property OnLoginPerQRCode: TNotifyEvent read fOnLoginPerQRCode write fOnLoginPerQRCode;
    property OnDatenschutzbestimmung: TNotifyEvent read fOnDatenschutzbestimmung write fOnDatenschutzbestimmung;
    procedure AktivateForm;
    procedure DoLogin;
  end;

var
  frm_Login: Tfrm_Login;

implementation

{$R *.fmx}

{ Tfrm_Login }

uses
  FMX.DialogService, Objekt.BasCloud, Objekt.JBasCloud, Datenmodul.Style, DB.ZaehlerUpdateList,
  Json.CurrentUser;



procedure Tfrm_Login.FormCreate(Sender: TObject);
var
  i1: Integer;
begin
  inherited;
  log.d('Tfrm_Login.FormCreate');
  lbl_PasswortZuruecksetzen.TextSettings.FontColor :=  TAlphaColors.Dodgerblue;
  lbl_LoginStatus.Visible := false;
  lbl_loginstatus.Text := 'Datenschutzbestimmung';
  lbl_LoginStatus.Visible := true;
  edt_Login_Mail.Text := BasCloud.Ini.LoginMail;
  edt_Login_Passwort.Text := BasCloud.Ini.LoginPasswort;
  fThreadLogin := TThreadLogin.Create;
  fThreadLogin.OnLoginSuccess := LoginSuccess;
  fThreadLogin.OnLoginFailed  := LoginFailed;

  fDBToDoList := TDBToDoList.Create;


  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TLabel then
      TLabel(Components[i1]).TextSettings.FontColor := BasCloud.Style.LabelColor;
    if Components[i1] is TCornerButton then
    begin
      TCornerButton(Components[i1]).OnApplyStyleLookup := CornerButtonApplyStyleLookup;
      BasCloud.Style.setCornerButtonDefaultTextColor(TCornerButton(Components[i1]));
    end;
  end;

  lbl_Version.Text := 'Version ' + BasCloud.Plattform.Version;

  lbl_PasswortZuruecksetzen.TextSettings.FontColor :=  TAlphaColors.Dodgerblue;

  gly_Eye.HitTest := true;
  gly_Eye.ImageIndex := 11;
  gly_Eye.OnClick := EyeClick;

  //lbl_PasswortZuruecksetzen.Text := ${versionMajor} + '.' + ${versionMinor} + '.' + ${versionPatch}';

end;

procedure Tfrm_Login.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fThreadLogin);
  FreeAndNil(fDBToDoList);
end;



procedure Tfrm_Login.FormShow(Sender: TObject);
var
  i1: Integer;
begin
  inherited;
  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TCornerButton then
      BasCloud.Style.setCornerButtonDefaultTextColor(TCornerButton(Components[i1]));
  end;
end;

procedure Tfrm_Login.AktivateForm;
begin
  lbl_loginstatus.Text := 'Datenschutzbestimmung';
  lbl_LoginStatus.Visible := true;
  lbl_Version.Visible := true;
end;

procedure Tfrm_Login.btn_AnmeldenClick(Sender: TObject);
begin
  Einloggen;
end;

procedure Tfrm_Login.CornerButtonApplyStyleLookup(Sender: TObject);
begin
  BasCloud.Style.setCornerButtonDefaultStyle(TCornerButton(Sender));
end;

procedure Tfrm_Login.DoLogin;
begin
  Einloggen;
end;

procedure Tfrm_Login.Einloggen;
begin
  if (Trim(edt_Login_Mail.Text) = '')
  or (Trim(edt_Login_Passwort.Text) = '') then
  begin
    TDialogService.ShowMessage('Bitte die Zugangsdaten eingeben.');
    exit;
  end;

  if not BasCloud.Plattform.InternetEnabled then
  begin
    if fDBToDoList.Count = 0 then
    begin
      TDialogService.ShowMessage('Sie können sich nicht anmelden.' +  sLineBreak + 'Zur Zeit besteht keine Internetverbindung');
      exit;
    end;
  end;

  btn_Anmelden.Visible := false;
  Ani_Wait.Visible := true;
  Ani_Wait.Enabled := true;
  lbl_PasswortZuruecksetzen.Visible := false;
  lbl_Version.Visible := false;

    {
  if Trim(edt_Login_Mail.Text) = '' then
    edt_Login_Mail.Text     := 'bachmann@ass-systemhaus.de';
  if Trim(edt_Login_Passwort.Text) = '' then
    edt_Login_Passwort.Text := 'd4eKEFNsFA3y';



  //{Sascha's Daten

  if Trim(edt_Login_Mail.Text) = '' then
    edt_Login_Mail.Text     := 'tigra330@gmx.de';
  if Trim(edt_Login_Passwort.Text) = '' then
    edt_Login_Passwort.Text := 'maup8pleh6dek_DRIM';
    }

  if BasCloud.Plattform.InternetEnabled then
  begin
    lbl_LoginStatus.Text := 'Sende Loggindaten';
    fThreadLogin.Login(edt_Login_Mail.Text, edt_Login_Passwort.Text);
  end
  else
    LoginSuccess(nil);

end;

procedure Tfrm_Login.EyeClick(Sender: TObject);
begin
  edt_Login_Passwort.Password := not edt_Login_Passwort.Password;
  if edt_Login_Passwort.Password then
    gly_Eye.ImageIndex := 11
  else
    gly_Eye.ImageIndex := 10;
end;


procedure Tfrm_Login.LoginSuccess(Sender: TObject);
var
//  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  JCurrentUser: TJCurrentUser;
begin
  BasCloud.Log('Start --> Tfrm_Login.LoginSuccess');

  if not SameText(edt_Login_Mail.Text, BasCloud.Ini.LoginMail) then
    fDBToDoList.DeleteAll;

  BasCloud.Ini.LoginMail     := edt_Login_Mail.Text;
  BasCloud.Ini.LoginPasswort := edt_Login_Passwort.Text;
  BasCloud.Ini.LetzteAnmeldung := DateToStr(now);

  try
    try
      JCurrentUser := JBasCloud.Read_CurrentUser;
       if JBascloud.ErrorList.Count = 0 then
         BasCloud.Ini.LoginUserId := JCurrentUser.data.id;
    except

    end;
  finally
    if JCurrentUser <> nil then
      FreeAndNil(JCurrentUser);
  end;


  btn_Anmelden.Visible := true;
  lbl_PasswortZuruecksetzen.Visible := true;
  Ani_Wait.Enabled := false;
  Ani_Wait.Visible := false;

  if Assigned(fOnLoginSuccess) then
    fOnLoginSuccess(Self);

  BasCloud.Log('Ende --> Tfrm_Login.LoginSuccess');
end;


procedure Tfrm_Login.LoginFailed(Sender: TObject);
begin
  BasCloud.Log('Start --> Tfrm_Login.LoginFailed');
  btn_Anmelden.Visible := true;
  lbl_PasswortZuruecksetzen.Visible := true;
  lbl_Version.Visible := true;
  Ani_Wait.Enabled := false;
  Ani_Wait.Visible := false;

  if (JBasCloud.ErrorList.Count > 0) and (SameText(JBasCloud.ErrorList.Item[0].title, 'Unauthorized')) then
  begin
    TDialogService.ShowMessage('E-Mail oder Passwort ist falsch');
  end
  else
  begin
    if JBasCloud.ErrorList.Count > 0 then
      TDialogService.ShowMessage(JBasCloud.ErrorList.Item[0].Title);
    TDialogService.ShowMessage('Login fehlgeschlagen');
  end;

  BasCloud.Log('Ende --> Tfrm_Login.LoginFailed');
end;

end.
