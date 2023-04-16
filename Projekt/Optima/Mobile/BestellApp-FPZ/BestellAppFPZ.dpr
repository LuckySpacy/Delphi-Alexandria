program BestellAppFPZ;

uses
  {$IFDEF WIN32}
  FastMM5 in '..\..\..\..\Komponenten\FastMM5\FastMM5.pas',
  {$ENDIF WIN32}
  System.StartUpCopy,
  FMX.Forms,
  Form.BestellAPP in 'Form\Form.BestellAPP.pas' {frm_BestellApp},
  Form.Login in 'Form\Form.Login.pas' {frm_Login},
  Objekt.FPZ in 'Objekt\Objekt.FPZ.pas',
  Objekt.FPZIni in 'Objekt\Objekt.FPZIni.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Communication.Base in 'Communication\Communication.Base.pas',
  Communication.API in 'Communication\Communication.API.pas',
  Objekt.JFPZ in 'Objekt\Objekt.JFPZ.pas',
  Objekt.Error in 'Objekt\Objekt.Error.pas',
  Objekt.ErrorList in 'Objekt\Objekt.ErrorList.pas',
  Objekt.Basislist in 'Objekt\Objekt.Basislist.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  Objekt.User in 'Objekt\Objekt.User.pas',
  Json.Error in '..\..\Webservice\Json\Json.Error.pas',
  Json.Login in '..\..\Webservice\Json\Json.Login.pas',
  Thread.Login in 'Thread\Thread.Login.pas',
  Json.User in '..\..\Webservice\Json\Json.User.pas',
  Form.Base in 'Form\Form.Base.pas' {frm_Base},
  Form.Servereinstellung in 'Form\Form.Servereinstellung.pas' {frm_Servereinstellung},
  Thread.ALive in 'Thread\Thread.ALive.pas',
  Form.Main in 'Form\Form.Main.pas' {frm_Main},
  Datenmodul.Bilder in 'Datenmodul\Datenmodul.Bilder.pas' {dm_Bilder: TDataModule},
  Objekt.Artikel in 'Objekt\Objekt.Artikel.pas',
  Objekt.ArtikelList in 'Objekt\Objekt.ArtikelList.pas',
  Json.Artikel in '..\..\Webservice\Json\Json.Artikel.pas',
  Thread.Artikel in 'Thread\Thread.Artikel.pas',
  Json.EAN in '..\..\Webservice\Json\Json.EAN.pas',
  c.Events in 'const\c.Events.pas',
  Form.Warenkorb in 'Form\Form.Warenkorb.pas' {frm_Warenkorb};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.CreateForm(Tfrm_BestellApp, frm_BestellApp);
  Application.Run;
end.
