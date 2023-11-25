unit tbToolbar;

interface

uses
  SysUtils, Classes, Controls, ToolWin, ComCtrls, ImgList, Graphics, Contnrs,
  Buttons, tbPropButtons, tbtoolbartypes, tbToolButton, tbFontbox, tbPropFontbox,
  Dialogs, tbFontSize, tbPropFontSize, tbRichviewEdit, RvStyle, RvEdit, Forms,
  Windows, RVFuncs, PtblRV, RVScroll, RVTable, ExtCtrls,
  RVMisc, RVUni, RVItem,  RVTypes, cToolbar;

type
  TToolbarItems = set of TToolbarItem;

type
  TChangeFontFavoritenEvent=procedure(Sender: TObject; aFontFavList: TStrings) of object;


type
  TTbToolbar = class(TCustomPanel)
  private
    //FParent: TWinControl;
    FButtons: TtbPropButtons;
    FButtonList: TObjectList;
    FOnBoldClick: TNotifyEvent;
    FButtonFrameColor: TColor;
    FUseButtonFrame: Boolean;
    FOnItalicClick: TNotifyEvent;
    FOnUnderlineClick: TNotifyEvent;
    FOnLeftClick: TNotifyEvent;
    FOnCenterClick: TNotifyEvent;
    FOnRightClick: TNotifyEvent;
    FOnJustifyClick: TNotifyEvent;
    FOnFontColorClick: TNotifyEvent;
    FOnBackgroundColorClick: TNotifyEvent;
    FOnParagraphBackgroundColorClick: TNotifyEvent;
    FOnBulletsClick: TNotifyEvent;
    FOnNumberClick: TNotifyEvent;
    FOnSaveClick: TNotifyEvent;
    FOnOpenClick: TNotifyEvent;
    FOnPictureClick: TNotifyEvent;
    FOnLargeEditorClick: TNotifyEvent;
    FOnTextHochClick: TNotifyEvent;
    FOnFontFavoritenClick: TNotifyEvent;
    FOnStandardFontClick: TNotifyEvent;
    FOnTextTiefClick: TNotifyEvent;
    FOnIdentIncClick: TNotifyEvent;
    FOnIdentDecClick: TNotifyEvent;
    FOnLinespaceClick: TNotifyEvent;
    FOnPrintClick: TNotifyEvent;
    FOnClipboardClick: TNotifyEvent;
    FOnReverseClick: TNotifyEvent;
    FOnCutClick: TNotifyEvent;
    FOnPasteClick: TNotifyEvent;
    FFontbox: TTbFontbox;
    FPropFontbox: TtbPropFontbox;
    FFontboxHeight: Integer;
    FFontboxWidth: Integer;
    FFontSizeboxHeight: Integer;
    FFontSizeboxWidth: Integer;
    FFontChanged: TNotifyEvent;
    FColorDialog: TColorDialog;
    FOpenDialog :TOpenDialog;
    FOnFontColorChanged: TNotifyEvent;
    FFontColor: TColor;
    FBackgroundcolor: TColor;
    FParagraphbackgroundcolor: TColor;
    FOnBackgroundColorChanged: TNotifyEvent;
    FOnParagraphBackgroundColorChanged: TNotifyEvent;
    FFontSizeBox: TTbFontSize;
    FPropFontSize: TtbPropFontSize;
    FOnFontSizeChanged: TNotifyEvent;
    FFontsize: Integer;
    FFilename: string;
    FRv: TtbRichviewEdit;
    FIgnoreChanges: Boolean;
    FSaveDialog: TSaveDialog;
    FPrinterDialog: TPrinterSetupDialog;
    FPrint: TRvPrint;
    FFindDialog: TFindDialog;
    FCurTextStyleChangedIgnore: Boolean;
    FFontFavList: TStringList;
    FLinespaceBefore : Integer;
    FLinespaceAfter  : Integer;
    FOnFontFavoritenChanged: TChangeFontFavoritenEvent;
    procedure LoadBitmapFromRes(aResType, aResName: string; aBitmap: Graphics.TBitmap);
    procedure AddButtons;
    function GetToolbarButtonItemsName(aToolbarItem: TToolbarItem): string;
    function GetToolbarItemsName(aToolbarItem: TToolbarItem): string;
    procedure ButtonChanged(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    function GetButtonFromTag(aTag: Integer): TTbToolbutton;
    procedure SetButtonFrameColor(const Value: TColor);
    procedure RefreshAllButtons;
    procedure SetUseButtonFrame(const Value: Boolean);
    procedure PropFontBoxChanged(Sender: TObject);
    procedure PropFontSizeBoxChanged(Sender: TObject);
    procedure FontChanged(Sender: TObject);
    function GetFontname: string;
    procedure SetFontColor(const Value: TColor);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetParagraphBackgroundColor(const Value: TColor);
    procedure FontSizeChanged(Sender: TObject);
    procedure SetFontSize(const Value: Integer);
    procedure CurTextStyleChanged(Sender: TObject);
    procedure CurParaStyleChanged(Sender: TObject);
    procedure SetRv(const Value: TtbRichviewEdit);
    procedure SetAlignmentToUI(Alignment: TRVAlignment);
    procedure ParaStyleConversion(Sender: TCustomRichViewEdit;
                  StyleNo, UserData: Integer; AppliedToText: Boolean;
                  var NewStyleNo: Integer);
    function GetAlignmentFromUI: TRVAlignment;
    procedure StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
              UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
    procedure SetRichViewEditFocus;
    procedure RvClear(Sender: TObject);
    procedure RvBeforeClear(Sender: TObject);
    procedure ShowFontFavoriten;
    procedure ShowLineSpace;
    procedure ChangeFontFavoriten(Sender: TObject);
    function CreateBullets: Integer;
    function CreateNumbering: Integer;
    function GetListNo(rve: TCustomRichViewEdit; ItemNo: Integer): Integer;
    procedure ToolbarButtonBulletChanged(Sender: TObject; aDown: Boolean);
    procedure ToolbarButtonNumberingChanged(Sender: TObject; aDown: Boolean);
  protected
    procedure Loaded; override;
    //procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //property Parent: TWinControl read FParent write SetParent;
    property Fontname: string read GetFontname;
    property FontColor: TColor read FFontColor write SetFontColor;
    property Backgroundcolor: TColor read FBackgroundcolor write SetBackgroundColor;
    property Paragraphbackgroundcolor: TColor read FParagraphbackgroundcolor write SetParagraphBackgroundColor;
    property Fontsize: Integer read FFontsize write SetFontSize;
    property Filename: string read FFilename;
    property FontFavList: TStringList read FFontFavList write FFontFavList;
  published
    property Color;
    property BevelOuter;
    property BevelInner;
    property Align;
    property FontSizeBox: TtbPropFontSize read FPropFontSize write FPropFontSize;
    property Fontbox: TtbPropFontbox read FPropFontbox write FPropFontbox;
    property Buttons: TtbPropButtons read FButtons write FButtons;
    property RichviewEdit: TtbRichviewEdit read FRv write SetRv;
    property OnBoldClick: TNotifyEvent read FOnBoldClick write FOnBoldClick;
    property OnItalicClick: TNotifyEvent read FOnItalicClick write FOnItalicClick;
    property OnUnderlineClick: TNotifyEvent read FOnUnderlineClick write FOnUnderlineClick;
    property OnLeftClick: TNotifyEvent read FOnLeftClick write FOnLeftClick;
    property OnCenterClick: TNotifyEvent read FOnCenterClick write FOnCenterClick;
    property OnRightClick: TNotifyEvent read FOnRightClick write FOnRightClick;
    property OnJustifyClick: TNotifyEvent read FOnJustifyClick write FOnJustifyClick;
    property OnFontColorClick: TNotifyEvent read FOnFontColorClick write FOnFontColorClick;
    property OnBackgroundColorClick: TNotifyEvent read FOnBackgroundColorClick write FOnBackgroundColorClick;
    property OnParagraphBackgroundColorClick: TNotifyEvent read FOnParagraphBackgroundColorClick write FOnParagraphBackgroundColorClick;
    property OnBulletsClick: TNotifyEvent read FOnBulletsClick write FOnBulletsClick;
    property OnNumberClick: TNotifyEvent read FOnNumberClick write FOnNumberClick;
    property OnSaveClick: TNotifyEvent read FOnSaveClick write FOnSaveClick;
    property OnOpenClick: TNotifyEvent read FOnOpenClick write FOnOpenClick;
    property OnPictureClick: TNotifyEvent read FOnPictureClick write FOnPictureClick;
    property OnLargeEditorClick: TNotifyEvent read FOnLargeEditorClick write FOnLargeEditorClick;
    property OnTextHochClick: TNotifyEvent read FOnTextHochClick write FOnTextHochClick;
    property OnTextTiefClick: TNotifyEvent read FOnTextTiefClick write FOnTextTiefClick;
    property OnStandardFontClick: TNotifyEvent read FOnStandardFontClick write FOnStandardFontClick;
    property OnFontFavoritenClick: TNotifyEvent read FOnFontFavoritenClick write FOnFontFavoritenClick;
    property OnIdentIncClick: TNotifyEvent read FOnIdentIncClick write FOnIdentIncClick;
    property OnIdentDecClick: TNotifyEvent read FOnIdentDecClick write FOnIdentDecClick;
    property OnLinespaceClick: TNotifyEvent read FOnLinespaceClick write FOnLinespaceClick;
    property OnPrintClick: TNotifyEvent read FOnPrintClick write FOnPrintClick;
    property OnClipboardClick: TNotifyEvent read FOnClipboardClick write FOnClipboardClick;
    property OnReverseClick: TNotifyEvent read FOnReverseClick write FOnReverseClick;
    property OnCutClick: TNotifyEvent read FOnCutClick write FOnCutClick;
    property OnPasteClick: TNotifyEvent read FOnPasteClick write FOnPasteClick;
    property ButtonFrameColor: TColor read FButtonFrameColor write SetButtonFrameColor;
    property UseButtonFrame: Boolean read FUseButtonFrame write SetUseButtonFrame;
    property OnFontChanged: TNotifyEvent read FFontChanged write FFontChanged;
    property OnFontColorChanged: TNotifyEvent read FOnFontColorChanged write FOnFontColorChanged;
    property OnBackgroundColorChanged: TNotifyEvent read FOnBackgroundColorChanged write FOnBackgroundColorChanged;
    property OnParagraphBackgroundColorChanged: TNotifyEvent read FOnParagraphBackgroundColorChanged write FOnParagraphBackgroundColorChanged;
    property OnFontSizeChanged: TNotifyEvent read FOnFontSizeChanged write FOnFontSizeChanged;
    property OnFontFavoritenChanged: TChangeFontFavoritenEvent read FOnFontFavoritenChanged write FOnFontFavoritenChanged;
  end;

procedure Register;

implementation

{$R Toolbar.res}

uses
  tbPropButton, fnt_FontFav, fnt_RveLinespace, System.UITypes, crvdata, Richview,
  RVGrHandler, rvrvdata;


procedure Register;
begin
  RegisterComponents('Samples', [TTbToolbar]);
end;

{ TTbToolbar }




constructor TTbToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCurTextStyleChangedIgnore := false;
  Height := 24;
  Width  := 680;
  FButtonList := TObjectList.Create;
  AddButtons;
  FButtons := TtbPropButtons.Create(Self);
  FButtons.ButtonsList := FButtonList;
  FButtons.OnChange    := ButtonChanged;
  FButtonFrameColor    := clSilver;
  FUseButtonFrame      := false;
  ButtonChanged(nil);
  FFontbox    := TTbFontbox.Create(Self);
  FFontbox.Parent := Self;
  FFontbox.Align := alLeft;
  FFontbox.OnChange := FontChanged;
  FPropFontbox := TtbPropFontbox.Create(Self);
  FPropFontbox.FontBox := FFontbox;
  FPropFontbox.OnChange := PropFontBoxChanged;
  FPropFontbox.Margins.Top := 0;
  FPropFontbox.Margins.Bottom := 0;

  FFontboxHeight:= FFontbox.Height;
  FFontboxWidth := FFontbox.Width;

  FColorDialog   := TColorDialog.Create(Self);
  FOpenDialog    := TOpenDialog.Create(Self);
  FSaveDialog    := TSaveDialog.Create(Self);
  FPrinterDialog := TPrinterSetupDialog.Create(Self);
  FFindDialog    := TFindDialog.Create(Self);


  FPrint := TRvPrint.Create(Self);

  FFontColor := clBlack;

  FFontSizeBox := TTbFontSize.Create(Self);
  FFontSizeBox.Parent := Self;
  FFontSizeboxHeight:= FFontSizeBox.Height;
  FFontSizeboxWidth := FFontSizeBox.Width;
  FFontSizebox.OnChange := FontSizeChanged;

  FPropFontSize := TtbPropFontSize.Create(Self);
  FFontSizeBox.AlignWithMargins := true;
  FPropFontSize.FontSizeBox := FFontSizeBox;
  FPropFontSize.OnChange := PropFontSizeBoxChanged;

  FFilename := '';
  FFontFavList := TStringList.Create;
  FFontFavList.Sorted := true;
  FFontFavList.Duplicates := dupIgnore;
  FFontFavList.OnChange := ChangeFontFavoriten;

  BevelOuter := bvNone;

  ShowCaption := false;

end;


destructor TTbToolbar.Destroy;
begin
  FreeAndNil(FPropFontbox);
  FreeAndNil(FButtons);
  FreeAndNil(FFontbox);
  FreeAndNil(FButtonList);
  FreeAndNil(FColorDialog);
  FreeAndNil(FOpenDialog);
  FreeAndNil(FFontSizeBox);
  FreeAndNil(FPropFontSize);
  FreeAndNil(FSaveDialog);
  FreeAndNil(FPrinterDialog);
  FreeAndNil(FPrint);
  FreeAndNil(FFindDialog);
  FreeAndNil(FFontFavList);
  inherited;
end;


procedure TTbToolbar.FontChanged(Sender: TObject);
var
  Fontname: string;
begin
  if Assigned(FRv) then
  begin
    Fontname := GetFontname;
    if (Fontname > '') and (not FIgnoreChanges) then
      FRv.ApplyStyleConversion(TEXT_APPLYFONTNAME);
    SetRichViewEditFocus;
  end;
  {
  if (cmbFont.ItemIndex<>-1) then begin
    if not IgnoreChanges then begin
      FontName := cmbFont.Items[cmbFont.ItemIndex];
      rve.ApplyStyleConversion(TEXT_APPLYFONTNAME);
    end;
  end;
  if Visible then
    rve.SetFocus;
  }

  if Assigned(FFontChanged) then
    FFontChanged(Sender);
end;

procedure TTbToolbar.FontSizeChanged(Sender: TObject);
var
  fs: Integer;
begin
  if TryStrToInt(FFontSizeBox.Text, fs) then
    SetFontSize(fs);
end;

function TTbToolbar.GetButtonFromTag(aTag: Integer): TTbToolbutton;
var
  i1: Integer;
  btn: TTbToolbutton;
begin
  Result := nil;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TTbToolbutton(FButtonList.Items[i1]);
    if btn.Tag = aTag then
    begin
      Result := btn;
      exit;
    end;
  end;
end;

function TTbToolbar.GetFontname: string;
begin
  Result := '';
  if not Assigned(FFontbox) then
    exit;
  if FFontbox.ItemIndex = -1 then
    exit;
  Result := FFontbox.Items.Strings[FFontbox.ItemIndex];
end;


function TTbToolbar.GetToolbarButtonItemsName(aToolbarItem: TToolbarItem): string;
begin
  Result := 'btn_' + GetToolbarItemsName(aToolbarItem);
end;


function TTbToolbar.GetToolbarItemsName(aToolbarItem: TToolbarItem): string;
begin
  Result := '';
  if aToolbarItem = tbBold then
    Result := 'Bold';
  if aToolbarItem = tbItalic then
    Result := 'Italic';
  if aToolbarItem = tbUnderline then
    Result := 'Underline';
  if aToolbarItem = tbLeft then
    Result := 'Left';
  if aToolbarItem = tbCenter then
    Result := 'Center';
  if aToolbarItem = tbRight then
    Result := 'Right';
  if aToolbarItem = tbJustify then
    Result := 'Justify';
  if aToolbarItem = tbFontcolor then
    Result := 'FontColor';
  if aToolbarItem = tbBackgroundcolor then
    Result := 'BackgroundColor';
  if aToolbarItem = tbParagraphBackground then
    Result := 'ParagraphBackgroundColor';
  if aToolbarItem = tbBullets then
    Result := 'Bullets';
  if aToolbarItem = tbNumber then
    Result := 'Number';
  if aToolbarItem = tbSave then
    Result := 'Save';
  if aToolbarItem = tbOpen then
    Result := 'Open';
  if aToolbarItem = tbPicture then
    Result := 'Picture';
  if aToolbarItem = tbLargeEditor then
    Result := 'LargeEditor';
  if aToolbarItem = tbTextHoch then
    Result := 'TextHoch';
  if aToolbarItem = tbTextTief then
    Result := 'TextTief';
  if aToolbarItem = tbStandardFont then
    Result := 'StandardFont';
  if aToolbarItem = tbFontFavoriten then
    Result := 'Fontfavoriten';
  if aToolbarItem = tbIndentInc then
    Result := 'IdentInc';
  if aToolbarItem = tbIndentDec then
    Result := 'IdentDec';
  if aToolbarItem = tbLineSpace then
    Result := 'LineSpace';
  if aToolbarItem = tbPrint then
    Result := 'Print';
  if aToolbarItem = tbClipboard then
    Result := 'Clipboard';
  if aToolbarItem = tbReverse then
    Result := 'Reverse';
  if aToolbarItem = tbCut then
    Result := 'Cut';
  if aToolbarItem = tbPaste then
    Result := 'Paste';
end;


procedure TTbToolbar.AddButtons;
  procedure AddButton(aToolbarItem: TToolbarItem; var aPos: Integer);
  var
    btn: TTbToolbutton;
    Bitmap: Graphics.TBitmap;
  begin
    btn := TTbToolbutton.Create(Self);
    FButtonList.Add(btn);
    Btn.Name   := GetToolbarButtonItemsName(aToolbarItem);
    btn.Parent := Self;
    btn.Tag    := Ord(aToolbarItem);
    btn.Width  := 23;
    btn.Height := 24;
    btn.Align  := alLeft;
    btn.AlignWithMargins := true;
    btn.Margins.Bottom := 0;
    btn.Margins.Left   := 0;
    if FUseButtonFrame then
      btn.Margins.Right  := 1
    else
      btn.Margins.Right  := 0;
    btn.Margins.Top    := 0;
    btn.Flat := true;
    btn.OnClick := ButtonClick;

    if (aToolbarItem = tbBold)
    or (aToolbarItem = tbItalic)
    or (aToolbarItem = tbUnderline) then
    begin
      btn.GroupIndex := ord(aToolbarItem) + 1;
      btn.AllowAllUp := true;
    end;

    if (aToolbarItem = tbLeft)
    or (aToolbarItem = tbCenter)
    or (aToolbarItem = tbRight)
    or (aToolbarItem = tbJustify) then
    begin
      btn.GroupIndex := 4;
      btn.AllowAllUp := true;
    end;

    if (aToolbarItem = tbBullets)
    or (aToolbarItem = tbNumber) then
    begin
      btn.GroupIndex := 5;
      btn.AllowAllUp := true;
    end;


    Bitmap := Graphics.TBitmap.Create;
    try
      LoadBitmapFromRes('RT_RCDATA', GetToolbarItemsName(aToolbarItem), Bitmap);
      btn.Glyph.Mask(clFuchsia);
      btn.Glyph.Assign(Bitmap);
    finally
      FreeAndNil(Bitmap);
    end;

    inc(aPos);

  end;
var
  iPos: Integer;
  ToolbarItem: TToolbarItem;
begin
  iPos := 0;

  for ToolbarItem := tbBold to tbPaste do
  begin
    AddButton(ToolbarItem, iPos);
  end;

  {
  AddButton(tbBold, iPos);
  AddButton(tbItalic, iPos);
  AddButton(tbUnderline, iPos);
  AddButton(tbLeft, iPos);
  AddButton(tbCenter, iPos);
  AddButton(tbRight, iPos);
  AddButton(tbJustify, iPos);
  AddButton(tbFontFavoriten, iPos);
  AddButton(tbFontcolor, iPos);
  AddButton(tbBackgroundcolor, iPos);
  AddButton(tbParagraphBackground, iPos);
  AddButton(tbBullets, iPos);
  AddButton(tbNumber, iPos);
  AddButton(tbSave, iPos);
  AddButton(tbOpen, iPos);
  AddButton(tbPicture, iPos);
  AddButton(tbLargeEditor, iPos);
  AddButton(tbTextHoch, iPos);
  AddButton(tbTextTief, iPos);
  AddButton(tbStandardFont, iPos);
  AddButton(tbIndentInc, iPos);
  AddButton(tbIndentDec, iPos);
  AddButton(tbLineSpace, iPos);
  }
end;


procedure TTbToolbar.LoadBitmapFromRes(aResType, aResName: string;
  aBitmap: Graphics.TBitmap);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aBitmap.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;


procedure TTbToolbar.Loaded;
begin
  inherited;
  Buttons.LadeButtonSortList;
  ButtonChanged(nil);
end;


procedure TTbToolbar.RefreshAllButtons;
var
  i1: Integer;
  btn: TTbToolbutton;
  AllSameMargin: Boolean;
  FirstMargin: Integer;
begin
  if not Assigned(FButtonList) then
    exit;

  if FButtonList.Count = 0 then
    exit;

  AllSameMargin := true;
  FirstMargin   := TTbToolbutton(FButtonList.Items[0]).Margins.Right;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    if FirstMargin <> TTbToolbutton(FButtonList.Items[i1]).Margins.Right then
    begin
      AllSameMargin := false;
      break;
    end;
  end;


  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TTbToolbutton(FButtonList.Items[i1]);
    btn.ButtonFrameColor := FButtonFrameColor;
    btn.UseButtonFrame   := FUseButtonFrame;
    if AllSameMargin then
    begin
      if FUseButtonFrame then
        btn.Margins.Right  := 1
      else
        btn.Margins.Right  := 0;
    end;
    btn.Invalidate;
    btn.Repaint;
  end;
end;


procedure TTbToolbar.RvBeforeClear(Sender: TObject);
begin
  FCurTextStyleChangedIgnore := true;
end;

procedure TTbToolbar.RvClear(Sender: TObject);
var
  f: TFont;
  btn: TTbToolbutton;
begin
  FCurTextStyleChangedIgnore := false;
  f := TFont.Create;
  try
    f.Name := 'Arial';
    if Fontbox.FontBox.ItemIndex > -1 then
      f.Name := Fontbox.FontBox.Items[Fontbox.FontBox.ItemIndex];
    f.Color := FFontColor;
    f.Size  := FFontsize;

    btn := GetButtonFromTag(Ord(tbBold));
    if btn.Down then
      f.Style := f.Style + [fsBold];

    btn := GetButtonFromTag(Ord(tbItalic));
    if btn.Down then
      f.Style := f.Style + [fsItalic];

    btn := GetButtonFromTag(Ord(tbUnderline));
    if btn.Down then
      f.Style := f.Style + [fsUnderline];

    FRv.CurTextStyleNo := FRv.GetStyleNo(f);
  finally
    FreeAndNil(f);
  end;
end;

procedure TTbToolbar.SetBackgroundColor(const Value: TColor);
begin
  if FBackgroundcolor = Value then
    exit;
  FBackgroundcolor := Value;
  if Assigned(FOnBackgroundColorChanged) then
  begin
    FOnBackgroundColorChanged(Self);
    exit;
  end;
  FRv.ApplyStyleConversion(TEXT_BACKCOLOR);
end;

procedure TTbToolbar.SetButtonFrameColor(const Value: TColor);
begin
  if not Assigned(FButtonList) then
    exit;
  if FButtonFrameColor = Value then
    exit;
  FButtonFrameColor := Value;
  RefreshAllButtons;
end;

procedure TTbToolbar.SetFontColor(const Value: TColor);
begin
  if Value = FFontColor then
    exit;
  FFontColor := Value;
  if Assigned(FOnFontColorChanged) then
  begin
    FOnFontColorChanged(Self);
    exit;
  end;
  //cd.Color := rvs.TextStyles[rve.CurTextStyleNo].Color;
  //if cd.Execute then
  FRv.ApplyStyleConversion(TEXT_COLOR);
end;


procedure TTbToolbar.SetFontSize(const Value: Integer);
var
  Fontname: string;
begin
  if Value = FFontsize then
    exit;

  FFontsize := Value;

  if Assigned(FOnFontSizeChanged) then
  begin
    FOnFontSizeChanged(Self);
    exit;
  end;

  if Assigned(FRv) then
  begin
    FontName := getFontname;
    if (FontName > '') and (not FIgnoreChanges) then
      FRv.ApplyStyleConversion(TEXT_APPLYFONTSIZE)
    else
      SetRichViewEditFocus;
  end;

end;

procedure TTbToolbar.SetParagraphBackgroundColor(const Value: TColor);
begin
  if FParagraphbackgroundcolor = Value then
    exit;
  FParagraphbackgroundcolor := Value;
  if Assigned(FOnParagraphBackgroundColorChanged) then
  begin
    FOnParagraphBackgroundColorChanged(Self);
    exit;
  end;
  FRv.ApplyParaStyleConversion(PARA_COLOR);
end;

{
procedure TTbToolbar.SetParent(AParent: TWinControl);
begin  //
  inherited;
  BringToFront;
end;
}
procedure TTbToolbar.SetRv(const Value: TtbRichviewEdit);
begin
  FRv := Value;
  FRv.OnCurParaStyleChanged := CurParaStyleChanged;
  FRv.OnCurTextStyleChanged := CurTextStyleChanged;
  FRv.OnParaStyleConversion := ParaStyleConversion;
  FRv.OnStyleConversion     := StyleConversion;
  FRv.OnClear               := RvClear;
  FRv.OnBeforeClear         := RvBeforeClear;
  FRv.OnChangedBullet       := ToolbarButtonBulletChanged;
  FRv.OnChangedNumbering    := ToolbarButtonNumberingChanged;
  CurTextStyleChanged(nil);
  CurParaStyleChanged(nil);
end;

procedure TTbToolbar.SetUseButtonFrame(const Value: Boolean);
begin
  if FUseButtonFrame = Value then
    exit;
  FUseButtonFrame := Value;
  RefreshAllButtons;
end;


procedure TTbToolbar.ButtonChanged(Sender: TObject);
var
  i1: Integer;
  btn: TTbToolbutton;
  iLeft: Integer;
  ButtonProp: TtbPropButton;
  ToolbarItem: TToolbarItem;
begin
  if Assigned(FFontbox) then
    FFontbox.Align := alNone;

  if Assigned(FFontSizeBox) then
    FFontSizeBox.Align := alNone;

  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TTbToolbutton(FButtonList.Items[i1]);
    if btn.Visible then
    begin
      btn.Align  := alLeft;
      btn.Width  := 23;
      btn.Height := 24;
    end
    else
    begin
      btn.Align  := alNone;
      btn.Width  := 0;
      btn.Height := 0;
    end;
    // Nur fürs Testen, kommt dann wieder weg.
    btn.Visible := false;
    btn.Align  := alNone;
    btn.Width  := 0;
    btn.Height := 0;
  end;

  iLeft := 0;
  for i1 := 0 to FButtons.SortList.Count - 1 do
  begin
    if Assigned(FFontbox) then
    begin
      if i1 = FPropFontbox.Position then
      begin
        FFontbox.Left := iLeft;
        iLeft := iLeft + FFontbox.Width + FFontbox.Margins.Left + FFontbox.Margins.Right;
        FFontbox.Align := alLeft;
      end;
    end;
    if Assigned(FFontSizeBox) then
    begin
      if i1 = FPropFontSize.Position then
      begin
        FFontSizeBox.Left := iLeft;
        iLeft := iLeft + FFontSizeBox.Width + FFontSizeBox.Margins.Left + FFontSizeBox.Margins.Right;
        FFontSizeBox.Align := alLeft;
      end;
    end;
    btn := GetButtonFromTag(StrToInt(FButtons.SortList.ValueFromIndex[i1]));
    if not Assigned(btn) then
      continue;
    ToolbarItem := TToolbarItem(StrToInt(FButtons.SortList.ValueFromIndex[i1]));
    FButtons.GetButtonProp(ToolbarItem);
    ButtonProp := FButtons.GetButtonProp(ToolbarItem);
    if not Assigned(ButtonProp) then
      continue;
    btn.Visible := ButtonProp.Visible;
    if not btn.Visible then
      continue;
    btn.Width   := 23;
    btn.Height  := 24;
    btn.Left    := iLeft;
    iLeft       := iLeft + btn.Width + btn.Margins.Left + btn.Margins.Right;
    btn.Align   := alLeft;
  end;

end;

procedure TTbToolbar.ButtonClick(Sender: TObject);
var
  gr: TGraphic;
begin
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbBold then
  begin
    if Assigned(FOnBoldClick) then
    begin
      FOnBoldClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_BOLD);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbItalic then
  begin
    if Assigned(FOnItalicClick) then
    begin
      FOnItalicClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_ITALIC);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbUnderline then
  begin
    if Assigned(FOnUnderlineClick) then
    begin
      FOnUnderlineClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_UNDERLINE);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbLeft then
  begin
    if Assigned(FOnLeftClick) then
    begin
      FOnLeftClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbCenter then
  begin
    if Assigned(FOnCenterClick) then
    begin
      FOnCenterClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbRight then
  begin
    if Assigned(FOnRightClick) then
    begin
      FOnRightClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbJustify then
  begin
    if Assigned(FOnJustifyClick) then
    begin
      FOnJustifyClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbFontcolor then
  begin
    if Assigned(FOnFontcolorclick) then
    begin
      FOnFontcolorclick(Sender);
      exit;
    end;
    FFontColor := FRv.Style.TextStyles[FRv.CurTextStyleNo].Color;
    FColorDialog.Color := FFontColor;
    if FColorDialog.Execute then
    begin
      SetFontColor(FColorDialog.Color);
      exit;
    end;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbBackgroundcolor then
  begin
    if Assigned(FOnBackgroundcolorclick) then
    begin
      FOnBackgroundcolorclick(Sender);
      exit;
    end;
    FColorDialog.Color := FBackgroundcolor;
    case Application.MessageBox('Möchten Sie einen transparenten Hintergrund?',
                            'Text Background', MB_YESNOCANCEL or MB_ICONQUESTION) of
      IDYES:
        begin
          FBackgroundcolor := clWhite;
          SetBackgroundColor(FBackgroundcolor);
          FRv.ApplyStyleConversion(TEXT_BACKCOLOR);
          exit;
        end;
      IDNO:
        begin
          FBackgroundcolor := FRv.Style.TextStyles[FRv.CurTextStyleNo].BackColor;
          if FBackgroundcolor = clNone then
            FBackgroundcolor := clWhite;
        end;
      IDCANCEL:
        exit;
    end;

    if FColorDialog.Execute then
    begin
      SetBackgroundColor(FColorDialog.Color);
      exit;
    end;
  end;

  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbParagraphBackground then
  begin
    if Assigned(FOnParagraphBackgroundColorClick) then
    begin
      FOnParagraphBackgroundColorClick(Sender);
      exit;
    end;

    case Application.MessageBox('Möchten Sie einen transparenten Hintergrund?',
                            'Text Background', MB_YESNOCANCEL or MB_ICONQUESTION) of
      IDYES:
        begin
          FParagraphbackgroundcolor := clWhite;
          FRv.ApplyParaStyleConversion(PARA_COLOR);
          exit;
        end;
      IDNO:
        begin
          FParagraphbackgroundcolor := FRv.Style.ParaStyles[FRv.CurParaStyleNo].Background.Color;
          if FParagraphbackgroundcolor = clNone then
            FParagraphbackgroundcolor := clWhite;
        end;
      IDCANCEL:
        exit;
    end;

    FColorDialog.Color := FParagraphBackgroundcolor;
    if FColorDialog.Execute then
    begin
      SetParagraphBackgroundColor(FColorDialog.Color);
      exit;
    end;

  end;

  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbBullets then
  begin
    if Assigned(FOnBulletsClick) then
    begin
      FOnBulletsClick(Sender);
      exit;
    end;
    if not Assigned(FRv) then
      exit;
    if not TTbToolbutton(Sender).Down then
      FRv.RemoveLists(false)
    else
      FRv.ApplyListStyle(createBullets, 0,0, false, false);
    end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbNumber then
  begin
    if Assigned(FOnNumberClick) then
    begin
      FOnNumberClick(Sender);
      exit;
    end;
    if not Assigned(FRv) then
      exit;
    if not TTbToolbutton(Sender).Down then
      FRv.RemoveLists(False)
    else
      FRv.ApplyListStyle(CreateNumbering,0,0,False,False);
  end;

  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbSave then
  begin
    if Assigned(FOnSaveClick) then
    begin
      FOnSaveClick(Sender);
      exit;
    end;

    if FFileName = '' then
    begin
      FSaveDialog.Filter := 'Richtext|*.rtf';
      FSaveDialog.DefaultExt := 'rtf';
      if FSaveDialog.Execute then
        FFileName := FSaveDialog.FileName;
    end;
    if FFileName > '' then
    begin
      FRv.SaveRTF(FFileName, False);
      FRv.Modified := False;
    end;
  end;

  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbOpen then
  begin
    if Assigned(FOnOpenClick) then
    begin
      FOnOpenClick(Sender);
      exit;
    end;
    FOpenDialog.Title  := '';
    FOpenDialog.Filter := '';
    if FOpenDialog.Execute then
      FFileName := FOpenDialog.FileName;
  end;


  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbPicture then
  begin
    if Assigned(FOnPictureClick) then
    begin
      FOnPictureClick(Sender);
      exit;
    end;

    FOpenDialog.Title  := 'Bild einfügen';
    FOpenDialog.Filter := 'Bilder(*.bmp;*.wmf;*.emf;*.ico;*.jpg)|*.bmp;*.wmf;*.emf;*.ico;*.jpg|All(*.*)|*.*';

    if FOpenDialog.Execute then
    begin
      //gr := nil;

      gr := RVGraphicHandler.LoadFromFile(FOpenDialog.FileName);
      if gr <> nil then
        FRv.InsertPicture('', gr, rvvaBaseline)
      else
        Application.MessageBox(PChar('Das Bild kann nicht eingelesen werden. '+ FOpenDialog.FileName), 'Error',
           MB_OK or MB_ICONSTOP);
    end;

  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbLargeEditor then
  begin
    if Assigned(FOnLargeEditorClick) then
      FOnLargeEditorClick(Sender);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbTextHoch then
  begin
    if Assigned(FOnTextHochClick) then
      FOnTextHochClick(Sender);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbTextTief then
  begin
    if Assigned(FOnTextTiefClick) then
      FOnTextTiefClick(Sender);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbStandardFont then
  begin
    if Assigned(FOnStandardFontClick) then
      FOnStandardFontClick(Sender);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbFontFavoriten then
  begin
    if Assigned(FOnFontFavoritenClick) then
    begin
      FOnFontFavoritenClick(Sender);
      exit;
    end;
    ShowFontFavoriten;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbIndentInc then
  begin
    if Assigned(FOnIdentIncClick) then
    begin
      FOnIdentIncClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_INDENTINC);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbIndentDec then
  begin
    if Assigned(FOnIdentDecClick) then
    begin
      FOnIdentDecClick(Sender);
      exit;
    end;
    FRv.ApplyParaStyleConversion(PARA_INDENTDEC);
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbLineSpace then
  begin
    if Assigned(FOnLinespaceClick) then
      FOnLinespaceClick(Sender)
    else
    begin
      ShowLineSpace;
    end;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbPrint then
  begin
    if Assigned(FOnPrintClick) then
    begin
      FOnPrintClick(Sender);
      exit;
    end;
    if FPrinterDialog.Execute then
    begin
      FPrint.AssignSource(FRv);
      FPrint.FormatPages(rvdoALL);
      if FPrint.PagesCount>0 then
        FPrint.Print('',1,False);
    end;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbClipboard then
  begin
    if Assigned(FOnClipboardClick) then
    begin
      FOnClipboardClick(Sender);
      exit;
    end;
    FRv.Copy;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbReverse then
  begin
    if Assigned(FOnReverseClick) then
    begin
      FOnReverseClick(Sender);
      exit;
    end;
    FRv.Undo;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbCut then
  begin
    if Assigned(FOnCutClick) then
    begin
      FOnCutClick(Sender);
      exit;
    end;
    FRv.Copy;
    FRv.DeleteSelection;
  end;
  if TToolbarItem(TTbToolbutton(Sender).Tag) = tbPaste then
  begin
    if Assigned(FOnPasteClick) then
    begin
      FOnPasteClick(Sender);
      exit;
    end;
    FRv.Paste;
  end;
