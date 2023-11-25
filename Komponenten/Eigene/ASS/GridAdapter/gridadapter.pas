{*---------------------------------------------------------------------
  Adapterklasse IGrid <--> TAdvStringGrid

  @Author Markus Müller
  @version 0.1
----------------------------------------------------------------------}
unit GridAdapter;

interface

uses
  Windows, Messages, SysUtils, Classes, i_grid, Grids, BaseGrid, AdvGrid, Graphics,
  AdvObj;

/// Test
type
  TGridAdapter = class(TComponent)
  private
    { Private-Deklarationen }
    Grid: TAdvStringGrid;
    AdaptedObj: IGrid;

    procedure InitGrid;
    procedure OnCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
    procedure OnGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure OnGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure OnEditCellDone(Sender: TObject; ACol, ARow: Integer);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(aOwner: TComponent; aGrid: TAdvStringGrid; aObj: IGrid); reintroduce; overload;

    procedure setGrid(aGrid: TAdvStringGrid);
    procedure setAdaptedObj(aObj: IGrid);
    procedure UpdateGrid;
    procedure UpdateGridSelectLast;
    procedure UpdateGridSelectFirst;
    procedure ClearGrid;
    procedure setToNil;
  published
    { Published-Deklarationen }
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('Optima', [TGridAdapter]);
end;

{ TGridAdapter }

{*---------------------------------------------------------------------
  Konstruktor - kann nur benutzt werden, wenn nicht visuell genutzt

  @param aOwner Ownership des Objektes
  @param aGrid zu adaptierendes Grid
  @param aObj zu adaptierendes Objekt
----------------------------------------------------------------------}
procedure TGridAdapter.ClearGrid;
begin
     if (Grid = nil) then Exit;

     Grid.Clear;
end;

constructor TGridAdapter.Create(aOwner: TComponent; aGrid: TAdvStringGrid;
  aObj: IGrid);
begin
     inherited Create(aOwner);
     setGrid(aGrid);
     setAdaptedObj(aObj);
end;

{*---------------------------------------------------------------------
  Initialisieren des Grids (Zeilen, Spalten, Überschriften)
----------------------------------------------------------------------}
procedure TGridAdapter.InitGrid;
var i: integer;
begin

     Grid.Clear;

     Grid.FixedRows := 1;
     Grid.FixedCols := 0;
     Grid.ColCount  := AdaptedObj.Grd_getColCount;
     if AdaptedObj.Grd_getRowCount > 0 then
        Grid.RowCount  := AdaptedObj.Grd_getRowCount+1
     else
        Grid.RowCount := 2;

     Grid.ColumnHeaders.Clear;
     for i := 0 to AdaptedObj.Grd_getColCount - 1 do
        Grid.ColumnHeaders.Add(AdaptedObj.Grd_getHeader(i));

end;


{*---------------------------------------------------------------------
  OnCanEditCell Event des Grids

  @param Sender Auslöser des Events --> Grid
  @param ARow Zeile, die abgefragt wird
  @param ACol Spalte, die abgefragt wird
  @param CanEdit var Wert. TRUE falls änderbar, sonst FALSE
----------------------------------------------------------------------}
procedure TGridAdapter.OnCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
     if AdaptedObj = nil then CanEdit := false
     else CanEdit := (aRow > 0) and AdaptedObj.Grd_canEdit(ACol, ARow);
end;



{*---------------------------------------------------------------------
  OnEditingDone Event des Grid

  @param Sender Auslöser des Events --> Grid
----------------------------------------------------------------------}
procedure TGridAdapter.OnEditCellDone(Sender: TObject; ACol, ARow: Integer);
begin
     if ((AdaptedObj = nil) or (AdaptedObj.Grd_getRowCount = 0)) then Exit
     else begin
        AdaptedObj.Grd_setValue(aCol, aRow, Grid.Cells[aCol, aRow]);
        Grid.RepaintRow(aRow);
     end;
end;


