unit NFSRichViewtoolbar;

interface

uses
  SysUtils, Classes, Controls, ToolWin, ComCtrls, ImgList, Graphics, Contnrs,
  Buttons, Prop.NFSFontbox, NFSToolbartypes, NFSToolbarButton,
  NFSToolbarFontbox, Dialogs, NFSToolbarFontSize, Prop.NFSFontSize, NFSRichViewEdit, RvStyle, RvEdit, Forms,
  Windows, RVFuncs, PtblRV, RVScroll, RVTable, ExtCtrls, RichView,
  RVMisc, RVUni, RVItem, RVTypes, Prop.NFSButtons, Prop.NFSSpell, NFSRichViewHunspell,
  Prop.NFSButtonPos, Winapi.Messages, RvHunSpell, crvData, Objekt.NFSRvFont,
  Objekt.NFSColor;

type
  TNFSToolbarItems = set of TNFSToolbarItem;
  TChangeFontFavoritenEvent = procedure(Sender: TObject; aFontFavList: TStrings) of object;
  TStandardFontBevorEvent = procedure(Sender: TObject; var aAllowChange: Boolean) of object;
  THunspellSettingsErrorEvent = procedure(Sender: TObject; aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean) of object;

type
  TNFSRichViewtoolbar = class(TCustomPanel)
  private
    FButtons: TPropNFSButtons;
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
    FFontbox: TNFSToolbarFontbox;
    FPropFontbox: TPropNFSFontbox;
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
    FFontSizeBox: TNFSToolbarFontSize;
    FPropFontSize: TPropNFSFontSize;
    //fPropSpell: TPropNFSSpell;
    FOnFontSizeChanged: TNotifyEvent;
    FFontsize: Integer;
    FFilename: string;
    FRv: TNFSRichviewEdit;
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
    FOnSpellCheckClick: TNotifyEvent;
    //fHunSpell: TRVHunSpell;
    FPositions: TPropNFSButtonPos;
    //fFontStyle: TRvFontStyle;
    fRvHunspell: TNFSRvHunspell;
    fNFSRvFont: TNFSRvFontObj;
    fOnStandardFontBevorClick: TStandardFontBevorEvent;
    fNFSColor: TNFSColorObj;
    fHunspellSettingsError: THunspellSettingsErrorEvent;
    procedure LoadBitmapFromRes(aResType, aResName: string; aBitmap: Graphics.TBitmap);
    procedure AddButtons;
    function GetToolbarButtonItemsName(aToolbarItem: TNFSToolbarItem): string;
    function GetToolbarItemsName(aToolbarItem: TNFSToolbarItem): string;
    procedure ButtonChanged(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    function GetButtonFromTag(aTag: Integer): TNFSToolbarbutton;
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
    procedure SetRv(const Value: TNFSRichviewEdit);
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
    procedure UseSpell(Sender: TObject);
    procedure RVHunSpell1SpellFormAction(Sender: TRVHunSpell; const AWord, AReplaceTo: TRVUnicodeString; Action: TRVHunSpellFormAction);
    procedure SpellingCheck(Sender: TCustomRichView; const AWord: TRVUnicodeString; StyleNo: Integer; var Misspelled: Boolean);
    procedure PositionChange(Sender: TObject);
    procedure ReadOnlyChanged(Sender: TObject);
    procedure setFontname(Sender: TObject);
    procedure setNFSRvFontFontSize(Sender: TObject);
    procedure setNFSRvFontFontStyle(Sender: TObject);
    procedure setNFSRvFontAlignment(Sender: TObject);
    procedure setNFSRvFontColor(Sender: TObject);
    procedure BtnStandardMouseEnter(Sender: TObject);
    procedure HunspellSettingsError(Sender: TObject; aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean);
    //procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;

  protected
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
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
    procedure Durchnummerieren;
    procedure setButtonHint(aToolbarItem: TNFSToolbarItem; aHint: string);
    function ToolbarButton(aToolbarItem: TNFSToolbarItem): TNFSToolbarbutton;
    property NFSRvFont: TNFSRvFontObj read fNFSRvFont write fNFSRvFont;
//    function FontStyle: TRvFontStyle;

  published
    property Color;
    property BevelOuter;
    property BevelInner;
    property Align;
    property FontSizeBox: TPropNFSFontSize read FPropFontSize write FPropFontSize;
    property Fontbox: TPropNFSFontbox read FPropFontbox write FPropFontbox;
    property Buttons: TPropNFSButtons read FButtons write FButtons;
    //property Spell: TPropNFSSpell read FPropSpell write FPropSpell;
    property RichviewEdit: TNFSRichviewEdit read FRv write SetRv;
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
    property OnStandardFontBevorClick: TStandardFontBevorEvent read fOnStandardFontBevorClick write fOnStandardFontBevorClick;
    property OnFontFavoritenClick: TNotifyEvent read FOnFontFavoritenClick write FOnFontFavoritenClick;
    property OnIdentIncClick: TNotifyEvent read FOnIdentIncClick write FOnIdentIncClick;
    property OnIdentDecClick: TNotifyEvent read FOnIdentDecClick write FOnIdentDecClick;
    property OnLinespaceClick: TNotifyEvent read FOnLinespaceClick write FOnLinespaceClick;
    property OnPrintClick: TNotifyEvent read FOnPrintClick write FOnPrintClick;
    property OnClipboardClick: TNotifyEvent read FOnClipboardClick write FOnClipboardClick;
    property OnReverseClick: TNotifyEvent read FOnReverseClick write FOnReverseClick;
    property OnCutClick: TNotifyEvent read FOnCutClick write FOnCutClick;
    property OnPasteClick: TNotifyEvent read FOnPasteClick write FOnPasteClick;
    property OnSpellCheckClick: TNotifyEvent read FOnSpellCheckClick write FOnSpellCheckClick;
    property ButtonFrameColor: TColor read FButtonFrameColor write SetButtonFrameColor;
    property UseButtonFrame: Boolean read FUseButtonFrame write SetUseButtonFrame;
    property OnFontChanged: TNotifyEvent read FFontChanged write FFontChanged;
    property OnFontColorChanged: TNotifyEvent read FOnFontColorChanged write FOnFontColorChanged;
    property OnBackgroundColorChanged: TNotifyEvent read FOnBackgroundColorChanged write FOnBackgroundColorChanged;
    property OnParagraphBackgroundColorChanged: TNotifyEvent read FOnParagraphBackgroundColorChanged write FOnParagraphBackgroundColorChanged;
    property OnFontSizeChanged: TNotifyEvent read FOnFontSizeChanged write FOnFontSizeChanged;
    property OnFontFavoritenChanged: TChangeFontFavoritenEvent read FOnFontFavoritenChanged write FOnFontFavoritenChanged;
    property Positions: TPropNFSButtonPos read FPositions write FPositions;
    property Hunspell: TNFSRvHunspell read fRvHunspell write fRvHunspell;
    property OnHunspellSettingsError: THunspellSettingsErrorEvent read fHunspellSettingsError write fHunspellSettingsError;
    property Visible;
  end;


procedure Register;

implementation

//{$R Toolbar.res}

uses
  Prop.NFSButton, Form.FontFav, Form.RveLinespace, System.UITypes,
  RVGrHandler, rvrvdata, rvWordEnum;


procedure Register;
begin
  RegisterComponents('Optima', [TNFSRichViewtoolbar]);
end;

{ TNFSRichViewtoolbar }


constructor TNFSRichViewtoolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fNFSRvFont := TNFSRvFontObj.Create;
  fNFSRvFont.OnFontnameChanged := setFontname;
  fNFSRvFont.OnFontSizeChanged := setNFSRvFontFontSize;
  fNFSRvFont.OnFontStyleChanged := setNFSRvFontFontStyle;
  fNFSRvFont.OnFontAlignmentChanged := setNFSRvFontAlignment;
  fNFSRvFont.OnFontColorChanged := setNFSRvFontColor;
//  fFontStyle := TRvFontStyle.Create;
//  fRvHunspell := nil;
  //fHunSpell := nil;
  FCurTextStyleChangedIgnore := false;
  Height := 24;
  Width  := 870;
  FButtonList := TObjectList.Create;
  //Caption := 'Hurra eine Toolbar';
  FButtonFrameColor    := clSilver;
  FUseButtonFrame      := false;
  ButtonChanged(nil);

  FFontbox     := nil;
  FFontSizeBox := nil;


  FPropFontbox := TPropNFSFontbox.Create(Self);
  FPropFontbox.FontBox := FFontbox;
  FPropFontbox.OnChange := PropFontBoxChanged;
  FPropFontbox.Margins.Top := 1;
  FPropFontbox.Margins.Bottom := 0;
  FpropFontbox.Position := 9;

  FColorDialog   := TColorDialog.Create(Self);
  FOpenDialog    := TOpenDialog.Create(Self);
  FSaveDialog    := TSaveDialog.Create(Self);
  FPrinterDialog := TPrinterSetupDialog.Create(Self);
  FFindDialog    := TFindDialog.Create(Self);


  FPrint := TRvPrint.Create(Self);

  FFontColor := clBlack;


  FPropFontSize := TPropNFSFontSize.Create(Self);
  FPropFontSize.Position := 10;
  FPropFontSize.OnChange := PropFontSizeBoxChanged;

  FFilename := '';
  FFontFavList := TStringList.Create;
  FFontFavList.Sorted := true;
  FFontFavList.Duplicates := dupIgnore;
  FFontFavList.OnChange := ChangeFontFavoriten;

  {
  fPropSpell := TPropNFSSpell.Create(Self);
  fPropSpell.OnUseSpell := UseSpell;
  fPropSpell.OnChangedDict := ChangedSpellDictionary;
  }

  AddButtons;

  FButtons := TPropNFSButtons.Create(Self);

  BevelOuter := bvNone;
  ShowCaption := false;

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
  FPositions.OnChange := PositionChange;

  fNFSColor := TNFSColorObj.Create;



          {
  If (AOwner<>nil) And (csDesigning In ComponentState) And Not (csReading In AOwner.ComponentState) then
    Buttons.Positions.DurchnummerierungErlauben := true
  else
    Buttons.Positions.DurchnummerierungErlauben := false;
    }
end;


destructor TNFSRichViewtoolbar.Destroy;
begin
  FreeAndNil(FButtonList);
  FreeAndNil(FFontbox);

  FreeAndNil(FPropFontbox);
  FreeAndNil(FButtons);
  FreeAndNil(FColorDialog);
  FreeAndNil(FOpenDialog);
  FreeAndNil(FFontSizeBox);
  FreeAndNil(FPropFontSize);
  FreeAndNil(FSaveDialog);
  FreeAndNil(FPrinterDialog);
  FreeAndNil(FPrint);
  FreeAndNil(FFindDialog);
  FreeAndNil(FFontFavList);
  FreeAndNil(fNFSRvFont);
  FreeAndNil(fNFSColor);
  //FreeAndNil(fPropSpell);

  {
  if (fRvHunspell = nil) and (Assigned(fHunSpell)) then
      FreeAndNil(fHunSpell);
  }
  FreeAndNil(FPositions);
  //FreeAndNil(fFontStyle);

  inherited;
end;

procedure TNFSRichViewtoolbar.CreateWnd;
begin
  inherited;
  if fFontBox = nil then
  begin
    FFontbox    := TNFSToolbarFontbox.Create(Self);
    FFontbox.Align := alLeft;
    FFontbox.OnChange := FontChanged;
    FFontboxHeight:= FFontbox.Height;
    FFontboxWidth := FFontbox.Width;

    FPropFontbox.FontBox := FFontbox;
    FPropFontbox.OnChange := PropFontBoxChanged;

  end;

  if fFontSizeBox = nil then
  begin
    FFontSizeBox := TNFSToolbarFontSize.Create(Self);
    FFontSizeBox.Parent := Self;
    FFontSizeboxHeight:= FFontSizeBox.Height;
    FFontSizeboxWidth := FFontSizeBox.Width;
    FFontSizebox.OnChange := FontSizeChanged;
    FFontSizebox.Margins.Top := 0;
    FFontSizebox.Margins.Bottom := 0;
    FFontSizeBox.AlignWithMargins := true;
    FPropFontSize.FontSizeBox := FFontSizeBox;
  end;
  FFontSizebox.Parent := Self;
  FFontbox.Parent := Self;
  FButtons.ButtonsList := FButtonList;
  FButtons.OnChange    := ButtonChanged;
  ButtonChanged(nil);

  if Assigned(fRV) then
  begin
    CurTextStyleChanged(nil);
    CurParaStyleChanged(nil);
    UseSpell(nil);
  end;



end;


procedure TNFSRichViewtoolbar.Durchnummerieren;
begin
  //FButtons.Durchnummerieren;
end;

procedure TNFSRichViewtoolbar.FontChanged(Sender: TObject);
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
  if Assigned(FFontChanged) then
    FFontChanged(Sender);
end;


procedure TNFSRichViewtoolbar.FontSizeChanged(Sender: TObject);
var
  fs: Integer;
begin
  if TryStrToInt(FFontSizeBox.Text, fs) then
    SetFontSize(fs);
end;

function TNFSRichViewtoolbar.GetButtonFromTag(aTag: Integer): TNFSToolbarbutton;
var
  i1: Integer;
  btn: TNFSToolbarbutton;
begin
  Result := nil;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TNFSToolbarbutton(FButtonList.Items[i1]);
    if btn.Tag = aTag then
    begin
      Result := btn;
      exit;
    end;
  end;
end;

function TNFSRichViewtoolbar.GetFontname: string;
begin
  Result := '';
  if not Assigned(FFontbox) then
    exit;
  if FFontbox.ItemIndex = -1 then
    exit;
  Result := FFontbox.Items.Strings[FFontbox.ItemIndex];
end;

function TNFSRichViewtoolbar.GetToolbarButtonItemsName(
  aToolbarItem: TNFSToolbarItem): string;
begin
  Result := 'btn_' + GetToolbarItemsName(aToolbarItem);
end;

function TNFSRichViewtoolbar.GetToolbarItemsName(
  aToolbarItem: TNFSToolbarItem): string;
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
  if aToolbarItem = tbSpellCheck then
    Result := 'SpellCheck';
end;


procedure TNFSRichViewtoolbar.AddButtons;
  procedure AddButton(aToolbarItem: TNFSToolbarItem; var aPos: Integer);
  var
    btn: TNFSToolbarbutton;
    Bitmap: Graphics.TBitmap;
  begin
    btn := TNFSToolbarbutton.Create(Self);
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

    if aToolbarItem = tbStandardFont then
     btn.OnMouseEnter := BtnStandardMouseEnter;

    if (aToolbarItem = tbBold)
    or (aToolbarItem = tbItalic)
    or (aToolbarItem = tbUnderline)
    or (aToolbarItem = tbTextHoch)
    or (aToolbarItem = tbTextTief) then
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
  ToolbarItem: TNFSToolbarItem;
begin
  iPos := 0;

  for ToolbarItem := tbBold to tbSpellCheck do
  begin
    AddButton(ToolbarItem, iPos);
  end;

end;


procedure TNFSRichViewtoolbar.LoadBitmapFromRes(aResType, aResName: string;
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


procedure TNFSRichViewtoolbar.Loaded;
begin
  inherited;
   // if csLoading in ComponentState then
   // exit;

  fPositions.DurchnummerierungErlauben := false;
  Buttons.LadeButtonSortList(FPositions);
  ButtonChanged(nil);

end;





procedure TNFSRichViewtoolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRv) then
    frv := nil;

  if (Operation = opRemove) and (AComponent = FRvHunspell) then
    fRvHunspell := nil;

  if (Operation = opInsert) and (AComponent = FRvHunspell) then
  begin
    fRvHunspell.OnUseSpell := UseSpell;
    fRvHunspell.OnHunspellSettingsError := HunspellSettingsError;
  end;


  {
   if csReading in ComponentState then
     Positions.DurchnummerierungErlauben := false;
   }
end;



procedure TNFSRichViewtoolbar.ReadOnlyChanged(Sender: TObject);
begin
  if (frvHunSpell <> nil) and (frvHunSpell.Spell.UseSpell) then
    UseSpell(nil);
end;

procedure TNFSRichViewtoolbar.RefreshAllButtons;
var
  i1: Integer;
  btn: TNFSToolbarbutton;
  AllSameMargin: Boolean;
  FirstMargin: Integer;
begin
  if not Assigned(FButtonList) then
    exit;

  if FButtonList.Count = 0 then
    exit;

  AllSameMargin := true;
  FirstMargin   := TNFSToolbarbutton(FButtonList.Items[0]).Margins.Right;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    if FirstMargin <> TNFSToolbarbutton(FButtonList.Items[i1]).Margins.Right then
    begin
      AllSameMargin := false;
      break;
    end;
  end;

  Invalidate;
  Refresh;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TNFSToolbarbutton(FButtonList.Items[i1]);
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


procedure TNFSRichViewtoolbar.RvBeforeClear(Sender: TObject);
begin
  FCurTextStyleChangedIgnore := true;
end;

procedure TNFSRichViewtoolbar.RvClear(Sender: TObject);
var
  f: TFont;
  btn: TNFSToolbarbutton;
begin
  FCurTextStyleChangedIgnore := false;
  f := TFont.Create;
  try
    f.Name := 'Arial';

    if not Assigned(fFontBox) then
      exit;

    if FFontbox.ItemIndex > -1 then
      f.Name := FFontbox.Items[fFontbox.ItemIndex];
    {
    if fFontbox.FontBox.ItemIndex > -1 then
      f.Name := fFontbox.FontBox.Items[Fontbox.FontBox.ItemIndex];
    }
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

    if Assigned(FRv) then
      FRv.CurTextStyleNo := FRv.GetStyleNo(f);
  finally
    FreeAndNil(f);
  end;
end;

procedure TNFSRichViewtoolbar.SetBackgroundColor(const Value: TColor);
begin
  if FBackgroundcolor = Value then
    exit;
  FBackgroundcolor := Value;
  if Assigned(FOnBackgroundColorChanged) then
  begin
    FOnBackgroundColorChanged(Self);
    exit;
  end;
  if Assigned(FRv) then
    FRv.ApplyStyleConversion(TEXT_BACKCOLOR);
end;

procedure TNFSRichViewtoolbar.SetButtonFrameColor(const Value: TColor);
begin
  if not Assigned(FButtonList) then
    exit;
  if FButtonFrameColor = Value then
    exit;
  FButtonFrameColor := Value;
  RefreshAllButtons;
end;

procedure TNFSRichViewtoolbar.setButtonHint(aToolbarItem: TNFSToolbarItem;
  aHint: string);
var
  btn: TNFSToolbarbutton;
begin
  btn := GetButtonFromTag(Ord(aToolbarItem));
  if btn = nil then
    exit;
  btn.Hint := aHint;
  btn.ShowHint := true;
end;

procedure TNFSRichViewtoolbar.SetFontColor(const Value: TColor);
begin
  if Value = FFontColor then
    exit;
  FFontColor := Value;
  if Assigned(FOnFontColorChanged) then
  begin
    FOnFontColorChanged(Self);
    exit;
  end;
  if Assigned(FRv) then
    FRv.ApplyStyleConversion(TEXT_COLOR);
end;


procedure TNFSRichViewtoolbar.setFontname(Sender: TObject);
var
  i1: Integer;
begin
  for i1 := 0 to Fontbox.FontBox.Items.Count -1 do
  begin
    if sametext(Fontbox.FontBox.Items[i1], fNFSRvFont.Fontname) then
    begin
      Fontbox.FontBox.ItemIndex := i1;
      FontChanged(Self);
      exit;
    end;
  end;
end;

procedure TNFSRichViewtoolbar.SetFontSize(const Value: Integer);
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

procedure TNFSRichViewtoolbar.setNFSRvFontAlignment(Sender: TObject);
var
  btn: TNFSToolbarbutton;
begin
  btn := nil;
  case fNFSRvFont.Alignment of
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
  if Btn <> nil then
    ButtonClick(Btn);
end;

procedure TNFSRichViewtoolbar.setNFSRvFontColor(Sender: TObject);
begin
  SetFontColor(fNFSRvFont.Fontcolor);
end;

procedure TNFSRichViewtoolbar.setNFSRvFontFontSize(Sender: TObject);
begin
  setFontSize(fNFSRvFont.Fontsize);
end;

procedure TNFSRichViewtoolbar.setNFSRvFontFontStyle(Sender: TObject);
var
  btn: TNFSToolbarbutton;
begin
  btn := GetButtonFromTag(Ord(tbBold));
  if fsBold in fNFSRvFont.Style then
    btn.Down := true
  else
    btn.Down := false;
  ButtonClick(Btn);

  btn := GetButtonFromTag(Ord(tbItalic));
  if fsItalic in fNFSRvFont.Style then
    btn.Down := true
  else
    btn.Down := false;
  ButtonClick(Btn);

  btn := GetButtonFromTag(Ord(tbUnderline));
  if fsUnderline in fNFSRvFont.Style then
    btn.Down := true
  else
    btn.Down := false;
  ButtonClick(Btn);

end;

procedure TNFSRichViewtoolbar.SetParagraphBackgroundColor(const Value: TColor);
begin
  if FParagraphbackgroundcolor = Value then
    exit;
  FParagraphbackgroundcolor := Value;
  if Assigned(FOnParagraphBackgroundColorChanged) then
  begin
    FOnParagraphBackgroundColorChanged(Self);
    exit;
  end;
  if Assigned(FRv) then
    FRv.ApplyParaStyleConversion(PARA_COLOR);
end;

procedure TNFSRichViewtoolbar.SetRv(const Value: TNFSRichviewEdit);
begin
  FRv := Value;
  if fRV = nil then
    exit;
  FRv.OnCurParaStyleChanged := CurParaStyleChanged;
  FRv.OnCurTextStyleChanged := CurTextStyleChanged;
  FRv.OnParaStyleConversion := ParaStyleConversion;
  FRv.OnStyleConversion     := StyleConversion;
  FRv.OnClear               := RvClear;
  FRv.OnBeforeClear         := RvBeforeClear;
  FRv.OnChangedBullet       := ToolbarButtonBulletChanged;
  FRv.OnChangedNumbering    := ToolbarButtonNumberingChanged;
  FRv.OnReadOnlyChanged     := ReadOnlyChanged;
  if Assigned(fRV) then
  begin
    CurTextStyleChanged(nil);
    CurParaStyleChanged(nil);
    UseSpell(nil);
  end;
end;

procedure TNFSRichViewtoolbar.SetUseButtonFrame(const Value: Boolean);
begin
  if FUseButtonFrame = Value then
    exit;
  FUseButtonFrame := Value;
  RefreshAllButtons;
end;

procedure TNFSRichViewtoolbar.BtnStandardMouseEnter(Sender: TObject);
var
  s: string;
  Ausrichtung: string;
  Style: string;
begin
  s := '';
  if Assigned(fRV) then
  begin
    if fRV.StandardFont.Alignment = rvaLeft then
      Ausrichtung := 'Links';
    if fRV.StandardFont.Alignment = rvaRight then
      Ausrichtung := 'Rechts';
    if fRV.StandardFont.Alignment = rvaCenter then
      Ausrichtung := 'Zentriert';
    if fRV.StandardFont.Alignment = rvaJustify then
      Ausrichtung := 'Blocksatz';

    Style := '';
    if fsBold in FRv.StandardFont.Style then
      Style := 'Fett';

    if (fsItalic in FRv.StandardFont.Style) then
    begin
      if Style = '' then
        Style := 'Kursiv'
      else
        Style := Style + ', Kursiv'
    end;

    if (fsUnderline in FRv.StandardFont.Style) then
    begin
      if Style = '' then
        Style := 'Unterstrichen'
      else
        Style := Style + ', Unterstrichen';
    end;

    if Style > '' then
      Style := '(' + Style + ')';

    s := 'Standardfont: ' + sLineBreak +
         'Schriftname = ' + FRv.StandardFont.Fontname + sLineBreak +
         'Schriftgröße = ' + IntToStr(FRv.StandardFont.Fontsize) + sLineBreak +
         'Ausrichtung = ' + Ausrichtung + sLineBreak  +
         'Farbe = ' + fNFSColor.ColorToStr(fRV.StandardFont.Fontcolor) + sLineBreak +
         'Style = ' + Style;
  end;

  setButtonHint(tbStandardFont, s);
  // Hint lesen;
end;

procedure TNFSRichViewtoolbar.ButtonChanged(Sender: TObject);
var
  i1: Integer;
  btn: TNFSToolbarbutton;
  iLeft: Integer;
  ButtonProp: TPropNFSButton;
  ToolbarItem: TNFSToolbarItem;
begin
  if not Assigned(FButtons) then
    exit;

  if Assigned(FPropFontbox)  then
    FPropFontbox.Position := Positions.Fontbox;
  if Assigned(FPropFontSize)  then
    FPropFontSize.Position := Positions.Fontsize;

  if Assigned(FFontbox) then
    FFontbox.Align := alNone;

  if Assigned(FFontSizeBox) then
    FFontSizeBox.Align := alNone;

  for i1 := 0 to FButtonList.Count - 1 do
  begin
    btn := TNFSToolbarbutton(FButtonList.Items[i1]);
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
    {
    btn.Visible := false;
    btn.Align  := alNone;
    btn.Width  := 0;
    btn.Height := 0;
    }
  end;
  if FPositions.Fontbox = 0 then
    exit;
  iLeft := 0;
  for i1 := 0 to FButtons.SortList.Count - 1 do
  begin
    if Assigned(FFontbox) then
    begin
      if i1 = FPropFontbox.Position -1 then
      begin
        FFontbox.Left := iLeft;
        iLeft := iLeft + FFontbox.Width + FFontbox.Margins.Left + FFontbox.Margins.Right;
        FFontbox.Align := alLeft;
        continue;
      end;
    end;
    if Assigned(FFontSizeBox) then
    begin
      if i1 = FPropFontSize.Position -1 then
      begin
        FFontSizeBox.Left := iLeft;
        iLeft := iLeft + FFontSizeBox.Width + FFontSizeBox.Margins.Left + FFontSizeBox.Margins.Right;
        FFontSizeBox.Align := alLeft;
        continue;
      end;
    end;
    btn := GetButtonFromTag(StrToInt(FButtons.SortList.ValueFromIndex[i1]));
    if not Assigned(btn) then
      continue;
    ToolbarItem := TNFSToolbarItem(StrToInt(FButtons.SortList.ValueFromIndex[i1]));
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


procedure TNFSRichViewtoolbar.ButtonClick(Sender: TObject);
var
  gr: TGraphic;
  ErrorMsg: string;
  Cur: TCursor;
  btn: TNFSToolbarbutton;
  AllowChange: Boolean;
begin
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbBold then
  begin
    if Assigned(FOnBoldClick) then
    begin
      FOnBoldClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_BOLD);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbItalic then
  begin
    if Assigned(FOnItalicClick) then
    begin
      FOnItalicClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_ITALIC);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbUnderline then
  begin
    if Assigned(FOnUnderlineClick) then
    begin
      FOnUnderlineClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      Frv.ApplyStyleConversion(TEXT_UNDERLINE);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbLeft then
  begin
    if Assigned(FOnLeftClick) then
    begin
      FOnLeftClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbCenter then
  begin
    if Assigned(FOnCenterClick) then
    begin
      FOnCenterClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbRight then
  begin
    if Assigned(FOnRightClick) then
    begin
      FOnRightClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbJustify then
  begin
    if Assigned(FOnJustifyClick) then
    begin
      FOnJustifyClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_ALIGNMENT);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbFontcolor then
  begin
    if Assigned(FOnFontcolorclick) then
    begin
      FOnFontcolorclick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FFontColor := FRv.Style.TextStyles[FRv.CurTextStyleNo].Color;
    FColorDialog.Color := FFontColor;
    if FColorDialog.Execute then
    begin
      SetFontColor(FColorDialog.Color);
      exit;
    end;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbBackgroundcolor then
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
          if Assigned(FRv) then
            FRv.ApplyStyleConversion(TEXT_BACKCOLOR);
          exit;
        end;
      IDNO:
        begin
          if Assigned(FRv) then
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

  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbParagraphBackground then
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
          if Assigned(FRv) then
            FRv.ApplyParaStyleConversion(PARA_COLOR);
          exit;
        end;
      IDNO:
        begin
         if Assigned(FRv) then
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

  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbBullets then
  begin
    if Assigned(FOnBulletsClick) then
    begin
      FOnBulletsClick(Sender);
      exit;
    end;
    if not Assigned(FRv) then
      exit;
    if not TNFSToolbarbutton(Sender).Down then
      FRv.RemoveLists(false)
    else
      FRv.ApplyListStyle(createBullets, 0,0, false, false);
    end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbNumber then
  begin
    if Assigned(FOnNumberClick) then
    begin
      FOnNumberClick(Sender);
      exit;
    end;
    if not Assigned(FRv) then
      exit;
    if not TNFSToolbarbutton(Sender).Down then
      FRv.RemoveLists(False)
    else
      FRv.ApplyListStyle(CreateNumbering,0,0,False,False);
  end;

  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbSave then
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
    if (FFileName > '') and (Assigned(FRv)) then
    begin
      FRv.SaveRTF(FFileName, False);
      FRv.Modified := False;
    end;
  end;

  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbOpen then
  begin
    if Assigned(FOnOpenClick) then
    begin
      FOnOpenClick(Sender);
      exit;
    end;
    FOpenDialog.Title  := '';
    FOpenDialog.Filter := '';
    if FOpenDialog.Execute then
    begin
      Cur := Screen.Cursor;
      try
        FFileName := FOpenDialog.FileName;
        if Assigned(FRv) then
        begin
          Screen.Cursor := crHourglass;
          ErrorMsg := RichviewEdit.LoadTextFromFile(FFileName);
          if ErrorMsg > '' then
            Application.MessageBox(PChar(ErrorMsg), 'Error', MB_OK or MB_ICONSTOP);
        end;
      finally
        Screen.Cursor := Cur;
      end;
    end;
  end;


  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbPicture then
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

      if Assigned(fRV) then
      begin
        gr := RVGraphicHandler.LoadFromFile(FOpenDialog.FileName);
        if gr <> nil  then
          FRv.InsertPicture('', gr, rvvaBaseline)
        else
          Application.MessageBox(PChar('Das Bild kann nicht eingelesen werden. '+ FOpenDialog.FileName), 'Error',
             MB_OK or MB_ICONSTOP);
      end;
    end;

  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbLargeEditor then
  begin
    if Assigned(FOnLargeEditorClick) then
      FOnLargeEditorClick(fRV);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbTextHoch then
  begin
    if Assigned(FOnTextHochClick) then
    begin
      FOnTextHochClick(Sender);
      exit;
    end;
    if Assigned(fRV) then
      fRv.ApplyStyleConversion(TEXT_HOCH);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbTextTief then
  begin
    if Assigned(FOnTextTiefClick) then
    begin
      FOnTextTiefClick(Sender);
      exit;
    end;
    if Assigned(fRV) then
      fRv.ApplyStyleConversion(TEXT_TIEF);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbStandardFont then
  begin
    AllowChange := true;
    if Assigned(fOnStandardFontBevorClick) then
      fOnStandardFontBevorClick(Self, AllowChange);

    if Assigned(fRV) and (AllowChange) then
    begin
      if Fontbox.FontBox.ItemIndex >= 0 then
        fRV.StandardFont.Fontname := Fontbox.FontBox.Items[Fontbox.FontBox.ItemIndex];
      fRV.StandardFont.Fontsize := FFontsize;
      fRV.StandardFont.Fontcolor := FFontColor;

      btn := GetButtonFromTag(Ord(tbBold));
      if btn.Down then
        fRV.StandardFont.Style := fRV.StandardFont.Style + [fsBold]
      else
        fRV.StandardFont.Style := fRV.StandardFont.Style - [fsBold];

      btn := GetButtonFromTag(Ord(tbItalic));
      if btn.Down then
        fRV.StandardFont.Style := fRV.StandardFont.Style + [fsItalic]
      else
        fRV.StandardFont.Style := fRV.StandardFont.Style - [fsItalic];

      btn := GetButtonFromTag(Ord(tbUnderline));
      if btn.Down then
        fRV.StandardFont.Style := fRV.StandardFont.Style + [fsUnderline]
      else
        fRV.StandardFont.Style := fRV.StandardFont.Style - [fsUnderline];

      btn := GetButtonFromTag(Ord(tbLeft));
      if btn.Down then
        fRV.StandardFont.Alignment := rvaLeft;

      btn := GetButtonFromTag(Ord(tbRight));
      if btn.Down then
        fRV.StandardFont.Alignment := rvaRight;

      btn := GetButtonFromTag(Ord(tbCenter));
      if btn.Down then
        fRV.StandardFont.Alignment := rvaCenter;

      btn := GetButtonFromTag(Ord(tbJustify));
      if btn.Down then
        fRV.StandardFont.Alignment := rvaJustify;

    end;
    if Assigned(FOnStandardFontClick) then
      FOnStandardFontClick(Sender);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbFontFavoriten then
  begin
    if Assigned(FOnFontFavoritenClick) then
    begin
      FOnFontFavoritenClick(Sender);
      exit;
    end;
    ShowFontFavoriten;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbIndentInc then
  begin
    if Assigned(FOnIdentIncClick) then
    begin
      FOnIdentIncClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_INDENTINC);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbIndentDec then
  begin
    if Assigned(FOnIdentDecClick) then
    begin
      FOnIdentDecClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.ApplyParaStyleConversion(PARA_INDENTDEC);
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbLineSpace then
  begin
    if Assigned(FOnLinespaceClick) then
      FOnLinespaceClick(Sender)
    else
    begin
      ShowLineSpace;
    end;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbPrint then
  begin
    if Assigned(FOnPrintClick) then
    begin
      FOnPrintClick(Sender);
      exit;
    end;
    if Assigned(fRV) and (FPrinterDialog.Execute) then
    begin
      FPrint.AssignSource(FRv);
      FPrint.FormatPages(rvdoALL);
      if FPrint.PagesCount>0 then
        FPrint.Print('',1,False);
    end;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbClipboard then
  begin
    if Assigned(FOnClipboardClick) then
    begin
      FOnClipboardClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.Copy;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbReverse then
  begin
    if Assigned(FOnReverseClick) then
    begin
      FOnReverseClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.Undo;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbCut then
  begin
    if Assigned(FOnCutClick) then
    begin
      FOnCutClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
    begin
      FRv.Copy;
      FRv.DeleteSelection;
    end;
  end;
  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbPaste then
  begin
    if Assigned(FOnPasteClick) then
    begin
      FOnPasteClick(Sender);
      exit;
    end;
    if Assigned(FRv) then
      FRv.Paste;
  end;

  if TNFSToolbarItem(TNFSToolbarbutton(Sender).Tag) = tbSpellCheck then
  begin
    if Assigned(FOnSpellCheckClick) then
    begin
      FOnSpellCheckClick(Sender);
      exit;
    end;
    if Assigned(fRV) then
    begin
      if (fRvHunspell <> nil) and (fRvHunspell.Spell.UseSpell) then
        fRvHunspell.Check(fRV, rvesFromStart);
      {
      if (fHunSpell <> nil) and (fPropSpell.UseSpell) then
        fHunSpell.Check(fRV, rvesFromStart);
        }
    end;
  end;

