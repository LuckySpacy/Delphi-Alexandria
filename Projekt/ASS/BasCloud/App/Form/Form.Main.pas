unit Form.Main;

interface

{$I debug.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Layouts, FMX.ImgList, FMX.Objects,
  ASSQRCodeScanner;

type
  Tfrm_Main = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    gly_Exit: TGlyph;
    Layout7: TLayout;
    Label2: TLabel;
    lbl_Anmeldename: TLabel;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    btn_Photo: TCornerButton;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    ShadowEffect1: TShadowEffect;
    Layout5: TLayout;
    Glyph1: TGlyph;
    Layout8: TLayout;
    Scannen: TLabel;
    Layout9: TLayout;
    Layout10: TLayout;
    Label3: TLabel;
    Layout11: TLayout;
    lbl_OffeneAufgaben: TLabel;
    Layout12: TLayout;
    Layout13: TLayout;
    Ü: TLabel;
    Layout14: TLayout;
    lbl_UeberfaelligeAufgaben: TLabel;
    Layout4: TLayout;
    Ani_Wait: TAniIndicator;
    Rectangle3: TRectangle;
    ShadowEffect2: TShadowEffect;
    Layout6: TLayout;
    Glyph2: TGlyph;
    Label1: TLabel;
    Layout15: TLayout;
    AniIndicator1: TAniIndicator;
    btn_Konnetivitaet: TRectangle;
    ShadowEffect3: TShadowEffect;
    Layout16: TLayout;
    gly_Konnektivitaet: TGlyph;
    lay_KonnetivitaetText: TLayout;
    lbl_Konnektivitaet: TLabel;
    lbl_Konnektivitaet2: TLabel;
    lbl_Version: TLabel;
    btn_Log: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_LogoutClick(Sender: TObject);
    procedure btn_ScannerClick(Sender: TObject);
    procedure btn_KonnektivitaetClick(Sender: TObject);
    procedure btn_ToDoClick(Sender: TObject);
    procedure LoggerClick(Sender: TObject);
    procedure btn_LogClick(Sender: TObject);
    procedure lbl_AnmeldenameClick(Sender: TObject);
  private
    fOnAufgabe: TNotifyEvent;
    fOnLogout: TNotifyEvent;
    fOnScanner: TNotifyEvent;
    fScanner: TASSQRCodeScanner;
    fOnLog: TNotifyEvent;
    fOnMitteilungseinstellung: TNotifyEvent;
    procedure FrageNachUploadVorLogout;
    procedure CornerButtonApplyStyleLookup(Sender: TObject);
    procedure setKonnektivitaet;
    procedure DoLogout;
  public
    property OnLogout: TNotifyEvent read fOnLogout write fOnLogout;
    property OnScanner: TNotifyEvent read fOnScanner write fOnScanner;
    property OnAufgabe: TNotifyEvent read fOnAufgabe write fOnAufgabe;
    property OnLog: TNotifyEvent read fOnLog write fOnLog;
    property OnMitteilungseinstellung: TNotifyEvent read fOnMitteilungseinstellung write fOnMitteilungseinstellung;
    procedure AktivateForm;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.fmx}

{ Tfrm_Main }

uses
  Datenmodul.Style, Objekt.BasCloud, FMX.Media, FMX.DialogService;


procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  i1: Integer;
begin
  for i1 := 0 to ComponentCount -1 do
  begin
    if Components[i1] is TCornerButton then
    begin
      TCornerButton(Components[i1]).OnApplyStyleLookup := CornerButtonApplyStyleLookup;
      BasCloud.Style.setCornerButtonDefaultTextColor(TCornerButton(Components[i1]));
    end;
  end;
  lbl_Anmeldename.TextSettings.FontColor := TAlphaColors.White;

  fScanner := TASSQRCodeScanner.Create;

  gly_Exit.HitTest := true;
  gly_Exit.OnClick := btn_LogoutClick;

  setKonnektivitaet;

  lbl_Version.Text := 'Version ' + BasCloud.Plattform.Version;

  btn_log.Visible := false;

  {$IFDEF DEBUGMODE}
  btn_log.Visible := true;
  {$ENDIF DEBUGMODE}

end;


procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScanner);
end;



procedure Tfrm_Main.lbl_AnmeldenameClick(Sender: TObject);
begin
  if Assigned(fOnMitteilungseinstellung) then
    fOnMitteilungseinstellung(Self);
