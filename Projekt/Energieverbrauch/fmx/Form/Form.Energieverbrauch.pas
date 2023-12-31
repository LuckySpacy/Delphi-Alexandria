unit Form.Energieverbrauch;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Objekt.Energieverbrauch,
  FMX.TabControl, Form.Main, Form.Hosteinstellung, Form.Daten, Form.Base,
  System.Generics.Collections, system.Net.HttpClient, Form.ZaehlerModify,
  Objekt.JEnergieverbrauch, FMX.Gestures, Form.DatenModify;

type
  Tfrm_Energieverbrauch = class(TForm)
    TabControl: TTabControl;
    tbs_Main: TTabItem;
    tbs_Daten: TTabItem;
    tbs_Hosteinstellung: TTabItem;
    tbs_ZaehlerModify: TTabItem;
    GestureManager: TGestureManager;
    tbs_DatenModify: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fFormMain: Tfrm_Main;
    fFormHosteinstellung: Tfrm_Hosteinstellung;
    fFormDaten: Tfrm_Daten;
    fFormZaehlerModify: Tfrm_ZaehlerModify;
    fFormDatenModify: Tfrm_DatenModify;
    fTabVerlauf : TList<TTabItem>;
    fCheckResult: string;
    procedure DoZurueck(Sender: TObject);
    procedure setTabActiv(aTab: TTabItem);
    function CheckConnection: Boolean;
    procedure HTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure HTTPRequestRequestError(const Sender: TObject; const AError: string);
    procedure ShowHostEinstellung(Sender: TObject);
    procedure ShowZaehlerModify(Sender: TObject);
    procedure NewZaehler(Sender: TObject);
    procedure ShowDaten(Sender: TObject);
    procedure ShowDatenModify(Sender: TObject);
    procedure AddZaehlerstand(Sender: TObject);
  public
  end;

var
  frm_Energieverbrauch: Tfrm_Energieverbrauch;

implementation

{$R *.fmx}

uses
  Datenmodul.Rest, fmx.DialogService, Objekt.JZaehler;


procedure Tfrm_Energieverbrauch.FormCreate(Sender: TObject);
begin
  Energieverbrauch := TEnergieverbrauch.Create;
  JEnergieverbrauch := TJEnergieverbrauch.Create;
  TabControl.TabPosition := TTabPosition.None;

  fFormMain := Tfrm_Main.Create(Self);
  while fFormMain.ChildrenCount > 0 do
    fFormMain.Children[0].Parent := tbs_Main;
  fFormMain.OnZurueck := DoZurueck;
  fFormMain.OnHostEinstellung := ShowHostEinstellung;
  fFormMain.OnZaehlerModify := ShowZaehlerModify;
  fFormMain.OnZaehlerClick := ShowDaten;
  tbs_Main.TagObject := fFormMain;


  fFormHosteinstellung := Tfrm_Hosteinstellung.Create(Self);
  while fFormHosteinstellung.ChildrenCount > 0 do
    fFormHosteinstellung.Children[0].Parent := tbs_Hosteinstellung;
  fFormHosteinstellung.OnZurueck := DoZurueck;
  tbs_Hosteinstellung.TagObject := fFormHosteinstellung;

  fFormDaten := Tfrm_Daten.Create(Self);
  while fFormDaten.ChildrenCount > 0 do
    fFormDaten.Children[0].Parent := tbs_Daten;
  fFormDaten.OnZurueck := DoZurueck;
  fFormDaten.OnAddZaehlerstand := AddZaehlerstand;
  tbs_Daten.TagObject := fFormDaten;


  fFormZaehlerModify := Tfrm_ZaehlerModify.Create(Self);
  while fFormZaehlerModify.ChildrenCount > 0 do
    fFormZaehlerModify.Children[0].Parent := tbs_ZaehlerModify;
  fFormZaehlerModify.OnZurueck := DoZurueck;
  fFormZaehlerModify.OnNewZaehler := NewZaehler;

  tbs_ZaehlerModify.TagObject := fFormZaehlerModify;


  fFormDatenModify := Tfrm_DatenModify.Create(Self);
  while fFormDatenModify.ChildrenCount > 0 do
    fFormDatenModify.Children[0].Parent := tbs_DatenModify;
  fFormDatenModify.OnZurueck := DoZurueck;

  tbs_DatenModify.TagObject := fFormDatenModify;




  fTabVerlauf := TList<TTabItem>.Create;
  setTabActiv(tbs_Main);

end;

