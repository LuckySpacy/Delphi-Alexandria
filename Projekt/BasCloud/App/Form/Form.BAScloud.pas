unit Form.BAScloud;

interface

{$I debug.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, Objekt.Aufgabe, Objekt.Zaehler, Objekt.ReturnFormList,
  Objekt.UploadZaehlerstaende, AssPhoto, Form.Splash, Form.Login2,
  Form.Main, Form.Aufgabe, Form.Zaehlerstand, Form.AddZaehlerstand, db.ToDoList,
  Form.Scanner, Form.Datenschutzbestimmung, Form.Loginwahl, Form.LoginScanner, Objekt.DBUpgrade, db.Queue, Objekt.AktualDaten,
  FMX.MultiView, Form.Log, DB.QueueList, Form.Mitteilungseinstellung
  {$IFDEF IOS}
  , Objekt.iOsPermission
  {$ENDIF IOS}
  ;

type
  Tfrm_BasCloud = class(TForm)
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
    MultiView1: TMultiView;
    tbs_Log: TTabItem;
    tbs_Mitteilungseinstellung: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fPhoto: TASSPhoto;
    fReturnFormList: TReturnFormList;
    fFormSplash: Tfrm_Splash;
    fFormLogin: Tfrm_Login2;
    fFormMain: Tfrm_Main;
    fFormAufgabe: Tfrm_Aufgabe;
    fFormZaehlerstand: Tfrm_Zaehlerstand;
    fFormAddZaehlerstand: Tfrm_AddZaehlerstand;
    fFormScanner: Tfrm_Scanner;
    fFormDatenschutzbestimmung: Tfrm_Datenschutzbestimmung;
    fFormLoginwahl: Tfrm_Loginwahl;
    fFormLoginScanner: Tfrm_LoginScanner;
    fFormMitteilungseinstellung: Tfrm_Mitteilungseinstellung;
    fFormLog: Tfrm_Log;
    fDBQueue: TDBQueue;
    fDBQueueList: TDBQueueList;
    fCanClose: Boolean;
    fAktualDaten: TAktualDaten;
    fCameraAccessAllowed: Boolean;
    fDBToDoList: TDBToDoList;
    {$IFDEF IOS}
    fiOsPermission: TiOsPermission;
    procedure CameraAccessPermitted(ASender: TObject; const AMessage: string; const AAccessGranted: Boolean);
    {$ENDIF IOS}
    procedure DoLogout(Sender: TObject);
    procedure LoginSuccess(Sender: TObject);
    procedure EndeLadeDaten(Sender: TObject);
    procedure EndeRefreshAufgabenListe(Sender: TObject);
    procedure ShowLog(Sender: TObject);
    procedure ShowAufgabe(Sender: TObject);
    procedure ShowScanner(Sender: TObject);
    procedure ShowZaehlerstand(Sender: TObject);
    procedure ShowZaehlerstandOhneAufgabe(Sender: TObject);
    procedure ShowAddZaehlerstand(Sender: TObject);
    procedure ShowAddZaehlerstandOhneAufgabe(Sender: TObject);
    procedure ShowDatenschutzbestimmung(Sender: TObject);
    procedure ShowMitteilungseinstellung(Sender: TObject);
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
    procedure CloseApp(Sender: TObject);
    procedure AktualDaten_ProgressInfo(aInfo: string; aIndex, aCount: Integer);
    procedure AufgabenListChanged(Sender: TObject);
    procedure EndRefreshProcess(Sender: TObject);
    procedure CheckTimer(Sender: TObject);
  public
  end;

var
  frm_BasCloud: Tfrm_BasCloud;

implementation

{$R *.fmx}

uses
  Datenmodul.Style, Datenmodul.db, Json.CurrentUser, DB.ZaehlerUpdateList,
  Objekt.BasCloud, Objekt.JBasCloud, FMX.DialogService, system.DateUtils
  {$IFNDEF WIN32}
  ,iPub.Fmx.systembars
  {$ENDIF}
  ,DB.GebaudeList, DB.DeviceList
  ;




procedure Tfrm_BasCloud.FormCreate(Sender: TObject);
begin
  fPhoto := nil;
  fCanClose := false;
  fCameraAccessAllowed := false;
  BasCloud  := TBasCloud.Create;
  JBasCloud := TJBasCloud.Create;
  fReturnFormList := TReturnFormList.Create;

