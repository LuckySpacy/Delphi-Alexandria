unit Form.Loginwahl;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  Tfrm_Loginwahl = class(TForm)
    lay_Top: TLayout;
    Image2: TImage;
    Image1: TImage;
    lbl_Datenschutzbestimmung: TLabel;
    lay_Center: TLayout;
    lay_Anmeldelabel: TLayout;
    lbl_1: TLabel;
    lay_BtnQrCode: TLayout;
    Rect_QrCode: TRectangle;
    ShadowEffect2: TShadowEffect;
    Layout6: TLayout;
    gly_Mail2: TGlyph;
    Label1: TLabel;
    lay_BtnEMail: TLayout;
    rect_Mail: TRectangle;
    ShadowEffect1: TShadowEffect;
    Layout2: TLayout;
    Glyph1: TGlyph;
    Label2: TLabel;
    lbl_Version: TLabel;
    Rec_Toolbar_Background: TRectangle;
    gly_Return: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure lbl_DatenschutzbestimmungClick(Sender: TObject);
    procedure rect_MailClick(Sender: TObject);
    procedure Rect_QrCodeClick(Sender: TObject);
  private
    fOnDatenschutzbestimmung: TNotifyEvent;
    fOnMail: TNotifyEvent;
    fOnQrCode: TNotifyEvent;
    fOnZurueck: TNotifyEvent;
    procedure btn_ReturnClick(Sender: TObject);
  public
    property OnQrCode: TNotifyEvent read fOnQrCode write fOnQrCode;
    property OnMail: TNotifyEvent read fOnMail write fOnMail;
    property OnDatenschutzbestimmung: TNotifyEvent read fOnDatenschutzbestimmung write fOnDatenschutzbestimmung;
    property OnZurueck: TNotifyEvent read fOnZurueck write fOnZurueck;
    procedure AktivateForm;
  end;

var
  frm_Loginwahl: Tfrm_Loginwahl;

implementation

{$R *.fmx}

uses
  Datenmodul.Style, system.DateUtils, Objekt.JBasCloud, Json.CurrentUser, Objekt.BasCloud,
  fmx.DialogService;

procedure Tfrm_Loginwahl.btn_ReturnClick(Sender: TObject);
begin
  if Assigned(fOnZurueck) then
    fOnZurueck(Self);
end;

procedure Tfrm_Loginwahl.FormCreate(Sender: TObject);
begin
  lbl_Version.Text := 'Version ' + BasCloud.Plattform.Version;
  gly_Return.HitTest := true;
  gly_return.OnClick := btn_ReturnClick;
  lay_Top.Visible := false;
  Rec_Toolbar_Background.Visible := false;
end;

procedure Tfrm_Loginwahl.AktivateForm;
begin
  if JBasCloud.TenantId = '' then
  begin
    lay_Top.Visible := true;
    Rec_Toolbar_Background.Visible := false;
  end
  else
  begin
    lay_Top.Visible := false;
    Rec_Toolbar_Background.Visible := true;
  end;

end;

procedure Tfrm_Loginwahl.lbl_DatenschutzbestimmungClick(Sender: TObject);
begin
  if Assigned(fOnDatenschutzbestimmung) then
    fOnDatenschutzbestimmung(Self);
end;

procedure Tfrm_Loginwahl.rect_MailClick(Sender: TObject);
begin
  if Assigned(fOnMail) then
    fOnMail(Self);
end;

procedure Tfrm_Loginwahl.Rect_QrCodeClick(Sender: TObject);
begin
  BasCloud.Ini.LoginPasswort := '';
  JBasCloud.Token := '';
  if Assigned(fOnQrCode) then
    fOnQrCode(Self);
end;

end.
