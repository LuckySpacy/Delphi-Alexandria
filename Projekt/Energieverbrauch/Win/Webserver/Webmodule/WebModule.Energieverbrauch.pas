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
    procedure wm_Energieverbrauchwai_Zaehler_DeleteAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_Zaehler_ReadAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    fDBSchnittstelle: TDBSchnittstelle;
  public
  end;

var
  WebModuleClass: TComponentClass = Twm_Energieverbrauch;

implementation


uses
  Datenmodul.Database, JObjekt.Zaehler, Objekt.JZaehler, DB.Zaehler, Objekt.JErrorList,
  DB.ZaehlerList, Objekt.JZaehlerList;

const
  cJOk : string = '{"OK":"1"}';

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


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

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehler_DeleteAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JZaehler: TJZaehler;
  JErrorList: TJErrorList;
  DBZaehler: TDBZaehler;
begin //
  Response.ContentType := 'application/json; charset=UTF-8';
  DBZaehler  := TDBZaehler.Create(nil);
  JZaehler   := TJZaehler.Create;
  JErrorList := TJErrorList.Create;
  try
    JZaehler.JsonString := Request.Content;
    DBZaehler.Trans := dm.Trans;
    DBZaehler.JDelete(JZaehler, JErrorList);
    if JErrorList.Count > 0 then
      Response.Content := JErrorList.JsonString
    else
       Response.Content := cJOk;
  finally
    FreeAndNil(JZaehler);
    FreeAndNil(JErrorList);
    FreeAndNil(DBZaehler);
  end;
end;


procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehler_UpdateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JZaehler: TJZaehler;
  JErrorList: TJErrorList;
  DBZaehler: TDBZaehler;
begin //
  Response.ContentType := 'application/json; charset=UTF-8';
  DBZaehler  := TDBZaehler.Create(nil);
  JZaehler   := TJZaehler.Create;
  JErrorList := TJErrorList.Create;
  try
    JZaehler.JsonString := Request.Content;
    DBZaehler.Trans := dm.Trans;
    DBZaehler.Patch(JZaehler, JErrorList);
    if JErrorList.Count > 0 then
      Response.Content := JErrorList.JsonString
    else
       Response.Content := cJOk;
  finally
    FreeAndNil(JZaehler);
    FreeAndNil(JErrorList);
    FreeAndNil(DBZaehler);
  end;
end;

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehler_ReadAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  DBZaehlerList: TDBZaehlerlist;
  JZaehlerList: TJZaehlerList;
  JZaehler: TJZaehler;
  JErrorList: TJErrorList;
  i1: Integer;
begin //
  try
    Response.ContentType := 'application/json; charset=UTF-8';
    DBZaehlerList := TDBZaehlerlist.Create;
    JErrorList    := TJErrorList.Create;
    JZaehlerList  := TJZaehlerList.Create;
    try
      DBZaehlerList.Trans := dm.Trans;
      if Request.Content = '' then
      begin
        DBZaehlerList.ReadAll;
      end
      else
      begin
        JZaehler := TJZaehler.Create;
        try
          JZaehler.JsonString := Request.Content;
            DBZaehlerList.ReadbyId(JZaehler.FieldByName('ZA_ID').AsInteger);
        finally
          FreeAndNil(JZaehler);
        end;
      end;

      for i1 := 0 to DBZaehlerList.Count -1 do
      begin
        JZaehler := JZaehlerList.Add;
        DBZaehlerList.Item[i1].LoadToJsonObjekt(JZaehler);
      end;
      Response.Content := JZaehlerList.JsonString;
    finally
      FreeAndNil(DBZaehlerList);
      FreeAndNil(JErrorList);
      FreeAndNil(JZaehlerList);
    end;
  except
    on E: Exception do
    begin
      JErrorList.setError('wm_Energieverbrauchwai_Zaehler_ReadAction -> ' +  E.Message, '99');
    end;
  end;
end;


end.