  fDBQueue := TDBQueue.Create;
  fDBToDoList := TDBToDoList.Create;
  fDBQueueList := TDBQueueList.Create;




  //UploadZaehlerstaendex := TUploadZaehlerstaende.Create;


  TabControl.TabPosition := TTabPosition.None;
  {$IFDEF IOS}
  fPhoto := TASSPhoto.Create;
  {$ENDIF IOS}

  fFormLogin := Tfrm_Login2.Create(Self);
//  while fFormLogin.ChildrenCount > 0 do
//    fFormLogin.Children[0].Parent := rect_Login_Background;
  while fFormLogin.ChildrenCount > 0 do
    fFormLogin.Children[0].Parent := tbs_Login;
  fFormLogin.OnLoginSuccess := LoginSuccess;
  fFormLogin.OnDatenschutzbestimmung := ShowDatenschutzbestimmung;
  fFormLogin.OnLoginPerQRCode := LoginPerQrCode;
  fFormLogin.OnZurueck := DoFormZurueck;


  fFormScanner := Tfrm_Scanner.Create(Self);
  while fFormScanner.ChildrenCount > 0 do
    fFormScanner.Children[0].Parent := tbs_Scanner;
  fFormScanner.OnZurueck := DoFormZurueck;
  fFormScanner.OnAufgabeScanned := AufgabeScanned;
  fFormScanner.OnZaehlerScanned := ZaehlerScanned;

  fFormSplash := Tfrm_Splash.Create(Self);
  while fFormSplash.ChildrenCount > 0 do
    fFormSplash.Children[0].Parent := tbs_Splash;
  fFormSplash.OnProgressInfo :=  AktualDaten_ProgressInfo;


  fFormMain := Tfrm_Main.Create(Self);
  while fFormMain.ChildrenCount > 0 do
    fFormMain.Children[0].Parent := tbs_Main;
  fFormMain.OnLogout := DoLogout;
  fFormMain.OnAufgabe := ShowAufgabe;
  fFormMain.OnScanner := ShowScanner;
  fFormMain.OnLog     := ShowLog;
  fFormMain.OnMitteilungseinstellung := ShowMitteilungseinstellung;


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
  fFormAddZaehlerstand.OnProgressInfo :=  AktualDaten_ProgressInfo;



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
  fFormLoginwahl.OnZurueck := DoFormZurueck;


  fFormLoginScanner := Tfrm_LoginScanner.Create(Self);
  while fFormLoginScanner.ChildrenCount > 0 do
    fFormLoginScanner.Children[0].Parent := tbs_LoginScanner;
  fFormLoginScanner.OnZurueck := LoginPerQrCodeZurueck;
  fFormLoginScanner.OnLoginErfolgreich := LoginPerQrCodeErfolgreich;
  fFormLoginScanner.OnLoginNichtErfolgreich := LoginPerQrCodeNichtErfolgreich;


  fFormLog := Tfrm_Log.Create(Self);
  while fFormLog.ChildrenCount > 0 do
    fFormLog.Children[0].Parent := tbs_Log;
  fFormLog.OnZurueck := DoFormZurueck;


  fFormMitteilungseinstellung := Tfrm_Mitteilungseinstellung.Create(Self);
  while fFormMitteilungseinstellung.ChildrenCount > 0 do
    fFormMitteilungseinstellung.Children[0].Parent := tbs_Mitteilungseinstellung;
  fFormMitteilungseinstellung.OnZurueck := DoFormZurueck;





  {$IFDEF IOS}
  fiOsPermission := TiOsPermission.Create;
  fiOsPermission.OnPermissionRequest := CameraAccessPermitted;
  {$ENDIF IOS}


  {$IFNDEF WIN32}
  SystemStatusBar.BackgroundColor := TAlphaColors.White;
  {$ENDIF}


  log.d('Tfrm_BasCloudDemo3.FormCreate(Sender: TObject)');