end;

procedure Tfrm_Main.CornerButtonApplyStyleLookup(Sender: TObject);
begin
  BasCloud.Style.setCornerButtonDefaultStyle(TCornerButton(Sender));
end;


procedure Tfrm_Main.AktivateForm;
begin
  lbl_OffeneAufgaben.Text        := IntToStr(BasCloud.AufgabeList.AnzahlOffeneAufgaben);
  lbl_UeberfaelligeAufgaben.Text := IntToStr(BasCloud.AufgabeList.AnzahlUeberfaelligeAufgaben);
end;




procedure Tfrm_Main.setKonnektivitaet;
begin
  Log.d('Tfrm_Main.setKonnektivitaet');
  if BasCloud.Ini.KonnektivitaetStatus.MobileDaten then
  begin
    lbl_Konnektivitaet.Text := 'Mobile Daten';
    lbl_Konnektivitaet2.Text := '(WiFi bevorzugt)';
    gly_Konnektivitaet.ImageIndex := 1;
  end;
  if BasCloud.Ini.KonnektivitaetStatus.Offline then
  begin
    lbl_Konnektivitaet.Text := 'Offline';
    lbl_Konnektivitaet2.Text := '(Keine Verbindung zur Cloud)';
    gly_Konnektivitaet.ImageIndex := 2;
  end;
  if BasCloud.Ini.KonnektivitaetStatus.Wifi then
  begin
    lbl_Konnektivitaet.Text := 'WiFi';
    lbl_Konnektivitaet2.Text := '(Verbindung nur über WLAN)';
    gly_Konnektivitaet.ImageIndex := 0;
  end;
end;




//******************************************************************************
//** Buttons
//******************************************************************************
procedure Tfrm_Main.btn_KonnektivitaetClick(Sender: TObject);
begin
  if BasCloud.Ini.KonnektivitaetStatus.Wifi then
  begin
    BasCloud.Ini.KonnektivitaetStatus.Offline := true;
    setKonnektivitaet;
    exit;
  end;

  if BasCloud.Ini.KonnektivitaetStatus.Offline then
  begin
    BasCloud.Ini.KonnektivitaetStatus.MobileDaten := true;
    setKonnektivitaet;
    exit;
  end;

  if BasCloud.Ini.KonnektivitaetStatus.MobileDaten then
  begin
    BasCloud.Ini.KonnektivitaetStatus.Wifi := true;
    setKonnektivitaet;
    exit;
  end;

end;

procedure Tfrm_Main.btn_LogoutClick(Sender: TObject);
var
  s: string;
begin

  s := 'Möchten Sie sich wirklich abmelden?';
  TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                               procedure(const AResult: TModalResult)
                               begin
                                 if AResult = mrYes then
                                 begin
                                   if BasCloud.AufgabeList.IsWaitingForUpload then
                                     FrageNachUploadVorLogout
                                   else
                                     DoLogout;
                                 end;
                               end);



end;

procedure Tfrm_Main.FrageNachUploadVorLogout;
var
  s: string;
begin
  s := 'Es wurden noch nicht alle erfassten Zählerstände hochgeladen. ' + sLineBreak +
       'Wenn Sie sich jetzt abmelden, dann werden diese Zählerstände nicht mehr hochgeladen.' + sLineBreak +
       'Möchten Sie sich trotzdem ausloggen?';

  TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                               procedure(const AResult: TModalResult)
                               begin
                                 if AResult = mrYes then
                                 begin
                                   DoLogout;
                                 end;
                               end);

end;

procedure Tfrm_Main.DoLogout;
begin
  if Assigned(fOnLogout) then
    fOnLogout(Self);
end;

procedure Tfrm_Main.btn_ScannerClick(Sender: TObject);
begin
  //BasCloud.sendNotification('Hurra eine Nachricht.');
  //exit;
  if Assigned(fOnScanner) then
    fOnScanner(Self);
end;

procedure Tfrm_Main.btn_ToDoClick(Sender: TObject);
begin
  if Assigned(fOnAufgabe) then
    fOnAufgabe(Self);
end;

procedure Tfrm_Main.btn_LogClick(Sender: TObject);
begin
  if Assigned(fOnLog) then
    fOnLog(Self);
end;

procedure Tfrm_Main.LoggerClick(Sender: TObject);
begin
  if Assigned(fOnLog) then
    fOnLog(Self);
end;



end.