end;



procedure TTbToolbar.PropFontBoxChanged(Sender: TObject);
begin
  if FFontbox.Visible then
  begin
    FFontbox.Align  := alLeft;
    FFontbox.Width  := FPropFontbox.Witdh;
    FFontbox.Height := FFontboxHeight;
  end
  else
  begin
    FFontbox.Align  := alNone;
    FFontbox.Width  := 0;
    FFontbox.Height := 0;
  end;
  ButtonChanged(nil);
end;

procedure TTbToolbar.PropFontSizeBoxChanged(Sender: TObject);
begin
  if FFontSizeBox.Visible then
  begin
    FFontSizeBox.Align  := alLeft;
    FFontSizeBox.Width  := FFontSizeboxWidth;
    FFontSizeBox.Height := FFontSizeboxHeight;
  end
  else
  begin
    FFontSizeBox.Align  := alNone;
    FFontSizeBox.Width  := 0;
    FFontSizeBox.Height := 0;
  end;
  ButtonChanged(nil);
end;


// RichviewEdit funktionen

// current text style was changed
procedure TTbToolbar.CurTextStyleChanged(Sender: TObject);
var
  fi: TFontInfo;
  btn: TTbToolbutton;
begin
  if FCurTextStyleChangedIgnore then
    exit;
  FIgnoreChanges := true;
  fi := FRv.Style.TextStyles[FRv.CurTextStyleNo];
  FFontbox.ItemIndex := FFontbox.Items.IndexOf(fi.FontName);
  FPropFontSize.FontSizeBox.Value := fi.Size;

  btn := GetButtonFromTag(Ord(tbBold));
  btn.Down := fsBold in fi.Style;

  btn := GetButtonFromTag(Ord(tbItalic));
  btn.Down := fsItalic in fi.Style;

  btn := GetButtonFromTag(Ord(tbUnderline));
  btn.Down := fsUnderline in fi.Style;
  FIgnoreChanges := false;

