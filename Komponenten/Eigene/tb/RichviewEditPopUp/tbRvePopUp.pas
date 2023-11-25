unit tbRvePopUp;

interface

uses
  SysUtils, Classes, Menus, tbRichviewEdit, RvStyle, RvEdit, Forms,
  Windows, RVFuncs, PtblRV, RVScroll, Dialogs, RvMisc, RvTable, Graphics,
  RvItem, RvUni, cRvePopUp;

type
  TtbRvePopUp = class(TPopupMenu)
  private
    FRv: TtbRichviewEdit;
    FSaveDialog: TSaveDialog;
    FPrinterDialog: TPrinterSetupDialog;
    FOpenDialog :TOpenDialog;
    FFileName: string;
    FPrint: TRvPrint;
    FFindDialog: TFindDialog;
    FReplaceDialog: TReplaceDialog;
    procedure SetRv(const Value: TtbRichviewEdit);
    procedure NeuClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure UnDoClick(Sender: TObject);
    procedure CutClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure TabNeuClick(Sender: TObject);
    procedure TabMergeCells(Sender: TObject);
    procedure TabInsertRowAbove(Sender: TObject);
    procedure TabInsertRowBelow(Sender: TObject);
    procedure TabInsertColLeft(Sender: TObject);
    procedure TabInsertColRight(Sender: TObject);
    procedure TabDeleteRows(Sender: TObject);
    procedure TabDeleteColumns(Sender: TObject);
    procedure TabSplittVert(Sender: TObject);
    procedure TabSplittHor(Sender: TObject);
    procedure TabUnMergeRows(Sender: TObject);
    procedure TabUnMergeColumns(Sender: TObject);
    procedure TabUnMergeRowsAndColumns(Sender: TObject);
    procedure SeitenumbruchClick(Sender: TObject);
    procedure EinfDateiClick(Sender: TObject);
    procedure EinfBildClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    function getMenuItem(aSearchName: string): TMenuItem;
    procedure FindDialogFind(Sender: TObject);
    procedure CellsOperation(aValue: Integer);
    procedure ReplaceDialogReplace(Sender: TObject);
    function IsEqualText(s1, s2: String; CaseSensitive: Boolean): Boolean;
    procedure SuchenUndErsetzenClick(Sender: TObject);
    function ShowTableEditor(var aTableInfo: RTableInfo): Boolean;
    procedure EinfLinieClick(Sender: TObject);
    procedure ShowLinie;
  protected
    procedure DoPopup(Sender: TObject); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RichviewEdit: TtbRichviewEdit read FRv write SetRv;
  end;

procedure Register;

implementation

uses
  fntRveTableEditor, fntRveLinie;

procedure Register;
begin
  RegisterComponents('Samples', [TtbRvePopUp]);
end;

{ TtbRvePopUp }


constructor TtbRvePopUp.Create(AOwner: TComponent);
  function NewItem(aName, aCaption: string; aShortCut: TShortCut): TMenuItem;
  begin
    Result := TMenuItem.Create(Self);
    Result.Name    := aName;
    Result.Caption := aCaption;
    if aShortCut <> ShortCut(0, []) then
      Result.ShortCut := aShortCut;
  end;
var
  mi: TMenuItem;
  mi_SubMen: TMenuItem;
  ShortCutNil: TShortCut;