  fAktualDaten := TAktualDaten.Create;
  fAktualDaten.OnCloseApp := CloseApp;
  fAktualDaten.OnProgressInfo :=  AktualDaten_ProgressInfo;
  fAktualDaten.OnAufgabenListChanged := AufgabenListChanged;
  fAktualDaten.OnEndRefreshProcess := EndRefreshProcess;

  BasCloud.OnCheckTimer := CheckTimer;


end;

procedure Tfrm_BasCloud.FormDestroy(Sender: TObject);
begin
  log.d('Tfrm_BasCloud.FormDestroy');
  fAktualDaten.Stop;
  if fPhoto <> nil then
    FreeAndNil(fPhoto);
  if BasCloud <> nil then
    FreeAndNil(BasCloud);
  if JBasCloud <> nil then
    FreeAndNil(JBasCloud);
  if fReturnFormList <> nil then
    FreeAndNil(fReturnFormList);
  FreeAndNil(fDBQueue);
  FreeAndNil(fAktualDaten);
  FreeAndNil(fDBToDoList);
  FreeAndNil(fDBQueueList);
end;


procedure Tfrm_BasCloud.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  log.d('Tfrm_BasCloud.FormCloseQuery');
  CanClose := fCanClose;
  if not fCanClose then
  begin
    log.d('Tfrm_BasCloud.FormCloseQuery --> Stop Timer');
    BasCloud.CloseAPP := true;
    fAktualDaten.Stop;
  end;
  if CanClose then
    log.d('CanClose = true')
  else
    log.d('CanClose = false');
end;



procedure Tfrm_BasCloud.FormShow(Sender: TObject);
var
  UpgradeDB: TUpgradeDB;
begin
  log.d('Tfrm_BasCloud.FormShow --> Start');
  dm_db.Connect;
  try
    dm_db.DoUpgrade;
  except
  end;

  UpgradeDB := TUpgradeDB.Create;
  try
    UpgradeDB.Start;
  finally
    FreeAndNil(UpgradeDB);
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
      log.d('QR-Code Token = ' + JBasCloud.Token);
      //LoginSuccess(nil); // Anmelden an der BAScloud nicht nötig;
      LoginPerQrCode(nil);
      exit;
    end;
  finally
    {$IFDEF IOS}
    fiOsPermission.doRequestVideoPermission;
    {$ENDIF IOS}
  end;
  log.d('Tfrm_BasCloud.FormShow --> Ende');

end;


procedure Tfrm_BasCloud.LoginSuccess(Sender: TObject);
var
  KeineAufgabenVorhanden: Boolean;
begin
  log.d('Tfrm_BasCloud.LoginSuccess --> Start');
  AktualDaten_ProgressInfo('Tfrm_BasCloud.LoginSuccess --> Start', 0, 0);
  {$IFDEF IOS}
  AktualDaten_ProgressInfo('BasCloud.CheckNotificationPermission --> Start', 0, 0);
  BasCloud.CheckNotificationPermission;
  AktualDaten_ProgressInfo('BasCloud.CheckNotificationPermission --> Ende', 0, 0);
  {$ENDIF IOS}
  fDBQueue.DeleteAll;
  TabControl.ActiveTab := tbs_Splash;
  fDBToDoList.ReadAll;
  KeineAufgabenVorhanden := fDBToDoList.Count = 0;


  if fDBQueue.InsertProcess_AlleDaten then
    AktualDaten_ProgressInfo('fDBQueue.InsertProcess_AlleDaten = true', 0, 0)
  else
    AktualDaten_ProgressInfo('fDBQueue.InsertProcess_AlleDaten = false', 0, 0);

  //fDBQueue.InsertProcess_ManuelRefresh;

  fDBQueueList.ReadAll;
  if fDBQueueList.Count > 0 then
  begin
    AktualDaten_ProgressInfo('LoginSuccess->fDBQueueList.Count = ' + IntToStr(fDBQueueList.Count), 0, 0);
    AktualDaten_ProgressInfo('LoginSuccess->fDBQueueList.Process = ' + IntToStr(fDBQueueList.Item[0].Process), 0, 0);
  end
  else
  begin
    AktualDaten_ProgressInfo('LoginSuccess->fDBQueueList.Count = ' + IntToStr(fDBQueueList.Count), 0, 0);
  end;

