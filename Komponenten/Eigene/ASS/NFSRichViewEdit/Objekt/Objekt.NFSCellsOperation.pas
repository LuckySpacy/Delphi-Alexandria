unit Objekt.NFSCellsOperation;

interface

uses
  SysUtils, Classes, RvEdit, RVStyle, Graphics;

const
  cInsertRowsAbove = 1;
  cInsertRowsBelow = 2;
  cInsertColsLeft  = 3;
  cInsertColsRight = 4;
  cDeleteRows      = 5;
  cDeleteColumns   = 6;
  cMergeCells      = 7;
  cUnMergeRows     = 8;
  cUnMergeColumns  = 9;
  cUnMergeRowsAndColumns = 10;
  cCellSplittHorizontal = 12;
  cCellSplittVertikal = 11;

type
  RTableInfo = record
    Spalten     : Integer;
    Zeilen      : Integer;
    Rahmendicke : Integer;
    Zellendicke : Integer;
    Tabellefarbe: TColor;
    Rahmenfarbe : TColor;
    Zellenrahmenfarbe: TColor;
  end;

type
  TNFSCellsOperation = class
  private
    fRv: TRichViewEdit;
    procedure CellsOperation(aCommand: Integer);
    function ShowTableForm(var aTableInfo: RTableInfo): Boolean;
  public
    constructor Create(aEditor: TRichViewEdit);
    destructor Destroy; override;
    procedure Init;
    procedure InsertTableRowsBelow;
    procedure InsertTableColLeft;
    procedure InsertTableColRight;
    procedure DeleteTableRow;
    procedure DeleteTableCol;
    procedure MergeCells;
    procedure UnmergeRows;
    procedure UnmergeColumns;
    procedure UnmergeRowsAndColumns;
    procedure TableCellSplittHorizontal;
    procedure TableCellSplittVertikal;
    procedure InsertTable;
  end;


implementation

{ TNFSCellsOperation }

uses
  RvTable, RvItem, Vcl.Dialogs, Form.NFSRichViewEditTable, Vcl.Forms;

constructor TNFSCellsOperation.Create(aEditor: TRichViewEdit);
begin
  fRv := aEditor;
end;

destructor TNFSCellsOperation.Destroy;
begin

  inherited;
end;


procedure TNFSCellsOperation.Init;
begin

end;

procedure TNFSCellsOperation.CellsOperation(aCommand: Integer);
var item: TCustomRVItemInfo;
    table: TRVTableItemInfo;
    Data: Integer;
    r,c,cs,rs: Integer;
    s: String;
    rve: TCustomRichViewEdit;
    ItemNo: Integer;
