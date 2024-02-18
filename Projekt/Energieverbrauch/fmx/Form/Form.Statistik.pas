unit Form.Statistik;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.DateTimeCtrls, Json.EnergieverbrauchZaehlerstandList, Json.EnergieverbrauchZaehlerstand, Json.EnergieverbrauchZaehler,
  FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.TabControl,
  FMX.MultiView, Form.StatistikMonate, Form.StatistikMonateVgl;

type
  Tfrm_Statistik = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    TabControl: TTabControl;
    gly_Menu: TGlyph;
    MultiView: TMultiView;
    tbs_StatistikMonate: TTabItem;
    TabItem2: TTabItem;
    tbs_StatistikMonateVgl: TTabItem;
    Lay_StatistikMonate: TLayout;
    Label1: TLabel;
    Gly_Host: TGlyph;
    Lay_StatistikMonateVgl: TLayout;
    Label2: TLabel;
    Glyph1: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Lay_StatistikMonateClick(Sender: TObject);
    procedure Lay_StatistikMonateVglClick(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fJZaehlerstandList : TJEnergieverbrauchZaehlerstandList;
    fFormStatistikMonate: Tfrm_StatistikMonate;
    fFormStatistikMonateVgl: Tfrm_StatistikMonateVgl;
    procedure Back(Sender: TObject);
    procedure ShowStatistikMonate;
    procedure ShowStatistikMonateVgl;
    procedure MenuClick(Sender: TObject);
    //procedure ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
    //procedure UpdateChart;
    //function getWert(aMonat, aJahr: Integer): Extended;
  public
    procedure setActiv; override;
    procedure setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
  end;

var
  frm_Statistik: Tfrm_Statistik;

implementation

{$R *.fmx}

uses
  DateUtils, Objekt.JEnergieverbrauch;



procedure Tfrm_Statistik.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
  gly_Menu.HitTest := true;
  gly_Menu.OnClick := MenuClick;

  Lay_StatistikMonate.HitTest := true;
  Lay_StatistikMonateVgl.HitTest := true;

  fJZaehler := nil;
  fJZaehlerstandList := TJEnergieverbrauchZaehlerstandList.Create;

  TabControl.TabPosition := TTabPosition.None;

  fFormStatistikMonate := Tfrm_StatistikMonate.Create(Self);
  while fFormStatistikMonate.ChildrenCount > 0 do
    fFormStatistikMonate.Children[0].Parent := tbs_StatistikMonate;

  fFormStatistikMonateVgl := Tfrm_StatistikMonateVgl.Create(Self);
  while fFormStatistikMonateVgl.ChildrenCount > 0 do
    fFormStatistikMonateVgl.Children[0].Parent := tbs_StatistikMonateVgl;


  MultiView.Width := 250;
  MultiView.Mode := TMultiViewMode.Drawer;


end;

procedure Tfrm_Statistik.FormDestroy(Sender: TObject);
begin   //
  if fJZaehlerstandList <> nil then
    FreeAndNil(fJZaehlerstandList);
  inherited;
end;

procedure Tfrm_Statistik.Lay_StatistikMonateClick(Sender: TObject);
begin
  MultiView.HideMaster;
  ShowStatistikMonate;
end;

procedure Tfrm_Statistik.Lay_StatistikMonateVglClick(Sender: TObject);
begin
  MultiView.HideMaster;
  ShowStatistikMonateVgl;
end;

procedure Tfrm_Statistik.MenuClick(Sender: TObject);
begin
  MultiView.ShowMaster;
end;

procedure Tfrm_Statistik.setActiv;
begin
  inherited;
 // edt_Datumbis.Date := trunc(now);
  //edt_Datumvon.Date := IncYear(now, -1);
  //edt_Datumvon.Date := StrToDate('01.01.2023');
  //ReadZaehlerstandZeitraum(edt_DatumVon.Date, edt_Datumbis.Date);
end;

procedure Tfrm_Statistik.setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
begin
  fJZaehler := aJZaehler;
  ShowStatistikMonate;
end;


procedure Tfrm_Statistik.ShowStatistikMonate;
begin
  TabControl.ActiveTab := tbs_StatistikMonate;
  fFormStatistikMonate.setZaehler(fJZaehler);
  fFormStatistikMonate.setActiv;

end;

procedure Tfrm_Statistik.ShowStatistikMonateVgl;
begin
  TabControl.ActiveTab := tbs_StatistikMonateVgl;
  fFormStatistikMonateVgl.setZaehler(fJZaehler);
  fFormStatistikMonateVgl.setActiv;
end;

procedure Tfrm_Statistik.Back(Sender: TObject);
begin
  DoZurueck(Self);
end;

{
procedure Tfrm_Statistik.ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
var
  JZaehlerstand: TJEnergieverbrauchZaehlerstand;
begin //
  if fJZaehler = nil then
    exit;
  JZaehlerstand := TJEnergieverbrauchZaehlerstand.Create;
  try
    JZaehlerstand.FieldByName('DATUMVON').AsDateTime := trunc(aDatumVon);
    JZaehlerstand.FieldByName('DATUMBIS').AsDateTime := trunc(aDatumBis);
    JZaehlerstand.FieldByName('ZS_ZA_ID').AsInteger := fJZaehler.FieldByName('ZA_ID').AsInteger;
    fJZaehlerstandList.JsonString := JEnergieverbrauch.ReadZaehlerstandListInZeitraum(JZaehlerstand.JsonString);
  finally
    FreeAndNil(JZaehlerstand);
  end;
  UpdateChart;
end;


procedure Tfrm_Statistik.UpdateChart;
var
  iMonth: Integer;  // = x Achse
//  i1: Integer;
  Wert: Extended;
begin //
  for iMonth := 1 to 12 do
  begin
    Wert := getWert(iMonth, 2023);
    Chart.Series[0].AddXY(iMonth, Wert);
  end;
end;

function Tfrm_Statistik.getWert(aMonat, aJahr: Integer): Extended;
var
  i1: Integer;
  Jahr: Integer;
  Monat: Integer;
begin
  Result := 0;
  for i1 := 0 to fJZaehlerstandList.Count -1 do
  begin
    Jahr := YearOf(fJZaehlerstandList.Item[i1].FieldByName('ZS_DATUM').AsDateTime);
    Monat := MonthOf(fJZaehlerstandList.Item[i1].FieldByName('ZS_DATUM').AsDateTime);
    if  (Jahr = aJahr)
    and (Monat = aMonat) then
    begin
      Result := fJZaehlerstandList.Item[i1].FieldByName('VERBRAUCH').AsFloat;
      exit;
    end;
  end;
end;

}
end.
