unit Form.StatistikMonate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, FMX.Layouts, Json.EnergieverbrauchZaehler,
  Objekt.StatistikJahreMonatList;

type
  Tfrm_StatistikMonate = class(Tfrm_Base)
    Chart: TChart;
    Series1: TBarSeries;
    Layout1: TLayout;
    Layout2: TLayout;
    cbx_VonMonat: TComboBox;
    edt_VonJahr: TEdit;
    cbx_BisMonat: TComboBox;
    edt_BisJahr: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbx_VonMonatChange(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fStatistikJahreMonatList: TStatistikJahreMonatsList;
    function getWert(aMonat, aJahr: Integer): Extended;
    procedure UpdateChart;
  public
    procedure setActiv; override;
    procedure setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
    procedure ReadVerbrauchMonatListImJahr;
  end;

var
  frm_StatistikMonate: Tfrm_StatistikMonate;

implementation

{$R *.fmx}

{ Tfrm_StatistikMonate }

uses
  DateUtils, Objekt.JEnergieverbrauch, Payload.EnergieverbrauchVerbrauchMonate,
  JSON.EnergieverbrauchVerbrauchMonateList, Objekt.StatistikMonatList, Objekt.StatistikMonat;


procedure Tfrm_StatistikMonate.FormCreate(Sender: TObject);
begin //
  inherited;
  cbx_VonMonat.ItemIndex := MonthOf(now);
  cbx_BisMonat.ItemIndex := MonthOf(now);
  edt_VonJahr.Text := IntToStr(YearOf(IncYear(now, -1)));
  edt_BisJahr.Text := IntToStr(YearOf(now));
  fStatistikJahreMonatList := TStatistikJahreMonatsList.Create;
end;

procedure Tfrm_StatistikMonate.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fStatistikJahreMonatList);
  inherited;
end;


procedure Tfrm_StatistikMonate.cbx_VonMonatChange(Sender: TObject);
begin
  setActiv;

end;



procedure Tfrm_StatistikMonate.ReadVerbrauchMonatListImJahr;
var
  Jahr: Integer;
  i1: Integer;
  PVerbrauchMonate: TPEnergieverbrauchVerbrauchMonate;
  JMonatList: TJEnergieverbrauchVerbrauchMonateList;
  StatistikMonatList: TStatistikMonatList;
  StatistikMonat: TStatistikMonat;
begin
  //JEnergieverbrauch.ReadVerbrauchMonatListImJahr();
  fStatistikJahreMonatList.Clear;
  JMonatList := TJEnergieverbrauchVerbrauchMonateList.Create;
  PVerbrauchMonate := TPEnergieverbrauchVerbrauchMonate.Create;
  try
    PVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger := fJZaehler.FieldByName('ZA_ID').AsInteger;
    for Jahr := StrToInt(edt_VonJahr.Text) to StrToInt(edt_BisJahr.Text) do
    begin
      PVerbrauchMonate.FieldByName('Jahr').AsInteger := Jahr;
      JMonatList.JsonString := JEnergieverbrauch.ReadVerbrauchMonatListImJahr(PVerbrauchMonate.JsonString);

      StatistikMonatList := fStatistikJahreMonatList.Add(Jahr);
      for i1 := 0 to JMonatList.Count -1 do
      begin
        StatistikMonat := StatistikMonatList.Add;
        StatistikMonat.Monat := JMonatList.Item[i1].FieldByName('VM_MONAT').AsInteger;
        StatistikMonat.Wert  := StrToCurr(JMonatList.Item[i1].FieldByName('VM_WERT').AsString);
      end;

    end;
  finally
    FreeAndNil(PVerbrauchMonate);
    FreeAndNil(JMonatList);
  end;

end;

procedure Tfrm_StatistikMonate.setActiv;
begin
  inherited;
  if fJZaehler = nil then
    exit;
  ReadVerbrauchMonatListImJahr;
  UpdateChart;
end;

procedure Tfrm_StatistikMonate.setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
begin
  fJZaehler := aJZaehler;
end;


procedure Tfrm_StatistikMonate.UpdateChart;
var
  iMonth: Integer;  // = x Achse
  Wert: Extended;
  Jahr: Integer;
  Monat: Integer;
begin //

  chart.Series[0].Clear;
  Jahr := StrToInt(edt_VonJahr.Text);
  for Monat := cbx_VonMonat.ItemIndex+1 to 12 do
  begin
    Wert := getWert(Monat, Jahr);
    Chart.Series[0].AddXY(Monat, Wert);
  end;

  Jahr := StrToInt(edt_BisJahr.Text);
  for Monat := cbx_bisMonat.ItemIndex +1 to 12 do
  begin
    Wert := getWert(Monat, Jahr);
    Chart.Series[0].AddXY(Monat, Wert);
  end;
end;

function Tfrm_StatistikMonate.getWert(aMonat, aJahr: Integer): Extended;
var
  StatistikMonatList: TStatistikMonatList;
  StatistikMonat: TStatistikMonat;
begin
  StatistikMonatList := fStatistikJahreMonatList.getJahr(aJahr);
  Result := StatistikMonatList.Item[aMonat-1].Wert;
end;


end.
