unit Form.TSI2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.Base, AdvUtil, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ExtCtrls, Objekt.AnsichtList, Objekt.Ansicht,
  Vcl.StdCtrls;


type
  RCol = Record
    const WKN: Integer = 0;
    const Aktie: Integer = 1;
    const LetzterKurs: Integer = 2;
    const TSI27: Integer = 3;
    const TSI12: Integer = 4;
    const Tage7: Integer = 5;
    const Tage14: Integer = 6;
    const Tage30: Integer = 7;
    const Tage90: Integer = 8;
    const Tage180: Integer = 9;
    const Tage365: Integer = 10;
    const Tag1: Integer = 11;
    const KGV: Integer = 12;
    const count: Integer = 13;
  End;

type
  Tfrm_TSI2 = class(Tfrm_Base)
    Panel1: TPanel;
    Panel2: TPanel;
    grd: TAdvStringGrid;
    cbx_KGV: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbx_KGVClick(Sender: TObject);
    procedure grdClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    fCol: RCol;
    fAnsichtList: TAnsichtList;
    fGrdList: TList;
    procedure AktualGrid;
    procedure LadeKompletteAnsicht;
    procedure LadeKGVAnsicht;
  public
    procedure setAnsichtList(aAnsichtList: TAnsichtList);
  end;

var
  frm_TSI2: Tfrm_TSI2;

implementation

{$R *.dfm}





procedure Tfrm_TSI2.FormCreate(Sender: TObject);
begin//
  inherited;
  grd.ColCount := fCol.count;
  grd.ColWidths[fCol.wkn] := 100;
  grd.ColWidths[fCol.Aktie] := 200;
  grd.ColWidths[fCol.LetzterKurs] := 80;
  grd.ColWidths[fCol.TSI27] := 80;
  grd.ColWidths[fCol.TSI12] := 80;
  grd.ColWidths[fCol.Tage7] := 80;
  grd.ColWidths[fCol.Tage14] := 80;
  grd.ColWidths[fCol.Tage30] := 80;
  grd.ColWidths[fCol.Tage90] := 80;
  grd.ColWidths[fCol.Tage180] := 80;
  grd.ColWidths[fCol.Tage365] := 80;
  grd.ColWidths[fCol.Tag1] := 80;
  grd.ColWidths[fCol.KGV] := 80;
  grd.Cells[fCol.wkn, 0] := 'WKN';
  grd.Cells[fCol.Aktie, 0] := 'Aktie';
  grd.Cells[fCol.LetzterKurs, 0] := 'Letzter Kurs';
  grd.Cells[fCol.TSI27, 0] := 'TSI 27';
  grd.Cells[fCol.TSI12, 0] := 'TSI 12';
  grd.Cells[fCol.Tage7, 0] := '7 Tage';
  grd.Cells[fCol.Tage14, 0] := '14 Tage';
  grd.Cells[fCol.Tage30, 0] := '30 Tage';
  grd.Cells[fCol.Tage90, 0] := '90 Tage';
  grd.Cells[fCol.Tage180, 0] := '180 Tage';
  grd.Cells[fCol.Tage365, 0] := '365 Tage';
  grd.Cells[fCol.Tag1, 0] := '1 Tag';
  grd.Cells[fCol.KGV, 0] := 'KGV';
  fGrdList := TList.Create;
end;

procedure Tfrm_TSI2.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fGrdList);
  inherited;
end;

procedure Tfrm_TSI2.grdClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if aRow <> 0 then
    exit;
  if ACol = fCol.Aktie then
    fAnsichtList.AktieSort;
  if ACol = fCol.TSI27 then
    fAnsichtList.TSI27Sort;
  if ACol = fCol.KGV then
    fAnsichtList.KGVSort;
  if cbx_KGV.Checked then
    LadeKGVAnsicht
  else
    LadeKompletteAnsicht;
  AktualGrid;
end;

procedure Tfrm_TSI2.LadeKGVAnsicht;
var
  i1: Integer;
  Ansicht: TAnsicht;
begin
  fGrdList.Clear;
  for i1 := 0 to fAnsichtList.Count -1 do
  begin
    Ansicht := fAnsichtList.Item[i1];
    if (Ansicht.Wert27 >= 1) and (Ansicht.KGV > 0) and (Ansicht.KGV < 10000) then
      fGrdList.Add(fAnsichtList.Item[i1]);
  end;
end;

procedure Tfrm_TSI2.LadeKompletteAnsicht;
var
  i1: Integer;
begin
  fGrdList.Clear;
  for i1 := 0 to fAnsichtList.Count -1 do
    fGrdList.Add(fAnsichtList.Item[i1]);
end;


procedure Tfrm_TSI2.cbx_KGVClick(Sender: TObject);
begin
  if cbx_KGV.Checked then
  begin
    fAnsichtList.KGVSort;
    LadeKGVAnsicht;
    AktualGrid;
  end
  else
  begin
    LadeKompletteAnsicht;
    AktualGrid;
  end;
end;

procedure Tfrm_TSI2.setAnsichtList(aAnsichtList: TAnsichtList);
var
  i1: Integer;
begin
  fAnsichtList := aAnsichtList;
  LadeKompletteAnsicht;
  AktualGrid;
end;


procedure Tfrm_TSI2.AktualGrid;
var
  i1: Integer;
  Ansicht: TAnsicht;
  iAnzahl: Integer;
begin
  for i1 := 0 to grd.RowCount -1 do
    grd.Objects[0, i1] := nil;

  grd.ClearNormalCells;

  iAnzahl := fGrdList.Count;
  if iAnzahl < 2 then
    iAnzahl := 2;
  grd.RowCount := iAnzahl;

  for i1 := 0 to fGrdList.Count -1 do
  begin
    Ansicht := TAnsicht(fGrdList.Items[i1]);
    grd.Objects[0,i1+1] := Ansicht;
    grd.Cells[fCol.WKN, i1+1] := Ansicht.WKN;
    grd.Cells[fCol.Aktie, i1+1] := Ansicht.Aktie;
    grd.Cells[fCol.LetzterKurs, i1+1] := FormatDateTime('dd.mm.yyyy', Ansicht.LetzterKursDatum);
    grd.Cells[fCol.TSI27, i1+1] := FloatToStr(Ansicht.Wert27);
    grd.Cells[fCol.TSI12, i1+1] := FloatToStr(Ansicht.Wert12);
    grd.Cells[fCol.Tage7, i1+1] := FloatToStr(Ansicht.Wert7);
    grd.Cells[fCol.Tage14, i1+1] := FloatToStr(Ansicht.Wert14);
    grd.Cells[fCol.Tage30, i1+1] := FloatToStr(Ansicht.Wert30);
    grd.Cells[fCol.Tage90, i1+1] := FloatToStr(Ansicht.Wert90);
    grd.Cells[fCol.Tage180, i1+1] := FloatToStr(Ansicht.Wert180);
    grd.Cells[fCol.Tage365, i1+1] := FloatToStr(Ansicht.Wert365);
    grd.Cells[fCol.Tag1, i1+1] := FloatToStr(Ansicht.Wert1);
    grd.Cells[fCol.KGV, i1+1] := FloatToStr(Ansicht.KGV);
  end;
end;

end.
