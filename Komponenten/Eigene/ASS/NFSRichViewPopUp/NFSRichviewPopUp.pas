unit NFSRichviewPopUp;

interface

uses
  System.SysUtils, System.Classes, Vcl.Menus, NFSRichViewEdit, Vcl.Dialogs;

type
  TEnumMenuItemProc = procedure (item: TMenuItem) of object;


type
  TNFSRichviewPopUp = class(TPopupMenu)
  private
    fRv: TNFSRichViewEdit;
    fFindMenuItem: TMenuItem;
    fOnFormatZwischenablage: TNotifyEvent;
    procedure EnumMenuItem(item: TMenuItem);
    function FindEnumerateMenuItems(aName: string; item: TMenuItem; proc: TEnumMenuItemProc): TMenuItem;
    procedure setRv(const Value: TNFSRichViewEdit);
    procedure setFormatZwischenablage;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure CreateItems;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopUpItemClick(Sender: TObject);
    function FindMenuItemByName(aName: string): TMenuItem;
  published
    property RichviewEdit: TNFSRichViewEdit read fRv write setRv;
    property OnFormatZwischenablage: TNotifyEvent read fOnFormatZwischenablage write fOnFormatZwischenablage;
  end;

procedure Register;

implementation

uses
  RvEdit;



procedure Register;
begin
  RegisterComponents('Optima', [TNFSRichviewPopUp]);
end;

{ TNFSRichviewPopUp }


procedure EnumerateMenuItems(item: TMenuItem; proc: TEnumMenuItemProc);
var
  i: Integer;
  subItem: TMenuItem;
begin
  for i := 0 to Pred(item.Count) do
  begin
    subItem := item.Items[i];
    proc(subItem);
    if subItem.Count > 0 then
      EnumerateMenuItems(subItem, proc);
  end;
end;


constructor TNFSRichviewPopUp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fRv := nil;
  If (AOwner<>nil) And (csDesigning In ComponentState) And Not (csReading In AOwner.ComponentState) then
    CreateItems;
end;

destructor TNFSRichviewPopUp.Destroy;
begin
  inherited;
end;



procedure TNFSRichviewPopUp.EnumMenuItem(item: TMenuItem);
begin
  if Assigned(Item.OnClick) then
    exit;
  Item.OnClick := PopUpItemClick;
end;

procedure TNFSRichviewPopUp.Loaded;
begin
  inherited;
  EnumerateMenuItems(Items, EnumMenuItem);
end;

function TNFSRichviewPopUp.FindEnumerateMenuItems(aName: string; item: TMenuItem; proc: TEnumMenuItemProc): TMenuItem;
var
  i: Integer;
  subItem: TMenuItem;
begin
  Result := nil;
  for i := 0 to Pred(item.Count) do
  begin
    subItem := item.Items[i];
    if SameText(aName, SubItem.Name) then
    begin
      fFindMenuItem := subItem;
      exit;
    end;
    if subItem.Count > 0 then
      FindEnumerateMenuItems(aName, subItem, proc);
  end;
end;


function TNFSRichviewPopUp.FindMenuItemByName(aName: string): TMenuItem;
begin
  fFindMenuItem := nil;
  FindEnumerateMenuItems(aName, Items, EnumMenuItem);
  Result := fFindMenuItem;
end;




procedure TNFSRichviewPopUp.CreateItems;
  function CreateItem(aSourceItem: TMenuItem; aName, aCaption, aShortCut: string; aOnClick: TNotifyEvent): TMenuItem;
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.Name := aName;
    NewItem.Caption := aCaption;
    Newitem.OnClick := aOnClick;
    if aShortCut > '' then
      NewItem.ShortCut := TextToShortCut(aShortCut);
    aSourceItem.Add(NewItem);
    Result := NewItem;
  end;
var
  Item: TMenuItem;