end;
{------------------------------------------------------------------------------}
// current paragraph style was changed
procedure TTbToolbar.CurParaStyleChanged(Sender: TObject);
begin
  SetAlignmentToUI(FRv.Style.ParaStyles[FRv.CurParaStyleNo].Alignment);
end;

procedure TTbToolbar.SetAlignmentToUI(Alignment: TRVAlignment);
var
  btn: TTbToolbutton;
begin
  case Alignment of
    rvaLeft:
      begin
        btn := GetButtonFromTag(Ord(tbLeft));
        btn.Down := true;
      end;
    rvaCenter:
      begin
        btn := GetButtonFromTag(Ord(tbCenter));
        btn.Down := true;
      end;
    rvaRight:
      begin
        btn := GetButtonFromTag(Ord(tbRight));
        btn.Down := true;
      end;
    rvaJustify:
      begin
        btn := GetButtonFromTag(Ord(tbJustify));
        btn.Down := true;
      end;
  end;
end;


procedure TTbToolbar.ParaStyleConversion(Sender: TCustomRichViewEdit;
  StyleNo, UserData: Integer; AppliedToText: Boolean;
  var NewStyleNo: Integer);
var ParaInfo: TParaInfo;
begin
  ParaInfo := TParaInfo.Create(nil);
  try
    ParaInfo.Assign(FRv.Style.ParaStyles[StyleNo]);
    case UserData of
      PARA_ALIGNMENT:
        ParaInfo.Alignment := GetAlignmentFromUI;
      PARA_INDENTINC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent+20;
          if ParaInfo.LeftIndent>200 then
            ParaInfo.LeftIndent := 200;
        end;
      PARA_INDENTDEC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent-20;
          if ParaInfo.LeftIndent<0 then
            ParaInfo.LeftIndent := 0;
        end;
      PARA_COLOR:
        ParaInfo.Background.Color := FParagraphbackgroundcolor;
      PARA_LINESPACE:
        begin
          ParaInfo.SpaceAfter  := FLinespaceAfter;
          paraInfo.SpaceBefore := FLinespaceBefore;
        end;
      // add your code here....
    end;
    NewStyleNo := FRv.Style.FindParaStyle(ParaInfo);
  finally
    ParaInfo.Free;
  end;

