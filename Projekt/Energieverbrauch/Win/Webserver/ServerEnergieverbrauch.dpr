program ServerEnergieverbrauch;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Form.Energieverbrauch in 'Form\Form.Energieverbrauch.pas' {Form1},
  WebModule.Energieverbrauch in 'Webmodule\WebModule.Energieverbrauch.pas' {wm_Energieverbrauch: TWebModule},
  DB.Basis in 'DB\DB.Basis.pas',
  DB.TBQuery in 'DB\DB.TBQuery.pas',
  DB.TBTransaction in 'DB\DB.TBTransaction.pas',
  DB.BasisList in 'DB\DB.BasisList.pas',
  Objekt.ObjektList in '..\..\..\Allgemein\Vcl\Objekt\Objekt.ObjektList.pas',
  Objekt.DBFeld in 'Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in 'Objekt\Objekt.DBFeldList.pas',
  Objekt.Allg in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Allg.pas',
  Datenmodul.Database in 'Datenmodul\Datenmodul.Database.pas' {dm: TDataModule},
  Objekt.Energieverbrauch in 'Objekt\Objekt.Energieverbrauch.pas',
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Log4D in '..\..\..\..\Komponenten\Log4d\Log4D.pas',
  Objekt.IniEnergieverbrauch in 'Objekt\Objekt.IniEnergieverbrauch.pas',
  Objekt.IniEinstellung in 'Objekt\Objekt.IniEinstellung.pas',
  Objekt.Ini in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Ini.pas',
  Objekt.IniBase in 'Objekt\Objekt.IniBase.pas',
  Objekt.Folderlocation in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Folderlocation.pas',
  Types.Folder in '..\..\..\Allgemein\Vcl\Types\Types.Folder.pas',
  Objekt.IniDB in 'Objekt\Objekt.IniDB.pas',
  DB.Zaehler in 'DB\DB.Zaehler.pas',
  DB.ZaehlerList in 'DB\DB.ZaehlerList.pas',
  JObjekt.Zaehler in '..\JObjekt\JObjekt.Zaehler.pas',
  Objekt.DBSchnittstelle in 'Objekt\Objekt.DBSchnittstelle.pas',
  JObjekt.Error in '..\JObjekt\JObjekt.Error.pas',
  JObjekt.ErrorList in '..\JObjekt\JObjekt.ErrorList.pas',
  Objekt.Basislist in '..\..\..\Allgemein\Vcl\Objekt\Objekt.Basislist.pas',
  Objekt.Feld in '..\Objekt\Objekt.Feld.pas',
  Objekt.FeldList in '..\Objekt\Objekt.FeldList.pas',
  Objekt.JZaehler in '..\Objekt\Objekt.JZaehler.pas',
  Objekt.JError in '..\Objekt\Objekt.JError.pas',
  Objekt.JErrorList in '..\Objekt\Objekt.JErrorList.pas',
  c.JsonError in '..\Const\c.JsonError.pas',
  Objekt.JZaehlerList in '..\Objekt\Objekt.JZaehlerList.pas',
  DB.Zaehlerstand in 'DB\DB.Zaehlerstand.pas',
  Objekt.JZaehlerstand in '..\Objekt\Objekt.JZaehlerstand.pas',
  Objekt.JZaehlerstandList in '..\Objekt\Objekt.JZaehlerstandList.pas',
  DB.ZaehlerstandList in 'DB\DB.ZaehlerstandList.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
