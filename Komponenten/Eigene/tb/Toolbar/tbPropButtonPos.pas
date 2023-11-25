unit tbPropButtonPos;

interface

uses
  Classes, SysUtils, Contnrs, Buttons, Controls;


type
  TtbPropButtonPos = class(TPersistent)
  private
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
    FFontbox: Integer;
    FFontsize: Integer;
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
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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
    property Fontbox: Integer read FFontbox write SetFontbox;
    property Fontsize: Integer read FFontsize write SetFontsize;
  end;


implementation

{ TtbPropButtonPos }

constructor TtbPropButtonPos.Create(aOwner: TComponent);
begin

end;

destructor TtbPropButtonPos.Destroy;
begin

  inherited;
end;

procedure TtbPropButtonPos.DoPositionChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TtbPropButtonPos.SetBackgroundcolor(const Value: Integer);
begin
  if Value <> FBackgroundcolor then
  begin
    FBackgroundcolor := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetBold(const Value: Integer);
begin
  if Value <> FBold then
  begin
    FBold := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetBullets(const Value: Integer);
begin
  if Value <> FBullets then
  begin
    FBullets := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetCenter(const Value: Integer);
begin
  if Value <> FCenter then
  begin
    FCenter := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetClipboard(const Value: Integer);
begin
  if Value <> FClipboard then
  begin
    FClipboard := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetCut(const Value: Integer);
begin
  if Value <> FCut then
  begin
    FCut := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetFontbox(const Value: Integer);
begin
  if Value <> FFontbox then
  begin
    FFontbox := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetFontcolor(const Value: Integer);
begin
  if Value <> FFontcolor then
  begin
    FFontcolor := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetFontfavoriten(const Value: Integer);
begin
  if Value <> FFontfavoriten then
  begin
    FFontfavoriten := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetFontsize(const Value: Integer);
begin
  if Value <> FFontsize then
  begin
    FFontsize := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetIndentDec(const Value: Integer);
begin
  if Value <> FIndentDec then
  begin
    FIndentDec := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetIndentInc(const Value: Integer);
begin
  if Value <> FIndentInc then
  begin
    FIndentInc := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetItalic(const Value: Integer);
begin
  if Value <> FItalic then
  begin
    FItalic := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetJustify(const Value: Integer);
begin
  if Value <> FJustify then
  begin
    FJustify := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetLargeEditor(const Value: Integer);
begin
  if Value <> FLargeEditor then
  begin
    FLargeEditor := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetLeft(const Value: Integer);
begin
  if Value <> FLeft then
  begin
    FLeft := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetLinespace(const Value: Integer);
begin
  if Value <> FLinespace then
  begin
    FLinespace := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetNumber(const Value: Integer);
begin
  if Value <> FNumber then
  begin
    FNumber := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetOpen(const Value: Integer);
begin
  if Value <> FOpen then
  begin
    FOpen := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetParagraphBackground(const Value: Integer);
begin
  if Value <> FParagraphBackground then
  begin
    FParagraphBackground := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetPaste(const Value: Integer);
begin
  if Value <> FPaste then
  begin
    FPaste := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetPicture(const Value: Integer);
begin
  if Value <> FPicture then
  begin
    FPicture := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetPrint(const Value: Integer);
begin
  if Value <> FPrint then
  begin
    FPrint := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetReverse(const Value: Integer);
begin
  if Value <> FReverse then
  begin
    FReverse := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetRight(const Value: Integer);
begin
  if Value <> FRight then
  begin
    FRight := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetSave(const Value: Integer);
begin
  if Value <> FSave then
  begin
    FSave := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetStandardfont(const Value: Integer);
begin
  if Value <> FStandardfont then
  begin
    FStandardfont := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetTextHoch(const Value: Integer);
begin
  if Value <> FTextHoch then
  begin
    FTextHoch := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetTextTief(const Value: Integer);
begin
  if Value <> FTextTief then
  begin
    FTextTief := Value;
    DoPositionChange;
  end;
end;

procedure TtbPropButtonPos.SetUnterline(const Value: Integer);
begin
  if Value <> FUnterline then
  begin
    FUnterline := Value;
    DoPositionChange;
  end;
end;

end.
