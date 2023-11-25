unit WebModule.Energieverbrauch;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Objekt.DBSchnittstelle;

type
  Twm_Energieverbrauch = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_CheckConnectAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_Zaehler_UpdateAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    fDBSchnittstelle: TDBSchnittstelle;
  public
  end;

var
  WebModuleClass: TComponentClass = Twm_Energieverbrauch;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Datenmodul.Database, JObjekt.Zaehler;

procedure Twm_Energieverbrauch.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Webserver-Anwendung</title></head>' +
    '<body>Webserver-Anwendung</body>' +
    '</html>';
end;

procedure Twm_Energieverbrauch.WebModuleCreate(Sender: TObject);
begin
  fDBSchnittstelle := TDBSchnittstelle.Create;
end;

procedure Twm_Energieverbrauch.WebModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fDBSchnittstelle);
end;

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_CheckConnectAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  Response.Content := 'Alive';
end;

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehler_UpdateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JObjZaehler: TJObjZaehler;
  Check: string;
begin //
  if Request.Content = 'Hallo' then
    exit;
  JObjZaehler := TJObjZaehler.Create;
  try
    JObjZaehler.JsonString := Request.content;
    Check := JObjZaehler.CheckValues;
    if Check > '' then
    begin
      Response.Content := Check;
      exit;
    end;
    fDBSchnittstelle.PatchZaehler(JObjZaehler);
  finally
    FreeAndNil(JObjZaehler);
  end;
  Response.Content := 'Ok';
end;

end.
