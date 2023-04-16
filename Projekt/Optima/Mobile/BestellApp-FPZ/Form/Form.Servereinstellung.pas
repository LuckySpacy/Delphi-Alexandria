unit Form.Servereinstellung;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Objects, FMX.Edit, FMX.Controls.Presentation, Thread.ALive,
  FMX.ImgList, FMX.Layouts;

type
  Tfrm_Servereinstellung = class(Tfrm_Base)
    lbl_Serveradresse: TLabel;
    edt_Serveradresse: TEdit;
    gly_Back: TGlyph;
    Lay_Form: TLayout;
    Lay_Serveradresse: TLayout;
    Lay_btnSpeichern: TLayout;
    btn_Speichern: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
    procedure edt_ServeradresseApplyStyleLookup(Sender: TObject);
  private
    fThreadALive: TThreadALive;
    procedure ALiveSuccess(Sender: TObject);
    procedure ALiveFailed(Sender: TObject);
  public
    procedure setActiv; override;
  end;

var
  frm_Servereinstellung: Tfrm_Servereinstellung;

implementation

{$R *.fmx}

uses
  Objekt.fpz, Fmx.DialogService, Objekt.JFPZ, datenmodul.Bilder;


procedure Tfrm_Servereinstellung.FormCreate(Sender: TObject);
begin  //
  inherited;
  fThreadALive := TThreadALive.Create;
  fThreadALive.OnSuccess := ALiveSuccess;
  fThreadALive.OnFailed  := ALiveFailed;
  gly_Back.OnClick := GoBack;
  gly_Back.HitTest := true;
end;

procedure Tfrm_Servereinstellung.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fThreadALive);
  inherited;
end;

procedure Tfrm_Servereinstellung.setActiv;
begin
  edt_Serveradresse.Text := fpz.Ini.Serveradresse;
end;


procedure Tfrm_Servereinstellung.ALiveFailed(Sender: TObject);
begin
  TDialogService.ShowMessage('Serververbindung ist fehlgeschlagen');
end;

procedure Tfrm_Servereinstellung.ALiveSuccess(Sender: TObject);
begin
  TDialogService.ShowMessage('Serververbindung wurde hergestellt');
end;

procedure Tfrm_Servereinstellung.btn_SpeichernClick(Sender: TObject);
begin
  FPZ.Ini.Serveradresse := edt_Serveradresse.Text;
  JFPZ.setBaseUrl(FPZ.Ini.Serveradresse);
  fThreadALive.Check;
end;


procedure Tfrm_Servereinstellung.edt_ServeradresseApplyStyleLookup(
  Sender: TObject);
var
  Obj: Tfmxobject;
begin
  Obj := edt_Serveradresse.FindStyleResource('Glyph');
  if (Obj <> nil) and (Obj is TGlyph) then
  begin
    TGlyph(Obj).Images := dm_Bilder.iml_16;
    TGlyph(Obj).ImageIndex := 8;
  end;
end;

end.