begin
  if not fRv.CanChange or
     not fRv.GetCurrentItemEx(TRVTableItemInfo, rve, item) then
    exit;
  table := TRVTableItemInfo(item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
  case aCommand of
    1:
      table.InsertRowsAbove(1);
    2:
      table.InsertRowsBelow(1);
    3:
      table.InsertColsLeft(1);
    4:
      table.InsertColsRight(1);
    5:
      begin
        table.GetNormalizedSelectionBounds(True,r,c,cs,rs);
        if rs=table.Rows.Count then
        begin
          // deleting the whole table
          rve.SetSelectionBounds(ItemNo,0,ItemNo,1);
          rve.DeleteSelection;
          exit;
        end;
        rve.BeginUndoGroup(rvutModifyItem);
        rve.SetUndoGroupMode(True);
        table.DeleteSelectedRows;
        // it's possible all-nil rows/cols appear after deleting
        table.DeleteEmptyRows;
        table.DeleteEmptyCols;
        rve.SetUndoGroupMode(False);
      end;
    6:
      begin
        table.GetNormalizedSelectionBounds(True,r,c,cs,rs);
        if cs=table.Rows[0].Count then
        begin
          // deleting the whole table
          rve.SetSelectionBounds(ItemNo,0,ItemNo,1);
          rve.DeleteSelection;
          exit;
        end;
        rve.BeginUndoGroup(rvutModifyItem);
        rve.SetUndoGroupMode(True);
        table.DeleteSelectedCols;
        // it's possible all-nil rows/cols appear after deleting
        table.DeleteEmptyRows;
        table.DeleteEmptyCols;
        rve.SetUndoGroupMode(False);
      end;
    7:
      begin
        // 3 methods: MergeSelectedCells, DeleteEmptyRows, DeleteEmptyCols
        // must be undone as one action.
        // So using BeginUndoGroup - SetUndoGroupMode(True) - ... - SetUndoGroupMode(False)
        rve.BeginUndoGroup(rvutModifyItem);
        rve.SetUndoGroupMode(True);
        table.MergeSelectedCells(True);
        table.DeleteEmptyRows;
        table.DeleteEmptyCols;
        rve.SetUndoGroupMode(False);
        // table.MergeSelectedCells(False) will not allow to create empty columns
        // or rows
      end;
    8:
      table.UnmergeSelectedCells(True, False);
    9:
      table.UnmergeSelectedCells(False, True);
    10:
      table.UnmergeSelectedCells(True, True);
    11:
      begin
        s := '2';
        if InputQuery('Split Vertically','Columns (in each selected cell):',s) then
        begin
          table.SplitSelectedCellsVertically(StrToIntDef(s,0));
        end;
      end;
    12:
      begin
        s := '2';
        if InputQuery('Split Horizontally','Rows (in each selected cell):',s) then
        begin
          table.SplitSelectedCellsHorizontally(StrToIntDef(s,0));
        end;
      end;
  end;
  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;


procedure TNFSCellsOperation.InsertTableRowsBelow;
begin
  CellsOperation(cInsertRowsBelow);
end;

procedure TNFSCellsOperation.InsertTableColLeft;
begin
  CellsOperation(cInsertColsLeft);
end;

procedure TNFSCellsOperation.InsertTableColRight;
begin
  CellsOperation(cInsertColsRight);
end;

procedure TNFSCellsOperation.DeleteTableRow;
begin
  CellsOperation(cDeleteRows);
end;

procedure TNFSCellsOperation.DeleteTableCol;
begin
  CellsOperation(cDeleteColumns);
end;

procedure TNFSCellsOperation.MergeCells;
begin
  CellsOperation(cMergeCells);
end;


procedure TNFSCellsOperation.UnmergeColumns;
begin
  CellsOperation(cUnMergeColumns);
end;

procedure TNFSCellsOperation.UnmergeRows;
begin
  CellsOperation(cUnMergeRows);
end;

procedure TNFSCellsOperation.UnmergeRowsAndColumns;
begin
  CellsOperation(cUnMergeRowsAndColumns);
end;

procedure TNFSCellsOperation.TableCellSplittHorizontal;
begin
  CellsOperation(cCellSplittHorizontal);
end;

procedure TNFSCellsOperation.TableCellSplittVertikal;
begin
  CellsOperation(cCellSplittVertikal);
end;


procedure TNFSCellsOperation.InsertTable;
var
  table: TRVTableItemInfo;
  r,c: Integer;
  TableInfo: RTableInfo;
begin
  TableInfo.Tabellefarbe      := -16777211;
  TableInfo.Rahmenfarbe       := -16777211;
  TableInfo.Zellenrahmenfarbe := -16777211;
  if not ShowTableForm(TableInfo) then
    exit;

  table := TRVTableItemInfo.CreateEx(TableInfo.Zeilen, TableInfo.Spalten, fRv.RVData);
  table.BorderWidth     := TableInfo.Rahmendicke;
  table.CellBorderWidth := TableInfo.Zellendicke;
  table.Color           := TableInfo.Tabellefarbe;
  table.BorderColor     := TableInfo.Rahmenfarbe;
  table.CellBorderColor := TableInfo.Zellenrahmenfarbe;

  for r := 0 to table.Rows.Count-1 do
    for c := 0 to table.Rows[r].Count-1 do
      table.Cells[r,c].BestWidth := 100;

  fRv.InsertItem('', table);

end;



function TNFSCellsOperation.ShowTableForm(var aTableInfo: RTableInfo): Boolean;
var
  Form: Tfrm_NFSRichViewEditTable;
  //fStyle: TFormStyle;
begin
  Result := false;
 //fStyle := BeforeShowForm;
  Form := Tfrm_NFSRichViewEditTable.Create(nil);
  try
    Form.cmd_TableColor.Color  := aTableInfo.Tabellefarbe;
    Form.cmd_BorderColor.Color := aTableInfo.Rahmenfarbe;
    Form.cmd_CellBorderColor.Color := aTableInfo.Zellenrahmenfarbe;
    Form.edt_Spalten.Value := 2;
    Form.edt_Zeilen.Value  := 2;
    Form.edt_Rahmendicke.Value := 0;
    Form.edt_Zellendicke.Value := 0;
    Form.FormStyle := fsStayOnTop;
    Form.ShowModal;
    if not Form.Cancel then
    begin
      Result := true;
      aTableInfo.Spalten      := Form.edt_Spalten.Value;
      aTableInfo.Zeilen       := Form.edt_Zeilen.Value;
      aTableInfo.Rahmendicke  := Form.edt_Rahmendicke.Value;
      aTableInfo.Zellendicke  := Form.edt_Zellendicke.Value;
      aTableInfo.Tabellefarbe := Form.cmd_TableColor.Color;
      aTableInfo.Rahmenfarbe  := Form.cmd_BorderColor.Color;
      aTableInfo.Zellenrahmenfarbe := Form.cmd_CellBorderColor.Color;
    end;
  finally
    FreeAndNil(Form);
  //  AfterShowForm(fStyle);
  end;
end;


end.
