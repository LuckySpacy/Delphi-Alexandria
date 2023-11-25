unit Prop.NFSButtons;

interface

uses
  Classes, SysUtils, Contnrs, Prop.NFSButton, Buttons, Controls, Prop.NFSButtonPos, NFSToolbartypes;

type
  TToolbarItemVisibleEvent = procedure(Sender: TObject; aToolbarItem: TNFSToolbarItem; aVisible: Boolean) of object;


type
  TPropNFSButtons = class(TPersistent)
  private
    FBold: TPropNFSButton;
    FButtonsList: TObjectList;
    FOnChange: TNotifyEvent;
    FItalic: TPropNFSButton;
    FUnderline: TPropNFSButton;
    //FPositions: TPropNFSButtonPos;
    FSortList : TStringList;
    FClipboard: TPropNFSButton;
    FCut: TPropNFSButton;
    FIndentDec: TPropNFSButton;
    FPicture: TPropNFSButton;
    FRight: TPropNFSButton;
    FPaste: TPropNFSButton;
    FTextHoch: TPropNFSButton;
    FLinespace: TPropNFSButton;
    FFontfavoriten: TPropNFSButton;
    FReverse: TPropNFSButton;
    FSave: TPropNFSButton;
    FStandardfont: TPropNFSButton;
    FIndentInc: TPropNFSButton;
    FOpen: TPropNFSButton;
    FTextTief: TPropNFSButton;
    FJustify: TPropNFSButton;
    FPrint: TPropNFSButton;
    FBullets: TPropNFSButton;
    FNumber: TPropNFSButton;
    FLargeEditor: TPropNFSButton;
    FParagraphBackground: TPropNFSButton;
    FBackgroundcolor: TPropNFSButton;
    FFontcolor: TPropNFSButton;
    FCenter: TPropNFSButton;
    FLeft: TPropNFSButton;
    fSpellCheck: TPropNFSButton;
    procedure SetButtonsList(const Value: TObjectList);
    function GetButton(aToolbarItem: TNFSToolbarItem): TSpeedButton;
    procedure DoChange(Sender: TObject);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    function GetButtonProp(aToolbarItem: TNFSToolbarItem): TPropNFSButton;
    procedure LadeButtonSortList(aPositions: TPropNFSButtonPos);
    property ButtonsList: TObjectList read FButtonsList write SetButtonsList;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SortList: TStringList read FSortList;
    //procedure Durchnummerieren;
  published
    //property Positions: TPropNFSButtonPos read FPositions write FPositions;
    property Bold: TPropNFSButton read FBold write FBold;
    property Italic: TPropNFSButton read FItalic write FItalic;
    property Underline: TPropNFSButton read FUnderline write FUnderline;
    property Left: TPropNFSButton read FLeft write FLeft;
    property Center: TPropNFSButton read FCenter write FCenter;
    property Right: TPropNFSButton read FRight write FRight;
    property Justify: TPropNFSButton read FJustify write FJustify;
    property Fontcolor: TPropNFSButton read FFontcolor write FFontcolor;
    property Backgroundcolor: TPropNFSButton read FBackgroundcolor write FBackgroundcolor;
    property ParagraphBackground: TPropNFSButton read FParagraphBackground write FParagraphBackground;
    property Bullets: TPropNFSButton read FBullets write FBullets;
    property Number: TPropNFSButton read FNumber write FNumber;
    property Save: TPropNFSButton read FSave write FSave;
    property Open: TPropNFSButton read FOpen write FOpen;
    property Picture: TPropNFSButton read FPicture write FPicture;
    property LargeEditor: TPropNFSButton read FLargeEditor write FLargeEditor;
    property TextHoch: TPropNFSButton read FTextHoch write FTextHoch;
    property TextTief: TPropNFSButton read FTextTief write FTextTief;
    property Standardfont: TPropNFSButton read FStandardfont write FStandardfont;
    property Fontfavoriten: TPropNFSButton read FFontfavoriten write FFontfavoriten;
    property IndentInc: TPropNFSButton read FIndentInc write FIndentInc;
    property IndentDec: TPropNFSButton read FIndentDec write FIndentDec;
    property Linespace: TPropNFSButton read FLinespace write FLinespace;
    property Print: TPropNFSButton read FPrint write FPrint;
    property Clipboard: TPropNFSButton read FClipboard write FClipboard;
    property Reverse: TPropNFSButton read FReverse write FReverse;
    property Cut: TPropNFSButton read FCut write FCut;
    property Paste: TPropNFSButton read FPaste write FPaste;
    property SpellCheck: TPropNFSButton read fSpellCheck write fSpellCheck;
  end;


