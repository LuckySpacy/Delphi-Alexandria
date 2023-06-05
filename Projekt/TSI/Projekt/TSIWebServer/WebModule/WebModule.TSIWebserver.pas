unit WebModule.TSIWebserver;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, system.Types;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_NumberAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_AktieListAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_AktiewknAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1wai_AnsichtlistAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    function GetParameters(const aActionPath, aRequestPath: string): TStringDynArray;
  public
    { Public-Deklarationen }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.StrUtils, System.Generics.Collections, system.SyncObjs,
  Datamodul.Database, db.AktieList, db.Aktie, Json.AktieList, Json.Aktie,
  System.JSON, View.AnsichtList, View.Ansicht, Json.AnsichtList;

var
  gKeyValueStore: TDictionary<string, string>;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>TSI-Webserver-Anwendung</title></head>' +
    '<body>TSI-Webserver-Anwendung</body>' +
    '</html>';
end;

procedure TWebModule1.WebModule1wai_AktieListAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  DBAktieList: TDBAktieList;
  DBAktie: TDBAktie;
  i1: Integer;
  JAktieList: TJAktieList;
  Data: Json.AktieList.TDataClass;
begin //
  JAktieList := TJAktieList.Create;
  DBAktieList := TDBAktieList.Create;
  try
    DBAktieList.Trans := dm.IBT_TSI;
    DBAktieList.ReadAll;
    for i1 := 0 to DBAktieList.Count -1 do
    begin
      DBAktie := DBAktieList.Item[i1];
      Data := JAktieList.Add;
      Data.Aktie := DBAktie.Aktie;
      Data.Aktiv := BoolToStr(DBAktie.Aktiv);
      Data.Depot := BoolToStr(DBAktie.Depot);
      Data.BiId := DBAktie.BiId.ToString;
      Data.EPS  := FloatToStr(DBAktie.EPS);
      Data.ISIN := DBAktie.ISIN;
      Data.Symbol := DBAktie.Symbol;
      Data.WKN    := DBAktie.WKN;
      Data.id     := DBAktie.Id.ToString;
    end;

    Response.ContentType := 'application/json;charset=utf-8';
    Response.Content := JAktieList.ToJsonString;

  finally
    FreeAndNil(DBAktieList);
    FreeAndNil(JAktieList);
  end;


end;

function TWebModule1.GetParameters(const aActionPath, aRequestPath: string): TStringDynArray;
var
  lActionPathLength: Integer;
  lRequestPathLength: Integer;
  lParameter: string;
  lParameters: TStringDynArray;
begin
  SetLength(Result, 0);
  lActionPathLength  := aActionPath.Length;
  lRequestPathLength := aRequestPath.Length;
  if (lRequestPathLength > lActionPathLength) then
  begin
    lParameter := RightStr(aRequestPath, lRequestPathLength - lActionPathLength);
    lParameters := SplitString(lParameter, '/');
    if (Length(lParameters) > 0) then
    begin
      Result := lParameters;
    end;
  end;
end;

(*
procedure TWebModule1.WebModule1wai_AktiewknAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  lParameters: TStringDynArray;
  lKey: string;
  lValue: string;
begin
  lParameters := GetParameters((Sender as TWebActionItem).PathInfo, Request.PathInfo);
  if (Length(lParameters) > 0) then
  begin
    lKey := lParameters[0];
    lValue := '';
    if (Length(lParameters) > 1) then
    begin
      lValue := lParameters[1];
    end
    else
    begin
      lValue := Request.Content;
    end;
    if not (lValue.IsEmpty) then
    begin
      Response.ContentType := 'application/json; charset=UTF-8';
      gKeyValueStore[lKey] := lValue;
      Response.Content := ' {"result":[]}';
      Handled := true;
    end
    else
    begin
      Handled := false;
    end;
  end
  else
  begin
    Handled := false;
  end;
end;
*)

procedure TWebModule1.WebModule1wai_AktiewknAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JsonString: string;
  JsonObject: TJsonObject;
  wknValue: string;
  s: string;
  DBAktie: TDBAktie;
  JAktie: TJAktie;
begin
  s := LowerCase(copy(Request.Content, 1, 6));
  if s <> '{"wkn"' then
  begin
    Handled := false;
    exit;
  end;
  JsonString := Request.Content;
  JAktie := TJAktie.Create;
  DBAktie := TDBAktie.Create(nil);
  JsonObject := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
  try
    DBAktie.Trans := dm.IBT_TSI;
    wknValue := JsonObject.GetValue('wkn').Value;
    DBAktie.ReadWKN(wknValue);
    if DBAktie.Gefunden then
    begin
      JAktie.Aktie := DBAktie.Aktie;
      JAktie.Aktiv := BoolToStr(DBAktie.Aktiv);
      JAktie.Depot := BoolToStr(DBAktie.Depot);
      JAktie.BiId := DBAktie.BiId.ToString;
      JAktie.EPS  := FloatToStr(DBAktie.EPS);
      JAktie.ISIN := DBAktie.ISIN;
      JAktie.Symbol := DBAktie.Symbol;
      JAktie.WKN    := DBAktie.WKN;
      JAktie.id     := DBAktie.Id.ToString;
      Response.ContentType := 'application/json;charset=utf-8';
      Response.Content := JAktie.ToJsonString;
    end;
  finally
    FreeAndNil(JsonObject);
    FreeAndNil(DBAktie);
    FreeAndNil(JAktie);
  end;
end;


procedure TWebModule1.WebModule1wai_AnsichtlistAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  VWAnsichtList: TVWAnsichtList;
  VWAnsicht: TVWAnsicht;
  i1: Integer;
  JAnsichtList: TJAnsichtList;
  Data: Json.AnsichtList.TDataClass;
