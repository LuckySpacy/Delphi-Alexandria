unit Form.Splash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, Thread.AktualThumbnails, Thread.AktualBildObjekt,
  FMX.Controls.Presentation;

type
  Tfrm_Splash = class(Tfrm_Base)
    AniIndicator1: TAniIndicator;
    lbl_Status: TLabel;
    pg: TProgressBar;
    lbl_PgInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fAktualThumbnails: TThreadAktualThumbnails;
    fAktualBildObject: TThreadAktualBildObjekt;
    fOnEndSplashAktualBildObjekt: TNotifyEvent;
    fFirstLoad: Boolean;
    procedure EndAktualBidObjekt(Sender: TObject);
    procedure EndAktualThumbnails(Sender: TObject);
  public
    procedure setActiv; override;
    property OnEndSplashAktualBildObjekt: TNotifyEvent read fOnEndSplashAktualBildObjekt write fOnEndSplashAktualBildObjekt;
  end;

var
  frm_Splash: Tfrm_Splash;

implementation

{$R *.fmx}

uses
  Objekt.PhotoOrga;



procedure Tfrm_Splash.FormCreate(Sender: TObject);
begin //
  inherited;
  fAktualThumbnails := TThreadAktualThumbnails.Create;
  fAktualThumbnails.OnEnde := EndAktualThumbnails;
  fAktualBildObject := TThreadAktualBildObjekt.Create;
  fAktualBildObject.OnEnde := EndAktualBidObjekt;
  fAktualThumbnails.setProgressbar(pg);
  fAktualThumbnails.setLabelPgInfo(lbl_PgInfo);
  fFirstLoad := true;
  PhotoOrga.BilderList.Clear;
end;

procedure Tfrm_Splash.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fAktualThumbnails);
  FreeAndNil(fAktualBildObject);
  inherited;
end;

procedure Tfrm_Splash.setActiv;
begin
  inherited;
  lbl_Status.Text := 'Lade Alben';
  AniIndicator1.Enabled := true;
  fAktualBildObject.Start;
end;


procedure Tfrm_Splash.EndAktualThumbnails(Sender: TObject);
begin
  lbl_Status.Text := 'Lade Alben';
  fAktualBildObject.Start;
end;


procedure Tfrm_Splash.EndAktualBidObjekt(Sender: TObject);
begin
  if (PhotoOrga.BilderList.AlleBilder.Count = 0) and (fFirstLoad) then
  begin
    fFirstLoad := false;
    lbl_Status.Text := 'Thumbnails erzeugen';
    fAktualThumbnails.Start;
    exit;
  end;

  AniIndicator1.Enabled := false;
  if Assigned(fOnEndSplashAktualBildObjekt) then
    fOnEndSplashAktualBildObjekt(Self);
end;


end.