end;


function TTbToolbar.GetAlignmentFromUI: TRVAlignment;
var
  btn: TTbToolbutton;
begin
  Result := rvaLeft;
  btn := GetButtonFromTag(Ord(tbLeft));
  if btn.Down then
    Result := rvaLeft;

  btn := GetButtonFromTag(Ord(tbRight));
  if btn.Down then
    Result := rvaRight;

  btn := GetButtonFromTag(Ord(tbCenter));
  if btn.Down then
    Result := rvaCenter;

  btn := GetButtonFromTag(Ord(tbJustify));
  if btn.Down then
    Result := rvaJustify;

end;


procedure TTbToolbar.StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
  UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
var
  FontInfo: TFontInfo;
  btn     : TTbToolbutton;
begin
  FontInfo := TFontInfo.Create(nil);
  try
    FontInfo.Assign(FRv.Style.TextStyles[StyleNo]);
    case UserData of
      TEXT_BOLD:
        begin
          btn := GetButtonFromTag(Ord(tbBold));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsBold]
          else
            FontInfo.Style := FontInfo.Style-[fsBold];
        end;
      TEXT_ITALIC:
        begin
          btn := GetButtonFromTag(Ord(tbItalic));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsItalic]
          else
            FontInfo.Style := FontInfo.Style-[fsItalic];
        end;
      TEXT_UNDERLINE:
        begin
          btn := GetButtonFromTag(Ord(tbUnderline));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsUnderline]
          else
            FontInfo.Style := FontInfo.Style-[fsUnderline];
        end;
      TEXT_APPLYFONTNAME:
        FontInfo.FontName := GetFontname;
      TEXT_APPLYFONTSIZE:
        FontInfo.Size     := FFontsize;
      //TEXT_APPLYFONT:
      //  FontInfo.Assign(fd.Font);
      TEXT_COLOR:
        FontInfo.Color := FFontColor;
      TEXT_BACKCOLOR:
        FontInfo.BackColor := FBackgroundcolor;
      // add your code here....
    end;
    NewStyleNo := FRv.Style.FindTextStyle(FontInfo);
  finally
    FontInfo.Free;
  end;
