unit Form.Mitteilungseinstellung;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.Objects, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation;

type
  Tfrm_Mitteilungseinstellung = class(TForm)
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    Lay_Ueberschrift: TLayout;
    Label2: TLabel;
    lbl_DatenInAppAktualisiert: TText;
    Lay_DatenInAppAktualisiert: TLayout;
    sw_DatenInAppAktualisiert: TSwitch;
    lay_AlleZaehlerstaendewurdengeladen: TLayout;
    lbl_AlleZaehlerstaendewurdengeladen: TText;
    sw_AlleZaehlerstaendewurdengeladen: TSwitch;
    Lay_NeueAufgaben: TLayout;
    lbl_NeueAufgaben: TText;
    sw_NeueAufgaben: TSwitch;
    Lay_DatenWurdenAktualisiert: TLayout;
    lbl_DatenWurdenAktualisiert: TText;
    sw_DatenWurdenAktualisiert: TSwitch;
    lay_ZaehlerstaendeAktualisiert: TLayout;
    lbl_ZaehlerstaendeAktualisiert: TText;
    sw_ZaehlerstaendeAktualisiert: TSwitch;
    Lay_ZaehlerstandeUploaded: TLayout;
    lbl_ZaehlerstandeUploaded: TText;
    Sw_ZaehlerstandeUploaded: TSwitch;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sw_DatenInAppAktualisiertSwitch(Sender: TObject);
    procedure sw_AlleZaehlerstaendewurdengeladenSwitch(Sender: TObject);
    procedure sw_DatenWurdenAktualisiertSwitch(Sender: TObject);
    procedure sw_NeueAufgabenSwitch(Sender: TObject);
    procedure sw_ZaehlerstaendeAktualisiertSwitch(Sender: TObject);
    procedure Sw_ZaehlerstandeUploadedSwitch(Sender: TObject);
  private
    fOnZurueck: TNotifyEvent;
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
  end;

var
  frm_Mitteilungseinstellung: Tfrm_Mitteilungseinstellung;

implementation

{$R *.fmx}

uses
  Objekt.BasCloud;

procedure Tfrm_Mitteilungseinstellung.FormCreate(Sender: TObject);
begin
  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;

  //Lay_NeueAufgaben.Visible := false;

  sw_DatenInAppAktualisiert.IsChecked := BasCloud.Ini.Mitteilungseinstellung.DatenInAppAktualisiert;
  sw_AlleZaehlerstaendewurdengeladen.IsChecked := BasCloud.Ini.Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen;
  sw_DatenWurdenAktualisiert.IsChecked := BasCloud.Ini.Mitteilungseinstellung.DatenWurdenAktualisiert;
  sw_NeueAufgaben.IsChecked := BasCloud.Ini.Mitteilungseinstellung.NeueAufgaben;
  sw_ZaehlerstaendeAktualisiert.IsChecked := BasCloud.Ini.Mitteilungseinstellung.ZaehlerstaendeAktualisiert;
  Sw_ZaehlerstandeUploaded.IsChecked := BasCloud.Ini.Mitteilungseinstellung.ZaehlerWurdeHochgeladen;

end;

procedure Tfrm_Mitteilungseinstellung.FormDestroy(Sender: TObject);
begin  //

end;

procedure Tfrm_Mitteilungseinstellung.sw_AlleZaehlerstaendewurdengeladenSwitch(
  Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.AlleZaehlerstaendewurdengeladen := sw_AlleZaehlerstaendewurdengeladen.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.sw_DatenInAppAktualisiertSwitch(
  Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.DatenInAppAktualisiert := sw_DatenInAppAktualisiert.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.sw_DatenWurdenAktualisiertSwitch(Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.DatenWurdenAktualisiert := sw_DatenWurdenAktualisiert.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.sw_NeueAufgabenSwitch(Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.NeueAufgaben := sw_NeueAufgaben.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.sw_ZaehlerstaendeAktualisiertSwitch(
  Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.ZaehlerstaendeAktualisiert := sw_ZaehlerstaendeAktualisiert.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.Sw_ZaehlerstandeUploadedSwitch(
  Sender: TObject);
begin
  BasCloud.Ini.Mitteilungseinstellung.ZaehlerWurdeHochgeladen := Sw_ZaehlerstandeUploaded.IsChecked;
end;

procedure Tfrm_Mitteilungseinstellung.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

end.
