unit Form.DatenModify;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Edit,
  FMX.Layouts, Objekt.JZaehler, oBjekt.JZaehlerstand;

type
  Tfrm_DatenModify = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    Label1: TLabel;
    lbl_Ablesedatum: TLabel;
    Label2: TLabel;
    edt_Zaehlerstand: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fJZaehler: TJZaehler;
    fZaehlerdatum: TDateTime;
    procedure Back(Sender: TObject);
  public
    procedure setZaehler(aJZaehler: TJZaehler);
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
end;

procedure Tfrm_DatenModify.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_DatenModify.setZaehler(aJZaehler: TJZaehler);
begin
  fJZaehler := aJZaehler;
  fZaehlerdatum := now;
  lbl_Ablesedatum.Text := FormatDateTime('dd.mm.yyyy hh:nn:ss', fZaehlerdatum);
  edt_Zaehlerstand.Text := '';
  edt_Zaehlerstand.SetFocus;
end;

procedure Tfrm_DatenModify.Back(Sender: TObject);
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
      JZaehlerstand.FieldByName('ZS_DATUM').AsDateTime  := fZaehlerdatum;
      JsonString := JZaehlerstand.JsonString;
      JEnergieverbrauch.AddZaehlerstand(JsonString);
    finally
      FreeAndNil(JZaehlerstand);
    end;
  end;
  DoZurueck(Self);
end;


end.
