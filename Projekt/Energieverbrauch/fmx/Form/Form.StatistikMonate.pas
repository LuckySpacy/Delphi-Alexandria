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
    procedure cbx_BisMonatChange(Sender: TObject);
    procedure edt_BisJahrExit(Sender: TObject);
    procedure edt_VonJahrExit(Sender: TObject);
  private
    fJZaehler: TJEnergieverbrauchZaehler;
    fStatistikJahreMonatList: TStatistikJahreMonatsList;
    fVerbrauchJahreMonatList: TList;
    procedure UpdateChart;
    function getMonatslabel(aMonat: Integer): string;
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
  fVerbrauchJahreMonatList := TList.Create;
end;

procedure Tfrm_StatistikMonate.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fStatistikJahreMonatList);
  FreeAndNil(fVerbrauchJahreMonatList);
  inherited;
end;


procedure Tfrm_StatistikMonate.cbx_BisMonatChange(Sender: TObject);
begin
  setActiv;
end;

procedure Tfrm_StatistikMonate.cbx_VonMonatChange(Sender: TObject);
begin
  setActiv;

end;



procedure Tfrm_StatistikMonate.edt_BisJahrExit(Sender: TObject);
begin
  setActiv;
end;

procedure Tfrm_StatistikMonate.edt_VonJahrExit(Sender: TObject);
begin
  setActiv;
end;

procedure Tfrm_StatistikMonate.ReadVerbrauchMonatListImJahr;
var
  Jahr: Integer;
  JahrVon: Integer;
  JahrBis: Integer;
  i1: Integer;
  PVerbrauchMonate: TPEnergieverbrauchVerbrauchMonate;
  JMonatList: TJEnergieverbrauchVerbrauchMonateList;
  StatistikMonatList: TStatistikMonatList;
  StatistikMonat: TStatistikMonat;
begin
  //JEnergieverbrauch.ReadVerbrauchMonatListImJahr();

  if not TryStrToInt(edt_VonJahr.Text, JahrVon) then
    exit;

  if not TryStrToInt(edt_BisJahr.Text, JahrBis) then
    exit;

   if JahrVon < 2000 then
     exit;
   if JahrBis < 2000 then
     exit;

   if JahrBis < JahrVon then
     exit;



  fStatistikJahreMonatList.Clear;
  fVerbrauchJahreMonatList.Clear;
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
        StatistikMonat.Jahr  := Jahr;
        StatistikMonat.Wert  := StrToCurr(JMonatList.Item[i1].FieldByName('VM_WERT').AsString);
        fVerbrauchJahreMonatList.Add(StatistikMonat);
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
  i1: Integer;
  Von: string;
  Bis: string;
  sMonat: string;
  sJahr: string;
  StatistikMonat: TStatistikMonat;
begin //

  chart.Series[0].Clear;

  sMonat := (cbx_VonMonat.ItemIndex+1).ToString;
  if length(sMonat) = 1 then
    sMonat := '0' + sMonat;
  Von := edt_VonJahr.Text + sMonat;

  sMonat := (cbx_BisMonat.ItemIndex+1).ToString;
  if length(sMonat) = 1 then
    sMonat := '0' + sMonat;
  Bis := edt_BisJahr.Text + sMonat;

  for i1 := 0 to fVerbrauchJahreMonatList.Count -1 do
  begin
    StatistikMonat := TStatistikMonat(fVerbrauchJahreMonatList.Items[i1]);
    if (StatistikMonat.JahrMonat >= Von) and (StatistikMonat.JahrMonat <= Bis) then
    begin
      sJahr := copy(StatistikMonat.Jahr.ToString, 3, 2);
      //Chart.Series[0].AddXY(StatistikMonat.JahrMonat.ToInteger, StatistikMonat.Wert, getMonatslabel(StatistikMonat.Monat)+sJahr);
      Chart.Series[0].AddXY(i1, StatistikMonat.Wert, getMonatslabel(StatistikMonat.Monat));
    end;
  end;
end;

function Tfrm_StatistikMonate.getMonatslabel(aMonat: Integer): string;
begin
  case aMonat of
    1: Result := 'Jan';
    2: Result := 'Feb';
    3: Result := 'Mär';
    4: Result := 'Apr';
    5: Result := 'Mai';
    6: Result := 'Jun';
    7: Result := 'Jul';
    8: Result := 'Aug';
    9: Result := 'Sep';
    10: Result := 'Okt';
    11: Result := 'Nov';
    12: Result := 'Dez';
  end;
end;




end.