begin
  //exit;
  Items.clear;
  CreateItem(Items, 'mnu_HDatei', 'Datei', '', nil);
  CreateItem(Items, 'mnu_HBearbeiten', 'Bearbeiten', '', nil);
  CreateItem(Items, 'mnu_HEinfuegen', 'Einfügen', '', nil);
  CreateItem(Items, 'mnu_HTabelle', 'Tabelle', '', nil);
  CreateItem(Items, 'mnu_HZwischenablage', 'Zwischenablage', '', nil);

  CreateItem(Items[0], 'mnu_Oeffnen', 'Öffnen', '', nil);
  CreateItem(Items[0], 'mnu_Speichern', 'Speichern', '', nil);
  CreateItem(Items[0], 'mnu_AllesEntfernen', 'Alles entfernen', '', nil);
  CreateItem(Items[0], 'mnu_Druckvorschau', 'Druckvorschau', '', nil);
  CreateItem(Items[0], 'mnu_Drucken', 'Drucken', '', nil);

  CreateItem(Items[1], 'mnu_Rueckgaengig', 'Rückgängig', 'Strg+Z', nil);
  CreateItem(Items[1], 'mnu_Strich1', '-', '', nil);
  CreateItem(Items[1], 'mnu_Ausschneiden', 'Ausschneiden', 'Strg+X', nil);
  CreateItem(Items[1], 'mnu_Kopieren', 'Kopieren', 'Strg+C', nil);
  CreateItem(Items[1], 'mnu_Einfuegen', 'Einfügen', 'Strg+V', nil);
  CreateItem(Items[1], 'mnu_Loeschen', 'Löschen', 'Entf', nil);
  CreateItem(Items[1], 'mnu_Strich2', '-', '', nil);
  CreateItem(Items[1], 'mnu_AllesMarkieren', 'Alles markieren', 'Strg+A', nil);
  CreateItem(Items[1], 'mnu_Suchen', 'Suchen', 'Strg+F', nil);
  CreateItem(Items[1], 'mnu_SuchenUndErsetzen', 'Suchen und Ersetzen', 'Strg+H', nil);
  CreateItem(Items[1], 'mnu_Strich3', '-', '', nil);
  CreateItem(Items[1], 'mnu_Seitenumbruch', 'Seitenumbruch', '', nil);

  CreateItem(Items[2], 'mnu_DateiEinfuegen', 'Datei einfügen', '', nil);
  CreateItem(Items[2], 'mnu_BildEinfuegen', 'Bild einfügen', '', nil);
  CreateItem(Items[2], 'mnu_Linie', 'Linie', '', nil);

  CreateItem(Items[3], 'mnu_TabEinfuegen', 'Tabelle einfügen', '', nil);
  Item := CreateItem(Items[3], 'mnu_TabelleEinfuegen', 'Einfügen', '', nil);
  CreateItem(Item, 'mnu_ZeileEinfuegen', 'Zeile einfügen', '', nil);
  CreateItem(Item, 'mnu_SpalteLinksEinfuegen', 'Spalte links einfügen', '', nil);
  CreateItem(Item, 'mnu_SpalteRechtsEinfuengen', 'Spalte rechts einfügen', '', nil);

  Item := CreateItem(Items[3], 'mnu_ZLoeschen', 'Löschen', '', nil);
  CreateItem(Item, 'mnu_ZeileLoeschen', 'Zeile löschen', '', nil);
  CreateItem(Item, 'mnu_SpalteLoeschen', 'Spalte löschen', '', nil);

  Item := CreateItem(Items[3], 'mnu_Verbinden', 'Verbinden', '', nil);
  CreateItem(Item, 'mnu_ZeilenVerbinden', 'Zeilen verbinden', '', nil);

  Item := CreateItem(Items[3], 'mnu_Trennen', 'Trennen', '', nil);
  CreateItem(Item, 'mnu_ZeilenTrennen', 'Zeilen trennen', '', nil);
  CreateItem(Item, 'mnu_SpaltenTrennen', 'Spalten trennen', '', nil);
  CreateItem(Item, 'mnu_SpaltenUndZeilenTrennen', 'Spalten und Zeilen trennen', '', nil);

  Item := CreateItem(Items[3], 'mnu_Splitten', 'Splitten', '', nil);
  CreateItem(Item, 'mnu_ZelleHorSplitten', 'Zelle Horizontal splitten', '', nil);
  CreateItem(Item, 'mnu_ZelleVerSplitten', 'Zelle Vertikal splitten', '', nil);

  CreateItem(Items[4], 'mnu_Format_Zwischenablage', 'Formatierung aus Zwischenablage beibehalten', '', nil);


end;




procedure TNFSRichviewPopUp.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRv) then
    fRv := nil;

end;


