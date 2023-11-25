unit Form.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  Objekt.PhotoOrga, Objekt.Aufgaben, Form.Alben, Form.Base,
  System.Generics.Collections, Form.Bilder, Form.Bild, FMX.Gestures,
  Form.Fortschritt;

type
  Tfrm_PhotoOrga = class(TForm)
    TabControl: TTabControl;
    tbs_Main: TTabItem;
    tbs_Bilder: TTabItem;
    tbs_Bild: TTabItem;
    tbs_Splash: TTabItem;
    GestureManager1: TGestureManager;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fAufgaben: TAufgaben;
    fFormAlben: Tfrm_Alben;
    fFormBilder: Tfrm_Bilder;
    fFormBild: Tfrm_Bild;
    fFormFortschritt: Tfrm_Fortschritt;
    fTabVerlauf : TList<TTabItem>;
    procedure AufgabeGestopt(Sender: TObject);
    procedure DoBack(Sender: TObject);
    procedure Albumclick(Sender: TObject);
    procedure BildClick(aIndex: string; aObject: TObject);
    procedure setTabActiv(aTab: TTabItem);
    procedure EndeLadeBildListFromDB(Sender: TObject);
  public
      property Fill;
  end;

var
  frm_PhotoOrga: Tfrm_PhotoOrga;

implementation

{$R *.fmx}

uses
{$IFDEF WIN32x}
  FASTMM5,
{$ENDIF}
  Fmx.DialogService, Datenmodul.db, types.PhotoOrga, Objekt.Album, Objekt.ReadFiles;


procedure Tfrm_PhotoOrga.FormCreate(Sender: TObject);
begin
  PhotoOrga := TPhotoOrga.Create;
  fAufgaben := TAufgaben.Create;
  fAufgaben.OnEndLadeBildListFromDB := EndeLadeBildListFromDB;
  fTabVerlauf := TList<TTabItem>.Create;

  fFormAlben := Tfrm_Alben.Create(Self);
  while fFormAlben.ChildrenCount > 0 do
    fFormAlben.Children[0].Parent := tbs_Main;
  tbs_main.TagObject := fFormAlben;
  Tfrm_Base(fFormAlben).OnBack := doBack;
  fFormAlben.OnAlbumClick := AlbumClick;


  fFormBilder := Tfrm_Bilder.Create(Self);
  while fFormBilder.ChildrenCount > 0 do
    fFormBilder.Children[0].Parent := tbs_Bilder;
  tbs_Bilder.TagObject := fFormBilder;
  Tfrm_Base(fFormBilder).OnBack := doBack;
  fFormBilder.OnBildClick := BildClick;

  fFormBild := Tfrm_Bild.Create(Self);
  while fFormBild.ChildrenCount > 0 do
    fFormBild.Children[0].Parent := tbs_Bild;
  tbs_Bild.TagObject := fFormBild;
  Tfrm_Base(fFormBild).OnBack := doBack;


  fFormFortschritt := Tfrm_Fortschritt.Create(Self);
  while fFormFortschritt.ChildrenCount > 0 do
    fFormFortschritt.Children[0].Parent := tbs_main;
  tbs_Main.TagObject := fFormFortschritt;
  Tfrm_Base(fFormFortschritt).OnBack := doBack;

  fAufgaben.OnProgress := fFormFortschritt.Progress;
  fAufgaben.OnProgressMaxValue := fFormFortschritt.ProgressMaxValue;


end;

procedure Tfrm_PhotoOrga.FormDestroy(Sender: TObject);
begin
  fTabVerlauf.DisposeOf;
  FreeAndNil(PhotoOrga);
  FreeAndNil(fAufgaben);
end;


procedure Tfrm_PhotoOrga.FormShow(Sender: TObject);
var
  ReadFiles: TReadFiles;
begin
//  TDialogService.ShowMessage('test');
  PhotoOrga.RequestPermissions;
  dm_db.Connect;
  //fAufgaben.LadeBildListFromDB;
  setTabActiv(tbs_Main);
  //PhotoOrga.sendNotification('Hurra');
  PhotoOrga.QueueList.Add(TQueueProcess.c_quReadFiles);
  fAufgaben.Start;
  //PhotoOrga.sendNotification('Hurra');
  {
  ReadFiles := TReadFiles.Create;
  try
    ReadFiles.Start;
  finally
    FreeAndNil(ReadFiles);
  end;
  }
end;

procedure Tfrm_PhotoOrga.setTabActiv(aTab: TTabItem);
var
  i1: Integer;
begin
  fTabVerlauf.Add(aTab);
  TabControl.ActiveTab := aTab;
  if (aTab.TagObject <> nil) then
    Tfrm_Base(aTab.TagObject).setActiv;
    {
  for i1 := 0 to aTab.ComponentCount -1 do
  begin
    if (aTab.Components[i1] is TForm) then
      Tfrm_Base(aTab.Components[i1]).setActiv;
  end;
  }
end;

procedure Tfrm_PhotoOrga.Albumclick(Sender: TObject);
//var
//  Album: Tfra_Album;
begin
//  Album := Tfra_Album(Sender);
//  fFormBilder.LadeBilder(Album.Pfad, '*.jpg');
//  fFormBilder.LadeBilder(Album.Pfad);
  fFormBilder.LadeBilder(TAlbum(Sender));
  setTabActiv(tbs_Bilder);
end;

procedure Tfrm_PhotoOrga.AufgabeGestopt(Sender: TObject);
begin
  close;
end;

procedure Tfrm_PhotoOrga.BildClick(aIndex: string; aObject: TObject);
begin //
  fFormBild.LadeBild(TAlbum(aObject), aIndex);
  setTabActiv(tbs_bild);
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

procedure Tfrm_PhotoOrga.EndeLadeBildListFromDB(Sender: TObject);
begin //
  setTabActiv(tbs_Main);
end;

procedure Tfrm_PhotoOrga.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not fAufgaben.TimerRunning;
  if not CanClose then
  begin
    fAufgaben.OnStopTimer := AufgabeGestopt;
    fAufgaben.Stop;
  end;
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
