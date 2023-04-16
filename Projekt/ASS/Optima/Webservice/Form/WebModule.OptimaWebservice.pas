unit WebModule.OptimaWebservice;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_LoginPostAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_aliveAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_EANAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    function getJsonString(aValue: string): string;
  public
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Json.Error, Json.Login, system.JSON, Json.User, Datenmodul.OptimaWebservice,
  Json.EAN, Json.Artikel, DB.Mengencodes, DB.Artikel, DB.AR_SP_Text;


procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Webserver-Anwendung</title></head>' +
    '<body>Webserver-Anwendung</body>' +
    '</html>';
end;


procedure TWebModule1.WebModule1wai_aliveAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := TJError.getErrorStr('Am Leben', 'OK', '');
end;

procedure TWebModule1.WebModule1wai_EANAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JEAN: TJEAN;
  JArtikel: TJArtikel;
  DBMengencodes: TDBMengencodes;
  DBArtikel: TDBArtikel;
  DBAR_SP_Text: TDBAR_SP_Text;
begin
  JEAN := TJEAN.FromJsonString(Request.Content);
  if JEAN = nil then
  begin
     Response.Content := TJError.getErrorStr('Json nicht korrekt', '-1', getJsonString(Request.Content));
    exit;
  end;

  JArtikel := TJArtikel.Create;
  DBAR_SP_Text := TDBAR_SP_Text.create(nil);
  DBMengencodes := TDBMengencodes.Create(nil);
  DBArtikel     := TDBArtikel.Create(nil);
  try
    DBAR_SP_Text.Trans := dm.IBT_Optima;
    DBArtikel.Trans := dm.IBT_Optima;
    DBMengencodes.Trans := dm.IBT_Optima;
    DBMengencodes.Read_EAN(JEAN.EAN);
    if DBMengencodes.Gefunden then
    begin
      DBArtikel.read(DBMengencodes.ArId);
      JArtikel.EAN := DBMengencodes.Ean;
      if DBArtikel.Gefunden then
      begin
        DBAR_SP_Text.Read_Artikel(dm.SpId, DBArtikel.id);
        JArtikel.Bez := DBAR_SP_Text.Bez;
        JArtikel.Id  := IntToStr(DBArtikel.Id);
        JArtikel.Nr  := IntToStr(DBArtikel.ArNr);
      end;

    end;

    Response.Content := JArtikel.ToJsonString;

  finally
    FreeAndNil(DBMengencodes);
    FreeAndNil(JArtikel);
    FreeAndNil(JEAN);
    FreeAndNil(DBArtikel);
    FreeAndNil(DBAR_SP_Text);
  end;


end;

procedure TWebModule1.WebModule1wai_LoginPostAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JError: TJError;
  JErrors: TArray<TErrorsClass>;
  JLogin: TJLogin;
  JUser: TJUser;
  List: TStringList;
begin //
  Response.ContentType := 'application/json;charset=utf-8';
  JLogin := TJLogin.FromJsonString(Request.Content);
  if JLogin = nil then
  begin
     Response.Content := TJError.getErrorStr('Json nicht korrekt', '-1', getJsonString(Request.Content));
    exit;
  end;

 // Response.Content := TJError.getErrorStr('Username oder Passwort ist nicht korrekt', '-2', '');


  JUser := TJUser.Create;
  try
    JUser.Vorname := 'Thomas';
    JUser.Nachname := 'Bachmann';
    JUser.MaId     := '101';
    Response.content := JUser.ToJsonString;
  finally
    FreeAndNil(JUser);
  end;


      {
  List := TStringList.Create;
  List.Add('Thomas');
  List.Add('Bachmann');
  List.Add('Hurra');
  //Response.Content := 'Benutzer: ' +  JLogin.Benutzer + ' / Passwort: ' + JLogin.Passwort;
  Response.Content := 'Benutzer: ' +  JLogin.Benutzer + ' / Passwort: ' + getJsonString(Trim(List.Text));
  FreeAndNil(List);
  }


  {
  JError := TJError.Create;
  try
    JErrors := JError.Add;
    JErrors[High(JErrors)].detail := 'detail';
    JErrors[High(JErrors)].status := 'status';
    JErrors[High(JErrors)].title  := 'title';
    Response.Content := JError.ToJsonString;
  finally
    FreeAndNil(JError);
  end;
  }

  FreeAndNil(JLogin);

end;


function TWebModule1.getJsonString(aValue: string): string;
var
  JsonString: TJsonString;
begin
  JsonString := TJSONString.Create(aValue);
  try
    Result := JsonString.ToJSON([TJSONAncestor.TJSONOutputOption.EncodeBelow32]);
  finally
    FreeAndNil(JsonString);
  end;
end;


end.
