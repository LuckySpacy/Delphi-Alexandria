unit tbStringGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, Messages, Graphics, Types, Windows,
  pngimage;

type
  TCellChangingEvent = procedure(Sender: TObject; ACol, ARow: Longint)
    of object;
  TGetBitmapEvent = procedure(Sender: TObject; ACol, ARow: Longint;
    var aBitmap: Graphics.TBitmap) of object;
  TGetIconEvent = procedure(Sender: TObject; ACol, ARow: Longint;
    var aIcon: Graphics.TIcon) of object;
  TGetPngEvent = procedure(Sender: TObject; ACol, ARow: Longint;
    var aPng: TPngImage) of object;

  TMoveSG = class(TCustomGrid);

  type
    TtbStringGrid = class(TStringGrid)
    private
      FAutosizeColMinWidth: Integer;
      FAutosizeCol: Integer;
      FColList: TStringList;
      FOnRowChanging: TCellChangingEvent;
      FOnColChanging: TCellChangingEvent;
      FOnCellChanging: TCellChangingEvent;
      FOnRowChanged: TNotifyEvent;
      FCheckIsCellChanged: Boolean;
      FOldRow: Longint;
      FOldCol: Longint;
      FOnColChanged: TNotifyEvent;
      FOnCellChanged: TNotifyEvent;
      FDataRows: Longint;
      FHeaderFont: TFont;
      FSortAsc: Boolean;
      FSortCol: Integer;
      FArrowDown: Graphics.TBitmap;
      FArrowUp: Graphics.TBitmap;
      FBitmapList: TList;
      FOnCellDblClick: TCellChangingEvent;
      FOnGetBitmap: TGetBitmapEvent;
    FOnGetIcon: TGetIconEvent;
    FOnGetPng: TGetPngEvent;
      procedure LoadBitmapFromRes(aResType, aResName: string; aBitmap: Graphics.TBitmap);
      procedure setAutosizeCol(const Value: Integer);
      procedure WMSize(var Msg: TWMSize); message WM_SIZE;
      function getObj(aName: string; ARow: Integer): TObject;
      procedure setObj(aName: string; ARow: Integer; const Value: TObject);
      procedure SetDataRows(const Value: Longint);
      function getCell(aName: string; ARow: Integer): string;
      procedure setCell(aName: string; ARow: Integer; const Value: string);
      procedure setHeaderFont(const Value: TFont);
      procedure SortGridByCols(Grid: TStringGrid; ColOrder: array of Integer; aAsc: Boolean = true);
    protected
      procedure ColWidthsChanged; override;
      function SelectCell(ACol, ARow: Longint): Boolean; override;
      procedure Paint; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
      procedure FixedCellClick(ACol, ARow: Longint); override;
      procedure WndProc(var Message: TMessage); override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Clear;
      procedure ClearAll;
      procedure ClearColList;
      procedure AddColList(aName: string);
      function AddRow: Integer;
      procedure SaveGridSpaltenbreite(aFilename: string);
      procedure LoadGridSpaltenbreite(aFilename: string);
      // procedure Cell(aName: string; aRow: Integer; aValue: string);
      property Obj[aName: string; ARow: Integer]: TObject read getObj write setObj;
      property Cell[aName: string; ARow: Integer]: string read getCell write setCell;
      property DataRows: Longint read FDataRows write SetDataRows;
      procedure GotoRow(aRow: Integer);
    published
      property AutosizeCol: Integer read FAutosizeCol write setAutosizeCol;
      property AutosizeColMinWidth: Integer read FAutosizeColMinWidth write FAutosizeColMinWidth;
      property OnRowChanging: TCellChangingEvent read FOnRowChanging write FOnRowChanging;
      property OnColChanging: TCellChangingEvent read FOnColChanging write FOnColChanging;
      property OnCellChanging: TCellChangingEvent read FOnCellChanging write FOnCellChanging;
      property OnRowChanged: TNotifyEvent read FOnRowChanged write FOnRowChanged;
      property OnColChanged: TNotifyEvent read FOnColChanged write FOnColChanged;
      property OnCellChanged: TNotifyEvent read FOnCellChanged write FOnCellChanged;
      property HeaderFont: TFont read FHeaderFont write setHeaderFont;
      property OnCellDblClick: TCellChangingEvent read FOnCellDblClick write FOnCellDblClick;
      property OnGetBitmap : TGetBitmapEvent read FOnGetBitmap write FOnGetBitmap;
      property OnGetIcon: TGetIconEvent read FOnGetIcon write FOnGetIcon;
      property OnGetPng: TGetPngEvent read FOnGetPng write FOnGetPng;
    end;

  procedure Register;

implementation

