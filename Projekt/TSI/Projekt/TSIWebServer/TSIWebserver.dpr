program TSIWebserver;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Form.TSIWebserver in 'Form\Form.TSIWebserver.pas' {frm_TSIWebserver},
  WebModule.TSIWebserver in 'WebModule\WebModule.TSIWebserver.pas' {WebModule1: TWebModule},
  Objekt.TSIWebServer in 'Objekt\Objekt.TSIWebServer.pas',
  Datamodul.Database in 'Datamodul\Datamodul.Database.pas' {dm: TDataModule},
  Objekt.IBConnectData in 'Objekt\Objekt.IBConnectData.pas',
  Objekt.IniBase in 'Objekt\Objekt.IniBase.pas',
  Objekt.Ini in '..\Global\Objekt\Objekt.Ini.pas',
  Objekt.IniFirebird in '..\Global\Objekt\Objekt.IniFirebird.pas',
  Objekt.DBFeld in '..\Global\Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in '..\Global\Objekt\Objekt.DBFeldList.pas',
  Objekt.ObjektList in '..\Global\Objekt\Objekt.ObjektList.pas',
  DB.Aktie in '..\Global\Datenbank\DB.Aktie.pas',
  DB.Basis in '..\Global\Datenbank\DB.Basis.pas',
  DB.AktieList in '..\Global\Datenbank\DB.AktieList.pas',
  Objekt.Basislist in '..\Global\Objekt\Objekt.Basislist.pas',
  DB.BasisList in '..\Global\Datenbank\DB.BasisList.pas',
  Json.AktieList in '..\Global\Json\Json.AktieList.pas',
  Json.Aktie in '..\Global\Json\Json.Aktie.pas',
  Json.AnsichtList in '..\Global\Json\Json.AnsichtList.pas',
  View.Base in '..\Global\View\View.Base.pas',
  View.Ansicht in '..\Global\View\View.Ansicht.pas',
  View.AnsichtList in '..\Global\View\View.AnsichtList.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrm_TSIWebserver, frm_TSIWebserver);
  Application.Run;
end.
