unit Form.StatistikMonateVgl;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart, Json.EnergieverbrauchZaehler,
  Objekt.StatistikJahreMonatList;

type
  Tfrm_StatistikMonateVgl = class(Tfrm_Base)
    Chart: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fStatistikJahreMonatList: TStatistikJahreMonatsList;
    procedure ReadVerbrauchMonatListImJahr;
    procedure UpdateChart;
  public
    procedure setActiv; override;
    procedure setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
  end;

var
  frm_StatistikMonateVgl: Tfrm_StatistikMonateVgl;

implementation

{$R *.fmx}

{ Tfrm_StatistikMonateVgl }

uses
  DateUtils, Objekt.JEnergieverbrauch, Payload.EnergieverbrauchVerbrauchMonate,
  JSON.EnergieverbrauchVerbrauchMonateList, Objekt.StatistikMonatList, Objekt.StatistikMonat;


procedure Tfrm_StatistikMonateVgl.FormCreate(Sender: TObject);
begin
  inherited;
  fJZaehler := nil;
  fStatistikJahreMonatList := TStatistikJahreMonatsList.Create;
end;

procedure Tfrm_StatistikMonateVgl.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fStatistikJahreMonatList);
  inherited;
end;

procedure Tfrm_StatistikMonateVgl.ReadVerbrauchMonatListImJahr;
var
  PVerbrauchMonate: TPEnergieverbrauchVerbrauchMonate;
  Jahr: Integer;
  JahrVon: Integer;
  JahrBis: Integer;
  JMonatList: TJEnergieverbrauchVerbrauchMonateList;
  StatistikMonatList: TStatistikMonatList;
  i1: Integer;
  StatistikMonat: TStatistikMonat;
begin
  if fJZaehler = nil then
    exit;

  JahrVon := 2022;
  JahrBis := 2024;

  fStatistikJahreMonatList.Clear;
  JMonatList := TJEnergieverbrauchVerbrauchMonateList.Create;
  PVerbrauchMonate := TPEnergieverbrauchVerbrauchMonate.Create;
  try
    PVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger := fJZaehler.FieldByName('ZA_ID').AsInteger;
    for Jahr := JahrVon to JahrBis do
    begin
      PVerbrauchMonate.FieldByName('Jahr').AsInteger := Jahr;
      JMonatList.JsonString := JEnergieverbrauch.ReadVerbrauchMonatListImJahr(PVerbrauchMonate.JsonString);
      StatistikMonatList := fStatistikJahreMonatList.Add(Jahr);
      for i1 := 0 to JMonatList.Count -1 do
      begin
        StatistikMonat := StatistikMonatList.Add;
        StatistikMonat.Monat := JMonatList.Item[i1].FieldByName('VM_MONAT').AsInteger;
        StatistikMonat.Jahr  := Jahr;
        StatistikMonat.Wert  := StrToCurr(JMonatList.Item[i1].FieldByName('VM_WERT').AsString);
      end;
    end;
  finally
    FreeAndNil(PVerbrauchMonate);
    FreeAndNil(JMonatList);

  end;

end;

procedure Tfrm_StatistikMonateVgl.setActiv;
begin
  inherited;
  ReadVerbrauchMonatListImJahr;
  UpdateChart;
end;

procedure Tfrm_StatistikMonateVgl.setZaehler(aJZaehler: TJEnergieverbrauchZaehler);
begin
  fJZaehler := aJZaehler;
end;

procedure Tfrm_StatistikMonateVgl.UpdateChart;
var
  //iMonth: Integer;  // = x Achse
  i1, i2: Integer;
  StatistikMonat: TStatistikMonat;
  StatistikMonatList: TStatistikMonatList;
  LineSeries: TLineSeries;
begin //
  Chart.RemoveAllSeries;

  for i1 := 0 to fStatistikJahreMonatList.count -1 do
  begin
    StatistikMonatList := fStatistikJahreMonatList.item[i1];
    LineSeries := TLineSeries.Create(Chart);
    Chart.AddSeries(LineSeries);
    LineSeries.Title := StatistikMonatList.Jahr.ToString;
    LineSeries.LinePen.Width := 2;
    for i2 := 0 to StatistikMonatList.Count -1  do
    begin
      StatistikMonat := StatistikMonatList.Item[i2];
      LineSeries.AddXY(i2, StatistikMonat.Wert, StatistikMonat.Monatslabel);
    end;
  end;



end;

end.