   if KeineAufgabenVorhanden then
  begin
    fDBQueue.InsertProcess_FulleVonBasCloudList;
    fDBQueue.InsertProcess_SyncDB;
  end;

  fFormSplash.OnEndeLadeDaten := EndeLadeDaten;
  fFormSplash.LadeDaten;

  //if not KeineAufgabenVorhanden then
  //begin


    AktualDaten_ProgressInfo('fAktualDaten.Start', 0, 0);
    fAktualDaten.AktualdatenStart;
  //end;

  log.d('InsertProcess_AlleZaehlerstaendeLaden');
  fDBQueue.InsertProcess_AlleZaehlerstaendeLaden;
  fDBQueueList.ReadAll;
  AktualDaten_ProgressInfo('TfDBQueueList.ReadAll', fDBQueueList.Count, 0);



  AktualDaten_ProgressInfo('Tfrm_BasCloud.LoginSuccess --> Ende', 0, 0);
  log.d('Tfrm_BasCloud.LoginSuccess --> Ende');


end;


procedure Tfrm_BasCloud.NewAufgabe(Sender: TObject);
begin
  fFormAufgabe.DoUpdateListView;
end;


procedure Tfrm_BasCloud.AufgabenListChanged(Sender: TObject);
begin
  if TabControl.ActiveTab = tbs_Aufgabe then
    fFormAufgabe.FormIsActivate;
end;

procedure Tfrm_BasCloud.EndRefreshProcess(Sender: TObject);
begin
  fFormAufgabe.EndRefresh;
end;

procedure Tfrm_BasCloud.AufgabeScanned(aAufgabe: TAufgabe);
begin
  ShowZaehlerstand(aAufgabe);
  AktualDaten_ProgressInfo('Tfrm_BasCloud.AufgabeScanned - fAktualDaten.Start', 0, 0);
  fAktualDaten.AktualdatenStart;
end;

procedure Tfrm_BasCloud.ZaehlerScanned(aZaehler: TZaehler);
begin
  ShowZaehlerstandOhneAufgabe(aZaehler);
  AktualDaten_ProgressInfo('Tfrm_BasCloud.ZaehlerScanned - fAktualDaten.Start', 0, 0);
  fAktualDaten.AktualdatenStart;
end;

procedure Tfrm_BasCloud.Button1Click(Sender: TObject);
begin
  fPhoto.MakePhoto;
end;

{$IFDEF IOS}
procedure Tfrm_BasCloud.CameraAccessPermitted(ASender: TObject;
  const AMessage: string; const AAccessGranted: Boolean);
begin //

end;
{$ENDIF IOS}

procedure Tfrm_BasCloud.CheckTimer(Sender: TObject);
begin
  fAktualDaten.CheckTimer;
end;

procedure Tfrm_BasCloud.CloseApp(Sender: TObject);
begin
  log.d('Tfrm_BasCloud.CloseApp');
  fCanClose := true;
  close;
end;

procedure Tfrm_BasCloud.EndeLadeDaten(Sender: TObject);
begin
  fFormMain.lbl_Anmeldename.Text := BasCloud.Ini.LoginMail;
  //fFormAufgabe.LadeListe;
  fFormAufgabe.DoUpdateListView;
  fReturnFormList.Clear;
  ShowLastTab;
  if not fAktualDaten.TimerAktiv then
  begin
    fDBQueue.InsertProcess_AlleDaten;
    fAktualDaten.AktualdatenStart;
  end;
end;




procedure Tfrm_BasCloud.DoFormZurueck(Sender: TObject);
begin
  if SameText(TForm(Sender).Name, 'frm_Datenschutzbestimmung') then
  begin
    if fReturnFormList.Count = 0 then
    begin
      TabControl.ActiveTab := tbs_LoginWahl;
      exit;
    end;
  end;
  if SameText(TForm(Sender).Name, 'frm_Login2') then
  begin
    if fReturnFormList.Count = 0 then
    begin
      TabControl.ActiveTab := tbs_LoginWahl;
      exit;
    end;
  end;
  ShowLastTab;
end;

procedure Tfrm_BasCloud.DoLogout(Sender: TObject);
begin
  fReturnFormList.Clear;
  BasCloud.Ini.LoginMail     := '';
  BasCloud.Ini.LoginPasswort := '';
  BasCloud.Ini.LoginToken    := '';