end;

procedure TNFSRichViewtoolbar.PropFontBoxChanged(Sender: TObject);
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

procedure TNFSRichViewtoolbar.PropFontSizeBoxChanged(Sender: TObject);
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
procedure TNFSRichViewtoolbar.CurTextStyleChanged(Sender: TObject);
var
  fi: TFontInfo;
  btn: TNFSToolbarbutton;
begin
  if not Assigned(fRV) then
    exit;
  if FCurTextStyleChangedIgnore then
    exit;

  if not Assigned(fFontBox) then
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

  btn := GetButtonFromTag(Ord(tbTextHoch));
  btn.Down := fi.SubSuperScriptType = rvsssSuperScript;

  btn := GetButtonFromTag(Ord(tbTextTief));
  btn.Down := fi.SubSuperScriptType = rvsssSubscript;

end;

procedure TNFSRichViewtoolbar.CurParaStyleChanged(Sender: TObject);
begin
  if Assigned(FRv) then
    SetAlignmentToUI(FRv.Style.ParaStyles[FRv.CurParaStyleNo].Alignment);
end;

procedure TNFSRichViewtoolbar.SetAlignmentToUI(Alignment: TRVAlignment);
var
  btn: TNFSToolbarbutton;
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

procedure TNFSRichViewtoolbar.Paint;
begin
  inherited;

