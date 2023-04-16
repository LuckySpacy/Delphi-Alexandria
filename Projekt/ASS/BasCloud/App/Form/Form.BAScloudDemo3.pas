unit Form.BasCloudDemo3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, Objekt.Aufgabe, Objekt.Zaehler, Objekt.ReturnFormList,
  Objekt.UploadZaehlerstaende, AssPhoto, Form.Splash, Form.Login,
  Form.Main, Form.Aufgabe, Form.Zaehlerstand, Form.AddZaehlerstand,
  Form.Scanner, Form.Datenschutzbestimmung, Form.Loginwahl, Form.LoginScanner
  {$IFDEF IOS}
  , Objekt.iOsPermission
  {$ENDIF IOS}
  ;

type
  Tfrm_BasCloudDemo3 = class(TForm)
    TabControl: TTabControl;
    tbs_Splash: TTabItem;
    tbs_Login: TTabItem;
    tbs_Main: TTabItem;
    tbs_Aufgabe: TTabItem;
    tbs_Zaehlerstand: TTabItem;
    tbs_AddZaehlerstand: TTabItem;
    tbs_Scanner: TTabItem;
    rec_Background: TRectangle;
    rect_Login_Background: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    tbs_Datenschutzbestimmung: TTabItem;
    tbs_LoginWahl: TTabItem;
    tbs_LoginScanner: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
  private
    fPhoto: TASSPhoto;
    fReturnFormList: TReturnFormList;
    fFormSplash: Tfrm_Splash;
    fFormLogin: Tfrm_Login;
    fFormMain: Tfrm_Main;
    fFormAufgabe: Tfrm_Aufgabe;
    fFormZaehlerstand: Tfrm_Zaehlerstand;
    fFormAddZaehlerstand: Tfrm_AddZaehlerstand;
    fFormScanner: Tfrm_Scanner;
    fFormDatenschutzbestimmung: Tfrm_Datenschutzbestimmung;
    fFormLoginwahl: Tfrm_Loginwahl;
    fFormLoginScanner: Tfrm_LoginScanner;
    {$IFDEF IOS}
    fiOsPermission: TiOsPermission;
   {$ENDIF IOS}
    fCameraAccessAllowed: Boolean;
   {$IFDEF IOS}
    procedure CameraAccessPermitted(ASender: TObject; const AMessage: string; const AAccessGranted: Boolean);
    {$ENDIF IOS}
    procedure DoLogout(Sender: TObject);
    procedure LoginSuccess(Sender: TObject);
    procedure EndeLadeDaten(Sender: TObject);
    procedure EndeRefreshAufgabenListe(Sender: TObject);
    procedure ShowAufgabe(Sender: TObject);
    procedure ShowScanner(Sender: TObject);
    procedure ShowZaehlerstand(Sender: TObject);
    procedure ShowZaehlerstandOhneAufgabe(Sender: TObject);
    procedure ShowAddZaehlerstand(Sender: TObject);
    procedure ShowAddZaehlerstandOhneAufgabe(Sender: TObject);
    procedure ShowDatenschutzbestimmung(Sender: TObject);
    procedure DoFormZurueck(Sender: TObject);
    procedure ShowTab(aFormName: string);
    procedure ShowLastTab;
    procedure ShowNextTab(aFormName: string);
    procedure DoRefreshAufgabenListe(Sender: TObject);
    procedure AufgabeScanned(aAufgabe: TAufgabe);
    procedure ZaehlerScanned(aZaehler: TZaehler);
    //procedure UploadZaehlerstaendeStart(Sender: TObject);
    //procedure UploadZaehlerstaendeEndUpload(Sender: TObject);
    //procedure ZaehlerstandUploadedBreak(Sender: TObject);
    procedure LoginPerMail(Sender: TObject);
    procedure LoginPerQrCode(Sender: TObject);
    procedure LoginPerQrCodeZurueck(Sender: TObject);
    procedure LoginPerQrCodeErfolgreich(Sender: TObject);
    procedure LoginPerQrCodeNichtErfolgreich(Sender: TObject);
    procedure DoUpload(Sender: TObject);
    procedure NewAufgabe(Sender: TObject);
  public
  end;

