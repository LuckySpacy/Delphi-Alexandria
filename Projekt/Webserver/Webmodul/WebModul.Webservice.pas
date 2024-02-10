unit WebModul.Webservice;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  Twem_Webservice = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wem_Webservicewai_LoginAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehler_ReadAllAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehler_UpdateAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehler_DeleteAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehlerstand_ReadZeitraumAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehlerstand_UpdateAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_Zaehlerstand_DeleteAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_CheckConnectAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_VerbrauchKomplNeuBerechnenAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_VerbrauchMonateAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wem_Webservicewai_Energieverbrauch_VerbrauchJahreAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  WebModuleClass: TComponentClass = Twem_Webservice;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  wma.Login, wma.Energieverbrauch, wma.CheckConnect;

procedure Twem_Webservice.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=  '{"OK":"false"}';
  {
  Response.Content :=
    '<html>' +
    '<head><title>Webserver-Anwendung</title></head>' +
    '<body>Webserver-Anwendung</body>' +
    '</html>';
  }
end;



procedure Twem_Webservice.wem_Webservicewai_LoginAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  wmaLogin: TwmaLogin;
begin //
  wmaLogin := TwmaLogin.Create;
  try
    wmaLogin.DoIt(Request, Response);
  finally
    FreeAndNil(wmaLogin);
  end;
end;




procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehler_ReadAllAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehler.ReadAll.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;

end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehler_UpdateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehler.DBUdate.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;

end;



procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehler_DeleteAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehler.DBDelete.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;

end;




procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehlerstand_ReadZeitraumAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehlerstand.Lese.Zeitraum.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;

end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehlerstand_UpdateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehlerstand.DBUdate.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;

end;

procedure Twem_Webservice.wem_Webservicewai_CheckConnectAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  wmaCheckConnect: TwmaCheckConnect;
begin //
  wmaCheckConnect := TwmaCheckConnect.Create;
  try
    wmaCheckConnect.DoIt(Request, Response);
  finally
    FreeAndNil(wmaCheckConnect);
  end;

end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_VerbrauchJahreAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Verbrauch.Jahre.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;
end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_VerbrauchKomplNeuBerechnenAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin//
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Verbrauch.KomplNeuBerechnen.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;
end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_VerbrauchMonateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Verbrauch.Monate.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;
end;

procedure Twem_Webservice.wem_Webservicewai_Energieverbrauch_Zaehlerstand_DeleteAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  wmaEnergieverbrauch: TwmaEnergieverbrauch;
begin
  wmaEnergieverbrauch := TwmaEnergieverbrauch.Create;
  try
    wmaEnergieverbrauch.Zaehlerstand.DBDelete.DoIt(Request, Response);
  finally
    FreeAndNil(wmaEnergieverbrauch);
  end;
end;

end.
