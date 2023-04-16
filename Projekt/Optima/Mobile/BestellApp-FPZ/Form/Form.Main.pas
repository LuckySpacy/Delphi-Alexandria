unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Effects, c.Events;

type
  Tfrm_Main = class(Tfrm_Base)
    gly_Exit: TGlyph;
    Layout7: TLayout;
    Label2: TLabel;
    lbl_Anmeldename: TLabel;
    lay_Bilder: TLayout;
    gly_Einstellung: TGlyph;
    Lay_Form: TLayout;
    Lay_Scanner: TLayout;
    btn_Scanner: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ASSButtonStyleApplyStyleLookup(Sender: TObject);
    procedure ASSButtonStyleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ASSButtonStyleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btn_ScannerClick(Sender: TObject);
  private
    fOnSettings: TNotifyEvent;
    fOnExit: TNotifyEvent;
    fOnArtikelabfrage: TStringNotifyEvent;
  public
    procedure setActiv; override;
    property OnSettings:TNotifyEvent read fOnSettings write fOnSettings;
    property OnExit:TNotifyEvent read fOnExit write fOnExit;
    procedure SettingsClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    property OnArtikelabfrage: TStringNotifyEvent read fOnArtikelabfrage write fOnArtikelabfrage;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.fmx}

{ Tfrm_Main }

uses
  Objekt.FPZ, datenmodul.Bilder, Thread.Artikel;


procedure Tfrm_Main.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Einstellung.OnClick := SettingsClick;
  gly_Einstellung.HitTest := true;
  gly_Exit.OnClick := ExitClick;
  gly_Exit.HitTest := true;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Main.setActiv;
begin
  lbl_Anmeldename.Text := fpz.User.Vorname + ' ' + fpz.User.Nachname;
  dm_Bilder.ASSButtonStyleMouseDown(btn_Scanner);
  dm_Bilder.ASSButtonStyleMouseUp(btn_Scanner);
end;

procedure Tfrm_Main.SettingsClick(Sender: TObject);
begin
  if Assigned(fOnSettings) then
    fOnSettings(Self);
end;


procedure Tfrm_Main.ASSButtonStyleApplyStyleLookup(Sender: TObject);
begin
  dm_Bilder.ASSButtonStyleApplyStyleLookup(Sender);
end;

procedure Tfrm_Main.ASSButtonStyleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  dm_Bilder.ASSButtonStyleMouseDown(Sender);
end;

procedure Tfrm_Main.ASSButtonStyleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  dm_Bilder.ASSButtonStyleMouseUp(Sender);
end;

procedure Tfrm_Main.btn_ScannerClick(Sender: TObject);
begin
  if Assigned(fonArtikelabfrage) then
    fOnArtikelabfrage(Self, '3574660527377');
end;

procedure Tfrm_Main.ExitClick(Sender: TObject);
begin
  if Assigned(fOnExit) then
    fOnExit(Self);
end;





end.