var
  frm_BasCloudDemo3: Tfrm_BasCloudDemo3;

implementation

{$R *.fmx}

uses
  Datenmodul.Style, Datenmodul.db, Json.CurrentUser, DB.ZaehlerUpdateList,
  Objekt.BasCloud, Objekt.JBasCloud, FMX.DialogService, system.DateUtils
  {$IFNDEF WIN32}
  ,iPub.Fmx.systembars
  {$ENDIF}
  ,DB.GebaudeList, DB.ToDoList, DB.DeviceList
  ;



procedure Tfrm_BasCloudDemo3.FormCreate(Sender: TObject);
begin
  fPhoto := nil;
  fCameraAccessAllowed := false;
  BasCloud  := TBasCloud.Create;
  JBasCloud := TJBasCloud.Create;
  fReturnFormList := TReturnFormList.Create;
  //UploadZaehlerstaendex := TUploadZaehlerstaende.Create;


  TabControl.TabPosition := TTabPosition.None;
  {$IFDEF IOS}
  fPhoto := TASSPhoto.Create;
  {$ENDIF IOS}

  fFormLogin := Tfrm_Login.Create(Self);
  while fFormLogin.ChildrenCount > 0 do
    fFormLogin.Children[0].Parent := rect_Login_Background;
  fFormLogin.OnLoginSuccess := LoginSuccess;
  fFormLogin.OnDatenschutzbestimmung := ShowDatenschutzbestimmung;
  fFormLogin.OnLoginPerQRCode := LoginPerQrCode;


  fFormScanner := Tfrm_Scanner.Create(Self);
  while fFormScanner.ChildrenCount > 0 do
    fFormScanner.Children[0].Parent := tbs_Scanner;
  fFormScanner.OnZurueck := DoFormZurueck;
  fFormScanner.OnAufgabeScanned := AufgabeScanned;
  fFormScanner.OnZaehlerScanned := ZaehlerScanned;

  fFormSplash := Tfrm_Splash.Create(Self);
  while fFormSplash.ChildrenCount > 0 do
    fFormSplash.Children[0].Parent := tbs_Splash;


  fFormMain := Tfrm_Main.Create(Self);
  while fFormMain.ChildrenCount > 0 do
    fFormMain.Children[0].Parent := tbs_Main;
  fFormMain.OnLogout := DoLogout;
  fFormMain.OnAufgabe := ShowAufgabe;
  fFormMain.OnScanner := ShowScanner;


  fFormAufgabe := Tfrm_Aufgabe.Create(Self);
  while fFormAufgabe.ChildrenCount > 0 do
    fFormAufgabe.Children[0].Parent := tbs_Aufgabe;
  fFormAufgabe.OnZurueck := DoFormZurueck;
  fFormAufgabe.OnRefreshAufgabenliste := DoRefreshAufgabenListe;
  fFormAufgabe.OnAufgabeClick := ShowZaehlerstand;
  fFormAufgabe.OnScannerClick := ShowScanner;


  fFormZaehlerstand := Tfrm_Zaehlerstand.Create(Self);
  while fFormZaehlerstand.ChildrenCount > 0 do
    fFormZaehlerstand.Children[0].Parent := tbs_Zaehlerstand;
  fFormZaehlerstand.OnZurueck := DoFormZurueck;
  fFormZaehlerstand.OnAddZaehlerstand := ShowAddZaehlerstand;
  fFormZaehlerstand.OnAddZaehlerstandOhneAufgabe := ShowAddZaehlerstandOhneAufgabe;


  fFormAddZaehlerstand := Tfrm_AddZaehlerstand.Create(Self);
  while fFormAddZaehlerstand.ChildrenCount > 0 do
    fFormAddZaehlerstand.Children[0].Parent := tbs_AddZaehlerstand;
  fFormAddZaehlerstand.OnZurueck := DoFormZurueck;
  fFormAddZaehlerstand.OnDoUpload := DoUpload;
  fFormAddZaehlerstand.OnNewAufgabe := NewAufgabe;


  fFormDatenschutzbestimmung := Tfrm_Datenschutzbestimmung.Create(Self);
  while fFormDatenschutzbestimmung.ChildrenCount > 0 do
    fFormDatenschutzbestimmung.Children[0].Parent := tbs_Datenschutzbestimmung;
  fFormDatenschutzbestimmung.OnZurueck := DoFormZurueck;

  fFormLoginwahl := Tfrm_Loginwahl.Create(Self);
  while fFormLoginwahl.ChildrenCount > 0 do
    fFormLoginwahl.Children[0].Parent := tbs_Loginwahl;
  fFormLoginwahl.OnQrCode := LoginPerQrCode;
  fFormLoginwahl.OnMail := LoginPerMail;
  fFormLoginwahl.OnDatenschutzbestimmung := ShowDatenschutzbestimmung;


  fFormLoginScanner := Tfrm_LoginScanner.Create(Self);
  while fFormLoginScanner.ChildrenCount > 0 do
    fFormLoginScanner.Children[0].Parent := tbs_LoginScanner;
  fFormLoginScanner.OnZurueck := LoginPerQrCodeZurueck;
  fFormLoginScanner.OnLoginErfolgreich := LoginPerQrCodeErfolgreich;
  fFormLoginScanner.OnLoginNichtErfolgreich := LoginPerQrCodeNichtErfolgreich;


  {$IFDEF IOS}
  fiOsPermission := TiOsPermission.Create;
  fiOsPermission.OnPermissionRequest := CameraAccessPermitted;
  {$ENDIF IOS}


  {$IFNDEF WIN32}
  //Systembars.NavigationBarBackgroundColor := TAlphaColors.Red;
  SystemStatusBar.BackgroundColor := TAlphaColors.White;
  //SystemStatusBar.BackgroundColor := BasCloud.getAlphaColor($005686);
  {$ENDIF}


  //UploadZaehlerstaendex.OnUploadEnde   := UploadZaehlerstaendeEndUpload;
  //UploadZaehlerstaendex.OnUploadStart  := UploadZaehlerstaendeStart;
  //UploadZaehlerstaendex.OnBreakUpload  := ZaehlerstandUploadedBreak;


  log.d('Tfrm_BasCloudDemo3.FormCreate(Sender: TObject)');

