unit Form.PhotoOrga;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  Objekt.PhotoOrga, Objekt.Aufgaben;

type
  Tfrm_PhotoOrga = class(TForm)
    TabControl: TTabControl;
    tbs_Main: TTabItem;
    tbs_Bilder: TTabItem;
    tbs_Bild: TTabItem;
    tbs_Splash: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    fAufgaben: TAufgaben;
    procedure AufgabeGestopt(Sender: TObject);
  public
  end;

var
  frm_PhotoOrga: Tfrm_PhotoOrga;

implementation

{$R *.fmx}

uses
{$IFDEF WIN32}
  FASTMM5,
{$ENDIF}
  Fmx.DialogService, Datenmodul.db;


procedure Tfrm_PhotoOrga.FormCreate(Sender: TObject);
begin
  PhotoOrga := TPhotoOrga.Create;
  fAufgaben := TAufgaben.Create;
end;

procedure Tfrm_PhotoOrga.FormDestroy(Sender: TObject);
begin
  FreeAndNil(PhotoOrga);
  FreeAndNil(fAufgaben);
end;

procedure Tfrm_PhotoOrga.FormShow(Sender: TObject);
begin
  PhotoOrga.RequestPermissions;
  dm_db.Connect;
  fAufgaben.Start;
  //PhotoOrga.sendNotification('Hurra');
end;

procedure Tfrm_PhotoOrga.AufgabeGestopt(Sender: TObject);
begin
  close;
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
{$ENDIF}

end.