{*---------------------------------------------------------------------
  OnGetAlignment Event des Grids

  @param Sender Auslöser des Events --> Grid
  @param ARow Zeile, die abgefragt wird
  @param ACol Spalte, die abgefragt wird
  @param HAlign [var] horizontales Alignment (links / mitte / rechts)
  @param Valign [var] vertikales Alignment (oben / mitte (unten)
----------------------------------------------------------------------}
procedure TGridAdapter.OnGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
     if AdaptedObj = nil then Exit
     else AdaptedObj.Grd_getAlignment(ACol, ARow, HAlign);
end;



{*---------------------------------------------------------------------
  OnGetCellColor Event des Grids

  @param Sender Auslöser des Events --> Grid
  @param ARow Zeile, die abgefragt wird
  @param ACol Spalte, die abgefragt wird
  @param ASate Aktueller Status der Zelle (selektiert / nicht selektiert)
  @param ABrush Brush mit dem die Zelle gezeichnet wird
  @param AFont Font mit dem der Inhalt der Zelle geschrieben wird  
----------------------------------------------------------------------}
procedure TGridAdapter.OnGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
     if AdaptedObj = nil then Exit
     else begin
        AdaptedObj.Grd_getColor(ACol, ARow, ABrush);
        AdaptedObj.Grd_getFont(ACol, ARow, AFont);
     end;
end;


{*---------------------------------------------------------------------
  Setzt das zu adaptierende Objekt

  @param aObj Objekt mit Schnittstelle IGrid
----------------------------------------------------------------------}
procedure TGridAdapter.setAdaptedObj(aObj: IGrid);
begin
     AdaptedObj := nil;
     AdaptedObj := aObj;
end; 

{*---------------------------------------------------------------------
  Setzt das zu adaptierende Grid und verknüpft die Events

  @param aGrid Grid, das für die Anzeige des Objektes genutzt wird.
----------------------------------------------------------------------}
procedure TGridAdapter.setGrid(aGrid: TAdvStringGrid);
begin
     Grid := aGrid;
     Grid.OnCanEditCell := self.OnCanEditCell;
     Grid.OnGetCellColor := self.OnGetCellColor;
     Grid.OnGetAlignment := self.OnGetAlignment;
     Grid.OnEditCellDone := self.OnEditCellDone;
end;


{*---------------------------------------------------------------------
  Alle Zeiger auf NIL setzen
  Verhindert mögliche Fehler beim Schließen des Formulars
----------------------------------------------------------------------}
procedure TGridAdapter.setToNil;
begin
     if Grid <> nil then begin
        Grid.OnGetCellColor := nil;
        Grid.OnGetAlignment := nil;
        Grid.OnCanEditCell := nil;
        Grid.OnEditingDone := nil;
        Grid := nil;
     end;
     AdaptedObj := nil;
end;

{*---------------------------------------------------------------------
  Aktualisiert, die im Grid angezeigten Daten
----------------------------------------------------------------------}
procedure TGridAdapter.UpdateGrid;
var i,j: integer;
    temp: integer;
    image : integer;
    Buttonspalte : integer;
begin
     if (Grid = nil) or (AdaptedObj = nil) then Exit;
     temp := Grid.RealRow;

     // TODO: Ggf. das Grid nicht immer wieder leeren
     InitGrid;

     if AdaptedObj.Grd_getRowCount > 0 then
     begin
       for i := 0 to Grid.ColCount - 1 do
       begin
         for j := 1 to Grid.RowCount -1 do
         begin
            Grid.Cells[i,j] := AdaptedObj.Grd_getValue(i,j);
            Grid.Objects[0, j] := AdaptedObj.getObject(j-1);

            image := AdaptedObj.Grd_getImage(i,j);
            if image >= 0 then
              Grid.AddImageIdx(i, j, image, haCenter, vaCenter);
         end;

         Buttonspalte := AdaptedObj.Grd_getButtonspalte;
         if (i > 0) and (Buttonspalte > -1) then
           Grid.AddButton(Buttonspalte,i,50,16,'<-',haCenter,vaTop);
       end;
     end;

     if temp < Grid.RowCount then
        Grid.SelectRows(temp, 1)
     else
        Grid.SelectRows(1,1);
end;

procedure TGridAdapter.UpdateGridSelectFirst;
begin
     if (Grid = nil) then Exit;
     updateGrid;
     Grid.SelectRows(1,1);
end;

procedure TGridAdapter.UpdateGridSelectLast;
begin
     if (Grid = nil) then Exit;
     updateGrid;
     Grid.SelectRows(Grid.RowCount-1,1);
end;

end.