procedure Tfrm_Energieverbrauch.FormDestroy(Sender: TObject);
begin
  fTabVerlauf.DisposeOf;
  FreeAndNil(Energieverbrauch);
  FreeAndNil(JEnergieverbrauch);
end;


procedure Tfrm_Energieverbrauch.FormShow(Sender: TObject);
begin
  if (Energieverbrauch.HostIni.Host = '') or (Energieverbrauch.HostIni.Port = 0) then
  begin
    setTabActiv(tbs_Hosteinstellung);
  end
  else
    CheckConnection;
end;



procedure Tfrm_Energieverbrauch.setTabActiv(aTab: TTabItem);
begin
  fTabVerlauf.Add(aTab);
  TabControl.ActiveTab := aTab;
  Tfrm_Base(aTab.TagObject).setActiv;
end;

procedure Tfrm_Energieverbrauch.ShowDaten(Sender: TObject);
begin
  fFormDaten.setZaehler(TJZaehler(Sender));
  setTabActiv(tbs_Daten);
end;

procedure Tfrm_Energieverbrauch.ShowDatenModify(Sender: TObject);
begin
  fFormDatenModify.setZaehler(TJZaehler(Sender));
  setTabActiv(tbs_DatenModify);
end;

procedure Tfrm_Energieverbrauch.ShowHostEinstellung(Sender: TObject);
begin //
  setTabActiv(tbs_Hosteinstellung);
end;

procedure Tfrm_Energieverbrauch.ShowZaehlerModify(Sender: TObject);
begin
  if Sender = nil then
    fFormZaehlerModify.setZaehler(nil)
  else
    fFormZaehlerModify.setZaehler(TJZaehler(Sender));
  setTabActiv(tbs_ZaehlerModify);
end;


procedure Tfrm_Energieverbrauch.DoZurueck(Sender: TObject);
var
  Tab: TTabItem;
begin
  if fTabVerlauf.Count = 0 then
  begin
    setTabActiv(tbs_Main);
    exit;
  end;

  if fTabVerlauf.Count > 0 then
    fTabVerlauf.Delete(fTabVerlauf.Count-1);
  if fTabVerlauf.Count > 0 then
  begin
    Tab := fTabVerlauf.Items[fTabVerlauf.Count-1];
    TabControl.ActiveTab := Tab;
    Tfrm_Base(Tab.TagObject).setActiv;
  end;
end;

procedure Tfrm_Energieverbrauch.AddZaehlerstand(Sender: TObject);
begin
  fFormDatenModify.setZaehler(TJZaehler(Sender));
  setTabActiv(tbs_DatenModify);
end;

function Tfrm_Energieverbrauch.CheckConnection: Boolean;
begin //
  Result := true;
  dm_Rest.HTTPRequest.MethodString := 'GET';
  //dm_Rest.HTTPRequest.URL := 'http://' +edt_Host.Text + ':' + Trim(edt_Port.Text) + '/CheckConnect';
  dm_Rest.HTTPRequest.URL := Energieverbrauch.HostIni.Host + ':' + Energieverbrauch.HostIni.Port.ToString + '/CheckConnect';
  dm_Rest.HTTPRequest.OnRequestCompleted := HTTPRequestRequestCompleted;
  dm_Rest.HTTPRequest.OnRequestError := HTTPRequestRequestError;
  dm_Rest.HTTPRequest.Execute();
end;

procedure Tfrm_Energieverbrauch.HTTPRequestRequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
var
  s: string;
begin
  fCheckResult := AResponse.ContentAsString;
  if not SameText(fCheckResult , 'Alive') then
  begin
    Energieverbrauch.HostConnectionOk := true;
    s := 'Die Verbindung zum Server ist fehlgeschlagen.' + sLineBreak +  sLineBreak + fCheckResult + sLineBreak + sLineBreak +
         'Bitte überprüfen Sie die Internetverbindung sowie die Host-Einstellung.';
    TDialogService.MessageDialog(s, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end
  else
  begin
    Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
    fFormMain.DoUpdateListView;
  end;

end;


procedure Tfrm_Energieverbrauch.HTTPRequestRequestError(const Sender: TObject;
  const AError: string);
var
  s: string;
begin
    s := 'Die Verbindung zum Server ist fehlgeschlagen.' + sLineBreak +  sLineBreak + AError + sLineBreak + sLineBreak +
         'Bitte überprüfen Sie die Internetverbindung sowie die Host-Einstellung.';
    TDialogService.MessageDialog(s, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

procedure Tfrm_Energieverbrauch.NewZaehler(Sender: TObject);
begin
  fFormMain.Reload;
end;

end.
