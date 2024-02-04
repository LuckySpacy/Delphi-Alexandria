unit Form.Statistik;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.DateTimeCtrls, Json.EnergieverbrauchZaehlerstandList, Json.EnergieverbrauchZaehlerstand, Json.EnergieverbrauchZaehler,
  FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart;

type
  Tfrm_Statistik = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    gly_Add: TGlyph;
    Layout1: TLayout;
    Label1: TLabel;
    edt_Datumvon: TDateEdit;
    edt_Datumbis: TDateEdit;
    Chart: TChart;
    Series1: TBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fJZaehlerstandList : TJEnergieverbrauchZaehlerstandList;
    procedure Back(Sender: TObject);
    procedure ReadZaehlerstandZeitraum(aDatumVon, aDatumBis: TDateTime);
    procedure UpdateChart;
    function getWert(aMonat, aJahr: Integer): Extended;
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
  fJZaehler := nil;
  fJZaehlerstandList := TJEnergieverbrauchZaehlerstandList.Create;
end;

procedure Tfrm_Statistik.FormDestroy(Sender: TObject);
begin   //
  if fJZaehlerstandList <> nil then
    FreeAndNil(fJZaehlerstandList);
  inherited;
end;

procedure Tfrm_Statistik.setActiv;
begin
  inherited;
  edt_Datumbis.Date := trunc(now);
  //edt_Datumvon.Date := IncYear(now, -1);
  edt_Datumvon.Date := StrToDate('01.01.2023');
  ReadZaehlerstandZeitraum(edt_DatumVon.Date, edt_Datumbis.Date);
end;

procedure Tfrm_Statistik.setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
begin
  fJZaehler := aJZaehler;
end;


procedure Tfrm_Statistik.Back(Sender: TObject);
begin
  DoZurueck(Self);
end;

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


end.