procedure TNFSRichviewPopUp.PopUpItemClick(Sender: TObject);
begin
  if fRV = nil then
    exit;
  if SameText(TMenuItem(Sender).Name, 'mnu_Oeffnen') then
    fRv.Open;
  if SameText(TMenuItem(Sender).Name, 'mnu_Speichern') then
    fRv.Save;
  if SameText(TMenuItem(Sender).Name, 'mnu_AllesEntfernen') then
    fRv.ClearAll;
  if SameText(TMenuItem(Sender).Name, 'mnu_Druckvorschau') then
    fRv.PrintPreview;
  if SameText(TMenuItem(Sender).Name, 'mnu_Drucken') then
    fRv.Print;
  if SameText(TMenuItem(Sender).Name, 'mnu_Rueckgaengig') then
    fRv.DoUndo;
  if SameText(TMenuItem(Sender).Name, 'mnu_Ausschneiden') then
    fRv.DoCut;
  if SameText(TMenuItem(Sender).Name, 'mnu_Kopieren') then
    fRv.DoCopy;
  if SameText(TMenuItem(Sender).Name, 'mnu_Einfuegen') then
    fRv.DoPaste;
  if SameText(TMenuItem(Sender).Name, 'mnu_Loeschen') then
    fRv.DoDelete;
  if SameText(TMenuItem(Sender).Name, 'mnu_AllesMarkieren') then
    fRv.DoSelectAll;
  if SameText(TMenuItem(Sender).Name, 'mnu_Suchen') then
    fRv.DoSearch;
  if SameText(TMenuItem(Sender).Name, 'mnu_SuchenUndErsetzen') then
    fRv.DoSearchAndReplace;
  if SameText(TMenuItem(Sender).Name, 'mnu_Seitenumbruch') then
    fRv.DoInsertPagebreak;
  if SameText(TMenuItem(Sender).Name, 'mnu_DateiEinfuegen') then
    fRv.DoInsertFile;
  if SameText(TMenuItem(Sender).Name, 'mnu_BildEinfuegen') then
    fRv.DoInsertPicture;
  if SameText(TMenuItem(Sender).Name, 'mnu_Linie') then
    fRv.DoInsertLine;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZeileEinfuegen') then
    fRv.CellsOperation.InsertTableRowsBelow;
  if SameText(TMenuItem(Sender).Name, 'mnu_SpalteLinksEinfuegen') then
    fRv.CellsOperation.InsertTableColLeft;
  if SameText(TMenuItem(Sender).Name, 'mnu_SpalteRechtsEinfuengen') then
    fRv.CellsOperation.InsertTableColRight;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZeileLoeschen') then
    fRv.CellsOperation.DeleteTableRow;
  if SameText(TMenuItem(Sender).Name, 'mnu_SpalteLoeschen') then
    fRv.CellsOperation.DeleteTableCol;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZeilenVerbinden') then
    fRv.CellsOperation.MergeCells;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZeilenTrennen') then
    fRv.CellsOperation.UnmergeRows;
  if SameText(TMenuItem(Sender).Name, 'mnu_SpaltenTrennen') then
    fRv.CellsOperation.UnmergeColumns;
  if SameText(TMenuItem(Sender).Name, 'mnu_SpaltenUndZeilenTrennen') then
    fRv.CellsOperation.UnmergeRowsAndColumns;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZelleHorSplitten') then
    fRv.CellsOperation.TableCellSplittHorizontal;
  if SameText(TMenuItem(Sender).Name, 'mnu_ZelleVerSplitten') then
    fRv.CellsOperation.TableCellSplittVertikal;
  if SameText(TMenuItem(Sender).Name, 'mnu_TabEinfuegen') then
    fRv.CellsOperation.InsertTable;
  if SameText(TMenuItem(Sender).Name, 'mnu_Format_Zwischenablage') then
  begin
    if (Assigned(fOnFormatZwischenablage)) then
      fOnFormatZwischenablage(Sender);
    setFormatZwischenablage;
  end;
end;


procedure TNFSRichviewPopUp.setFormatZwischenablage;
var
  MenuItem: TMenuItem;
begin
  if fRV = nil then
    exit;
  MenuItem := FindMenuItemByName('mnu_Format_Zwischenablage');
  if MenuItem = nil then
    exit;
  if MenuItem.Checked then
    fRV.AcceptPasteFormats := fRV.AcceptPasteFormats + [rvddRTF]
  else
    fRV.AcceptPasteFormats := fRV.AcceptPasteFormats - [rvddRTF];
end;

procedure TNFSRichviewPopUp.setRv(const Value: TNFSRichViewEdit);
begin
  fRv := Value;
  setFormatZwischenablage;
end;

end.