end;

procedure Tfrm_BasCloudDemo3.FormDestroy(Sender: TObject);
begin
  if fPhoto <> nil then
    FreeAndNil(fPhoto);
  if BasCloud <> nil then
    FreeAndNil(BasCloud);
  if JBasCloud <> nil then
    FreeAndNil(JBasCloud);
  if fReturnFormList <> nil then
    FreeAndNil(fReturnFormList);
  //FreeAndNil(UploadZaehlerstaendex);
end;


procedure Tfrm_BasCloudDemo3.FormShow(Sender: TObject);
begin
  dm_db.Connect;
  try
    dm_db.DoUpgrade;
  except
  end;

  try
    if (Trim(BasCloud.Ini.LoginMail) > '') and (Trim(BasCloud.Ini.LoginPasswort) > '') then
    begin
      TabControl.ActiveTab := tbs_Login;
      fFormLogin.AktivateForm;
      fFormLogin.doLogin;
      exit;
    end;
    if (Trim(BasCloud.Ini.LoginMail) = '') and (Trim(BasCloud.Ini.LoginToken) = '') then
    begin
      ShowNextTab(fFormLoginwahl.Name);
      //TabControl.ActiveTab := tbs_Loginwahl;
      exit;
    end;
    if (Trim(BasCloud.Ini.LoginMail) > '') and (Trim(BasCloud.Ini.LoginToken) = '') then
    begin
      ShowNextTab(fFormLoginwahl.Name);
      //TabControl.ActiveTab := tbs_Loginwahl;
      exit;
    end;
    if (Trim(BasCloud.Ini.LoginMail) > '') and (Trim(BasCloud.Ini.LoginToken) > '') then
    begin
      JBasCloud.Token := Trim(BasCloud.Ini.LoginToken);
      LoginPerQrCode(nil);
      exit;
    end;
  finally
    {$IFDEF IOS}
    fiOsPermission.doRequestVideoPermission;
    {$ENDIF IOS}
  end;