{$R tbStringgrid.res}

uses
  Dialogs, IniFiles;

procedure Register;
begin
  RegisterComponents('Samples', [TtbStringGrid]);
end;

{ TtbStringGrid }

constructor TtbStringGrid.Create(AOwner: TComponent);
begin
  inherited;
  // ColWidths[0] := 10;
  DefaultRowHeight := 18;
  FAutosizeCol := -1;
  FAutosizeColMinWidth := 3;
  FColList := TStringList.Create;
  FCheckIsCellChanged := false;
  FHeaderFont := TFont.Create;
  FHeaderFont.Style := [fsBold];
  setHeaderFont(FHeaderFont);
  Options := Options + [goFixedRowClick];
  Options := Options + [goColSizing];
  FSortAsc := false;
  FArrowUp := Graphics.TBitmap.Create;
  FArrowDown := Graphics.TBitmap.Create;
  LoadBitmapFromRes('RT_RCDATA', 'ArrowDown', FArrowDown);
  FArrowDown.Transparent := true;
  FArrowDown.TransparentColor := FArrowDown.Canvas.Pixels[0, 0];

  LoadBitmapFromRes('RT_RCDATA', 'ArrowUp', FArrowUp);
  FArrowUp.Transparent := true;
  FArrowUp.TransparentColor := FArrowDown.Canvas.Pixels[0, 0];

  FSortCol := -1;
  FBitmapList := TList.Create;
end;

destructor TtbStringGrid.Destroy;
begin
  FreeAndNil(FColList);
  FreeAndNil(FHeaderFont);
  FreeAndNil(FArrowDown);
  FreeAndNil(FArrowUp);
  FreeAndNil(FBitmapList);
  inherited;
end;

procedure TtbStringGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
  procedure GetPosition(ARect: TRect; AImageW, AImageH: Integer; var ALeft, ATop: Integer);
  var
    RectWidth: Integer;
    RectHeight: Integer;
    RectWidthHalb: Integer;
    RectHeightHalb: Integer;
  begin
    ALeft := ARect.Left;
    ATop := ARect.Top;
    RectWidth := ARect.Right - ARect.Left;
    RectHeight := ARect.Bottom - ARect.Top;
    RectWidthHalb := trunc(RectWidth / 2);
    RectHeightHalb := trunc(RectHeight / 2);
    if RectWidth > AImageW then
      ALeft := ALeft + RectWidthHalb - trunc((AImageW) / 2);
    if RectHeight > AImageH then
      ATop := ATop + RectHeightHalb - trunc((AImageH) / 2);
  end;
var
  s: string;
  RectForText: TRect;
  Bmp: Graphics.TBitmap;
  Icon: Graphics.TIcon;
  Png: TPngImage;
  PosLeft: Integer;
  PosTop: Integer;
begin
  inherited;
  if ARow <= FixedRows - 1 then
  begin
    s := Cells[ACol, ARow];
    Canvas.Brush.Color := FixedColor;
    Canvas.FillRect(ARect);
    Canvas.Font.Assign(FHeaderFont);
    RectForText := ARect;
    InflateRect(RectForText, -2, -2);
    Canvas.TextRect(RectForText, s);
  end;
  if FSortCol > -1 then
  begin
    if (ARow = 0) and (ACol = FSortCol) then
    begin
      if FSortAsc then
        Canvas.Draw(ARect.Right - 12, ARect.Top, FArrowDown)
      else
        Canvas.Draw(ARect.Right - 12, ARect.Top, FArrowUp)
    end;
  end;

  if Assigned(FOnGetBitmap) then
  begin
    FOnGetBitmap(Self, ACol, ARow, Bmp);
    if Bmp <> nil then
    begin
      GetPosition(ARect, Bmp.Width, Bmp.Height, PosLeft, PosTop);
      Canvas.FillRect(ARect);
      Canvas.Draw(PosLeft, PosTop, Bmp);
    end;
  end;

  if Assigned(FOnGetIcon) then
  begin
    FOnGetIcon(Self, ACol, ARow, Icon);
    if Icon <> nil then
    begin
      GetPosition(ARect, Icon.Width, Icon.Height, PosLeft, PosTop);
      Canvas.FillRect(ARect);
      Canvas.Draw(PosLeft, PosTop, Icon);
    end;
  end;


  if Assigned(FOnGetPng) then
  begin
    FOnGetPng(Self, ACol, ARow, Png);
    if Png <> nil then
    begin
      GetPosition(ARect, Png.Width, Png.Height, PosLeft, PosTop);
      Canvas.FillRect(ARect);
      Canvas.Draw(PosLeft, PosTop, Png);
    end;
  end;


      {
  if Assigned(OnDrawCell) then
  begin
    OnDrawCell(Self, ACol, ARow, ARect, AState);
  end;
       }


  {
    if Objects[ACol, ARow] is Graphics.TBitmap then
    begin
    bmp := Graphics.TBitmap(TObject(Objects[ACol, ARow]));
    if bmp <> nil then
    begin
    PosLeft := ARect.Left;
    PosTop  := ARect.Top;
    RectWidth  := ARect.Right - ARect.Left;
    RectHeight := ARect.Bottom - ARect.Top;
    if RectWidth > bmp.Width then
    PosLeft := PosLeft + bmp.Width - trunc((bmp.Width)/2);
    if RectHeight > bmp.Height then
    PosTop := PosTop + bmp.Height - trunc((bmp.Height)/2);
    Canvas.FillRect(ARect);
    Canvas.Draw(PosLeft, PosTop, bmp);
    end;
    end;
    }
