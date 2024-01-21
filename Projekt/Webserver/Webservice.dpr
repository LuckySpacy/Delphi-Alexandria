program Webservice;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Form.Webserver in 'Form\Form.Webserver.pas' {frm_Webservice},
  WebModul.Webservice in 'Webmodul\WebModul.Webservice.pas' {wem_Webservice: TWebModule},
  Form.Datenbank in 'Form\Form.Datenbank.pas' {frm_Datenbank},
  Form.DatenbankEinstellung in 'Form\Form.DatenbankEinstellung.pas' {frm_Datenbankeinstellung},
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.Folderlocation in 'Objekt\Objekt.Folderlocation.pas',
  Types.Folder in 'Types\Types.Folder.pas',
  Objekt.IniBase in 'Objekt\Objekt.IniBase.pas',
  Objekt.IniDB in 'Objekt\Objekt.IniDB.pas',
  Objekt.Webservice in 'Objekt\Objekt.Webservice.pas',
  Objekt.WebserviceIni in 'Objekt\Objekt.WebserviceIni.pas',
  Objekt.IniDatenbanken in 'Objekt\Objekt.IniDatenbanken.pas',
  Datenmodul.Database in 'Datenmodul\Datenmodul.Database.pas' {dm: TDataModule},
  Objekt.ObjektList in 'Objekt\Objekt.ObjektList.pas',
  Objekt.Basislist in 'Objekt\Objekt.Basislist.pas',
  Objekt.Feld in 'Objekt\Objekt.Feld.pas',
  Objekt.FeldList in 'Objekt\Objekt.FeldList.pas',
  Json.Error in 'Json\Json.Error.pas',
  Json.ErrorList in 'Json\Json.ErrorList.pas',
  Objekt.JWT in '..\..\Minitools\JWT\Objekt\Objekt.JWT.pas',
  Objekt.JsonWebToken in '..\..\Minitools\JWT\Objekt\Objekt.JsonWebToken.pas',
  Objekt.AccessPermission in 'Objekt\Objekt.AccessPermission.pas',
  DB.TBTransaction in 'DB\DB.TBTransaction.pas',
  DB.Basis in 'DB\DB.Basis.pas',
  DB.TBQuery in 'DB\DB.TBQuery.pas',
  Objekt.DBFeld in 'Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in 'Objekt\Objekt.DBFeldList.pas',
  Objekt.Allg in 'Objekt\Objekt.Allg.pas',
  c.JsonError in 'const\c.JsonError.pas',
  DB.Token in 'DB\APIAccess\DB.Token.pas',
  Payload.Login in 'Payload\Payload.Login.pas',
  wma.Login in 'WebmodulAction\wma.Login.pas',
  wma.Base in 'WebmodulAction\wma.Base.pas',
  wma.Energieverbrauch in 'WebmodulAction\Energieverbrauch\wma.Energieverbrauch.pas',
  wma.EnergieverbrauchZaehler in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehler.pas',
  wma.EnergieverbrauchZaehlerReadAll in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerReadAll.pas',
  Json.EnergieverbrauchZaehler in 'Json\Energieverbrauch\Json.EnergieverbrauchZaehler.pas',
  Json.EnergieverbrauchZaehlerList in 'Json\Energieverbrauch\Json.EnergieverbrauchZaehlerList.pas',
  DB.EnergieverbrauchZaehler in 'DB\Energieverbrauch\DB.EnergieverbrauchZaehler.pas',
  DB.EnergieverbrauchZaehlerList in 'DB\Energieverbrauch\DB.EnergieverbrauchZaehlerList.pas',
  DB.BasisList in 'DB\DB.BasisList.pas',
  Objekt.IniWebservice in 'Objekt\Objekt.IniWebservice.pas',
  Payload.EnergieverbrauchZaehlerUpdate in 'Payload\Energieverbrauch\Payload.EnergieverbrauchZaehlerUpdate.pas',
  wma.EnergieverbrauchZaehlerUpdate in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerUpdate.pas',
  wma.EnergieverbrauchZaehlerDelete in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerDelete.pas',
  wma.BaseEnergieverbrauch in 'WebmodulAction\Energieverbrauch\wma.BaseEnergieverbrauch.pas',
  wma.EnergieverbrauchZaehlerstand in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerstand.pas',
  wma.EnergieverbrauchZaehlerstandRead in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerstandRead.pas',
  wma.EnergieverbrauchZaehlerstandReadZeitraum in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerstandReadZeitraum.pas',
  DB.EnergieverbrauchZaehlerstand in 'DB\Energieverbrauch\DB.EnergieverbrauchZaehlerstand.pas',
  Json.EnergieverbrauchZaehlerstand in 'Json\Energieverbrauch\Json.EnergieverbrauchZaehlerstand.pas',
  Json.EnergieverbrauchZaehlerstandList in 'Json\Energieverbrauch\Json.EnergieverbrauchZaehlerstandList.pas',
  DB.EnergieverbrauchZaehlerstandList in 'DB\Energieverbrauch\DB.EnergieverbrauchZaehlerstandList.pas',
  Payload.EnergieverbrauchZaehlerstandRead in 'Payload\Energieverbrauch\Payload.EnergieverbrauchZaehlerstandRead.pas',
  wma.EnergieverbrauchZaehlerstandUpdate in 'WebmodulAction\Energieverbrauch\wma.EnergieverbrauchZaehlerstandUpdate.pas',
  Payload.EnergieverbrauchZaehlerstandUpdate in 'Payload\Energieverbrauch\Payload.EnergieverbrauchZaehlerstandUpdate.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(Tfrm_Webservice, frm_Webservice);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
