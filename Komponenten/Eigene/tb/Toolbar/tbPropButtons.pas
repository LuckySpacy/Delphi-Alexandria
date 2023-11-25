unit tbPropButtons;

interface

uses
  Classes, SysUtils, Contnrs, tbPropButton, Buttons, Controls, tbPropButtonPos, tbtoolbartypes;

type
  TToolbarItemVisibleEvent = procedure(Sender: TObject; aToolbarItem: TToolbarItem; aVisible: Boolean) of object;


type
  TtbPropButtons = class(TPersistent)
  private
    FBold: TtbPropButton;
    FButtonsList: TObjectList;
    FOnChange: TNotifyEvent;
    FItalic: TtbPropButton;
    FUnderline: TtbPropButton;
    FPositions: TtbPropButtonPos;
    FSortList : TStringList;
    FClipboard: TtbPropButton;
    FCut: TtbPropButton;
    FIndentDec: TtbPropButton;
    FPicture: TtbPropButton;
    FRight: TtbPropButton;
    FPaste: TtbPropButton;
    FTextHoch: TtbPropButton;
    FLinespace: TtbPropButton;
    FFontfavoriten: TtbPropButton;
    FReverse: TtbPropButton;
    FSave: TtbPropButton;
    FStandardfont: TtbPropButton;
    FIndentInc: TtbPropButton;
    FOpen: TtbPropButton;
    FTextTief: TtbPropButton;
    FJustify: TtbPropButton;
    FPrint: TtbPropButton;
    FBullets: TtbPropButton;
    FNumber: TtbPropButton;
    FLargeEditor: TtbPropButton;
    FParagraphBackground: TtbPropButton;
    FBackgroundcolor: TtbPropButton;
    FFontcolor: TtbPropButton;
    FCenter: TtbPropButton;
    FLeft: TtbPropButton;
    procedure SetButtonsList(const Value: TObjectList);
    function GetButton(aToolbarItem: TToolbarItem): TSpeedButton;
    procedure DoChange(Sender: TObject);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    function GetButtonProp(aToolbarItem: TToolbarItem): TtbPropButton;
    procedure LadeButtonSortList;
    property ButtonsList: TObjectList read FButtonsList write SetButtonsList;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property SortList: TStringList read FSortList;
  published
    property Positions: TtbPropButtonPos read FPositions write FPositions;
    property Bold: TtbPropButton read FBold write FBold;
    property Italic: TtbPropButton read FItalic write FItalic;
    property Underline: TtbPropButton read FUnderline write FUnderline;
    property Left: TtbPropButton read FLeft write FLeft;
    property Center: TtbPropButton read FCenter write FCenter;
    property Right: TtbPropButton read FRight write FRight;
    property Justify: TtbPropButton read FJustify write FJustify;
    property Fontcolor: TtbPropButton read FFontcolor write FFontcolor;
    property Backgroundcolor: TtbPropButton read FBackgroundcolor write FBackgroundcolor;
    property ParagraphBackground: TtbPropButton read FParagraphBackground write FParagraphBackground;
    property Bullets: TtbPropButton read FBullets write FBullets;
    property Number: TtbPropButton read FNumber write FNumber;
    property Save: TtbPropButton read FSave write FSave;
    property Open: TtbPropButton read FOpen write FOpen;
    property Picture: TtbPropButton read FPicture write FPicture;
    property LargeEditor: TtbPropButton read FLargeEditor write FLargeEditor;
    property TextHoch: TtbPropButton read FTextHoch write FTextHoch;
    property TextTief: TtbPropButton read FTextTief write FTextTief;
    property Standardfont: TtbPropButton read FStandardfont write FStandardfont;
    property Fontfavoriten: TtbPropButton read FFontfavoriten write FFontfavoriten;
    property IndentInc: TtbPropButton read FIndentInc write FIndentInc;
    property IndentDec: TtbPropButton read FIndentDec write FIndentDec;
    property Linespace: TtbPropButton read FLinespace write FLinespace;
    property Print: TtbPropButton read FPrint write FPrint;
    property Clipboard: TtbPropButton read FClipboard write FClipboard;
    property Reverse: TtbPropButton read FReverse write FReverse;
    property Cut: TtbPropButton read FCut write FCut;
    property Paste: TtbPropButton read FPaste write FPaste;
  end;