implementation

{ TtbPropButtons }

constructor TPropNFSButtons.Create(aOwner: TComponent);
  function PropNFSButtonCreate: TPropNFSButton;
  begin
     Result := TPropNFSButton.Create(aOwner);
     Result.OnChange := DoChange;
     Result.Visible := true;
  end;
begin
  FSortList  := TStringList.Create;
  FSortList.Sorted := true;
  FSortList.Duplicates := dupAccept;
  {
  FPositions := TPropNFSButtonPos.Create(aOwner);
  If (AOwner<>nil) And (csDesigning In AOwner.ComponentState) And Not (csReading In AOwner.ComponentState) then
  begin
    FPositions.Bold      := 1;
    FPositions.Italic    := 2;
    FPositions.Underline := 3;
    FPositions.Left      := 4;
    FPositions.Center    := 5;
    FPositions.Right     := 6;
    FPositions.Justify   := 7;
    FPositions.Fontfavoriten := 8;
    FPositions.Fontbox       := 9;
    FPositions.Fontsize      := 10;
    FPositions.Fontcolor     := 11;
    FPositions.Standardfont  := 12;
    FPositions.LargeEditor   := 13;
    FPositions.Bullets       := 14;
    FPositions.Number        := 15;
    FPositions.IndentInc     := 16;
    FPositions.IndentDec     := 17;
    FPositions.Linespace     := 18;
    FPositions.TextHoch      := 19;
    FPositions.TextTief      := 20;
    FPositions.Save          := 21;
    FPositions.Open          := 22;
    FPositions.Picture       := 23;
    FPositions.Print         := 24;
    FPositions.Clipboard     := 25;
    FPositions.Reverse       := 26;
    FPositions.Cut           := 27;
    FPositions.Paste         := 28;
    FPositions.Backgroundcolor := 29;
    FPositions.ParagraphBackground := 30;
    FPositions.SpellCheck := 31;
  end;
  FPositions.OnChange := DoChange;
  }
  FBold          := PropNFSButtonCreate;
  FItalic        := PropNFSButtonCreate;
  FUnderline     := PropNFSButtonCreate;
  FLeft          := PropNFSButtonCreate;
  FCenter        := PropNFSButtonCreate;
  FRight         := PropNFSButtonCreate;
  FJustify       := PropNFSButtonCreate;
  FFontColor     := PropNFSButtonCreate;
  FBullets       := PropNFSButtonCreate;
  FNumber        := PropNFSButtonCreate;
  FSave          := PropNFSButtonCreate;
  FOpen          := PropNFSButtonCreate;
  FPicture       := PropNFSButtonCreate;
  FLargeEditor   := PropNFSButtonCreate;
  FTextHoch      := PropNFSButtonCreate;
  FTextTief      := PropNFSButtonCreate;
  FStandardfont  := PropNFSButtonCreate;
  FFontfavoriten := PropNFSButtonCreate;
  FIndentDec     := PropNFSButtonCreate;
  FIndentInc     := PropNFSButtonCreate;
  FLinespace     := PropNFSButtonCreate;
  FPrint         := PropNFSButtonCreate;
  FClipboard     := PropNFSButtonCreate;
  FReverse       := PropNFSButtonCreate;
  FCut           := PropNFSButtonCreate;
  FPaste         := PropNFSButtonCreate;
  fSpellCheck    := PropNFSButtonCreate;
  FBackgroundcolor := PropNFSButtonCreate;
  FParagraphBackground := PropNFSButtonCreate;
  DoChange(nil);
end;


destructor TPropNFSButtons.Destroy;
begin
  FreeAndNil(FSortList);
  FreeAndNil(FBold);
  FreeAndNil(FItalic);
  FreeAndNil(FUnderline);
  FreeAndNil(FLeft);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FJustify);
  FreeAndNil(FFontcolor);
  FreeAndNil(FBackgroundcolor);
  FreeAndNil(FParagraphBackground);
  FreeAndNil(FBullets);
  FreeAndNil(FNumber);
  FreeAndNil(FSave);
  FreeAndNil(FOpen);
  FreeAndNil(FPicture);
  FreeAndNil(FLargeEditor);
  FreeAndNil(FTextHoch);
  FreeAndNil(FTextTief);
  FreeAndNil(FStandardfont);
  FreeAndNil(FFontfavoriten);
  FreeAndNil(FIndentInc);
  FreeAndNil(FIndentDec);
  FreeAndNil(FLinespace);
  FreeAndNil(FPrint);
  FreeAndNil(FClipboard);
  FreeAndNil(FReverse);
  FreeAndNil(FCut);
  FreeAndNil(FPaste);
  FreeAndNil(fSpellCheck);
  inherited;
