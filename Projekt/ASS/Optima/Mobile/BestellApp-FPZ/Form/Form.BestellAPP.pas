unit Form.BestellAPP;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.ImgList, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Form.Login, Form.Main, Form.Servereinstellung, System.Generics.Collections,
  c.Events, Thread.Artikel, Form.Warenkorb;

type
  Tfrm_BestellApp = class(TForm)
    TabControl: TTabControl;
    tbs_Login: TTabItem;
    tbs_Main: TTabItem;
    tbs_Servereinstellung: TTabItem;
    tbs_Warenkorb: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fFormLogin: Tfrm_Login;
    fFormMain: Tfrm_Main;
    fFormServereinstellung: Tfrm_Servereinstellung;
    fFormWarenkorb: Tfrm_Warenkorb;
    fTabVerlauf : TList<TTabItem>;
    fThreadArtikel: TThreadArtikel;
    procedure LoginErfolgreich(Sender: TObject);
    procedure LoginNichtErfolgreich(Sender: TObject);
    procedure DoSettings(Sender: TObject);
    procedure DoExit(Sender: TObject);
    procedure DoBack(Sender: TObject);
    procedure DoArtikelabfrage(Sender: TObject; aValue: string);
    procedure ResultThreadArtikel(Sender: TObject);
    procedure setTabActiv(aTab: TTabItem);
  public
  end;

var
  frm_BestellApp: Tfrm_BestellApp;

implementation

{$R *.fmx}

uses
  {$IFDEF WIN32}
  FastMM5,
  {$ENDIF WIN32}
  Objekt.FPZ, Objekt.JFPZ, Form.Base, fmx.DialogService;





procedure Tfrm_BestellApp.FormCreate(Sender: TObject);
begin   //
  TabControl.TabPosition := TTabPosition.None;

  FPZ  := TFPZ.Create;
  JFPZ := TJFPZ.Create;

  fFormLogin := Tfrm_Login.Create(Self);
  while fFormLogin.ChildrenCount > 0 do
    fFormLogin.Children[0].Parent := tbs_Login;
  fFormLogin.OnLoginErfolgreich := LoginErfolgreich;
  fFormLogin.OnLoginNichtErfolgreich := LoginNichtErfolgreich;
  fFormLogin.OnServerEinstellung := doSettings;

  fFormMain := Tfrm_Main.Create(tbs_Main);
  while fFormMain.ChildrenCount > 0 do
    fFormMain.Children[0].Parent := tbs_Main;
  fFormMain.OnSettings := doSettings;
  fFormMain.OnExit     := doExit;
  fFormMain.OnArtikelabfrage := DoArtikelabfrage;
  Tfrm_Base(fFormMain).OnBack := doBack;

  fFormServereinstellung := Tfrm_Servereinstellung.Create(tbs_Servereinstellung);
  while fFormServereinstellung.ChildrenCount > 0 do
    fFormServereinstellung.Children[0].Parent := tbs_Servereinstellung;
  Tfrm_Base(fFormServereinstellung).OnBack := doBack;

  fFormWarenkorb := Tfrm_Warenkorb.Create(tbs_Warenkorb);
  while fFormWarenkorb.ChildrenCount > 0 do
    fFormWarenkorb.Children[0].Parent := tbs_Warenkorb;
  Tfrm_Base(fFormWarenkorb).OnBack := doBack;


  fTabVerlauf := TList<TTabItem>.Create;
  setTabActiv(tbs_Login);
  //TabControl.ActiveTab := tbs_Login;
  //fFormLogin.setActiv;

  fThreadArtikel := TThreadArtikel.Create;
  fThreadArtikel.OnArtikel := ResultThreadArtikel;


end;

procedure Tfrm_BestellApp.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(FPZ);
  FreeAndNil(JFPZ);
  FreeAndNil(fThreadArtikel);
  fTabVerlauf.DisposeOf;
end;


procedure Tfrm_BestellApp.LoginErfolgreich(Sender: TObject);
begin
  setTabActiv(tbs_Main);
end;

procedure Tfrm_BestellApp.LoginNichtErfolgreich(Sender: TObject);
begin

end;

procedure Tfrm_BestellApp.ResultThreadArtikel(Sender: TObject);
var
  s: string;
begin //
  setTabActiv(tbs_Warenkorb);
{
  s := '';
  if fpz.ArtikelList.Count > 0 then
    s := fpz.ArtikelList.Item[fpz.ArtikelList.Count-1].Bez;
  TDialogService.ShowMessage(s);
  }
end;

procedure Tfrm_BestellApp.setTabActiv(aTab: TTabItem);
var
  i1: Integer;
begin
  fTabVerlauf.Add(aTab);
  TabControl.ActiveTab := aTab;
  for i1 := 0 to aTab.ComponentCount -1 do
  begin
    if (aTab.Components[i1] is TForm) then
      Tfrm_Base(aTab.Components[i1]).setActiv;
  end;
end;




procedure Tfrm_BestellApp.DoBack(Sender: TObject);
var
  Tab: TTabItem;
  i1: Integer;
begin
  if fTabVerlauf.Count > 0 then
    fTabVerlauf.Delete(fTabVerlauf.Count-1);
  if fTabVerlauf.Count > 0 then
  begin
    Tab := fTabVerlauf.Items[fTabVerlauf.Count-1];
    TabControl.ActiveTab := Tab;
    for i1 := 0 to Tab.ComponentCount -1 do
    begin
      if (Tab.Components[i1] is TForm) then
        Tfrm_Base(Tab.Components[i1]).setActiv;
    end;
  end;
end;

procedure Tfrm_BestellApp.DoExit(Sender: TObject);
begin
  setTabActiv(tbs_Login);
  fTabVerlauf.Clear;
end;


procedure Tfrm_BestellApp.DoSettings(Sender: TObject);
begin
  setTabActiv(tbs_Servereinstellung);
end;


procedure Tfrm_BestellApp.DoArtikelabfrage(Sender: TObject; aValue: string);
begin  //
  fThreadArtikel.Artikel(aValue);
end;


initialization
  {$IFDEF WIN32}
  {First try to share this memory manager.  This will fail if another module is already sharing its memory manager.  In
  case of the latter, try to use the memory manager shared by the other module.}
  if FastMM_ShareMemoryManager then
  begin
    {Try to load the debug support library (FastMM_FullDebugMode.dll, or FastMM_FullDebugMode64.dll under 64-bit). If
    it is available, then enter debug mode.}
    if FastMM_LoadDebugSupportLibrary then
    begin
      FastMM_EnterDebugMode;
      {In debug mode, also show the stack traces for memory leaks.}
      FastMM_MessageBoxEvents := FastMM_MessageBoxEvents + [mmetUnexpectedMemoryLeakDetail];
    end;
  end
  else
  begin
    {Another module is already sharing its memory manager, so try to use that.}
    FastMM_AttemptToUseSharedMemoryManager;
  end;
  {$ENDIF WIN32}
end.
