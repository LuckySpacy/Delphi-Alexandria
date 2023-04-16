program OptimaWebservice;
{$APPTYPE GUI}

uses
  FastMM5 in '..\..\..\Komponenten\FastMM5\FastMM5.pas',
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Form.OptimaWebservice in 'Form\Form.OptimaWebservice.pas' {frm_OptimaWebservice},
  WebModule.OptimaWebservice in 'Form\WebModule.OptimaWebservice.pas' {WebModule1: TWebModule},
  Datenmodul.OptimaWebservice in 'Form\Datenmodul.OptimaWebservice.pas' {dm: TDataModule},
  Objekt.OptimaWebservice in 'Objekt\Objekt.OptimaWebservice.pas',
  Objekt.IBDIni in 'Objekt\Objekt.IBDIni.pas',
  Objekt.Basislist in 'Objekt\Objekt.Basislist.pas',
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  Objekt.IBDIniList in 'Objekt\Objekt.IBDIniList.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Json.Login in 'Json\Json.Login.pas',
  Json.Error in 'Json\Json.Error.pas',
  Json.User in 'Json\Json.User.pas',
  Json.EAN in 'Json\Json.EAN.pas',
  Json.Artikel in 'Json\Json.Artikel.pas',
  DB.Basis in 'Datenbank\DB.Basis.pas',
  DB.BasisHistorie in 'Datenbank\DB.BasisHistorie.pas',
  NfsQuery in 'Datenbank\NfsQuery.pas',
  Objekt.DBFeld in 'Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in 'Objekt\Objekt.DBFeldList.pas',
  c_Historie in 'const\c_Historie.pas',
  DB.Historie2 in 'Datenbank\DB.Historie2.pas',
  DB.Historietext in 'Datenbank\DB.Historietext.pas',
  DB.Artikel in 'Datenbank\DB.Artikel.pas',
  DB.Mengencodes in 'Datenbank\DB.Mengencodes.pas',
  DB.Sprachen in 'Datenbank\DB.Sprachen.pas',
  DB.AR_SP_Text in 'Datenbank\DB.AR_SP_Text.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(Tfrm_OptimaWebservice, frm_OptimaWebservice);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