end;


procedure TTbToolbar.SetRichViewEditFocus;
begin
  if (Visible) and (FRv.CanFocus) then
  begin
    if (csDesigning in ComponentState)
    or (csLoading in ComponentState)
    or (csWriting in ComponentState)
    or (csReading in ComponentState) then
      exit;
    try
      FRv.SetFocus;
    except
    end;
  end;
end;


procedure TTbToolbar.ShowFontFavoriten;
var
  Form: Tfrm_FontFav;
begin
  Form := Tfrm_FontFav.Create(nil);
  try
    Form.SetFavoriten(FFontFavList.Text);
    Form.ShowModal;
    if not Form.Cancel then
    begin
      FFontFavList.Text := Form.GetFavoriten;

    end;
  finally
    FreeAndNil(Form);
  end;
end;



procedure TTbToolbar.ShowLineSpace;
var
  Form: Tfrm_RveLinespace;
  ParaInfo: TParaInfo;
begin
  ParaInfo := FRv.Style.ParaStyles.Items[FRv.CurParaStyleNo];
  Form := Tfrm_RveLinespace.Create(Self);
  try
    Form.FormStyle      := fsStayOnTop;
    Form.edt_Vor.Value  := ParaInfo.SpaceBefore;
    Form.edt_Nach.Value := ParaInfo.SpaceAfter;
    Form.ShowModal;
    if not Form.Cancel then
    begin
      FLinespaceBefore := Form.edt_Vor.Value;
      FLinespaceAfter  := Form.edt_Nach.Value;
      FRv.ApplyParaStyleConversion(PARA_LINESPACE);
    end;
  finally
    FreeAndNil(Form);
  end;