implementation

{ TtbPropButtons }

constructor TtbPropButtons.Create(aOwner: TComponent);
begin
  FSortList  := TStringList.Create;
  FSortList.Sorted := true;
  FSortList.Duplicates := dupAccept;
  FPositions := TtbPropButtonPos.Create(aOwner);
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
  end;
  FPositions.OnChange := DoChange;
  FBold := TtbPropButton.Create(aOwner);
  FBold.OnChange := DoChange;
  FItalic := TtbPropButton.Create(aOwner);
  FItalic.OnChange := DoChange;
  FUnderline := TtbPropButton.Create(aOwner);
  FUnderline.OnChange := DoChange;
  FLeft := TtbPropButton.Create(aOwner);
  FLeft.OnChange := DoChange;
  FCenter := TtbPropButton.Create(aOwner);
  FCenter.OnChange := DoChange;
  FRight := TtbPropButton.Create(aOwner);
  FRight.OnChange := DoChange;
  FJustify := TtbPropButton.Create(aOwner);
  FJustify.OnChange := DoChange;
  FFontColor := TtbPropButton.Create(aOwner);
  FFontColor.OnChange := DoChange;
  FBackgroundcolor := TtbPropButton.Create(aOwner);
  FBackgroundcolor.OnChange := DoChange;
  FParagraphBackground := TtbPropButton.Create(aOwner);
  FParagraphBackground.OnChange := DoChange;
  FBullets := TtbPropButton.Create(aOwner);
  FBullets.OnChange := DoChange;
  FNumber := TtbPropButton.Create(aOwner);
  FNumber.OnChange := DoChange;
  FSave := TtbPropButton.Create(aOwner);
  FSave.OnChange := DoChange;
  FOpen := TtbPropButton.Create(aOwner);
  FOpen.OnChange := DoChange;
  FPicture := TtbPropButton.Create(aOwner);
  FPicture.OnChange := DoChange;
  FLargeEditor := TtbPropButton.Create(aOwner);
  FLargeEditor.OnChange := DoChange;
  FTextHoch := TtbPropButton.Create(aOwner);
  FTextHoch.OnChange := DoChange;
  FTextTief := TtbPropButton.Create(aOwner);
  FTextTief.OnChange := DoChange;
  FStandardfont := TtbPropButton.Create(aOwner);
  FStandardfont.OnChange := DoChange;
  FFontfavoriten := TtbPropButton.Create(aOwner);
  FFontfavoriten.OnChange := DoChange;
  FIndentDec := TtbPropButton.Create(aOwner);
  FIndentDec.OnChange := DoChange;
  FIndentInc := TtbPropButton.Create(aOwner);
  FIndentInc.OnChange := DoChange;
  FLinespace := TtbPropButton.Create(aOwner);
  FLinespace.OnChange := DoChange;
  FPrint := TtbPropButton.Create(aOwner);
  FPrint.OnChange := DoChange;
  FClipboard := TtbPropButton.Create(aOwner);
  FClipboard.OnChange := DoChange;
  FReverse := TtbPropButton.Create(aOwner);
  FReverse.OnChange := DoChange;
  FCut := TtbPropButton.Create(aOwner);
  FCut.OnChange := DoChange;
  FPaste := TtbPropButton.Create(aOwner);
  FPaste.OnChange := DoChange;
  DoChange(nil);
end;

destructor TtbPropButtons.Destroy;
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
  inherited;
end;

procedure TtbPropButtons.DoChange(Sender: TObject);
begin
  LadeButtonSortList;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TtbPropButtons.GetButton(aToolbarItem: TToolbarItem): TSpeedButton;
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


function TtbPropButtons.GetButtonProp(aToolbarItem: TToolbarItem): TtbPropButton;
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
    tbPaste: Result := Paste;
  end;
end;

procedure TtbPropButtons.LadeButtonSortList;
  function GetStrFromInt(aInt: Integer): String;
  begin
    Result := IntToStr(aInt);
    while Length(Result) < 4 do
      Result := '0' + Result;
  end;