end;

procedure TPropNFSButtons.DoChange(Sender: TObject);
begin
  //LadeButtonSortList(FPositions);
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{
procedure TPropNFSButtons.Durchnummerieren;
begin
  FPositions.Durchnummerieren;
end;
}

function TPropNFSButtons.GetButton(aToolbarItem: TNFSToolbarItem): TSpeedButton;
var
  i1: Integer;
begin
  Result := nil;
  if not Assigned(FButtonsList) then
    exit;
  for i1 := 0 to FButtonsList.Count - 1 do
  begin
    if TSpeedButton(FButtonsList[i1]).Tag = ord(aToolbarItem) then
    begin
      Result := TSpeedButton(FButtonsList[i1]);
      exit;
    end;
  end;
end;

function TPropNFSButtons.GetButtonProp(
  aToolbarItem: TNFSToolbarItem): TPropNFSButton;
begin
  Result := nil;
  case aToolbarItem of
    tbBold: Result := FBold;
    tbItalic: Result := FItalic;
    tbUnderline: Result := FUnderline;
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
  end;
end;

procedure TPropNFSButtons.LadeButtonSortList(aPositions: TPropNFSButtonPos);
  function GetStrFromInt(aInt: Integer): String;
  begin
    Result := IntToStr(aInt);
    while Length(Result) < 4 do
      Result := '0' + Result;
  end;
begin
  FSortList.Clear;
  FSortList.Add(GetStrFromInt(aPositions.Bold) + '=' + IntToStr(Ord(tbBold)));
  FSortList.Add(GetStrFromInt(aPositions.Italic) + '=' + IntToStr(Ord(tbItalic)));
  FSortList.Add(GetStrFromInt(aPositions.Underline) + '=' + IntToStr(Ord(tbUnderline)));
  FSortList.Add(GetStrFromInt(aPositions.Left) + '=' + IntToStr(Ord(tbLeft)));
  FSortList.Add(GetStrFromInt(aPositions.Center) + '=' + IntToStr(Ord(tbCenter)));
  FSortList.Add(GetStrFromInt(aPositions.Right) + '=' + IntToStr(Ord(tbRight)));
  FSortList.Add(GetStrFromInt(aPositions.Justify) + '=' + IntToStr(Ord(tbJustify)));
  FSortList.Add(GetStrFromInt(aPositions.Fontcolor) + '=' + IntToStr(Ord(tbFontcolor)));
  FSortList.Add(GetStrFromInt(aPositions.Backgroundcolor) + '=' + IntToStr(Ord(tbBackgroundcolor)));
  FSortList.Add(GetStrFromInt(aPositions.ParagraphBackground) + '=' + IntToStr(Ord(tbParagraphBackground)));
  FSortList.Add(GetStrFromInt(aPositions.Bullets) + '=' + IntToStr(Ord(tbBullets)));
  FSortList.Add(GetStrFromInt(aPositions.Number) + '=' + IntToStr(Ord(tbNumber)));
  FSortList.Add(GetStrFromInt(aPositions.Save) + '=' + IntToStr(Ord(tbSave)));
  FSortList.Add(GetStrFromInt(aPositions.Open) + '=' + IntToStr(Ord(tbOpen)));
  FSortList.Add(GetStrFromInt(aPositions.Picture) + '=' + IntToStr(Ord(tbPicture)));
  FSortList.Add(GetStrFromInt(aPositions.LargeEditor) + '=' + IntToStr(Ord(tbLargeEditor)));
  FSortList.Add(GetStrFromInt(aPositions.TextHoch) + '=' + IntToStr(Ord(tbTextHoch)));
  FSortList.Add(GetStrFromInt(aPositions.TextTief) + '=' + IntToStr(Ord(tbTextTief)));
  FSortList.Add(GetStrFromInt(aPositions.Standardfont) + '=' + IntToStr(Ord(tbStandardFont)));
  FSortList.Add(GetStrFromInt(aPositions.Fontfavoriten) + '=' + IntToStr(Ord(tbFontFavoriten)));
  FSortList.Add(GetStrFromInt(aPositions.IndentInc) + '=' + IntToStr(Ord(tbIndentInc)));
  FSortList.Add(GetStrFromInt(aPositions.IndentDec) + '=' + IntToStr(Ord(tbIndentDec)));
  FSortList.Add(GetStrFromInt(aPositions.Linespace) + '=' + IntToStr(Ord(tbLineSpace)));
  FSortList.Add(GetStrFromInt(aPositions.Print) + '=' + IntToStr(Ord(tbPrint)));
  FSortList.Add(GetStrFromInt(aPositions.Clipboard) + '=' + IntToStr(Ord(tbClipboard)));
  FSortList.Add(GetStrFromInt(aPositions.Reverse) + '=' + IntToStr(Ord(tbReverse)));
  FSortList.Add(GetStrFromInt(aPositions.Cut) + '=' + IntToStr(Ord(tbCut)));
  FSortList.Add(GetStrFromInt(aPositions.Paste) + '=' + IntToStr(Ord(tbPaste)));
  FSortList.Add(GetStrFromInt(aPositions.SpellCheck) + '=' + IntToStr(Ord(tbSpellCheck)));
  FSortList.Add(GetStrFromInt(aPositions.Fontbox) + '=' + IntToStr(Ord(tbFontbox)));
  FSortList.Add(GetStrFromInt(aPositions.Fontsize) + '=' + IntToStr(Ord(tbFontsize)));
