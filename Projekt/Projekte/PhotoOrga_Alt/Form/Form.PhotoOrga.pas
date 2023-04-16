unit Form.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  Form.Alben, System.Permissions, Form.Bilder2,System.Generics.Collections,
  Form.Base, Objekt.Aufgaben, Objekt.PhotoOrga, Form.Bild, types.PhotoOrga,
  DB.BilderList, FMX.Gestures, Form.Splash;

type
  Tfrm_PhotoOrga = class(TForm)
    TabControl: TTabControl;
    tbs_Main: TTabItem;
    tbs_Bilder: TTabItem;
    tbs_Bild: TTabItem;
    GestureManager1: TGestureManager;
    tbs_Splash: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabControlGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    fFormAlben: Tfrm_Alben;
    fFormBilder: Tfrm_Bilder2;
    fFormBild: Tfrm_Bild;
    fFormSplash: Tfrm_Splash;
    fTabVerlauf : TList<TTabItem>;
    fAufgaben: TAufgaben;
    {$IFDEF ANDROID}
    fOK : Boolean;
    procedure PermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
   {$ENDIF}
    procedure setTabActiv(aTab: TTabItem);
    procedure DoBack(Sender: TObject);
    procedure Albumclick(Sender: TObject);
    procedure BildClick(Sender: TObject; aItemIndex: Integer);
    procedure EndLoadAlleBilder(Sender: TObject);
    procedure EndSplashAktualBildObjekt(Sender: TObject);
  public
    procedure DoExit(Sender: TObject);
  end;

var
  frm_PhotoOrga: Tfrm_PhotoOrga;

implementation

{$R *.fmx}

uses
  Datenmodul.db, frame.Album, Objekt.Bild
{$IFDEF WIN32}
  ,FASTMM5;
{$ENDIF}

{$IFDEF ANDROID}
   ,Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os;
{$ENDIF}






procedure Tfrm_PhotoOrga.FormCreate(Sender: TObject);
  {$IFDEF ANDROID}
var
  p:Tarray<string>;
  {$ENDIF}
begin   //
  PhotoOrga := TPhotoOrga.Create;
  fAufgaben := TAufgaben.Create;
  TabControl.TabPosition := TTabPosition.None;
  fTabVerlauf := TList<TTabItem>.Create;



  {$IFDEF ANDROID}
  p:=[JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)];
   PermissionsService.RequestPermissions(p,PermissionsResult,nil);
  {$ENDIF}

  fFormAlben := Tfrm_Alben.Create(Self);
  while fFormAlben.ChildrenCount > 0 do
    fFormAlben.Children[0].Parent := tbs_Main;
  Tfrm_Base(fFormAlben).OnBack := doBack;
  fFormAlben.OnAlbumClick := AlbumClick;

  fFormBilder := Tfrm_Bilder2.Create(Self);
  while fFormBilder.ChildrenCount > 0 do
    fFormBilder.Children[0].Parent := tbs_Bilder;
  Tfrm_Base(fFormBilder).OnBack := doBack;
  fFormBilder.onBildClick := BildClick;

  fFormBild := Tfrm_Bild.Create(Self);
  while fFormBild.ChildrenCount > 0 do
    fFormBild.Children[0].Parent := tbs_Bild;
  Tfrm_Base(fFormBild).OnBack := doBack;

  fFormSplash := Tfrm_Splash.Create(Self);
  while fFormSplash.ChildrenCount > 0 do
    fFormSplash.Children[0].Parent := tbs_Splash;
  Tfrm_Base(fFormBild).OnBack := doBack;
  fFormSplash.OnEndSplashAktualBildObjekt := EndSplashAktualBildObjekt;


  //setTabActiv(tbs_Main);
  setTabActiv(tbs_Splash);


end;

procedure Tfrm_PhotoOrga.FormDestroy(Sender: TObject);
begin  //
  fTabVerlauf.DisposeOf;
  FreeAndNil(fAufgaben);
  FreeAndNil(PhotoOrga);
end;

procedure Tfrm_PhotoOrga.FormShow(Sender: TObject);
begin
  dm_db.Connect;
  PhotoOrga.Connection  := dm_db.Connection;
  PhotoOrga.QueueList.Add(c_quAktualThumbnails);
  PhotoOrga.QueueList.Add(c_quReadAllBilder);
  fAufgaben.OnEndReadAllBilder := EndLoadAlleBilder;
  //fAufgaben.OnEndAktualThumbnails := EndLoadAlleBilder;
  fFormSplash.setActiv;
 //fAufgaben.Start;
 //fFormAlben.setActiv;
 // fFormAlben.LoadAlben;
 // PhotoOrga.sendNotification('Das ist eine Testbenachrichtigung');

end;


{$IFDEF ANDROID}
procedure Tfrm_PhotoOrga.PermissionsResult(Sender: TObject;
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
 var
  n:integer;
 begin
  if length(AGrantResults)>0 then
   for n:=0 to length(AGrantResults)-1 do
    if not (AGrantResults[n] = TPermissionStatus.Granted) then fOK:=false;
 end;
{$ENDIF}


procedure Tfrm_PhotoOrga.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  fAufgaben.Stop;
end;


procedure Tfrm_PhotoOrga.Albumclick(Sender: TObject);
var
  Album: Tfra_Album;
begin
  Album := Tfra_Album(Sender);
//  fFormBilder.LadeBilder(Album.Pfad, '*.jpg');
  fFormBilder.LadeBilder(Album.Pfad);
  setTabActiv(tbs_Bilder);
end;

procedure Tfrm_PhotoOrga.BildClick(Sender: TObject; aItemIndex: Integer);
begin
  setTabActiv(tbs_Bild);
  fFormBild.setBild(TBild(Sender));
  //fFormBild.setDBBilderList(TDBBilderList(Sender));
  //fFormBild.LadeBild(aItemIndex);
end;

procedure Tfrm_PhotoOrga.DoBack(Sender: TObject);
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

procedure Tfrm_PhotoOrga.DoExit(Sender: TObject);
begin
  //setTabActiv(tbs_Login);
  fTabVerlauf.Clear;
end;


procedure Tfrm_PhotoOrga.EndLoadAlleBilder(Sender: TObject);
begin
 //PhotoOrga.sendNotification('Tfrm_PhotoOrga.EndLoadAlleBilder');
  fFormAlben.setActiv;
  Invalidate;
  //fFormAlben.LoadAlben;
end;

procedure Tfrm_PhotoOrga.EndSplashAktualBildObjekt(Sender: TObject);
begin
  setTabActiv(tbs_Main);
  fFormAlben.setActiv;
  //fAufgaben.Start;
end;

procedure Tfrm_PhotoOrga.setTabActiv(aTab: TTabItem);
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


procedure Tfrm_PhotoOrga.TabControlGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  //caption := 'Hurra';
end;

initialization
{$IFDEF WIN32x}
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
{$ENDIF}
end.
