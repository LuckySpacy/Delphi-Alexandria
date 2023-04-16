unit Form.Splash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, Thread.LadeDBDaten,
  db.ToDoList, Thread.LadeDaten;

type
   TProgressInfoEvent = procedure(aInfo: string; aIndex, aCount: Integer) of object;
  Tfrm_Splash = class(TForm)
    Rectangle2: TRectangle;
    img_Splash: TImage;
    ani_SplashWait: TAniIndicator;
    lbl_SplashStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fThreadLadeDaten: TThreadLadedaten;
    fThreadLadeDBDaten: TThreadLadeDBDaten;
    fOnEndeLadeDaten: TNotifyEvent;
    fOnEndeRefreshAufgabenListe: TNotifyEvent;
    fDBTodoList: TDBToDoList;
    fOnProgressInfo: TProgressInfoEvent;
    procedure LadeDatenEnde(Sender: TObject);
  public
    procedure LadeDaten;
    procedure RefreshAufgabenListe;
    property OnEndeLadeDaten: TNotifyEvent read fOnEndeLadeDaten write fOnEndeLadeDaten;
    property OnEndeRefreshAufgabenListe: TNotifyEvent read fOnEndeRefreshAufgabenListe write fOnEndeRefreshAufgabenListe;
    property OnProgressInfo: TProgressInfoEvent read fOnProgressInfo write fOnProgressInfo;
  end;

var
  frm_Splash: Tfrm_Splash;

implementation

{$R *.fmx}

{ Tfrm_Splash }

uses
  Objekt.BasCloud,  FMX.DialogService;

procedure Tfrm_Splash.FormCreate(Sender: TObject);
begin
  fDBTodoList := TDBToDoList.Create;
  fThreadLadeDBDaten := TThreadLadeDBDaten.Create;
  fThreadLadeDBDaten.setStatusLabel(lbl_SplashStatus);
  fThreadLadeDBDaten.OnEndeDatenLaden := LadeDatenEnde;
  fThreadLadeDaten := TThreadLadedaten.Create;
  fThreadLadeDaten.setStatusLabel(lbl_SplashStatus);
end;

procedure Tfrm_Splash.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fThreadLadeDBDaten);
  FreeAndNil(fDBTodoList);
  FreeAndNil(fThreadLadeDaten);
end;

procedure Tfrm_Splash.LadeDaten;
begin
  BasCloud.InitError;
  ani_SplashWait.Visible := true;
  ani_SplashWait.Enabled := true;
  fDBTodoList.ReadAll;
  if fDBTodoList.Count = 0 then
  begin
    fThreadLadeDaten.OnEndeDatenLaden := LadeDatenEnde;
    fThreadLadeDaten.Start;
  end
  else
    fThreadLadeDBDaten.Start;
end;

procedure Tfrm_Splash.LadeDatenEnde(Sender: TObject);
begin
  ani_SplashWait.Visible := false;
  ani_SplashWait.Enabled := false;
  if BasCloud.Error > '' then
  begin
    TDialogService.ShowMessage('xFehler:');
    TDialogService.ShowMessage(BasCloud.Error);
    fOnProgressInfo('Tfrm_Splash.LadeDatenEnde = ' + BasCloud.Error, 0,0);
  end;
  if Assigned(fOnEndeLadeDaten) then
    fOnEndeLadeDaten(Self);
end;

procedure Tfrm_Splash.RefreshAufgabenListe;
begin

end;

end.