end;

procedure TTbToolbar.ChangeFontFavoriten(Sender: TObject);
begin
  if not Assigned(FPropFontbox) then
    exit;
  FPropFontbox.SetFontFavoriten(FFontFavList);
  if Assigned(FOnFontFavoritenChanged) then
    FOnFontFavoritenChanged(Self, FFontFavList);
end;


function TTbToolbar.CreateBullets: Integer;
var
  ListStyle: TRVListInfo;
  ListLevel: TRVListLevel;
  i: Integer;
begin
  Result := 0;
  if not Assigned(FRv) then
    exit;

  // 1. Creating desired list style
  ListStyle := TRVListInfo.Create(nil);
  for i := 0 to 8 do
  begin
    ListLevel := ListStyle.Levels.add;
    ListLevel.ListType := rvlstBullet;
    case i mod 3 of
      0: begin
           ListLevel.Font.Name := 'Symbol';
           ListLevel.Font.Charset := SYMBOL_CHARSET;
           ListLevel.FormatString := {$IFDEF RVUNICODESTR}#$00B7{$ELSE}#$B7{$ENDIF};
         end;
      1: begin
           ListLevel.Font.Name := 'Courier New';
           ListLevel.Font.Charset := ANSI_CHARSET;
           ListLevel.FormatString := 'o';
         end;
      2: begin
           ListLevel.Font.Name := 'Wingdings';
           ListLevel.Font.Charset := SYMBOL_CHARSET;
           ListLevel.FormatString := {$IFDEF RVUNICODESTR}#$00A7{$ELSE}#$A7{$ENDIF};
         end;
    end;

    ListLevel.Font.Size    := FFontsize;
    ListLevel.FirstIndent  := 0;
    ListLevel.LeftIndent   := (i+1) * FFontsize;
    ListLevel.MarkerIndent := i * FFontsize;

    ListLevel.LeftIndent   := (i+1)*DEF_INDENT;
    ListLevel.MarkerIndent := i*DEF_INDENT;

    {
    ListLevel.Font.Size    := 10;
    ListLevel.FirstIndent  := 0;
    ListLevel.LeftIndent   := (i+1) * 10;
    ListLevel.MarkerIndent := i * 10;
    }
    {
    Hier kann alles flexible eingestellt werden.
    ListLevel.Font.Size    := edt_Fontsize.Value;
    ListLevel.FirstIndent  := 0;
    ListLevel.LeftIndent   := (i+1) * edt_Fontsize.Value;
    ListLevel.MarkerIndent := i * edt_Fontsize.Value;
    }

    {
    ListLevel.LeftIndent   := (i+1)*DEF_INDENT;
    ListLevel.MarkerIndent := i*DEF_INDENT;
    }
  end;
  // 2. Searching for existing style with these properties. Creating it, if not found
  Result := FRv.Style.ListStyles.FindSuchStyle(ListStyle, True);
  ListStyle.Free;

