unit Form.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, Thread.Login,
  FMX.Layouts, FMX.Objects;

type
  Tfrm_Login = class(TForm)
    btn_Anmelden: TCornerButton;
    Lay_Form: TLayout;
    lay_Form_Passwort: TLayout;
    lay_Form_Benutzer: TLayout;
    Lay_Form_Button: TLayout;
    Ani_Wait: TAniIndicator;
    Lay_Ani_Wait: TLayout;
    edt_Benutzer: TEdit;
    edt_Passwort: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AnmeldenClick(Sender: TObject);
    procedure edt_BenutzerApplyStyleLookup(Sender: TObject);
    procedure edt_PasswortApplyStyleLookup(Sender: TObject);
  private
    fThreadLogin: TThreadLogin;
    fOnLoginNichtErfolgreich: TNotifyEvent;
    fOnLoginErfolgreich: TNotifyEvent;
    fOnServerEinstellung: TNotifyEvent;
    procedure Login;
    procedure LoginErfolgreich(Sender: TObject);
    procedure LoginNichtErfolgreich(Sender: TObject);
    procedure AugeClick(Sender: TObject);
    procedure FrageNachServerEinstellung;
  public
    property OnLoginErfolgreich: TNotifyEvent read fOnLoginErfolgreich write fOnLoginErfolgreich;
    property OnLoginNichtErfolgreich: TNotifyEvent read fOnLoginNichtErfolgreich write fOnLoginNichtErfolgreich;
    property OnServerEinstellung: TNotifyEvent read fOnServerEinstellung write fOnServerEinstellung;
    procedure setActiv;
  end;

var
  frm_Login: Tfrm_Login;

implementation

{$R *.fmx}

uses
  Objekt.FPZ, Objekt.JFPZ, FMX.DialogService, Datenmodul.Bilder;


procedure Tfrm_Login.FormCreate(Sender: TObject);
begin  //
  edt_Benutzer.Text     := FPZ.Ini.LoginMail;
  edt_Passwort.Text := FPZ.Ini.LoginPasswort;
  fThreadLogin := TThreadLogin.Create;
  fThreadLogin.OnLoginSuccess := LoginErfolgreich;
  fThreadLogin.OnLoginFailed  := LoginNichtErfolgreich;
  Ani_Wait.Visible := false;
  Ani_Wait.Enabled := false;
  JFPZ.setBaseUrl(FPZ.Ini.Serveradresse);
end;

procedure Tfrm_Login.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fThreadLogin);
end;

procedure Tfrm_Login.AugeClick(Sender: TObject);
begin
  edt_Passwort.Password := not edt_Passwort.Password;
  edt_Passwort.NeedStyleLookup;
  edt_Passwort.ApplyStyleLookup;
end;

procedure Tfrm_Login.btn_AnmeldenClick(Sender: TObject);
begin
  btn_Anmelden.Visible := false;
  Ani_Wait.Enabled := true;
  Ani_Wait.Visible := true;
  Login;
end;


procedure Tfrm_Login.edt_BenutzerApplyStyleLookup(Sender: TObject);
var
  Obj: Tfmxobject;
begin
  Obj := edt_Benutzer.FindStyleResource('Glyph');
  if (Obj <> nil) and (Obj is TGlyph) then
  begin
    TGlyph(Obj).Images := dm_Bilder.iml_16;
    TGlyph(Obj).ImageIndex := 5;
  end;
end;

procedure Tfrm_Login.edt_PasswortApplyStyleLookup(Sender: TObject);
var
  Obj: Tfmxobject;
begin
  Obj := edt_Passwort.FindStyleResource('Glyph');
  if (Obj <> nil) and (Obj is TGlyph) then
  begin
    TGlyph(Obj).Images := dm_Bilder.iml_16;
  end;
  Obj := edt_Passwort.FindStyleResource('Gly_Auge');
  if (Obj <> nil) and (Obj is TGlyph) then
  begin
    TGlyph(Obj).HitTest := true;
    TGlyph(Obj).Locked  := false;
    TGlyph(Obj).Onclick := AugeClick;
    TGlyph(Obj).Images := dm_Bilder.iml_16;
    if edt_Passwort.Password then
      TGlyph(Obj).ImageIndex := 7
    else
      TGlyph(Obj).ImageIndex := 6;
  end;
end;

procedure Tfrm_Login.Login;
begin
  fThreadLogin.Login(edt_Benutzer.Text, edt_Passwort.Text);
end;

procedure Tfrm_Login.LoginErfolgreich(Sender: TObject);
begin
  Ani_Wait.Visible := false;
  Ani_Wait.Enabled := false;
  btn_Anmelden.Visible := true;
  if Assigned(fOnLoginErfolgreich) then
    fOnLoginErfolgreich(Self);
  //TDialogService.ShowMessage('Login Erfolgreich');
end;

procedure Tfrm_Login.LoginNichtErfolgreich(Sender: TObject);
begin
  Ani_Wait.Visible := false;
  Ani_Wait.Enabled := false;
  btn_Anmelden.Visible := true;
  if JFPZ.ErrorList.Count > 0 then
  begin
    if JFPZ.ErrorList.ConnectToServerError then
    begin
      TDialogService.ShowMessage('Die Serververbindung konnte nicht hergestellt werden.');
      if Assigned(fOnServerEinstellung) then
      begin
        FrageNachServerEinstellung;
        exit;
      end;
    end
    else
      if JFPZ.ErrorList.Item[0].Status = '-2' then
        TDialogService.ShowMessage('Benutzername oder Passwort ist nicht korrekt')
      else
      begin
        TDialogService.ShowMessage(JFPZ.ErrorList.getErrorsString);
        if Assigned(fOnServerEinstellung) then
        begin
          FrageNachServerEinstellung;
          exit;
        end;
      end;
  end;
  if Assigned(fOnLoginNichtErfolgreich) then
    fOnLoginNichtErfolgreich(Self);
end;

procedure Tfrm_Login.FrageNachServerEinstellung;
var
  s: string;
begin
  s := 'Möchten Sie die Servereinstellung prüfen?';
  TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                               procedure(const AResult: TModalResult)
                               begin
                                 if AResult = mrYes then
                                 begin
                                   if Assigned(fOnServerEinstellung) then
                                     fOnServerEinstellung(Self);
                                 end;
                               end);

end;


procedure Tfrm_Login.setActiv;
begin
  btn_Anmelden.Visible := true;
  edt_Benutzer.SetFocus;
end;

end.
