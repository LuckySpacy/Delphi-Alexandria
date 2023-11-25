unit fntStringGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, tbStringGrid, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Button1: TButton;
    tbStringGrid1: TtbStringGrid;
    StringGrid2: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tbStringGrid1Click(Sender: TObject);
    procedure tbStringGrid1CellChanging(Sender: TObject; ACol, ARow: Integer);
    procedure tbStringGrid1ColChanging(Sender: TObject; ACol, ARow: Integer);
    procedure tbStringGrid1RowChanging(Sender: TObject; ACol, ARow: Integer);
    procedure tbStringGrid1RowChanged(Sender: TObject);
    procedure tbStringGrid1ColChanged(Sender: TObject);
    procedure tbStringGrid1CellChanged(Sender: TObject);
    procedure tbStringGrid1FixedCellClick(Sender: TObject; ACol, ARow: Integer);
  private
    FGrid : TTbStringGrid;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  tbStringGrid1.Row := 3;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  iRow: Integer;
begin
  tbStringGrid1.RowCount := 6;
  tbStringGrid1.Clear;
  tbstringgrid1.Cells[0, 0] := 'A Gruppe ';
  tbstringgrid1.Cells[0, 1] := 'A5';
  tbstringgrid1.Cells[0, 2] := 'A3';
  tbstringgrid1.Cells[0, 3] := 'A8';
  tbstringgrid1.Cells[0, 4] := 'A1';
  tbstringgrid1.Cells[0, 5] := 'A9';

  tbstringgrid1.Cells[1, 0] := 'B Gruppe ';
  tbstringgrid1.Cells[1, 1] := 'B3';
  tbstringgrid1.Cells[1, 2] := 'B3';
  tbstringgrid1.Cells[1, 3] := 'B3';
  tbstringgrid1.Cells[1, 4] := 'B7';
  tbstringgrid1.Cells[1, 5] := 'B9';

  tbstringgrid1.Cells[2, 0] := 'C Gruppe ';
  tbstringgrid1.Cells[2, 1] := 'C7';
  tbstringgrid1.Cells[2, 2] := 'C9';
  tbstringgrid1.Cells[2, 3] := 'C1';
  tbstringgrid1.Cells[2, 4] := 'C4';
  tbstringgrid1.Cells[2, 5] := 'C3';

end;

procedure TForm2.tbStringGrid1CellChanged(Sender: TObject);
begin
  ShowMessage('CellChanged');
end;

procedure TForm2.tbStringGrid1CellChanging(Sender: TObject; ACol,
  ARow: Integer);
begin
  //ShowMessage('CellChanging ' + IntToStr(ARow) + ' / ' + IntToStr(tbStringGrid1.Row));
end;

procedure TForm2.tbStringGrid1Click(Sender: TObject);
begin
  //ShowMessage('Click');
end;

procedure TForm2.tbStringGrid1ColChanged(Sender: TObject);
begin
  ShowMessage('ColChanged');
end;

procedure TForm2.tbStringGrid1ColChanging(Sender: TObject; ACol, ARow: Integer);
begin
  //ShowMessage('ColChanging ' + IntToStr(ARow) + ' / ' + IntToStr(tbStringGrid1.Row));

end;

procedure TForm2.tbStringGrid1FixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  //ShowMessage('FixedCell');
end;

procedure TForm2.tbStringGrid1RowChanged(Sender: TObject);
begin
  ShowMessage('RowChanged');
end;

procedure TForm2.tbStringGrid1RowChanging(Sender: TObject; ACol, ARow: Integer);
begin
  //ShowMessage('RowChanging ' + IntToStr(ARow) + ' / ' + IntToStr(tbStringGrid1.Row));
end;

end.