begin
  inherited;
  if (AOwner<>nil) And (csDesigning In ComponentState) And Not (csReading In AOwner.ComponentState) then
  begin
    while Items.Count > 0 do
      Items.Delete(0);
    // Datei
    ShortCutNil := ShortCut(0, []);
    mi := NewItem('mnu_Datei', 'Datei', ShortCutNil);
    Items.Add(mi);
    mi := NewItem('mnu_Neu', 'Neu', ShortCutNil);
    mi.OnClick := NeuClick;
    Items.Items[0].Add(mi);
    mi := NewItem('mnu_Oeffnen','Öffnen', ShortCutNil);
    Items.Items[0].Add(mi);
    mi := NewItem('mnu_Speichern', 'Speichern', ShortCutNil);
    Items.Items[0].Add(mi);
    mi := NewItem('mnu_SpeichernUnter', 'Speichern unter', ShortCutNil);
    Items.Items[0].Add(mi);
    mi := NewItem('mnu_Strich1','-', ShortCutNil);
    Items.Items[0].Add(mi);
    mi := NewItem('mnu_Drucken','Drucken', ShortCutNil);
    Items.Items[0].Add(mi);

    // Bearbeiten
    mi := NewItem('mnu_Bearbeiten','Bearbeiten', ShortCutNil);
    Items.Add(mi);
    mi := NewItem('mnu_Rueckgaengig','Rückgängig', ShortCut(Word('U'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Strich2', '-', ShortCutNil);
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_SelectAll','Alles selektieren', ShortCut(Word('A'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Strich8', '-', ShortCutNil);
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Ausschneiden','Ausschneiden', ShortCut(Word('X'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Kopieren','Kopieren', ShortCut(Word('C'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Einfuegen','Einfügen', ShortCut(Word('V'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Loeschen','Löschen', ShortCutNil);
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Strich3', '-', ShortCutNil);
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_Suchen','Suchen', ShortCut(Word('F'), [ssCtrl]));
    Items.Items[1].Add(mi);
    mi := NewItem('mnu_SuchenUndErsetzen','Suchen und Ersetzen', ShortCut(Word('R'), [ssCtrl]));
    Items.Items[1].Add(mi);
    //mi := NewItem('mnu_Weitersuchen','Weitersuchen', nil);
    //Items.Items[1].Add(mi);

    // Tabelle
    mi := NewItem('mnu_Tabelle','Tabelle', ShortCutNil);
    Items.Add(mi);
    mi := NewItem('mnu_TabNeu', 'Neu', ShortCutNil);
    Items.Items[2].Add(mi);
    mi := NewItem('mnu_Strich4', '-', ShortCutNil);
    Items.Items[2].Add(mi);

    // Einfügen
    mi_SubMen := NewItem('mnu_TabEinfuegen', 'Einfügen', ShortCutNil);
    Items.Items[2].Add(mi_SubMen);
    mi := NewItem('mnu_ZeileDarueber','Zeile darüber', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_ZeileDarunter','Zeile darunter', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_Strich6','-', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_SpalteLinks','Links', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_SpalteRechts','Rechts', ShortCutNil);
    mi_SubMen.Add(mi);

    // Löschen
    mi_SubMen := NewItem('mnu_TabLoeschen', 'Löschen', ShortCutNil);
    mi_SubMen.Caption := 'Löschen';
    Items.Items[2].Add(mi_SubMen);
    mi := NewItem('mnu_TabDelZeilen', 'Zeilen', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_TabDelZellen', 'Zellen', ShortCutNil);
    mi_SubMen.Add(mi);

    mi := NewItem('mnu_Strich5','-', ShortCutNil);
    Items.Items[2].Add(mi);

    mi := NewItem('mnu_TabZelleVerbinden','Zelle verbinden', ShortCutNil);
    Items.Items[2].Add(mi);

    // Splitten
    mi_SubMen := NewItem('mnu_TabSplitten','Splitten', ShortCutNil);
    Items.Items[2].Add(mi_SubMen);
    mi := NewItem('mnu_TabVertikal','Vertikal', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_TabHorizontal','Horizontal', ShortCutNil);
    mi_SubMen.Add(mi);

    // Verbinden
    mi_SubMen := NewItem('mnu_TabVerbinden','Verbinden', ShortCutNil);
    Items.Items[2].Add(mi_SubMen);
    mi := NewItem('mnu_TabZeilen','Zeilen', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_TabSpalten','Spalten', ShortCutNil);
    mi_SubMen.Add(mi);
    mi := NewItem('mnu_TabZeilenUndSpalten','Zeilen und Spalten', ShortCutNil);
    mi_SubMen.Add(mi);

    // Datei einfügen
    mi := NewItem('mnu_DatEinfuegen','Einfügen', ShortCutNil);
    Items.Add(mi);
    mi := NewItem('mnu_EinfDatei', 'Datei', ShortCutNil);
    Items.Items[3].Add(mi);
    mi := NewItem('mnu_EinfBild', 'Bild', ShortCutNil);
    Items.Items[3].Add(mi);
    mi := NewItem('mnu_Strich7','-', ShortCutNil);
    Items.Items[3].Add(mi);
    mi := NewItem('mnu_Seitenumbruch','Seitenumbruch', ShortCutNil);
    Items.Items[3].Add(mi);
    mi := NewItem('mnu_Linie','Linie', ShortCutNil);
    Items.Items[3].Add(mi);

  end;
  FSaveDialog    := TSaveDialog.Create(Self);
  FPrinterDialog := TPrinterSetupDialog.Create(Self);
  FOpenDialog    := TOpenDialog.Create(Self);
  FPrint         := TRvPrint.Create(Self);
  FFindDialog    := TFindDialog.Create(Self);
  FFindDialog.OnFind := FindDialogFind;
  FReplaceDialog     := TReplaceDialog.Create(Self);
  FReplaceDialog.OnReplace := ReplaceDialogReplace;
  FReplaceDialog.OnFind := FindDialogFind;
end;

destructor TtbRvePopUp.Destroy;
begin
  FreeAndNil(FSaveDialog);
  FreeAndNil(FPrinterDialog);
  FreeAndNil(FOpenDialog);
  FreeAndNil(FPrint);
  FreeAndNil(FFindDialog);
  FreeAndNil(FReplaceDialog);
  inherited;
end;


procedure TtbRvePopUp.FindClick(Sender: TObject);
begin
  FFindDialog.Execute;
end;

procedure TtbRvePopUp.FindDialogFind(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  if not FRv.SearchText(FFindDialog.FindText,
                           GetRVESearchOptions(FFindDialog.Options)) then
   Application.MessageBox('Suche beendet', 'Suche beendet', MB_OK or MB_ICONEXCLAMATION);
end;

procedure TtbRvePopUp.ReplaceDialogReplace(Sender: TObject);
var
  c: Integer;
begin
  if frReplace in FReplaceDialog.Options then
  begin
    if IsEqualText(FRv.GetSelText, FReplaceDialog.FindText, frMatchCase in FReplaceDialog.Options) then
      FRv.InsertText(FReplaceDialog.ReplaceText,False);
    if not FRv.SearchText(FReplaceDialog.FindText,GetRVESearchOptions(FReplaceDialog.Options)) then
       Application.MessageBox('Suche und Ersetzen', 'Wort nicht gefunden', MB_OK or MB_ICONEXCLAMATION);
  end
  else if frReplaceAll in FReplaceDialog.Options then begin
    c := 0;
    if IsEqualText(FRv.GetSelText, FReplaceDialog.FindText, frMatchCase in FReplaceDialog.Options) then begin
      FRv.InsertText(FReplaceDialog.ReplaceText,False);
      inc(c);
    end;
    while FRv.SearchText(FReplaceDialog.FindText,GetRVESearchOptions(FReplaceDialog.Options)) do
    begin
      FRv.InsertText(FReplaceDialog.ReplaceText,False);
      inc(c);
    end;
    Application.MessageBox('Ersetzt', PWideChar('Es wurden ' +IntToStr(c) + ' ersetzt'), MB_OK or MB_ICONEXCLAMATION);
  end;
end;


function TtbRvePopUp.IsEqualText(s1, s2: String; CaseSensitive: Boolean): Boolean;
begin
  if CaseSensitive then
    Result := s1=s2
  else
    Result := AnsiLowerCase(s1)=AnsiLowerCase(s2);
end;



procedure TtbRvePopUp.CutClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.Copy;
  FRv.DeleteSelection;
end;

procedure TtbRvePopUp.DelClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  if FRv.SelectionExists then
    FRv.DeleteSelection;
end;



procedure TtbRvePopUp.DoPopup(Sender: TObject);
  procedure SetMenuItemEnable(aName: string; aEnable: Boolean);
  var
    mi: TMenuItem;
  begin
    mi := getMenuItem(aName);
    if (mi <> nil) and (Assigned(mi.OnClick)) then
      mi.Enabled := aEnable;
  end;
var
  mi: TMenuItem;
  item: TCustomRVItemInfo;
  table: TRVTableItemInfo;
  r,c,cs,rs: Integer;
  rve: TCustomRichViewEdit;
  Selected, SelectionRectangular: Boolean;
begin
  mi := getMenuItem('mnu_Loeschen');
  if mi <> nil then
  begin
    if Assigned(mi.OnClick) then
    begin
      if not Assigned(FRv) then
        exit;
      mi.Enabled := FRv.SelectionExists;
    end;
  end;

  SetMenuItemEnable('mnu_ZeileDarueber', true);
  SetMenuItemEnable('mnu_ZeileDarunter', true);
  SetMenuItemEnable('mnu_SpalteLinks', true);
  SetMenuItemEnable('mnu_SpalteRechts', true);
  SetMenuItemEnable('mnu_TabDelZeilen', true);
  SetMenuItemEnable('mnu_TabDelZellen', true);

  SetMenuItemEnable('mnu_TabZelleVerbinden', false);
  SetMenuItemEnable('mnu_TabVertikal', false);
  SetMenuItemEnable('mnu_TabHorizontal', false);
  SetMenuItemEnable('mnu_TabZeilen', false);
  SetMenuItemEnable('mnu_TabSpalten', false);
  SetMenuItemEnable('mnu_TabZeilenUndSpalten', false);


  if not FRv.GetCurrentItemEx(TRVTableItemInfo, rve, item) then
  begin
    SetMenuItemEnable('mnu_ZeileDarueber', false);
    SetMenuItemEnable('mnu_ZeileDarunter', false);
    SetMenuItemEnable('mnu_SpalteLinks', false);
    SetMenuItemEnable('mnu_SpalteRechts', false);
    SetMenuItemEnable('mnu_TabDelZeilen', false);
    SetMenuItemEnable('mnu_TabDelZellen', false);
    exit;
  end;

  table := TRVTableItemInfo(item);
  Selected := table.GetNormalizedSelectionBounds(True,r,c,cs,rs);
  SelectionRectangular := Selected and
                          (table.CanMergeSelectedCells(True) or
                           (table.GetEditedCell(r,c)<>nil));

  if table.CanMergeSelectedCells(True) then
    SetMenuItemEnable('mnu_TabZelleVerbinden', true)
  else
    SetMenuItemEnable('mnu_TabZelleVerbinden', false);

  SetMenuItemEnable('mnu_TabVertikal', SelectionRectangular);
  SetMenuItemEnable('mnu_TabHorizontal', SelectionRectangular);

  SetMenuItemEnable('mnu_TabZeilen', SelectionRectangular);
  SetMenuItemEnable('mnu_TabSpalten', SelectionRectangular);
  SetMenuItemEnable('mnu_TabZeilenUndSpalten', SelectionRectangular);


{
var item: TCustomRVItemInfo;
    table: TRVTableItemInfo;
    r,c,cs,rs: Integer;
    rve: TCustomRichViewEdit;
    Selected, SelectionRectangular: Boolean;
begin
  if not RichViewEdit1.GetCurrentItemEx(TRVTableItemInfo, rve, item) then begin
    mitRowsAbove.Enabled         := False;
    mitRowsBelow.Enabled         := False;
    mitColsLeft.Enabled          := False;
    mitColsRight.Enabled         := False;
    mitDelRows.Enabled           := False;
    mitDelColumns.Enabled        := False;
    mitMergeCells.Enabled        := False;
    mitUmRows.Enabled            := False;
    mitUmCols.Enabled            := False;
    mitUmRowsAndCols.Enabled     := False;
    mitSplitVertically.Enabled   := False;
    mitSplitHorizontally.Enabled := False;
    exit;
  end;
  table := TRVTableItemInfo(item);
  Selected := table.GetNormalizedSelectionBounds(True,r,c,cs,rs);
  mitRowsAbove.Enabled         := Selected;
  mitRowsBelow.Enabled         := Selected;
  mitColsLeft.Enabled          := Selected;
  mitColsRight.Enabled         := Selected;
  mitDelRows.Enabled           := Selected;
  mitDelColumns.Enabled        := Selected;
  mitMergeCells.Enabled        := table.CanMergeSelectedCells(True);
  SelectionRectangular := Selected and
                          (table.CanMergeSelectedCells(True) or
                           (table.GetEditedCell(r,c)<>nil));
  mitSplitVertically.Enabled   := SelectionRectangular;
  mitSplitHorizontally.Enabled := SelectionRectangular;
  mitUmRows.Enabled            := SelectionRectangular;
  mitUmCols.Enabled            := SelectionRectangular;
  mitUmRowsAndCols.Enabled     := SelectionRectangular;
end;


  SetNotifyClick('mnu_TabZelleVerbinden', TabMergeCells);
  SetNotifyClick('mnu_ZeileDarueber', TabInsertRowAbove);
  SetNotifyClick('mnu_ZeileDarunter', TabInsertRowBelow);
  SetNotifyClick('mnu_SpalteLinks', TabInsertColLeft);
  SetNotifyClick('mnu_SpalteRechts', TabInsertColRight);
  SetNotifyClick('mnu_TabDelZeilen', TabDeleteRows);
  SetNotifyClick('mnu_TabDelZellen', TabDeleteColumns);
  SetNotifyClick('mnu_TabVertikal', TabSplittVert);
  SetNotifyClick('mnu_TabHorizontal', TabSplittHor);
  SetNotifyClick('mnu_TabZeilen', TabUnMergeRows);
  SetNotifyClick('mnu_TabSpalten', TabUnMergeColumns);
  SetNotifyClick('mnu_TabZeilenUndSpalten', TabUnMergeRowsAndColumns);


}


  inherited;
end;

procedure TtbRvePopUp.EinfBildClick(Sender: TObject);
var
  gr: TGraphic;
begin
  if not Assigned(FRv) then
    exit;
  FOpenDialog.Title  := 'Bild einfügen';
  FOpenDialog.Filter := 'Bilder(*.bmp;*.wmf;*.emf;*.ico;*.jpg)|*.bmp;*.wmf;*.emf;*.ico;*.jpg|All(*.*)|*.*';

  if FOpenDialog.Execute then
  begin
    gr := nil;
    //gr := RVGraphicHandler.LoadFromFile(FOpenDialog.FileName); <-- das funktioniert unter D2010
    if gr <> nil then
      FRv.InsertPicture('', gr, rvvaBaseline)
    else
      Application.MessageBox(PChar('Das Bild kann nicht eingelesen werden. '+ FOpenDialog.FileName), 'Error',
         MB_OK or MB_ICONSTOP);
  end;
end;

procedure TtbRvePopUp.EinfDateiClick(Sender: TObject);
var
  r: Boolean;
begin
  if not Assigned(FRv) then
    exit;
  FOpenDialog.Title := 'Datei einfügen';
  FOpenDialog.Filter := 'RichView Format Datei(*.rvf)|*.rvf|'+
                        'RTF Dateien(*.rtf)|*.rtf|'+
                        'Text Datien - autodetect (*.txt)|*.txt|'+
                        'ANSI Text Dateien (*.txt)|*.txt|'+
                        'Unicode Text Dateien (*.txt)|*.txt|'+
                        'OEM Text Dateien (*.txt)|*.txt';
  if FOpenDialog.Execute then
  begin
    //Screen.Cursor := crHourglass;
    case FOpenDialog.FilterIndex of
      1: // RVF
        r := FRv.InsertRVFFromFileEd(FOpenDialog.FileName);
      2: // RTF
        r := FRv.InsertRTFFromFileEd(FOpenDialog.FileName);
      3: // Text
        begin
          if RV_TestFileUnicode(FOpenDialog.FileName)=rvutYes then
            r := FRv.InsertTextFromFileW(FOpenDialog.FileName)
          else
            r := FRv.InsertTextFromFile(FOpenDialog.FileName);
        end;
      4: // ANSI Text
        r := FRv.InsertTextFromFile(FOpenDialog.FileName);
      5: // Unicode Text
        r := FRv.InsertTextFromFileW(FOpenDialog.FileName);
      6: // OEM Text
        r := FRv.InsertOEMTextFromFile(FOpenDialog.FileName);
      else
        r := False;
    end;
    //Screen.Cursor := crDefault;
    if not r then
      Application.MessageBox('Fehler beim Lesen der Datei', 'Error',
                             MB_OK or MB_ICONSTOP);
  end;
end;


procedure TtbRvePopUp.EinfLinieClick(Sender: TObject);
begin
  ShowLinie;
end;

procedure TtbRvePopUp.NeuClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.Clear;
  FRv.Format;
end;

procedure TtbRvePopUp.OpenClick(Sender: TObject);
begin
  FOpenDialog.Title  := '';
  FOpenDialog.Filter := '';
  if FOpenDialog.Execute then
    FFileName := FOpenDialog.FileName;
end;

procedure TtbRvePopUp.PasteClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.Paste;
end;

procedure TtbRvePopUp.PrintClick(Sender: TObject);
begin
  if FPrinterDialog.Execute then
  begin
    FPrint.AssignSource(FRv);
    FPrint.FormatPages(rvdoALL);
    if FPrint.PagesCount>0 then
      FPrint.Print('',1,False);
  end;
end;

procedure TtbRvePopUp.SaveAsClick(Sender: TObject);
begin
  FSaveDialog.Filter := 'Richtext|*.rtf';
  FSaveDialog.DefaultExt := 'rtf';
  if FSaveDialog.Execute then
    FFileName := FSaveDialog.FileName;
end;

procedure TtbRvePopUp.SaveClick(Sender: TObject);
begin  //
  if FFileName = '' then
  begin
    SaveAsClick(Sender);
    exit;
  end;
  if FFileName > '' then
  begin
    FRv.SaveRTF(FFileName, False);
    FRv.Modified := False;
  end;
end;

procedure TtbRvePopUp.CopyClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.Copy;
end;



procedure TtbRvePopUp.SetRv(const Value: TtbRichviewEdit);
begin
  FRv := Value;
end;

procedure TtbRvePopUp.SuchenUndErsetzenClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FReplaceDialog.Execute;
end;

procedure TtbRvePopUp.TabDeleteColumns(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(6);
end;

procedure TtbRvePopUp.TabDeleteRows(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(5);
end;

procedure TtbRvePopUp.TabInsertColLeft(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(3);
end;

procedure TtbRvePopUp.TabInsertColRight(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(4);
end;

procedure TtbRvePopUp.TabInsertRowAbove(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(1);
end;

procedure TtbRvePopUp.TabInsertRowBelow(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(2);
end;

procedure TtbRvePopUp.TabMergeCells(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(7);
end;

procedure TtbRvePopUp.CellsOperation(aValue: Integer);
var
  item: TCustomRVItemInfo;
  table: TRVTableItemInfo;
  Data: Integer;
  r,c,cs,rs: Integer;
  s: String;
  rve: TCustomRichViewEdit;
  ItemNo: Integer;
begin
  if not FRv.CanChange or
     not FRv.GetCurrentItemEx(TRVTableItemInfo, rve, item) then
    exit;
  table := TRVTableItemInfo(item);
  ItemNo := rve.GetItemNo(table);
  rve.BeginItemModify(ItemNo, Data);
  case aValue of
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
        if rs=table.Rows.Count then begin
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
        if cs=table.Rows[0].Count then begin
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
        if InputQuery('Splitten Vertikal','Spalten (in jeder selektierten Zelle):',s) then begin
          table.SplitSelectedCellsVertically(StrToIntDef(s,0));
        end;
      end;
    12:
      begin
        s := '2';
        if InputQuery('Splitten Horizontal','Zeilen (in jeder selektierten Zelle):',s) then begin
          table.SplitSelectedCellsHorizontally(StrToIntDef(s,0));
        end;
      end;
  end;
  rve.EndItemModify(ItemNo, Data);
  rve.Change;
end;


procedure TtbRvePopUp.TabNeuClick(Sender: TObject);
var
  table: TRVTableItemInfo;
  r,c: Integer;
  TableInfo: RTableInfo;
begin
  if not Assigned(FRv) then
    exit;

  TableInfo.Tabellefarbe      := -16777211;
  TableInfo.Rahmenfarbe       := -16777211;
  TableInfo.Zellenrahmenfarbe := -16777211;
  if not ShowTableEditor(TableInfo) then
    exit;

  table := TRVTableItemInfo.CreateEx(TableInfo.Zeilen, TableInfo.Spalten, FRv.RVData);
  table.BorderWidth     := TableInfo.Rahmendicke;
  table.CellBorderWidth := TableInfo.Zellendicke;
  table.Color           := TableInfo.Tabellefarbe;
  table.BorderColor     := TableInfo.Rahmenfarbe;
  table.CellBorderColor := TableInfo.Zellenrahmenfarbe;

  for r := 0 to table.Rows.Count-1 do
    for c := 0 to table.Rows[r].Count-1 do
      table.Cells[r,c].BestWidth := 100;

  FRv.InsertItem('', table);
  FRv.Format;

end;

procedure TtbRvePopUp.TabSplittHor(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(12);
end;

procedure TtbRvePopUp.TabSplittVert(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(11);
end;

procedure TtbRvePopUp.TabUnMergeColumns(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(8);
end;

procedure TtbRvePopUp.TabUnMergeRows(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(9);
end;

procedure TtbRvePopUp.TabUnMergeRowsAndColumns(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  CellsOperation(10);
end;

procedure TtbRvePopUp.SeitenumbruchClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.InsertPageBreak;
end;


procedure TtbRvePopUp.SelectAllClick(Sender: TObject);
begin
  if not Assigned(FRv) then
    exit;
  FRv.SelectAll;
  FRv.SetFocus;
  FRv.Invalidate;
end;

procedure TtbRvePopUp.UnDoClick(Sender: TObject);
begin
  if Assigned(FRv) then
    FRv.Undo;
end;

function TtbRvePopUp.getMenuItem(aSearchName: string): TMenuItem;
  procedure Iterate(mi:TMenuItem; aSearchName: string; var aResultMenu: TMenuItem);
  var
    i1: Integer;
  begin
    if SameText(mi.Name, aSearchname) then
    begin
      aResultMenu := mi;
      exit;
    end;
    for i1 := 0 to mi.Count - 1 do Iterate(mi.Items[i1], aSearchName, aResultMenu);
  end;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to Items.Count - 1 do
  begin
    Iterate(Items[i1], aSearchName, Result);
    if Result <> nil then
      exit;
  end;
end;



procedure TtbRvePopUp.Loaded;
  procedure SetNotifyClick(aMenuName: string; aClickEvent: TNotifyEvent);
  var
    mi: TMenuItem;
  begin
    mi := getMenuItem(aMenuName);
    if mi = nil then
      exit;
    if not Assigned(mi.OnClick) then
      mi.OnClick := aClickEvent;
  end;
begin
  inherited;
  SetNotifyClick('mnu_Neu', NeuClick);
  SetNotifyClick('mnu_Oeffnen', OpenClick);
  SetNotifyClick('mnu_Speichern', SaveClick);
  SetNotifyClick('mnu_SpeichernUnter', SaveAsClick);
  SetNotifyClick('mnu_Drucken', PrintClick);
  SetNotifyClick('mnu_Rueckgaengig', UnDoClick);
  SetNotifyClick('mnu_Ausschneiden', CutClick);
  SetNotifyClick('mnu_Kopieren', CopyClick);
  SetNotifyClick('mnu_Einfuegen', PasteClick);
  SetNotifyClick('mnu_Loeschen', DelClick);
  SetNotifyClick('mnu_Suchen', FindClick);
  SetNotifyClick('mnu_TabNeu', TabNeuClick);
  SetNotifyClick('mnu_TabZelleVerbinden', TabMergeCells);
  SetNotifyClick('mnu_ZeileDarueber', TabInsertRowAbove);
  SetNotifyClick('mnu_ZeileDarunter', TabInsertRowBelow);
  SetNotifyClick('mnu_SpalteLinks', TabInsertColLeft);
  SetNotifyClick('mnu_SpalteRechts', TabInsertColRight);
  SetNotifyClick('mnu_TabDelZeilen', TabDeleteRows);
  SetNotifyClick('mnu_TabDelZellen', TabDeleteColumns);
  SetNotifyClick('mnu_TabVertikal', TabSplittVert);
  SetNotifyClick('mnu_TabHorizontal', TabSplittHor);
  SetNotifyClick('mnu_TabZeilen', TabUnMergeRows);
  SetNotifyClick('mnu_TabSpalten', TabUnMergeColumns);
  SetNotifyClick('mnu_TabZeilenUndSpalten', TabUnMergeRowsAndColumns);
  SetNotifyClick('mnu_Seitenumbruch', SeitenumbruchClick);
  SetNotifyClick('mnu_EinfDatei', EinfDateiClick);
  SetNotifyClick('mnu_EinfBild', EinfBildClick);
  SetNotifyClick('mnu_SelectAll', SelectAllClick);
  SetNotifyClick('mnu_SuchenundErsetzen', SuchenUndErsetzenClick);
  SetNotifyClick('mnu_Linie', EinfLinieClick);

end;


function TtbRvePopUp.ShowTableEditor(var aTableInfo: RTableInfo): Boolean;
var
  Form: Tfrm_RveTableEditor;
begin
  Result := false;
  Form := Tfrm_RveTableEditor.Create(Self);
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
  end;

end;

procedure TtbRvePopUp.ShowLinie;
var
  Form: Tfrm_RveLinie;
begin
  if not Assigned(FRv) then
    exit;
  Form := Tfrm_RveLinie.Create(Self);
  try
    Form.FormStyle := fsStayOnTop;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    if Form.cob_Linienart.ItemIndex = -1 then
      exit;
    if Form.cob_Linienart.ItemIndex = 0 then
      FRv.InsertBreak(Form.edt_Width.Value, rvbsLine, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 1 then
      FRv.InsertBreak(Form.edt_Width.Value, rvbsDotted, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 2 then
      FRv.InsertBreak(Form.edt_Width.Value, rvbsDashed, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 3 then
      FRv.InsertBreak(Form.edt_Width.Value, rvbsRectangle, Form.btn_Color.Color);
  finally
    FreeAndNil(Form);
  end;
end;





{
procedure TForm1.rdFind(Sender: TObject);
begin
  if not rve.SearchText(rd.FindText,GetRVESearchOptions(rd.Options)) then
    ShowInfo('String not found','Search and Replace');
end;
procedure TForm1.rdReplace(Sender: TObject);
var c: Integer;
begin
  if frReplace in rd.Options then begin
    if IsEqualText(rve.GetSelText, rd.FindText, frMatchCase in rd.Options) then
      rve.InsertText(rd.ReplaceText,False);
    if not rve.SearchText(rd.FindText,GetRVESearchOptions(rd.Options)) then
      ShowInfo('String not found','Search and Replace');
    end
  else if frReplaceAll in rd.Options then begin
    c := 0;
    if IsEqualText(rve.GetSelText, rd.FindText, frMatchCase in rd.Options) then begin
      rve.InsertText(rd.ReplaceText,False);
      inc(c);
    end;
    while rve.SearchText(rd.FindText,GetRVESearchOptions(rd.Options)) do begin
      rve.InsertText(rd.ReplaceText,False);
      inc(c);
    end;
    ShowInfo(Format('There were %d replacements',[c]),'Replace');
  end;
end;
}

//  RichViewEdit1.InsertPageBreak;



end.