begin
  VWAnsichtList := TVWAnsichtList.Create;
  JAnsichtList  := TJAnsichtList.Create;
  try
    VWAnsichtList.Trans := dm.IBT_TSI;
    VWAnsichtList.ReadAll;
    for i1 := 0 to VWAnsichtList.Count -1 do
    begin
      VWAnsicht := VWAnsichtList.Item[i1];
      Data := JAnsichtList.Add;
      Data.HT_EPS              := VWAnsicht.FeldList.FieldByName('HT_EPS').AsString;
      Data.HT_KGV              := VWAnsicht.FeldList.FieldByName('HT_KGV').AsString;
      Data.HT_KGVSORT          := VWAnsicht.FeldList.FieldByName('HT_KGVSORT').AsString;
      Data.HT_LETZTERKURS      := VWAnsicht.FeldList.FieldByName('HT_LETZTERKURS').AsString;
      Data.HT_LETZTERKURSDATUM := VWAnsicht.FeldList.FieldByName('HT_LETZTERKURSDATUM').AsString;
      Data.ak_aktie            := VWAnsicht.FeldList.FieldByName('ak_aktie').AsString;
      Data.ak_aktiv            := VWAnsicht.FeldList.FieldByName('ak_aktiv').AsString;
      Data.ak_bi_id            := VWAnsicht.FeldList.FieldByName('ak_bi_id').AsString;
      Data.ak_depot            := VWAnsicht.FeldList.FieldByName('ak_depot').AsString;
      Data.ak_id               := VWAnsicht.FeldList.FieldByName('ak_id').AsString;
      Data.ak_link             := VWAnsicht.FeldList.FieldByName('ak_link').AsString;
      Data.ak_symbol           := VWAnsicht.FeldList.FieldByName('ak_symbol').AsString;
      Data.ak_wkn              := VWAnsicht.FeldList.FieldByName('ak_wkn').AsString;
      Data.ap_datum1           := VWAnsicht.FeldList.FieldByName('ap_datum1').AsString;
      Data.ap_datum14          := VWAnsicht.FeldList.FieldByName('ap_datum14').AsString;
      Data.ap_datum180         := VWAnsicht.FeldList.FieldByName('ap_datum180').AsString;
      Data.ap_datum30          := VWAnsicht.FeldList.FieldByName('ap_datum30').AsString;
      Data.ap_datum365         := VWAnsicht.FeldList.FieldByName('ap_datum365').AsString;
      Data.ap_datum60          := VWAnsicht.FeldList.FieldByName('ap_datum60').AsString;
      Data.ap_datum7           := VWAnsicht.FeldList.FieldByName('ap_datum7').AsString;
      Data.ap_datum90          := VWAnsicht.FeldList.FieldByName('ap_datum90').AsString;
      Data.ap_wert1            := VWAnsicht.FeldList.FieldByName('ap_wert1').AsString;
      Data.ap_wert14           := VWAnsicht.FeldList.FieldByName('ap_wert14').AsString;
      Data.ap_wert180          := VWAnsicht.FeldList.FieldByName('ap_wert180').AsString;
      Data.ap_wert30           := VWAnsicht.FeldList.FieldByName('ap_wert30').AsString;
      Data.ap_wert365          := VWAnsicht.FeldList.FieldByName('ap_wert365').AsString;
      Data.ap_wert60           := VWAnsicht.FeldList.FieldByName('ap_wert60').AsString;
      Data.ap_wert7            := VWAnsicht.FeldList.FieldByName('ap_wert7').AsString;
      Data.ap_wert90           := VWAnsicht.FeldList.FieldByName('ap_wert90').AsString;
      Data.ht_hoch_hjahrdatum  := VWAnsicht.FeldList.FieldByName('ht_hoch_hjahrdatum').AsString;
      Data.ht_hoch_hjahrkurs   := VWAnsicht.FeldList.FieldByName('ht_hoch_hjahrkurs').AsString;
      Data.ht_hoch_jahrdatum   := VWAnsicht.FeldList.FieldByName('ht_hoch_jahrdatum').AsString;
      Data.ht_hoch_jahrkurs    := VWAnsicht.FeldList.FieldByName('ht_hoch_jahrkurs').AsString;
      Data.ht_tief_hjahrdatum  := VWAnsicht.FeldList.FieldByName('ht_tief_hjahrdatum').AsString;
      Data.ht_tief_hjahrkurs   := VWAnsicht.FeldList.FieldByName('ht_tief_hjahrkurs').AsString;
      Data.ht_tief_jahrdatum   := VWAnsicht.FeldList.FieldByName('ht_tief_jahrdatum').AsString;
      Data.ht_tief_jahrkurs    := VWAnsicht.FeldList.FieldByName('ht_tief_jahrkurs').AsString;
      Data.tl_datum12          := VWAnsicht.FeldList.FieldByName('tl_datum12').AsString;
      Data.tl_datum27          := VWAnsicht.FeldList.FieldByName('tl_datum27').AsString;
      Data.tl_wert12           := VWAnsicht.FeldList.FieldByName('tl_wert12').AsString;
      Data.tl_wert27           := VWAnsicht.FeldList.FieldByName('tl_wert27').AsString;
    end;
    Response.ContentType := 'application/json;charset=utf-8';
    Response.Content := JAnsichtList.ToJsonString;
  finally
    FreeAndNil(VWAnsichtList);
    FreeAndNil(JAnsichtList);
  end;

end;

procedure TWebModule1.WebModule1wai_NumberAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'application/json;charset=utf-8';
  Response.Content := random(100).ToString;
end;


initialization
  gKeyValueStore := TDictionary<string, string>.Create;
  gKeyValueStore.AddOrSetValue('0', 'Zero');

end.
