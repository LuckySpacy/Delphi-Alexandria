unit Prop.NFSButtonPos;

interface

uses
  System.Classes, SysUtils, Contnrs, Buttons, Controls, Objekt.SortList, NFSToolbarTypes ;


type
  TPropNFSButtonPos = class(TPersistent)
  private
    fSortObjList: TSortObjList;
    FOnChange: TNotifyEvent;
    FBold: Integer;
    FUnterline: Integer;
    FItalic: Integer;
    FLeft: Integer;
    FCenter: Integer;
    FRight: Integer;
    FJustify: Integer;
    FFontcolor: Integer;
    FBackgroundcolor: Integer;
    FParagraphBackground: Integer;
    FBullets: Integer;
    FNumber: Integer;
    FSave: Integer;
    FOpen: Integer;
    FPicture: Integer;
    FLargeEditor: Integer;
    FTextHoch: Integer;
    FTextTief: Integer;
    FStandardfont: Integer;
    FFontfavoriten: Integer;
    FIndentInc: Integer;
    FIndentDec: Integer;
    FLinespace: Integer;
    FPrint: Integer;
    FClipboard: Integer;
    FReverse: Integer;
    FCut: Integer;
    FPaste: Integer;
    fSpellCheck: Integer;
    FFontbox: Integer;
    FFontsize: Integer;
    fChangedName: TNFSToolbarItem;
    fChangedValue: Integer;
    fChangeHigh: Boolean;
    fDurchnummerierungErlauben: Boolean;
    fOwner: TComponent;
    procedure DoPositionChange;
    procedure SetBold(const Value: Integer);
    procedure SetItalic(const Value: Integer);
    procedure SetUnterline(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetCenter(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetJustify(const Value: Integer);
    procedure SetFontcolor(const Value: Integer);
    procedure SetBackgroundcolor(const Value: Integer);
    procedure SetParagraphBackground(const Value: Integer);
    procedure SetBullets(const Value: Integer);
    procedure SetNumber(const Value: Integer);
    procedure SetSave(const Value: Integer);
    procedure SetOpen(const Value: Integer);
    procedure SetPicture(const Value: Integer);
    procedure SetLargeEditor(const Value: Integer);
    procedure SetTextHoch(const Value: Integer);
    procedure SetTextTief(const Value: Integer);
    procedure SetStandardfont(const Value: Integer);
    procedure SetFontfavoriten(const Value: Integer);
    procedure SetIndentInc(const Value: Integer);
    procedure SetIndentDec(const Value: Integer);
    procedure SetLinespace(const Value: Integer);
    procedure SetPrint(const Value: Integer);
    procedure SetClipboard(const Value: Integer);
    procedure SetReverse(const Value: Integer);
    procedure SetCut(const Value: Integer);
    procedure SetPaste(const Value: Integer);
    procedure SetFontbox(const Value: Integer);
    procedure SetFontsize(const Value: Integer);
    procedure setSpellCheck(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    procedure Durchnummerieren;
    procedure PositionsnummernToSortObj;
    procedure SortObjToPositionsnummer;
    function getPosNr(aToolbarItem: TNFSToolbarItem): Integer;
    procedure setPosNr(aToolbarItem: TNFSToolbarItem; aValue: Integer);
    property DurchnummerierungErlauben: Boolean read fDurchnummerierungErlauben write fDurchnummerierungErlauben;
  published
    property Bold: Integer read FBold write SetBold;
    property Italic: Integer read FItalic write SetItalic;
    property Underline: Integer read FUnterline write SetUnterline;
    property Left: Integer read FLeft write SetLeft;
    property Center: Integer read FCenter write SetCenter;
    property Right: Integer read FRight write SetRight;
    property Justify: Integer read FJustify write SetJustify;
    property Fontcolor: Integer read FFontcolor write SetFontcolor;
    property Backgroundcolor: Integer read FBackgroundcolor write SetBackgroundcolor;
    property ParagraphBackground: Integer read FParagraphBackground write SetParagraphBackground;
    property Bullets: Integer read FBullets write SetBullets;
    property Number: Integer read FNumber write SetNumber;
    property Save: Integer read FSave write SetSave;
    property Open: Integer read FOpen write SetOpen;
    property Picture: Integer read FPicture write SetPicture;
    property LargeEditor: Integer read FLargeEditor write SetLargeEditor;
    property TextHoch: Integer read FTextHoch write SetTextHoch;
    property TextTief: Integer read FTextTief write SetTextTief;
    property Standardfont: Integer read FStandardfont write SetStandardfont;
    property Fontfavoriten: Integer read FFontfavoriten write SetFontfavoriten;
    property IndentInc: Integer read FIndentInc write SetIndentInc;
    property IndentDec: Integer read FIndentDec write SetIndentDec;
    property Linespace: Integer read FLinespace write SetLinespace;
    property Print: Integer read FPrint write SetPrint;
    property Clipboard: Integer read FClipboard write SetClipboard;
    property Reverse: Integer read FReverse write SetReverse;
    property Cut: Integer read FCut write SetCut;
    property Paste: Integer read FPaste write SetPaste;
    property SpellCheck: Integer read fSpellCheck write setSpellCheck;
    property Fontbox: Integer read FFontbox write SetFontbox;
    property Fontsize: Integer read FFontsize write SetFontsize;
  end;

implementation

{ TPropNFSButtonPos }

uses
  Objekt.Sort, System.Math;

function NrSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := CompareValue(TSortObj(Item1).Nr, TSortObj(Item2).Nr);
end;

constructor TPropNFSButtonPos.Create(aOwner: TComponent);
var
  ToolbarItem: TNFSToolbarItem;
begin
  fDurchnummerierungErlauben := true;
  fChangedValue := 0;
  fSortObjList := TSortObjList.Create;

  for ToolbarItem := tbBold to tbFontsize do
    fSortObjList.Add.ToolbarItem := ToolbarItem;

  fOwner := AOwner;
  If (AOwner<>nil) And (csDesigning In AOwner.ComponentState) And Not (csReading In AOwner.ComponentState) then
    fDurchnummerierungErlauben := true;
  If (AOwner<>nil) And (csLoading In AOwner.ComponentState) then
    fDurchnummerierungErlauben := false;

end;

destructor TPropNFSButtonPos.Destroy;
begin
  FreeAndNil(fSortObjList);
  inherited;
end;

procedure TPropNFSButtonPos.DoPositionChange;
begin
//  if csDesigning in ComponentState then

  If (fOwner<>nil) And (csLoading In fOwner.ComponentState) then
  begin
    fDurchnummerierungErlauben := false;
  end;

  if fDurchnummerierungErlauben then
    Durchnummerieren;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;



procedure TPropNFSButtonPos.SetBackgroundcolor(const Value: Integer);
begin
  if Value <> FBackgroundcolor then
  begin
    fChangeHigh := FBackgroundcolor < Value;
    FBackgroundcolor := Value;
    fChangedName := tbBackgroundcolor;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetBold(const Value: Integer);
begin
  if Value <> FBold then
  begin
    fChangeHigh := FBold < Value;
    FBold := Value;
    fChangedName := tbBold;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetBullets(const Value: Integer);
begin
  if Value <> FBullets then
  begin
    fChangeHigh := FBullets < Value;
    FBullets := Value;
    fChangedName := tbBullets;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetCenter(const Value: Integer);
begin
  if Value <> FCenter then
  begin
    fChangeHigh := FCenter < Value;
    FCenter := Value;
    fChangedName := tbCenter;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetClipboard(const Value: Integer);
begin
  if Value <> FClipboard then
  begin
    fChangeHigh := FClipboard < Value;
    FClipboard := Value;
    fChangedName := tbClipboard;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetCut(const Value: Integer);
begin
  if Value <> FCut then
  begin
    fChangeHigh := FCut < Value;
    FCut := Value;
    fChangedName := tbCut;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetFontbox(const Value: Integer);
begin
  if Value <> FFontbox then
  begin
    fChangeHigh := FFontbox < Value;
    FFontbox := Value;
    fChangedName := tbFontbox;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetFontcolor(const Value: Integer);
begin
  if Value <> FFontcolor then
  begin
    fChangeHigh := FFontcolor < Value;
    FFontcolor := Value;
    fChangedName := tbFontcolor;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetFontfavoriten(const Value: Integer);
begin
  if Value <> FFontfavoriten then
  begin
    fChangeHigh := FFontfavoriten < Value;
    FFontfavoriten := Value;
    fChangedName := tbFontfavoriten;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;


procedure TPropNFSButtonPos.SetFontsize(const Value: Integer);
begin
  if Value <> FFontsize then
  begin
    fChangeHigh := FFontsize < Value;
    FFontsize := Value;
    fChangedName := tbFontsize;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;


procedure TPropNFSButtonPos.SetIndentDec(const Value: Integer);
begin
  if Value <> FIndentDec then
  begin
    fChangeHigh := FIndentDec < Value;
    FIndentDec := Value;
    fChangedName := tbIndentDec;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetIndentInc(const Value: Integer);
begin
  if Value <> FIndentInc then
  begin
    fChangeHigh := FIndentInc < Value;
    FIndentInc := Value;
    fChangedName := tbIndentInc;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetItalic(const Value: Integer);
begin
  if Value <> FItalic then
  begin
    fChangeHigh := FItalic < Value;
    FItalic := Value;
    fChangedName := tbItalic;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetJustify(const Value: Integer);
begin
  if Value <> FJustify then
  begin
    fChangeHigh := FJustify < Value;
    FJustify := Value;
    fChangedName := tbJustify;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetLargeEditor(const Value: Integer);
begin
  if Value <> FLargeEditor then
  begin
    fChangeHigh := FLargeEditor < Value;
    FLargeEditor := Value;
    fChangedName := tbLargeEditor;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetLeft(const Value: Integer);
begin
  if Value <> FLeft then
  begin
    fChangeHigh := FLeft < Value;
    FLeft := Value;
    fChangedName := tbLeft;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetLinespace(const Value: Integer);
begin
  if Value <> FLinespace then
  begin
    fChangeHigh := FLinespace < Value;
    FLinespace := Value;
    fChangedName := tbLinespace;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetNumber(const Value: Integer);
begin
  if Value <> FNumber then
  begin
    fChangeHigh := FNumber < Value;
    FNumber := Value;
    fChangedName := tbNumber;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetOpen(const Value: Integer);
begin
  if Value <> FOpen then
  begin
    fChangeHigh := FOpen < Value;
    FOpen := Value;
    fChangedName := tbOpen;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetParagraphBackground(const Value: Integer);
begin
  if Value <> FParagraphBackground then
  begin
    fChangeHigh := FParagraphBackground < Value;
    FParagraphBackground := Value;
    fChangedName := tbParagraphBackground;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetPaste(const Value: Integer);
begin
  if Value <> FPaste then
  begin
    fChangeHigh := FPaste < Value;
    FPaste := Value;
    fChangedName := tbPaste;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetPicture(const Value: Integer);
begin
  if Value <> FPicture then
  begin
    fChangeHigh := FPicture < Value;
    FPicture := Value;
    fChangedName := tbPicture;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetPrint(const Value: Integer);
begin
  if Value <> FPrint then
  begin
    fChangeHigh := FPrint < Value;
    fChangedName := tbPrint;
    fChangedValue := Value;
    FPrint := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetReverse(const Value: Integer);
begin
  if Value <> FReverse then
  begin
    fChangeHigh := FReverse < Value;
    fChangedName := tbReverse;
    fChangedValue := Value;
    FReverse := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetRight(const Value: Integer);
begin
  if Value <> FRight then
  begin
    fChangeHigh := FRight < Value;
    FRight := Value;
    fChangedName := tbRight;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetSave(const Value: Integer);
begin
  if Value <> FSave then
  begin
    fChangeHigh := FSave < Value;
    FSave := Value;
    fChangedName := tbSave;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.setSpellCheck(const Value: Integer);
begin
  if Value <> fSpellCheck then
  begin
    fChangeHigh := fSpellCheck < Value;
    fSpellCheck := Value;
    fChangedName := tbSpellCheck;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetStandardfont(const Value: Integer);
begin
  if Value <> FStandardfont then
  begin
    fChangeHigh := FStandardfont < Value;
    FStandardfont := Value;
    fChangedName := tbStandardfont;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetTextHoch(const Value: Integer);
begin
  if Value <> FTextHoch then
  begin
    fChangeHigh := FTextHoch < Value;
    FTextHoch := Value;
    fChangedName := tbTextHoch;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetTextTief(const Value: Integer);
begin
  if Value <> FTextTief then
  begin
    fChangeHigh := FTextTief < Value;
    FTextTief := Value;
    fChangedName := tbTextTief;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;

procedure TPropNFSButtonPos.SetUnterline(const Value: Integer);
begin
  if Value <> FUnterline then
  begin
    fChangeHigh := FUnterline < Value;
    FUnterline := Value;
    fChangedName := tbUnderline;
    fChangedValue := Value;
    DoPositionChange;
  end;
end;


procedure TPropNFSButtonPos.Durchnummerieren;
var
  i1: Integer;
begin
  PositionsnummernToSortObj;
  for i1 := 0 to fSortObjList.Count -1 do
  begin
    if  (fSortObjList.Item[i1].Nr = fChangedValue)
    and (fSortObjList.Item[i1].ToolbarItem <> fChangedName) then
    begin
      if fChangeHigh then
        fSortObjList.Item[i1].Nr := fChangedValue -1
      else
        fSortObjList.Item[i1].Nr := fChangedValue +1;
    end;
  end;
  fSortObjList.Sort;

  for i1 := 0 to fSortObjList.Count -1 do
    fSortObjList.Item[i1].Nr := i1 + 1;

  SortObjToPositionsnummer;
end;




procedure TPropNFSButtonPos.PositionsnummernToSortObj;
var
  ToolbarItem: TNFSToolbarItem;
  SortObj: TSortObj;
begin
  for ToolbarItem := tbBold to tbFontsize do
  begin
    SortObj := fSortObjList.getItem(ToolbarItem);
    SortObj.Nr := getPosNr(ToolbarItem);
  end;
end;

procedure TPropNFSButtonPos.SortObjToPositionsnummer;
var
  ToolbarItem: TNFSToolbarItem;
  SortObj: TSortObj;
begin
  for ToolbarItem := tbBold to tbFontsize do
  begin
    SortObj := fSortObjList.getItem(ToolbarItem);
    setPosNr(ToolbarItem, SortObj.Nr);
  end;
end;


function TPropNFSButtonPos.getPosNr(aToolbarItem: TNFSToolbarItem): Integer;
begin
  Result := 0;
  case aToolbarItem of
    tbBold: Result := FBold;
    tbItalic: Result := FItalic;
    tbUnderline: Result := FUnterline;
    tbLeft: Result := FLeft;
    tbCenter: Result := FCenter;
    tbRight: Result := FRight;
    tbJustify: Result := FJustify;
    tbFontcolor: Result := FFontcolor;
    tbBackgroundcolor: Result := FBackgroundcolor;
    tbParagraphBackground: Result := FParagraphBackground;
    tbBullets: Result := FBullets;
    tbNumber: Result := FNumber;
    tbSave: Result := FSave;
    tbOpen: Result := FOpen;
    tbPicture: Result := FPicture;
    tbLargeEditor: Result := FLargeEditor;
    tbTextHoch: Result := FTextHoch;
    tbTextTief: Result := FTextTief;
    tbStandardFont: Result := FStandardfont;
    tbFontFavoriten: Result := FFontfavoriten;
    tbIndentInc: Result := FIndentInc;
    tbIndentDec: Result := FIndentDec;
    tbLineSpace: Result := FLinespace;
    tbPrint: Result := FPrint;
    tbClipboard: Result := FClipboard;
    tbReverse: Result := FReverse;
    tbCut: Result := FCut;
    tbPaste: Result := FPaste;
    tbSpellCheck: Result := fSpellCheck;
    tbFontbox : Result := FFontbox;
    tbFontsize: Result := FFontsize;
  end;
end;

procedure TPropNFSButtonPos.setPosNr(aToolbarItem: TNFSToolbarItem; aValue: Integer);
begin
  case aToolbarItem of
    tbBold: FBold := aValue;
    tbItalic: FItalic := aValue;
    tbUnderline: FUnterline := aValue;
    tbLeft: FLeft := aValue;
    tbCenter: FCenter := aValue;
    tbRight: FRight := aValue;
    tbJustify: FJustify := aValue;
    tbFontcolor: FFontcolor := aValue;
    tbBackgroundcolor: FBackgroundcolor := aValue;
    tbParagraphBackground: FParagraphBackground := aValue;
    tbBullets: FBullets := aValue;
    tbNumber: FNumber := aValue;
    tbSave: FSave := aValue;
    tbOpen: FOpen := aValue;
    tbPicture: FPicture := aValue;
    tbLargeEditor: FLargeEditor := aValue;
    tbTextHoch: FTextHoch := aValue;
    tbTextTief: FTextTief := aValue;
    tbStandardFont: FStandardfont := aValue;
    tbFontFavoriten: FFontfavoriten := aValue;
    tbIndentInc: FIndentInc := aValue;
    tbIndentDec: FIndentDec := aValue;
    tbLineSpace: FLinespace := aValue;
    tbPrint: FPrint := aValue;
    tbClipboard: FClipboard := aValue;
    tbReverse: FReverse := aValue;
    tbCut: FCut := aValue;
    tbPaste: FPaste := aValue;
    tbSpellCheck: fSpellCheck := aValue;
    tbFontbox : FFontbox := aValue;
    tbFontsize: FFontsize := aValue;
  end;
end;


end.
