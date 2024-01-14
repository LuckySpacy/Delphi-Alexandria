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
    procedure wm_Energieverbrauchwai_Zaehlerstand_UpdateAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_Zaehlerstand_DeleteAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_ZaehlerstandReadJahrAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wm_Energieverbrauchwai_Zaehlerstand_ReadZeitraumAction(
      Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    fDBSchnittstelle: TDBSchnittstelle;
  public
  end;

var
  WebModuleClass: TComponentClass = Twm_Energieverbrauch;

implementation


uses
  Datenmodul.Database, JObjekt.Zaehler, Objekt.JZaehler, DB.Zaehler, Objekt.JErrorList,
  DB.ZaehlerList, Objekt.JZaehlerList, DB.ZaehlerstandList, DB.Zaehlerstand,
  Objekt.JZaehlerstand, Objekt.JZaehlerstandList, wai.ZaehlerstandReadZeitraum;

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


procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_ZaehlerstandReadJahrAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JZaehlerstand: TJZaehlerstand;
  JZahlerstandList: TJZaehlerstandList;
  JErrorList: TJErrorList;
  DBZaehlerstandList: TDBZaehlerstandList;
  DBZaehler: TDBZaehler;
  i1: Integer;
begin
  Response.ContentType := 'application/json; charset=UTF-8';
  DBZaehlerstandList  := TDBZaehlerstandList.Create;
  DBZaehler := TDBZaehler.Create(nil);
  //JZaehlerstand   := TJZaehlerstand.Create;
  JErrorList := TJErrorList.Create;
  JZahlerstandList := TJZaehlerstandList.Create;
  try
    JZaehlerstand := JZahlerstandList.Add;
    JZaehlerstand.setErrorList(JErrorList);
    JZaehlerstand.JsonString := Request.Content;
    if JErrorList.Count > 0 then
    begin
      Response.Content := JErrorList.JsonString;
      exit;
    end;

    if JZaehlerstand.FieldByName('JAHR').AsInteger <= 0 then
    begin
      JErrorList.setError('Jahr entweder nicht übergeben oder nicht numerisch', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;

    if JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger <= 0 then
    begin
      JErrorList.setError('ZS_ZA_ID entweder nicht übergeben oder nicht numerisch', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehler.Trans := dm.Trans;
    DBZaehler.Read(JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger);
    if JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger <> DBZaehler.Id then
    begin
      JErrorList.setError('Zähler zur ZS_ZA_ID nicht gefunden', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;

    DBZaehlerstandList.Trans := dm.Trans;
    DBZaehlerstandList.ReadAllByZaIdAndJahr(JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger,
                                            JZaehlerstand.FieldByName('JAHR').AsInteger);

    JZahlerstandList.Clear;
    if DBZaehlerstandList.Count = 0 then
      JZaehlerstand := JZahlerstandList.Add;

    for i1 := 0 to DBZaehlerstandList.Count -1 do
    begin
      JZaehlerstand := JZahlerstandList.Add;
      DBZaehlerstandList.Item[i1].LoadToJsonObjekt(JZaehlerstand);
    end;

    Response.Content := JZahlerstandList.JsonString;

  finally
    FreeAndNil(JZahlerstandList);
    FreeAndNil(JErrorList);
    FreeAndNil(DBZaehlerstandList);
    FreeAndNil(DBZaehler);
  end;

end;

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehlerstand_DeleteAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JZaehlerstand: TJZaehlerstand;
  JErrorList: TJErrorList;
  DBZaehlerstand: TDBZaehlerstand;
begin //
  Response.ContentType := 'application/json; charset=UTF-8';
  DBZaehlerstand  := TDBZaehlerstand.Create(nil);
  JZaehlerstand   := TJZaehlerstand.Create;
  JErrorList := TJErrorList.Create;
  try
    JZaehlerstand.JsonString := Request.Content;
    DBZaehlerstand.Trans := dm.Trans;
    DBZaehlerstand.JDelete(JZaehlerstand, JErrorList);
    if JErrorList.Count > 0 then
      Response.Content := JErrorList.JsonString
    else
       Response.Content := cJOk;
  finally
    FreeAndNil(JZaehlerstand);
    FreeAndNil(JErrorList);
    FreeAndNil(DBZaehlerstand);
  end;
end;



procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehlerstand_UpdateAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  JZaehlerstand: TJZaehlerstand;
  JErrorList: TJErrorList;
  DBZaehlerstand: TDBZaehlerstand;
  DBZaehler: TDBZaehler;
begin //
  Response.ContentType := 'application/json; charset=UTF-8';
  DBZaehlerstand  := TDBZaehlerstand.Create(nil);
  DBZaehler := TDBZaehler.Create(nil);
  JZaehlerstand   := TJZaehlerstand.Create;
  JErrorList := TJErrorList.Create;
  try
    JZaehlerstand.setErrorList(JErrorList);
    JZaehlerstand.JsonString := Request.Content;
    if JErrorList.Count > 0 then
    begin
      Response.Content := JErrorList.JsonString;
      exit;
    end;
    DBZaehlerstand.LoadFromJsonObjekt(JZaehlerstand);
    if DBZaehlerstand.ZaId <= 0 then
    begin
      JErrorList.setError('Wert für ZS_ZA_ID nicht übergeben', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;

    if DBZaehlerstand.Wert <= 0 then
    begin
      JErrorList.setError('Wert für ZS_WERT nicht übergeben oder nicht numerisch', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;


    DBZaehler.Trans := dm.Trans;
    DBZaehler.Read(DBZaehlerstand.ZaId);
    if (DBZaehler.Id <> DBZaehlerstand.ZaId) then
    begin
      JErrorList.setError('Kein Zähler mit dem Wert von ZS_ZA_ID gefunden', '1');
      Response.Content := JErrorList.JsonString;
      exit;
    end;


    DBZaehlerstand.Trans := dm.Trans;
    DBZaehlerstand.Patch(JZaehlerstand, JErrorList);
    if JErrorList.Count > 0 then
      Response.Content := JErrorList.JsonString
    else
       Response.Content := cJOk;
  finally
    FreeAndNil(JZaehlerstand);
    FreeAndNil(JErrorList);
    FreeAndNil(DBZaehlerstand);
    FreeAndNil(DBZaehler);
  end;
end;

procedure Twm_Energieverbrauch.wm_Energieverbrauchwai_Zaehlerstand_ReadZeitraumAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  ZaehlerstandReadZeitraum: Twai_ZaehlerstandReadZeitraum;
begin //
  ZaehlerstandReadZeitraum := Twai_ZaehlerstandReadZeitraum.Create(Request, Response);
  try
    ZaehlerstandReadZeitraum.DoIt;
  finally
    FreeAndNil(ZaehlerstandReadZeitraum);
  end;

end;


end.
