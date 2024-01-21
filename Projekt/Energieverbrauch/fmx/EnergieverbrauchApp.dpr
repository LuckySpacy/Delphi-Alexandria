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
  Form.Statistik in 'Form\Form.Statistik.pas' {frm_Statistik};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Energieverbrauch, frm_Energieverbrauch);
  Application.CreateForm(Tdm_Rest, dm_Rest);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.Run;
end.