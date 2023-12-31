unit Form.ZaehlerModify;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.Edit, Objekt.JZaehler;

type
  Tfrm_ZaehlerModify = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    Layout1: TLayout;
    Label1: TLabel;
    edt_Zaehler: TEdit;
    btn_Save: TCornerButton;
    btn_Neu: TCornerButton;
    lay_Speichern: TLayout;
    lbl_Speichern: TLabel;
    gly_Speichern: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
  private
    fOnNewZaehler: TNotifyEvent;
    fJZaehler: TJZaehler;
    procedure Back(Sender: TObject);
  public
    procedure setZaehler(aJZaehler: TJZaehler);
    property OnNewZaehler: TNotifyEvent read fOnNewZaehler write fOnNewZaehler;
  end;

var
  frm_ZaehlerModify: Tfrm_ZaehlerModify;

implementation

{$R *.fmx}

{ Tfrm_ZaehlerModify }

uses
  Objekt.JEnergieverbrauch, Objekt.Energieverbrauch, FMX.DialogService,
  Datenmodul.Bilder;




procedure Tfrm_ZaehlerModify.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
  fJZaehler := nil;
  btn_Neu.Visible := false;
  lay_Speichern.HitTest := true;
  lay_Speichern.OnClick := btn_SaveClick;
  lbl_Speichern.HitTest := true;
  lbl_Speichern.OnClick := btn_SaveClick;
  gly_Speichern.HitTest := true;
  gly_Speichern.OnClick := btn_SaveClick;
  btn_Save.Visible := false;
end;

procedure Tfrm_ZaehlerModify.FormDestroy(Sender: TObject);
begin //
  inherited;

end;


procedure Tfrm_ZaehlerModify.setZaehler(aJZaehler: TJZaehler);
begin
  fJZaehler := aJZaehler;

  if aJZaehler = nil then
  begin
    //btn_Neu.Visible := true;
    exit;
  end;

  edt_Zaehler.Text := fJZaehler.FieldByName('ZA_ZAEHLER').AsString;
  //btn_Neu.Visible := false;
end;

procedure Tfrm_ZaehlerModify.Back(Sender: TObject);
begin
  DoZurueck(Self);

end;


procedure Tfrm_ZaehlerModify.btn_SaveClick(Sender: TObject);
var
  JZaehler: TJZaehler;
  s: string;
begin
  if fJZaehler = nil then
  begin
    JZaehler := TJZaehler.Create;
    try
      JZaehler.FieldByName('ZA_ZAEHLER').AsString :=  edt_Zaehler.Text;
      JEnergieverbrauch.AddZaehler(JZaehler.JsonString);
      Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
      if Assigned(fOnNewZaehler) then
        fOnNewZaehler(Self);
      s:= 'Zähler wurde angelegt.' + sLineBreak +
          'Möchten Sie weitere Zähler anlegen?';
      TDialogService.MessageDialog(s, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
                                procedure(const AResult: TModalResult)
                                begin
                                 if AResult = mrYes then
                                 begin
                                   edt_Zaehler.Text := '';
                                   exit;
                                 end
                                 else
                                 begin
                                   Back(nil);
                                 end;
                               end);
    finally
      FreeAndNil(JZaehler);
    end;
  end
  else
  begin
    fJZaehler.FieldByName('ZA_ZAEHLER').AsString :=  edt_Zaehler.Text;
    JEnergieverbrauch.AddZaehler(fJZaehler.JsonString);  // Patch Zähler
    Energieverbrauch.ZaehlerList.JsonString := JEnergieverbrauch.ReadZaehlerList;
    if Assigned(fOnNewZaehler) then
      fOnNewZaehler(Self);
    Back(nil);
  end;

  //JEnergieverbrauch.
end;



end.
