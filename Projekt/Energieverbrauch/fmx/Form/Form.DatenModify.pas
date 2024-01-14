unit Form.DatenModify;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Edit,
  FMX.Layouts, Objekt.JZaehler, oBjekt.JZaehlerstand, FMX.DateTimeCtrls;

type
  Tfrm_DatenModify = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edt_Zaehlerstand: TEdit;
    gly_Save: TGlyph;
    edt_Ablesedatum: TDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fJZaehler: TJZaehler;
    procedure Back(Sender: TObject);
    procedure save(Sender: TObject);
  public
    procedure setZaehler(aJZaehler: TJZaehler);
    procedure setActiv; override;
  end;

var
  frm_DatenModify: Tfrm_DatenModify;

implementation

{$R *.fmx}

uses
  Objekt.Energieverbrauch, Objekt.JEnergieverbrauch;


procedure Tfrm_DatenModify.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
  gly_Save.HitTest := true;
  gly_Save.OnClick := save;
end;

procedure Tfrm_DatenModify.FormDestroy(Sender: TObject);
begin //
  inherited;

end;


procedure Tfrm_DatenModify.setActiv;
begin
  inherited;
  edt_Ablesedatum.SetFocus;
end;

procedure Tfrm_DatenModify.setZaehler(aJZaehler: TJZaehler);
begin
  fJZaehler := aJZaehler;
  //lbl_Ablesedatum.Text := FormatDateTime('dd.mm.yyyy hh:nn:ss', fZaehlerdatum);
  edt_Ablesedatum.date := trunc(now);
  edt_Zaehlerstand.Text := '';
  edt_Zaehlerstand.SetFocus;
end;

procedure Tfrm_DatenModify.Back(Sender: TObject);
begin
  save(nil);
  DoZurueck(Self);
end;

procedure Tfrm_DatenModify.save(Sender: TObject);
var
  JsonString: String;
  JZaehlerstand: TJZaehlerstand;
begin
  if Trim(edt_Zaehlerstand.Text) > '' then
  begin
    JZaehlerstand := TJZaehlerstand.Create;
    try
      JZaehlerstand.FieldByName('ZS_ID').AsInteger      := 0;
      JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger   := fJZaehler.FieldByName('ZA_ID').AsInteger;
      JZaehlerstand.FieldByName('ZS_WERT').AsString     := Trim(edt_Zaehlerstand.Text);
      JZaehlerstand.FieldByName('ZS_DATUM').AsDateTime  := edt_Ablesedatum.Date;
      JsonString := JZaehlerstand.JsonString;
      JEnergieverbrauch.AddZaehlerstand(JsonString);
      edt_Zaehlerstand.Text := '';
      edt_Ablesedatum.SetFocus;
    finally
      FreeAndNil(JZaehlerstand);
    end;
  end;
end;



end.