   fAktualDaten.Stop;
  //TabControl.ActiveTab := tbs_Login;
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
  fFormLogin.AktivateForm;
end;

procedure Tfrm_BasCloud.DoRefreshAufgabenListe(Sender: TObject);
begin
  TabControl.ActiveTab := tbs_Splash;
  fFormSplash.OnEndeRefreshAufgabenListe := EndeRefreshAufgabenListe;
  fFormSplash.RefreshAufgabenListe;
end;

procedure Tfrm_BasCloud.DoUpload(Sender: TObject);
begin
  fFormAufgabe.UploadAufgaben;
end;

procedure Tfrm_BasCloud.EndeRefreshAufgabenListe(Sender: TObject);
begin
  //fFormAufgabe.LadeListe;
  TabControl.ActiveTab := tbs_Aufgabe;
end;



procedure Tfrm_BasCloud.ShowAufgabe(Sender: TObject);
begin
  ShowNextTab(fFormAufgabe.Name);
end;


procedure Tfrm_BasCloud.ShowLog(Sender: TObject);
begin
  ShowNextTab(fFormLog.Name);
end;

procedure Tfrm_BasCloud.ShowMitteilungseinstellung(Sender: TObject);
begin
  ShowNextTab(fFormMitteilungseinstellung.Name);
end;

procedure Tfrm_BasCloud.ShowDatenschutzbestimmung(Sender: TObject);
begin
  ShowNextTab(fFormDatenschutzbestimmung.Name);
  fFormDatenschutzbestimmung.setUrl('https://bascloud.net/app-datenschutzerklaerung/');
end;

procedure Tfrm_BasCloud.ShowLastTab;
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



procedure Tfrm_BasCloud.ShowNextTab(aFormName: string);
begin

  fAktualDaten.CheckTimer;
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
  if TabControl.ActiveTab = tbs_Log then
    fReturnFormList.Add(fFormLog.Name);
  if TabControl.ActiveTab = tbs_Mitteilungseinstellung then
    fReturnFormList.Add(fFormMitteilungseinstellung.Name);

