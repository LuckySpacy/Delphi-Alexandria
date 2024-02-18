program EnergieverbrauchApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.Energieverbrauch in 'Form\Form.Energieverbrauch.pas' {frm_Energieverbrauch},
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Form.Main in 'Form\Form.Main.pas' {frm_Main},
  Form.Hosteinstellung in 'Form\Form.Hosteinstellung.pas' {frm_Hosteinstellung},
  Form.Daten in 'Form\Form.Daten.pas' {frm_Daten},
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.HostIni in 'Objekt\Objekt.HostIni.pas',
  Objekt.Energieverbrauch in 'Objekt\Objekt.Energieverbrauch.pas',
  Datenmodul.Rest in 'Datenmodul\Datenmodul.Rest.pas' {dm_Rest: TDataModule},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {dm_Bilder: TDataModule},
  Form.ZaehlerModify in 'Form\Form.ZaehlerModify.pas' {frm_ZaehlerModify},
  Communication.Base in 'Communication\Communication.Base.pas',
  Communication.API in 'Communication\Communication.API.pas',
  Objekt.JEnergieverbrauch in 'Objekt\Objekt.JEnergieverbrauch.pas',
  Thread.Timer in 'Timer\Thread.Timer.pas',
  Form.DatenModify in 'Form\Form.DatenModify.pas' {frm_DatenModify},
  Form.Statistik in 'Form\Form.Statistik.pas' {frm_Statistik},
  Objekt.Login in 'Objekt\Objekt.Login.pas',
  Payload.Login in '..\..\Webserver\Payload\Payload.Login.pas',
  Json.Error in '..\..\Webserver\Json\Json.Error.pas',
  Json.ErrorList in '..\..\Webserver\Json\Json.ErrorList.pas',
  c.JsonError in '..\..\Webserver\const\c.JsonError.pas',
  Json.CheckResult in '..\..\Webserver\Json\Json.CheckResult.pas',
  Json.EnergieverbrauchZaehlerList in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchZaehlerList.pas',
  Json.EnergieverbrauchZaehler in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchZaehler.pas',
  Json.Token in '..\..\Webserver\Json\Json.Token.pas',
  Json.BasisList in '..\..\Webserver\Json\Json.BasisList.pas',
  Objekt.ZaehlerList in 'Objekt\Objekt.ZaehlerList.pas',
  Payload.ZaehlerstandReadZeitraum in 'Payload\Payload.ZaehlerstandReadZeitraum.pas',
  Json.EnergieverbrauchZaehlerstand in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchZaehlerstand.pas',
  Json.EnergieverbrauchZaehlerstandList in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchZaehlerstandList.pas',
  Objekt.Feld in '..\..\Webserver\Objekt\Objekt.Feld.pas',
  Objekt.FeldList in '..\..\Webserver\Objekt\Objekt.FeldList.pas',
  Payload.EnergieverbrauchZaehlerstandUpdate in '..\..\Webserver\Payload\Energieverbrauch\Payload.EnergieverbrauchZaehlerstandUpdate.pas',
  Payload.EnergieverbrauchZaehlerUpdate in '..\..\Webserver\Payload\Energieverbrauch\Payload.EnergieverbrauchZaehlerUpdate.pas',
  Form.StatistikMonate in 'Form\Form.StatistikMonate.pas' {frm_StatistikMonate},
  Objekt.StatistikJahreMonatList in 'Objekt\Statistik\Objekt.StatistikJahreMonatList.pas',
  Objekt.StatistikMonatList in 'Objekt\Statistik\Objekt.StatistikMonatList.pas',
  Objekt.StatistikMonat in 'Objekt\Statistik\Objekt.StatistikMonat.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  Objekt.BasisList in 'Objekt\Objekt.BasisList.pas',
  Payload.EnergieverbrauchVerbrauchMonate in '..\..\Webserver\Payload\Energieverbrauch\Payload.EnergieverbrauchVerbrauchMonate.pas',
  Json.EnergieverbrauchVerbrauchMonateList in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchVerbrauchMonateList.pas',
  Json.EnergieverbrauchVerbrauchMonate in '..\..\Webserver\Json\Energieverbrauch\Json.EnergieverbrauchVerbrauchMonate.pas',
  Datenmodul.Stylebook in 'Datenmodul\Datenmodul.Stylebook.pas' {dm_Stylebook: TDataModule},
  Form.StatistikMonateVgl in 'Form\Form.StatistikMonateVgl.pas' {frm_StatistikMonateVgl};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Energieverbrauch, frm_Energieverbrauch);
  Application.CreateForm(Tdm_Rest, dm_Rest);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.CreateForm(Tdm_Stylebook, dm_Stylebook);
  Application.Run;
end.