end;

procedure TtbStringGrid.FixedCellClick(ACol, ARow: Integer);
var
  ColOrder: Array of Integer;
  i1: Integer;
begin
  setlength(ColOrder, ColCount);
  ColOrder[0] := ACol;
  for i1 := 1 to High(ColOrder) do
    ColOrder[i1] := 0;
  FSortAsc := not FSortAsc;
  if FSortCol <> ACol then
    FSortAsc := true;
  SortGridByCols(Self, ColOrder, FSortAsc);
  setlength(ColOrder, 0);
  inherited;
end;

procedure TtbStringGrid.ClearColList;
begin
  FColList.Clear;
end;

procedure TtbStringGrid.ColWidthsChanged;
begin
  inherited;
  setAutosizeCol(FAutosizeCol);
end;

procedure TtbStringGrid.setAutosizeCol(const Value: Integer);
var
  i1: Integer;
  Gesamtbreite: Integer;
  NeueBreite: Integer;
begin
  if FAutosizeCol < 0 then
    exit;
  if FAutosizeCol > ColCount - 1 then
    exit;
  Gesamtbreite := 0;
  FAutosizeCol := Value;
  for i1 := 0 to ColCount - 1 do
  begin
    if i1 = FAutosizeCol then
      continue;
    Gesamtbreite := Gesamtbreite + ColWidths[i1] + GridLineWidth;
  end;
  NeueBreite := ClientWidth - Gesamtbreite;
  if NeueBreite < FAutosizeColMinWidth then
    NeueBreite := FAutosizeColMinWidth;
  ColWidths[FAutosizeCol] := NeueBreite;
end;

procedure TtbStringGrid.setCell(aName: string; ARow: Integer;
  const Value: string);
var
  iCol: Integer;
begin
  iCol := FColList.IndexOf(lowercase(aName));
  if iCol < 0 then
    exit;
  Cells[iCol, ARow] := Value;
end;

procedure TtbStringGrid.SetDataRows(const Value: Longint);
begin
  FDataRows := Value;
  RowCount := Value + FixedRows;
end;

procedure TtbStringGrid.WMSize(var Msg: TWMSize);
begin
  inherited;
  setAutosizeCol(FAutosizeCol);
end;

procedure TtbStringGrid.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_LBUTTONDBLCLK:
      begin
        if Assigned(FOnCellDblClick) then
          FOnCellDblClick(Self, Col, Row);
      end;
  end;
  inherited;

end;

procedure TtbStringGrid.AddColList(aName: string);
begin
  FColList.Add(lowercase(aName));
end;

function TtbStringGrid.AddRow: Integer;
begin
  RowCount := RowCount + 1;
  Result := RowCount - 1;
end;

procedure TtbStringGrid.setHeaderFont(const Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TtbStringGrid.setObj(aName: string; ARow: Integer;
  const Value: TObject);
var
  iCol: Integer;
begin
  iCol := FColList.IndexOf(lowercase(aName));
  if iCol < 0 then
    exit;
  Objects[iCol, ARow] := Value;
end;

function TtbStringGrid.getCell(aName: string; ARow: Integer): string;
var
  iCol: Integer;
begin
  Result := '';
  iCol := FColList.IndexOf(lowercase(aName));
  if iCol < 0 then
    exit;
  Result := Cells[iCol, ARow];
end;

function TtbStringGrid.getObj(aName: string; ARow: Integer): TObject;
var
  iCol: Integer;
begin
  Result := nil;
  iCol := FColList.IndexOf(lowercase(aName));
  if iCol < 0 then
    exit;
  Result := Objects[iCol, ARow];
end;

procedure TtbStringGrid.GotoRow(aRow: Integer);
//var
//  i1: Integer;
begin
  if aRow < RowCount then
    Row := aRow;
end;

procedure TtbStringGrid.LoadBitmapFromRes(aResType, aResName: string;
  aBitmap: Graphics.TBitmap);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResName, PChar(aResType));
  try
    aBitmap.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;