end;

procedure TNFSRichViewtoolbar.ParaStyleConversion(Sender: TCustomRichViewEdit;
  StyleNo, UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
var
  ParaInfo: TParaInfo;
begin
  if not Assigned(fRV) then
    exit;
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

procedure TNFSRichViewtoolbar.PositionChange(Sender: TObject);
begin
  FButtons.LadeButtonSortList(FPositions);
  ButtonChanged(nil);
end;

function TNFSRichViewtoolbar.GetAlignmentFromUI: TRVAlignment;
var
  btn: TNFSToolbarbutton;
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

procedure TNFSRichViewtoolbar.StyleConversion(Sender: TCustomRichViewEdit;
  StyleNo, UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
var
  FontInfo: TFontInfo;
  btn     : TNFSToolbarbutton;
begin
  if not Assigned(fRV) then
    exit;
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
      TEXT_HOCH:
        if FontInfo.SubSuperScriptType = rvsssSuperScript then
          FontInfo.SubSuperScriptType := rvsssNormal
        else
          FontInfo.SubSuperScriptType := rvsssSuperScript;
      TEXT_TIEF:
        if FontInfo.SubSuperScriptType = rvsssSubscript then
          FontInfo.SubSuperScriptType := rvsssNormal
        else
          FontInfo.SubSuperScriptType := rvsssSubscript;
      // add your code here....
    end;
    NewStyleNo := FRv.Style.FindTextStyle(FontInfo);
  finally
    FontInfo.Free;
  end;
end;

procedure TNFSRichViewtoolbar.SetRichViewEditFocus;
begin
  if not Assigned(fRV) then
    exit;
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

procedure TNFSRichViewtoolbar.ShowFontFavoriten;
var
  Form: Tfrm_FontFavoriten;
begin
  Form := Tfrm_FontFavoriten.Create(nil);
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

procedure TNFSRichViewtoolbar.ShowLineSpace;
var
  Form: Tfrm_RveLinespace;
  ParaInfo: TParaInfo;
begin
  if not Assigned(fRV) then
    exit;
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


procedure TNFSRichViewtoolbar.ChangeFontFavoriten(Sender: TObject);
begin
  if not Assigned(FPropFontbox) then
    exit;
  FPropFontbox.SetFontFavoriten(FFontFavList);
  if Assigned(FOnFontFavoritenChanged) then
    FOnFontFavoritenChanged(Self, FFontFavList);
end;

{
procedure TNFSRichViewtoolbar.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
//  RefreshAllButtons;
end;
}

function TNFSRichViewtoolbar.CreateBullets: Integer;
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

  end;
  // 2. Searching for existing style with these properties. Creating it, if not found
  Result := FRv.Style.ListStyles.FindSuchStyle(ListStyle, True);
  ListStyle.Free;

end;

function TNFSRichViewtoolbar.CreateNumbering: Integer;
var
  ListStyle: TRVListInfo;
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


function TNFSRichViewtoolbar.GetListNo(rve: TCustomRichViewEdit;
  ItemNo: Integer): Integer;
var
  Level, StartFrom: Integer;
  Reset: Boolean;
begin
  if not Assigned(FRv) then
    exit;
  FRv.GetListMarkerInfo(ItemNo, Result, Level, StartFrom, Reset);
end;

function TNFSRichViewtoolbar.ToolbarButton(
  aToolbarItem: TNFSToolbarItem): TNFSToolbarbutton;
begin
  Result := GetButtonFromTag(Ord(aToolbarItem));
end;

procedure TNFSRichViewtoolbar.ToolbarButtonBulletChanged(Sender: TObject;
  aDown: Boolean);
var
  btn: TNFSToolbarbutton;
begin
  btn := GetButtonFromTag(Ord(tbBullets));
  btn.Down := aDown;
end;

procedure TNFSRichViewtoolbar.ToolbarButtonNumberingChanged(Sender: TObject;
  aDown: Boolean);
var
  btn: TNFSToolbarbutton;
begin
  btn := GetButtonFromTag(Ord(tbNumber));
  btn.Down := aDown;
end;




procedure TNFSRichViewtoolbar.UseSpell(Sender: TObject);
var
  CanSpell: Boolean;
begin
  if not Assigned(fRvHunspell) then
    exit;
  CanSpell := false;
  if (Assigned(fRV)) and (fRvHunspell.Spell.UseSpell) then
  begin
    if not fRvHunspell.Spell.UseSpellOnlyWriteCapability then
      CanSpell := true;
    if (fRvHunspell.Spell.UseSpellOnlyWriteCapability) and (not fRv.ReadOnly) and (fRv.Enabled) then
      CanSpell := true;
  end;
  if not fRvHunspell.Spell.UseSpell then
  begin
    if Assigned(fRV) then
    begin
      fRV.ClearLiveSpellingResults;
    end;
    exit;
  end;

  if CanSpell then
  begin
    fRvHunSpell.OnSpellFormAction := RVHunSpell1SpellFormAction;
    fRv.OnSpellingCheck := SpellingCheck;
    FRv.StartLiveSpelling;
  end
  else
  begin
    if Assigned(fRV) then
    begin
      fRV.ClearLiveSpellingResults;
    end;
  end;
end;

procedure TNFSRichViewtoolbar.HunspellSettingsError(Sender: TObject;
  aErrorText: string; aErrorCode: Integer; var aUseSpell: Boolean);
begin
  if Assigned(fHunspellSettingsError) then
    fHunspellSettingsError(Self, aErrorText, aErrorCode, aUseSpell)
  else
    ShowMessage(aErrorText);
end;



{
procedure TNFSRichViewtoolbar.UseSpell(Sender: TObject);
var
  CanSpell: Boolean;
begin //
  CanSpell := false;
  if (Assigned(fRV)) and (fPropSpell.UseSpell) then
  begin
    if not fPropSpell.UseSpellOnlyWriteCapability then
      CanSpell := true;
    if (fPropSpell.UseSpellOnlyWriteCapability) and (not fRv.ReadOnly) and (fRv.Enabled) then
      CanSpell := true;
  end;
  if not fPropSpell.UseSpell then
  begin
    if Assigned(fRV) then
    begin
      fRV.ClearLiveSpellingResults;
    end;
    exit;
  end;

  if (fRvHunSpell <> nil) and (fHunSpell = nil) then
    fHunSpell := fRvHunSpell;

  if fHunSpell = nil then
  begin
    fHunSpell := TRVHunSpell.Create(Self);
    fHunSpell.SpellFormStyle := fPropSpell.FormStyle;
    fHunSpell.DllDir := fPropSpell.DLLDir;
    fHunSpell.DllName := fPropSpell.DLLName;
    fHunSpell.DictDir := fPropSpell.DictDir;
    if fPropSpell.DictCustomerDir > '' then
      fHunSpell.CustomDictionaryFileName := IncludeTrailingPathDelimiter(fPropSpell.DictCustomerDir) + fPropSpell.DictCustomerName
    else
      fHunSpell.CustomDictionaryFileName := '';
    fHunSpell.Dictionaries.Clear;
    fHunSpell.LoadAllDictionaries;
    fHunSpell.LoadCustomDic;
  end;
  if CanSpell then
  begin
    fHunSpell.OnSpellFormAction := RVHunSpell1SpellFormAction;
    fRv.OnSpellingCheck := SpellingCheck;
    FRv.StartLiveSpelling;
  end
  else
  begin
    if Assigned(fRV) then
    begin
      fRV.ClearLiveSpellingResults;
    end;
  end;

end;
}

procedure TNFSRichViewtoolbar.RVHunSpell1SpellFormAction(Sender: TRVHunSpell; const AWord,
  AReplaceTo: TRVUnicodeString; Action: TRVHunSpellFormAction);
begin
  if not Assigned(fRV) then
    exit;
  if Action in [rvhsIgnoreAll, rvhsAdd] then
    fRv.LiveSpellingValidateWord(AWord);
end;

procedure TNFSRichViewtoolbar.SpellingCheck(Sender: TCustomRichView;
  const AWord: TRVUnicodeString; StyleNo: Integer; var Misspelled: Boolean);
begin
  Misspelled := not fRvHunSpell.Spells(AWord);
end;

end.