end;

procedure TPropNFSButtons.SetButtonsList(const Value: TObjectList);
  procedure SetButtonsStyle(aToolbarItem: TNFSToolbarItem; aPropButton: TPropNFSButton);
  var
    btn: TSpeedButton;
    m: TMargins;
  begin
    aPropButton.ToolButton := GetButton(aToolbarItem);
    btn := aPropButton.ToolButton;
    if Assigned(btn) then
    begin
      m := TMargins.Create(nil);
      try
        m.Assign(btn.Margins);
        aPropButton.Visible        := btn.Visible;
        aPropButton.Margins.Left   := m.Left;
        aPropButton.Margins.Top    := m.Top;
        aPropButton.Margins.Right  := m.Right;
        aPropButton.Margins.Bottom := m.Bottom;
      finally
        FreeAndNil(m);
      end;
    end;
  end;
begin
  FButtonsList := Value;
  SetButtonsStyle(tbBold, FBold);
  SetButtonsStyle(tbItalic, FItalic);
  SetButtonsStyle(tbUnderline, FUnderline);
  SetButtonsStyle(tbLeft, FLeft);
  SetButtonsStyle(tbCenter, FCenter);
  SetButtonsStyle(tbRight, FRight);
  SetButtonsStyle(tbJustify, FJustify);
  SetButtonsStyle(tbFontcolor, FFontcolor);
  SetButtonsStyle(tbBackgroundcolor, FBackgroundcolor);
  SetButtonsStyle(tbParagraphBackground, FParagraphBackground);
  SetButtonsStyle(tbBullets, FBullets);
  SetButtonsStyle(tbNumber, FNumber);
  SetButtonsStyle(tbSave, FSave);
  SetButtonsStyle(tbOpen, FOpen);
  SetButtonsStyle(tbPicture, FPicture);
  SetButtonsStyle(tbLargeEditor, FLargeEditor);
  SetButtonsStyle(tbTextHoch, FTextHoch);
  SetButtonsStyle(tbTextTief, FTextTief);
  SetButtonsStyle(tbStandardFont, FStandardfont);
  SetButtonsStyle(tbFontFavoriten, FFontfavoriten);
  SetButtonsStyle(tbIndentInc, FIndentInc);
  SetButtonsStyle(tbIndentDec, FIndentDec);
  SetButtonsStyle(tbLineSpace, FLinespace);
  SetButtonsStyle(tbPrint, FPrint);
  SetButtonsStyle(tbClipboard, FClipboard);
  SetButtonsStyle(tbReverse, FReverse);
  SetButtonsStyle(tbCut, FCut);
  SetButtonsStyle(tbPaste, FPaste);
  SetButtonsStyle(tbSpellCheck, FSpellCheck);
end;

end.