end;


procedure Tfrm_BasCloudDemo3.LoginSuccess(Sender: TObject);
begin
  //TDialogService.ShowMessage('Login erfolgreich');
  TabControl.ActiveTab := tbs_Splash;
  fFormSplash.OnEndeLadeDaten := EndeLadeDaten;
  fFormSplash.LadeDaten;
end;


procedure Tfrm_BasCloudDemo3.NewAufgabe(Sender: TObject);
begin
  fFormAufgabe.DoUpdateListView;
end;

procedure Tfrm_BasCloudDemo3.AufgabeScanned(aAufgabe: TAufgabe);
begin
  ShowZaehlerstand(aAufgabe);
end;

procedure Tfrm_BasCloudDemo3.ZaehlerScanned(aZaehler: TZaehler);
begin
  ShowZaehlerstandOhneAufgabe(aZaehler);
end;

procedure Tfrm_BasCloudDemo3.Button1Click(Sender: TObject);
begin
  fPhoto.MakePhoto;
end;

procedure Tfrm_BasCloudDemo3.EndeLadeDaten(Sender: TObject);
begin
  fFormMain.lbl_Anmeldename.Text := BasCloud.Ini.LoginMail;
  fFormAufgabe.LadeListe;
  ShowLastTab;
end;




procedure Tfrm_BasCloudDemo3.DoFormZurueck(Sender: TObject);
begin
  if SameText(TForm(Sender).Name, 'frm_Datenschutzbestimmung') then
  begin
    if fReturnFormList.Count = 0 then
    begin
      TabControl.ActiveTab := tbs_LoginWahl;
      exit;
    end;
  end;
  ShowLastTab;
end;

procedure Tfrm_BasCloudDemo3.DoLogout(Sender: TObject);
begin
  fReturnFormList.Clear;
  //TabControl.ActiveTab := tbs_Login;
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
  fFormLogin.AktivateForm;
end;

procedure Tfrm_BasCloudDemo3.DoRefreshAufgabenListe(Sender: TObject);
begin
  TabControl.ActiveTab := tbs_Splash;
  fFormSplash.OnEndeRefreshAufgabenListe := EndeRefreshAufgabenListe;
  fFormSplash.RefreshAufgabenListe;
end;

procedure Tfrm_BasCloudDemo3.DoUpload(Sender: TObject);
begin
  fFormAufgabe.UploadAufgaben;
end;

procedure Tfrm_BasCloudDemo3.EndeRefreshAufgabenListe(Sender: TObject);
begin
  fFormAufgabe.LadeListe;
  TabControl.ActiveTab := tbs_Aufgabe;
end;



procedure Tfrm_BasCloudDemo3.ShowAufgabe(Sender: TObject);
begin
  ShowNextTab(fFormAufgabe.Name);
end;


procedure Tfrm_BasCloudDemo3.ShowDatenschutzbestimmung(Sender: TObject);
begin
  ShowNextTab(fFormDatenschutzbestimmung.Name);
  fFormDatenschutzbestimmung.setUrl('https://bascloud.net/app-datenschutzerklaerung/');
end;

procedure Tfrm_BasCloudDemo3.ShowLastTab;
var
  s: string;
begin
  if fReturnFormList.Count = 0 then
  begin
    ShowNextTab(fFormMain.Name);
    //TabControl.ActiveTab := tbs_Main;
    exit;
  end;
  s := fReturnFormList.LastFormname;
  fReturnFormList.DeleteLastItem;
  ShowTab(s);
end;



procedure Tfrm_BasCloudDemo3.ShowNextTab(aFormName: string);
begin

  if TabControl.ActiveTab = tbs_Main then
    fReturnFormList.Add(fFormMain.Name);
  if TabControl.ActiveTab = tbs_Aufgabe then
    fReturnFormList.Add(fFormAufgabe.Name);
  if TabControl.ActiveTab = tbs_Zaehlerstand then
    fReturnFormList.Add(fFormZaehlerstand.Name);
  if TabControl.ActiveTab = tbs_AddZaehlerstand then
    fReturnFormList.Add(fFormAddZaehlerstand.Name);
  if TabControl.ActiveTab = tbs_Datenschutzbestimmung then
    fReturnFormList.Add(fFormDatenschutzbestimmung.Name);
  if TabControl.ActiveTab = tbs_LoginWahl then
    fReturnFormList.Add(fFormLoginwahl.Name);

  ShowTab(aFormName);