  ShowTab(aFormName);


end;

procedure Tfrm_BasCloud.ShowTab(aFormName: string);
begin
  if SameText(aFormName, fFormMain.Name) then
  begin
    SystemStatusBar.BackgroundColor := BasCloud.getAlphaColor($005686);
    fFormMain.AktivateForm;
    TabControl.ActiveTab := tbs_Main;
    fAktualDaten.AktualdatenStart;
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
  begin
    TabControl.ActiveTab := tbs_LoginWahl;
    fFormLoginwahl.AktivateForm;
  end;
  if SameText(aFormName, 'frm_Login2') then
    TabControl.ActiveTab := tbs_Login;
  if SameText(aFormName, 'frm_Log') then
    TabControl.ActiveTab := tbs_Log;
  if SameText(aFormName, 'frm_Mitteilungseinstellung') then
    TabControl.ActiveTab := tbs_Mitteilungseinstellung;
end;


procedure Tfrm_BasCloud.ShowZaehlerstand(Sender: TObject);
begin
  fFormZaehlerstand.Aufgabe := TAufgabe(Sender);
  ShowNextTab(fFormZaehlerstand.Name);
end;

procedure Tfrm_BasCloud.ShowZaehlerstandOhneAufgabe(Sender: TObject);
begin
  fFormZaehlerstand.Aufgabe := nil;
  fFormZaehlerstand.Zaehler := TZaehler(Sender);
  ShowNextTab(fFormZaehlerstand.Name);
end;


procedure Tfrm_BasCloud.TabControlChange(Sender: TObject);
begin
  if TabControl.ActiveTab = tbs_Aufgabe then
    fFormAufgabe.FormIsActivate;
  if TabControl.ActiveTab = tbs_AddZaehlerstand then
    fFormAddZaehlerstand.FormIsActivate;
end;


procedure Tfrm_BasCloud.ShowScanner(Sender: TObject);
begin
  try
    AktualDaten_ProgressInfo('fAktualDaten.Stop', 0, 0);
    fAktualDaten.Stop;
    ShowNextTab(fFormScanner.Name);
    fFormScanner.StartScanner;
  except
    on E: Exception do
    begin
      log.d('Tfrm_BasCloud.ShowScanner Error:' + E.Message);
    end;
  end;
end;


procedure Tfrm_BasCloud.ShowAddZaehlerstand(Sender: TObject);
begin
  log.d('Tfrm_BasCloudDemo3.ShowAddZaehlerstand');
  fFormAddZaehlerstand.Aufgabe := TAufgabe(Sender);
  ShowNextTab(fFormAddZaehlerstand.Name);
  fformAddZaehlerstand.MakePhoto;
end;

procedure Tfrm_BasCloud.ShowAddZaehlerstandOhneAufgabe(Sender: TObject);
begin
  fFormAddZaehlerstand.Aufgabe := nil;
  fFormAddZaehlerstand.Zaehler := TZaehler(Sender);
  ShowNextTab(fFormAddZaehlerstand.Name);
  fformAddZaehlerstand.MakePhoto;
end;



(*
{$IFDEF IOS}
procedure Tfrm_BasCloudDemo3.CameraAccessPermitted(ASender: TObject; const AMessage: string; const AAccessGranted: Boolean);
begin
  fCameraAccessAllowed := AAccessGranted;
end;
{$ENDIF IOS}
*)


procedure Tfrm_BasCloud.LoginPerMail(Sender: TObject);
begin
  ShowNextTab(fFormLogin.Name);
  //TabControl.ActiveTab := tbs_Login;
  fFormLogin.AktivateForm;
end;

procedure Tfrm_BasCloud.LoginPerQrCodeNichtErfolgreich(Sender: TObject);
begin
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
end;

procedure Tfrm_BasCloud.LoginPerQrCodeErfolgreich(Sender: TObject);
begin
  //Log.d('Tfrm_BasCloud.LoginPerQrCodeErfolgreich');
  LoginSuccess(nil);
end;


procedure Tfrm_BasCloud.LoginPerQrCode(Sender: TObject);
var
  JCurrentUser: TJCurrentUser;
  DBZaehlerUpdateList: TDBZaehlerUpdateList;
  DBGebaudeList: TDBGebaudeList;
  DBToDoList: TDBToDoList;
  DBDeviceList: TDBDeviceList;
begin
  log.d('Tfrm_BasCloud.LoginPerQrCode --> Start');
  if (Trim(BasCloud.Ini.LoginMail) > '') and (Trim(JBasCloud.Token) > '') then
  begin
    JBasCloud.Token := BasCloud.Ini.LoginToken;
    JBasCloud.TokenExpire := BasCloud.StringToDate(BasCloud.Ini.LoginExpires);
    JBasCloud.TenantId    := BasCloud.Ini.LoginTenantId;

    if not Bascloud.Plattform.InternetEnabled then
    begin
      log.d('Kein Internet');
      //TDialogService.ShowMessage('Kein Internet');
      LoginPerQrCodeErfolgreich(nil);
      exit;
    end;

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
  log.d('Tfrm_BasCloud.LoginPerQrCode --> Ende');
end;


procedure Tfrm_BasCloud.LoginPerQrCodeZurueck(Sender: TObject);
begin
  ShowNextTab(fFormLoginwahl.Name);
  //TabControl.ActiveTab := tbs_LoginWahl;
end;

procedure Tfrm_BasCloud.AktualDaten_ProgressInfo(aInfo: string; aIndex,
  aCount: Integer);
begin
  {$IFDEF DEBUGMODE}
  fFormLog.mem.Lines.Add(FormatDateTime('hh:nn:ss', now) + ' ' + aInfo + ' ' + IntToStr(aIndex) + '/' + IntToStr(aCount));
  log.D(FormatDateTime('hh:nn:ss', now) + ' ' + aInfo + ' ' + IntToStr(aIndex) + '/' + IntToStr(aCount));
  {$ENDIF DEBUGMODE}
end;


end.