begin
  FSortList.Clear;
  FSortList.Add(GetStrFromInt(Positions.Bold) + '=' + IntToStr(Ord(tbBold)));
  FSortList.Add(GetStrFromInt(Positions.Italic) + '=' + IntToStr(Ord(tbItalic)));
  FSortList.Add(GetStrFromInt(Positions.Underline) + '=' + IntToStr(Ord(tbUnderline)));
  FSortList.Add(GetStrFromInt(Positions.Left) + '=' + IntToStr(Ord(tbLeft)));
  FSortList.Add(GetStrFromInt(Positions.Center) + '=' + IntToStr(Ord(tbCenter)));
  FSortList.Add(GetStrFromInt(Positions.Right) + '=' + IntToStr(Ord(tbRight)));
  FSortList.Add(GetStrFromInt(Positions.Justify) + '=' + IntToStr(Ord(tbJustify)));
  FSortList.Add(GetStrFromInt(Positions.Fontcolor) + '=' + IntToStr(Ord(tbFontcolor)));
  FSortList.Add(GetStrFromInt(Positions.Backgroundcolor) + '=' + IntToStr(Ord(tbBackgroundcolor)));
  FSortList.Add(GetStrFromInt(Positions.ParagraphBackground) + '=' + IntToStr(Ord(tbParagraphBackground)));
  FSortList.Add(GetStrFromInt(Positions.Bullets) + '=' + IntToStr(Ord(tbBullets)));
  FSortList.Add(GetStrFromInt(Positions.Number) + '=' + IntToStr(Ord(tbNumber)));
  FSortList.Add(GetStrFromInt(Positions.Save) + '=' + IntToStr(Ord(tbSave)));
  FSortList.Add(GetStrFromInt(Positions.Open) + '=' + IntToStr(Ord(tbOpen)));
  FSortList.Add(GetStrFromInt(Positions.Picture) + '=' + IntToStr(Ord(tbPicture)));
  FSortList.Add(GetStrFromInt(Positions.LargeEditor) + '=' + IntToStr(Ord(tbLargeEditor)));
  FSortList.Add(GetStrFromInt(Positions.TextHoch) + '=' + IntToStr(Ord(tbTextHoch)));
  FSortList.Add(GetStrFromInt(Positions.TextTief) + '=' + IntToStr(Ord(tbTextTief)));
  FSortList.Add(GetStrFromInt(Positions.Standardfont) + '=' + IntToStr(Ord(tbStandardFont)));
  FSortList.Add(GetStrFromInt(Positions.Fontfavoriten) + '=' + IntToStr(Ord(tbFontFavoriten)));
  FSortList.Add(GetStrFromInt(Positions.IndentInc) + '=' + IntToStr(Ord(tbIndentInc)));
  FSortList.Add(GetStrFromInt(Positions.IndentDec) + '=' + IntToStr(Ord(tbIndentDec)));
  FSortList.Add(GetStrFromInt(Positions.Linespace) + '=' + IntToStr(Ord(tbLineSpace)));
  FSortList.Add(GetStrFromInt(Positions.Print) + '=' + IntToStr(Ord(tbPrint)));
  FSortList.Add(GetStrFromInt(Positions.Clipboard) + '=' + IntToStr(Ord(tbClipboard)));
  FSortList.Add(GetStrFromInt(Positions.Reverse) + '=' + IntToStr(Ord(tbReverse)));
  FSortList.Add(GetStrFromInt(Positions.Cut) + '=' + IntToStr(Ord(tbCut)));
  FSortList.Add(GetStrFromInt(Positions.Paste) + '=' + IntToStr(Ord(tbPaste)));
end;

procedure TtbPropButtons.SetButtonsList(const Value: TObjectList);
  procedure SetButtonsStyle(aToolbarItem: TToolbarItem; aPropButton: TtbPropButton);
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
//var
//  btn: TSpeedButton;
//  m: TMargins;
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
  {
  FBold.ToolButton := GetButton(tbBold);
  btn := FBold.ToolButton;
  if Assigned(btn) then
  begin
    m := TMargins.Create(nil);
    try
      m.Assign(btn.Margins);
      FBold.Visible        := btn.Visible;
      FBold.Margins.Left   := m.Left;
      FBold.Margins.Top    := m.Top;
      FBold.Margins.Right  := m.Right;
      FBold.Margins.Bottom := m.Bottom;
    finally
      FreeAndNil(m);
    end;
  end;
  }
end;

end.