end;

procedure Tfrm_BasCloudDemo3.ShowTab(aFormName: string);
begin
  if SameText(aFormName, fFormMain.Name) then
  begin
    SystemStatusBar.BackgroundColor := BasCloud.getAlphaColor($005686);
    fFormMain.AktivateForm;
    TabControl.ActiveTab := tbs_Main;
  end;
  if SameText(aFormName, 'frm_Aufgabe') then
    TabControl.ActiveTab := tbs_Aufgabe;
  if SameText(aFormName, 'frm_Zaehlerstand') then
  begin
    fFormZaehlerstand.Aktual;
    TabControl.ActiveTab := tbs_Zaehlerstand;
  end;
  if SameText(aFormName, 'frm_AddZaehlerstand') then
  begin
    TabControl.ActiveTab := tbs_AddZaehlerstand;
    fFormAddZaehlerstand.FormActivate(nil);
  end;
  if SameText(aFormName, 'frm_Scanner') then
    TabControl.ActiveTab := tbs_Scanner;
  if SameText(aFormName, 'frm_Datenschutzbestimmung') then
    TabControl.ActiveTab := tbs_Datenschutzbestimmung;
  if SameText(aFormName, 'frm_Loginwahl') then
    TabControl.ActiveTab := tbs_LoginWahl;
end;


procedure Tfrm_BasCloudDemo3.ShowZaehlerstand(Sender: TObject);
begin
  fFormZaehlerstand.Aufgabe := TAufgabe(Sender);
  ShowNextTab(fFormZaehlerstand.Name);
end;

procedure Tfrm_BasCloudDemo3.ShowZaehlerstandOhneAufgabe(Sender: TObject);
begin
  fFormZaehlerstand.Aufgabe := nil;
  fFormZaehlerstand.Zaehler := TZaehler(Sender);
  ShowNextTab(fFormZaehlerstand.Name);
end;


procedure Tfrm_BasCloudDemo3.TabControlChange(Sender: TObject);
begin
  if TabControl.ActiveTab = tbs_Aufgabe then
    fFormAufgabe.FormIsActivate;
  if TabControl.ActiveTab = tbs_AddZaehlerstand then
    fFormAddZaehlerstand.FormIsActivate;
end;


{
procedure Tfrm_BasCloudDemo3.ZaehlerstandUploadedBreak(Sender: TObject);
begin
  //UploadZaehlerstaendeEndUpload(Sender);
end;
}
{
procedure Tfrm_BasCloudDemo3.UploadZaehlerstaendeStart(Sender: TObject);
begin  //

end;
}

{
procedure Tfrm_BasCloudDemo3.UploadZaehlerstaendeEndUpload(Sender: TObject);
var
  i1: Integer;
begin  //


  for i1 := fReturnFormList.Count -1 downto 0 do
  begin
    if not SameText(fReturnFormList.LastFormname, 'frm_Main') then
      fReturnFormList.DeleteLastItem;
  end;

  BasCloud.InitError;
  fReturnFormList.Clear;
  TabControl.ActiveTab := tbs_Main;
  fFormAufgabe.LadeListe;
  fFormAufgabe.UploadZaehlerstaendeEndUpload(nil);
  ShowNextTab('frm_Aufgabe');


end;
}

procedure Tfrm_BasCloudDemo3.ShowScanner(Sender: TObject);
begin
  ShowNextTab(fFormScanner.Name);
  fFormScanner.StartScanner;
end;


procedure Tfrm_BasCloudDemo3.ShowAddZaehlerstand(Sender: TObject);
begin
  log.d('Tfrm_BasCloudDemo3.ShowAddZaehlerstand');
  fFormAddZaehlerstand.Aufgabe := TAufgabe(Sender);
  ShowNextTab(fFormAddZaehlerstand.Name);
  fformAddZaehlerstand.MakePhoto;
