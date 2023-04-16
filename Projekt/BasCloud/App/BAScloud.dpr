program BAScloud;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.BAScloud in 'Form\Form.BAScloud.pas' {frm_BasCloud},
  Datenmodul.db in 'Datenmodul\Datenmodul.db.pas' {dm_db: TDataModule},
  Datenmodul.Style in 'Datenmodul\Datenmodul.Style.pas' {dm_Style: TDataModule},
  Objekt.AktualDaten in 'Objekt\Objekt.AktualDaten.pas',
  Objekt.Aufgabe in 'Objekt\Objekt.Aufgabe.pas',
  Objekt.AufgabeList in 'Objekt\Objekt.AufgabeList.pas',
  Objekt.AufgabePointerList in 'Objekt\Objekt.AufgabePointerList.pas',
  Objekt.BasCloud in 'Objekt\Objekt.BasCloud.pas',
  Objekt.BasCloudIni in 'Objekt\Objekt.BasCloudIni.pas',
  Objekt.BasCloudInternetCheck in 'Objekt\Objekt.BasCloudInternetCheck.pas',
  Objekt.BasCloudLog in 'Objekt\Objekt.BasCloudLog.pas',
  Objekt.BasCloudPlattform in 'Objekt\Objekt.BasCloudPlattform.pas',
  Objekt.BasCloudStyle in 'Objekt\Objekt.BasCloudStyle.pas',
  Objekt.Basislist in 'Objekt\Objekt.Basislist.pas',
  Objekt.Datum in 'Objekt\Objekt.Datum.pas',
  Objekt.DBSync in 'Objekt\Objekt.DBSync.pas',
  Objekt.DBUpgrade in 'Objekt\Objekt.DBUpgrade.pas',
  Objekt.Error in 'Objekt\Objekt.Error.pas',
  Objekt.ErrorList in 'Objekt\Objekt.ErrorList.pas',
  Objekt.Funktionen in 'Objekt\Objekt.Funktionen.pas',
  Objekt.Gebaude in 'Objekt\Objekt.Gebaude.pas',
  Objekt.GebaudeList in 'Objekt\Objekt.GebaudeList.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.JBasCloud in 'Objekt\Objekt.JBasCloud.pas',
  Objekt.KonnektivitaetStatus in 'Objekt\Objekt.KonnektivitaetStatus.pas',
  Objekt.LadeDatenFromDB in 'Objekt\Objekt.LadeDatenFromDB.pas',
  Objekt.Mitteilungseinstellung in 'Objekt\Objekt.Mitteilungseinstellung.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  Objekt.ReturnFormList in 'Objekt\Objekt.ReturnFormList.pas',
  Objekt.ScannerPosition in 'Objekt\Objekt.ScannerPosition.pas',
  Objekt.ScannerView in 'Objekt\Objekt.ScannerView.pas',
  Objekt.TimerIntervalCheck in 'Objekt\Objekt.TimerIntervalCheck.pas',
  Objekt.UpgradeSql in 'Objekt\Objekt.UpgradeSql.pas',
  Objekt.UpgradeSqlList in 'Objekt\Objekt.UpgradeSqlList.pas',
  Objekt.UploadAufgabe in 'Objekt\Objekt.UploadAufgabe.pas',
  Objekt.UploadZaehlerstaende in 'Objekt\Objekt.UploadZaehlerstaende.pas',
  Objekt.Zaehler in 'Objekt\Objekt.Zaehler.pas',
  Objekt.ZaehlerList in 'Objekt\Objekt.ZaehlerList.pas',
  Objekt.Zaehlerstand in 'Objekt\Objekt.Zaehlerstand.pas',
  DB.Basis in 'DB\DB.Basis.pas',
  DB.Basislist in 'DB\DB.Basislist.pas',
  DB.Device in 'DB\DB.Device.pas',
  DB.DeviceList in 'DB\DB.DeviceList.pas',
  DB.Gebaude in 'DB\DB.Gebaude.pas',
  DB.GebaudeList in 'DB\DB.GebaudeList.pas',
  DB.Queue in 'DB\DB.Queue.pas',
  DB.QueueList in 'DB\DB.QueueList.pas',
  DB.ToDo in 'DB\DB.ToDo.pas',
  DB.ToDoList in 'DB\DB.ToDoList.pas',
  DB.Upgrade in 'DB\DB.Upgrade.pas',
  DB.UpgradeList in 'DB\DB.UpgradeList.pas',
  DB.Zaehler in 'DB\DB.Zaehler.pas',
  DB.Zaehlerstandbild in 'DB\DB.Zaehlerstandbild.pas',
  DB.ZaehlerUpdate in 'DB\DB.ZaehlerUpdate.pas',
  DB.ZaehlerUpdateList in 'DB\DB.ZaehlerUpdateList.pas',
  Form.AddZaehlerstand in 'Form\Form.AddZaehlerstand.pas' {frm_AddZaehlerstand},
  Form.Aufgabe in 'Form\Form.Aufgabe.pas' {frm_Aufgabe},
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Form.Datenschutzbestimmung in 'Form\Form.Datenschutzbestimmung.pas' {frm_Datenschutzbestimmung},
  Form.Log in 'Form\Form.Log.pas' {frm_Log},
  Form.Login in 'Form\Form.Login.pas' {frm_Login},
  Form.Login2 in 'Form\Form.Login2.pas' {frm_Login2},
  Form.LoginScanner in 'Form\Form.LoginScanner.pas' {frm_Loginscanner},
  Form.Loginwahl in 'Form\Form.Loginwahl.pas' {frm_Loginwahl},
  Form.Main in 'Form\Form.Main.pas' {frm_Main},
  Form.Mitteilungseinstellung in 'Form\Form.Mitteilungseinstellung.pas' {frm_Mitteilungseinstellung},
  Form.Scanner in 'Form\Form.Scanner.pas' {frm_Scanner},
  Form.Splash in 'Form\Form.Splash.pas' {frm_Splash},
  Form.Zaehlerstand in 'Form\Form.Zaehlerstand.pas' {frm_Zaehlerstand},
  Json.CreatedReading in 'Json\Json.CreatedReading.pas',
  Json.CreateReading in 'Json\Json.CreateReading.pas',
  Json.CurrentUser in 'Json\Json.CurrentUser.pas',
  Json.Device in 'Json\Json.Device.pas',
  Json.Devices in 'Json\Json.Devices.pas',
  Json.Error in 'Json\Json.Error.pas',
  Json.EventsCollection in 'Json\Json.EventsCollection.pas',
  Json.Login in 'Json\Json.Login.pas',
  Json.Properties in 'Json\Json.Properties.pas',
  Json.PropertyAssociatedDevices in 'Json\Json.PropertyAssociatedDevices.pas',
  Json.QrCodeToken in 'Json\Json.QrCodeToken.pas',
  Json.Reading in 'Json\Json.Reading.pas',
  Json.ReadingImageUpload in 'Json\Json.ReadingImageUpload.pas',
  Json.Readings in 'Json\Json.Readings.pas',
  Json.ResetPassword in 'Json\Json.ResetPassword.pas',
  Json.SystemError in 'Json\Json.SystemError.pas',
  Json.Tenants in 'Json\Json.Tenants.pas',
  Json.Token in 'Json\Json.Token.pas',
  Thread.InternetCheck in 'Thread\Thread.InternetCheck.pas',
  Thread.LadeDaten in 'Thread\Thread.LadeDaten.pas',
  Thread.LadeDBDaten in 'Thread\Thread.LadeDBDaten.pas',
  Thread.Login in 'Thread\Thread.Login.pas',
  Thread.Timer in 'Thread\Thread.Timer.pas',
  Thread.UploadAufgabe in 'Thread\Thread.UploadAufgabe.pas',
  Thread.UploadAufgaben in 'Thread\Thread.UploadAufgaben.pas',
  Thread.UploadZaehlerstaende in 'Thread\Thread.UploadZaehlerstaende.pas',
  Thread.UploadZaehlerstand in 'Thread\Thread.UploadZaehlerstand.pas',
  {$IFDEF IOS}
  Objekt.iOsPermission in 'Objekt\iOs\Objekt.iOsPermission.pas',
  {$ENDIF IOS}
  Communication.BasCloud in 'Communication\Communication.BasCloud.pas',
  Communication.BasCloudAPI in 'Communication\Communication.BasCloudAPI.pas',
  Communication.BasCloudImageServiceAPI in 'Communication\Communication.BasCloudImageServiceAPI.pas',
  Communication.BasCloudMeteringServiceAPI in 'Communication\Communication.BasCloudMeteringServiceAPI.pas',
  Communication.Base in 'Communication\Communication.Base.pas',
  Objekt.DateTime in 'Objekt\Objekt.DateTime.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_db, dm_db);
  Application.CreateForm(Tdm_Style, dm_Style);
  Application.CreateForm(Tfrm_BasCloud, frm_BasCloud);
  Application.Run;
end.