procedure TtbStringGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

procedure TtbStringGrid.Paint;
begin
  inherited;
  if FCheckIsCellChanged then
  begin
    if (FOldRow <> Row) and (Assigned(FOnRowChanged)) then
    begin
      FCheckIsCellChanged := false;
      FOnRowChanged(Self);
    end;
    if (FOldCol <> Col) and (Assigned(FOnColChanged)) then
    begin
      FCheckIsCellChanged := false;
      FOnColChanged(Self);
    end;
    if Assigned(FOnCellChanged) then
    begin
      if (FOldCol <> Col) or (FOldRow <> Row) then
      begin
        FCheckIsCellChanged := false;
        FOnCellChanged(Self);
      end;
    end;
  end;
end;


procedure TtbStringGrid.SaveGridSpaltenbreite(aFilename: string);
var
  i1: Integer;
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFilename);
  try
    for i1 := 0 to ColCount -1 do
    begin
      INI.WriteString('Spaltenbreite_' + Name, IntToStr(i1), IntToStr(ColWidths[i1]));
    end;
  finally
    FreeAndNil(INI);
  end;
end;

procedure TtbStringGrid.LoadGridSpaltenbreite(aFilename: string);
var
  i1: Integer;
  INI: TIniFile;
  Breite: Integer;
begin
  INI := TIniFile.Create(aFilename);
  try
    for i1 := 0 to ColCount -1 do
    begin
      if not TryStrToInt(INI.ReadString('Spaltenbreite_' + Name, IntToStr(i1), '64'), Breite) then
        Breite := 64;
      ColWidths[i1] := Breite;
    end;
  finally
    FreeAndNil(INI);
  end;
end;


function TtbStringGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  Result := inherited;
  if not Result then
    exit;
  if (Row <> ARow) and (Assigned(FOnRowChanging)) then
    FOnRowChanging(Self, ACol, ARow);
  if (Col <> ACol) and (Assigned(FOnColChanging)) then
    FOnColChanging(Self, ACol, ARow);
  if Assigned(FOnCellChanging) then
  begin
    if (Row <> ARow) or (Col <> ACol) then
      FOnCellChanging(Self, ACol, ARow);
  end;
  FOldRow := Row;
  FOldCol := Col;
  FCheckIsCellChanged := true;
end;

procedure TtbStringGrid.Clear;
var
  i: Integer;
begin
  FSortAsc := false;
  FSortCol := -1;
  for i := FixedRows to RowCount - 1 do
    Rows[i].Clear;
end;

procedure TtbStringGrid.ClearAll;
var
  i: Integer;
begin
  FSortAsc := false;
  FSortCol := -1;
  for i := 0 to RowCount - 1 do
    Rows[i].Clear;
end;

procedure TtbStringGrid.SortGridByCols(Grid: TStringGrid;
  ColOrder: array of Integer; aAsc: Boolean);
var
  i: Integer;
  // j: Integer;
  Sorted: Boolean;

  function Sort(Row1, Row2: Integer): Integer;
  var
    C: Integer;
  begin
    C := 0;
    Result := AnsiCompareStr(Grid.Cols[ColOrder[C]][Row1],
      Grid.Cols[ColOrder[C]][Row2]);
    if Result = 0 then
    begin
      Inc(C);
      while (C <= High(ColOrder)) and (Result = 0) do
      begin
        Result := AnsiCompareStr(Grid.Cols[ColOrder[C]][Row1],
          Grid.Cols[ColOrder[C]][Row2]);
        Inc(C);
      end;
    end;
  end;

begin
  if SizeOf(ColOrder) div SizeOf(i) <> Grid.ColCount then
    exit;

  for i := 0 to High(ColOrder) do
    if (ColOrder[i] < 0) or (ColOrder[i] >= Grid.ColCount) then
      exit;

  FSortCol := ColOrder[0];

  // j := 0;
  repeat
    Sorted := true;
    // Inc(j);
    with Grid do
      for i := Grid.FixedRows to RowCount - 2 do
      begin
        if aAsc then
        begin
          if Sort(i, i + 1) > 0 then
          begin
            TMoveSG(Grid).MoveRow(i + 1, i);
            Sorted := false;
          end;
        end
        else
        begin
          if Sort(i, i + 1) < 0 then
          begin
            TMoveSG(Grid).MoveRow(i + 1, i);
            Sorted := false;
          end;
        end;
      end;
  until Sorted;
  // until Sorted or (j = 1000);
  Grid.Repaint;
end;

end.