end;

procedure Tfrm_BasCloudDemo3.ShowAddZaehlerstandOhneAufgabe(Sender: TObject);
begin
  fFormAddZaehlerstand.Aufgabe := nil;
  fFormAddZaehlerstand.Zaehler := TZaehler(Sender);
  ShowNextTab(fFormAddZaehlerstand.Name);
  fformAddZaehlerstand.MakePhoto;
end;



{$IFDEF IOS}
procedure Tfrm_BasCloudDemo3.CameraAccessPermitted(ASender: TObject; const AMessage: string; const AAccessGranted: Boolean);
begin
  fCameraAccessAllowed := AAccessGranted;
end;
{$ENDIF IOS}



procedure Tfrm_BasCloudDemo3.LoginPerMail(Sender: TObject);
begin
  TabControl.ActiveTab := tbs_Login;
  fFormLogin.AktivateForm;
end;

procedure Tfrm_BasCloudDemo3.LoginPerQrCodeNichtErfolgreich(Sender: TObject);
begin
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
end;

procedure Tfrm_BasCloudDemo3.LoginPerQrCodeErfolgreich(Sender: TObject);
begin
  LoginSuccess(nil);
end;


procedure Tfrm_BasCloudDemo3.LoginPerQrCode(Sender: TObject);
var
  JCurrentUser: TJCurrentUser;
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  DBGebaudeList: TDBGebaudeList;
  DBToDoList: TDBToDoList;
  DBDeviceList: TDBDeviceList;
begin
  if (Trim(BasCloud.Ini.LoginMail) > '') and (Trim(JBasCloud.Token) > '') then
  begin
    JBasCloud.Token := BasCloud.Ini.LoginToken;
    JBasCloud.TokenExpire := BasCloud.StringToDate(BasCloud.Ini.LoginExpires);
    if BasCloud.Ini.KonnektivitaetStatus.Offline then
    begin
      LoginPerQrCodeErfolgreich(nil);
      exit;
    end;
    JCurrentUser := JBasCloud.Read_CurrentUser;
    try
      if JBascloud.ErrorList.Count > 0 then
      begin
        try
          if JBascloud.ErrorList.TokenNichtMehrGueltig then
          begin
            TDialogService.ShowMessage('Token ist nicht mehr gültig.');
            exit;
          end;
          if JBascloud.ErrorList.InternalServerError then
          begin
            TDialogService.ShowMessage('Ungültiger QR-Code.' + sLineBreak + 'QR-Code beinhaltet kein Token.');
            exit;
          end;
          TDialogService.ShowMessage(JBascloud.ErrorList.getErrorString);
          exit;
        finally
          LoginPerQrCodeNichtErfolgreich(nil);
        end;
      end;


      if not SameText(BasCloud.Ini.LoginUserId, JCurrentUser.data.id) then
      begin
        BasCloud.Ini.LoginUserId := JCurrentUser.data.id;
        Log.d('Delete Dateien');
        DBZaehlerUpdateList := TDBZaehlerUpdateList.Create;
        DBZaehlerUpdateList.DeleteAll;
        FreeAndNil(DBZaehlerUpdateList);
        DBGebaudeList := TDBGebaudeList.Create;
        DBGebaudeList.DeleteAll;
        FreeAndNil(DBGebaudeList);
        DBToDoList := TDBToDoList.Create;
        DBToDoList.DeleteAll;
        FreeAndNil(DBToDoList);
        DBDeviceList := TDBDeviceList.Create;
        DBDeviceList.DeleteAll;
        FreeAndNil(DBDeviceList);
      end;


      LoginPerQrCodeErfolgreich(nil);
      exit;
    finally
      FreeAndNil(JCurrentUser);
    end;
  end;
  TabControl.ActiveTab := tbs_LoginScanner;
  fFormLoginScanner.StartScanner;
end;


procedure Tfrm_BasCloudDemo3.LoginPerQrCodeZurueck(Sender: TObject);
begin
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
end;

end.