end;

function TTbToolbar.CreateNumbering: Integer;
var ListStyle: TRVListInfo;
    rve: TCustomRichViewEdit;
    i, StartNo, EndNo, a, b, ListNo: Integer;
begin
  Result := -1;
  if not Assigned(FRv) then
    exit;
  // 1. Creating desired list style
  ListStyle := TRVListInfo.Create(nil);
  with ListStyle.Levels.Add do begin
    ListType  := rvlstDecimal;
    Font.Name := 'Arial';
    Font.Size := 10;
    if FFontSizeBox.Value > 0 then
      Font.Size := FFontSizeBox.Value;
    if FFontbox.ItemIndex > 0 then
      Font.Name := FFontbox.Items[FFontbox.ItemIndex];
    //Font.Name := cob_Font.Text;
    //Font.Size := edt_Fontsize.Value;
    FirstIndent := 0; // Ist wahrscheinlich der Grundabstand, LeftIndent wird dann wohl zum FirstIdent draufgerechnet.
    //LeftIndent  := 24;
    LeftIndent  := 15; // Abstand zwischen Zahl und Eingabe
    FormatString := '%0:s.';
  end;
  // 2. Searching for such style in the selected paragraphs, the paragraph before,
  // and the paragraph after. If found, using it.
  rve := FRv.TopLevelEditor;
  rve.GetSelectionBounds(StartNo, a, EndNo, b, True);
  if StartNo<0 then begin
    StartNo := rve.CurItemNo;
    EndNo   := StartNo;
  end;
  // ExpandToPara is an undocumented method that changes item range StartNo..EndNo
  // so that it completely includes paragraphs containing StartNo..EndNo
  rve.RVData.ExpandToPara(StartNo, EndNo, StartNo, EndNo);
  if StartNo>0 then
    dec(StartNo);
  if EndNo<rve.ItemCount-1 then
    inc(EndNo);
  rve.RVData.ExpandToPara(StartNo, EndNo, StartNo, EndNo);
  for i := StartNo to EndNo do
    if rve.IsParaStart(i) and (rve.GetItemStyle(i)=rvsListMarker) then begin
      ListNo := GetListNo(rve, i);
      if FRv.Style.ListStyles[ListNo].IsSimpleEqual(ListStyle, True, True) then begin
        Result := ListNo;
        break;
      end;
  end;
  // 3. Idea for improving. You can try to reuse existing list style with the
  // given properties, which is not used in the document. If you want to do it,
  // you need to iterate through all items in the document, and check all markers.

  // 4. If not found, creating it
  if Result<0 then begin
    FRv.Style.ListStyles.Add.Assign(ListStyle);
    Result := FRv.Style.ListStyles.Count-1;
    FRv.Style.ListStyles[Result].Standard := False;
  end;
  ListStyle.Free;
end;

function TTbToolbar.GetListNo(rve: TCustomRichViewEdit;
  ItemNo: Integer): Integer;
var Level, StartFrom: Integer;
    Reset: Boolean;
begin
  if not Assigned(FRv) then
    exit;
  FRv.GetListMarkerInfo(ItemNo, Result, Level, StartFrom, Reset);
end;

procedure TTbToolbar.ToolbarButtonBulletChanged(Sender: TObject;
  aDown: Boolean);
var
  btn: TTbToolbutton;
begin
  btn := GetButtonFromTag(Ord(tbBullets));
  btn.Down := aDown;
end;

procedure TTbToolbar.ToolbarButtonNumberingChanged(Sender: TObject;
  aDown: Boolean);
var
  btn: TTbToolbutton;
begin
  btn := GetButtonFromTag(Ord(tbNumber));
  btn.Down := aDown;
end;





end.
