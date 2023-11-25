unit NFSRichViewEdit;

interface

uses
  SysUtils, Classes, Controls, RVScroll, RichView, RVEdit, RVStyle, RVReport, Graphics,
  RvGetText, CRVData, RVRVData, Objekt.NFSRvFontStyle, Vcl.Forms, Vcl.Dialogs,
  PtbLRV, Objekt.NFSCellsOperation, Objekt.NFSRvFont;

const
  TEXT_BOLD       = 1;
  TEXT_ITALIC     = 2;
  TEXT_UNDERLINE  = 3;
  TEXT_APPLYFONTNAME  = 4;
  TEXT_APPLYFONT      = 5;
  TEXT_APPLYFONTSIZE  = 6;
  TEXT_COLOR      = 7;
  TEXT_BACKCOLOR  = 8;
  TEXT_HOCH = 9;
  TEXT_TIEF = 10;
// Parameters for ApplyParaStyleConversion
  PARA_ALIGNMENT  = 1;
  PARA_INDENTINC  = 2;
  PARA_INDENTDEC  = 3;
  PARA_COLOR      = 4;
  PARA_LINESPACE  = 5;
  DEF_INDENT = 24;

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
  TNFSToolbarButtonChangedEvent = procedure(Sender: TObject; aDown: Boolean) of object;

type
  TNFSFontStyle = Record
    Bold: Boolean;
    Italic: Boolean;
    Underline: Boolean;
  End;


type
  TNFSRichViewEdit = class(TRichViewEdit)
  private
    fFontname: string;
    fFontsize: Integer;
    fFont    : TFont;
    fFontColor: TColor;
    fBackgroundcolor: TColor;
    fRvStyle: TRvStyle;
    fOnClear: TNotifyEvent;
    fOnBeforeClear: TNotifyEvent;
    fOnChangedBullet: TNFSToolbarButtonChangedEvent;
    fOnChangedNumbering: TNFSToolbarButtonChangedEvent;
    fNFSRvFontStyle: TNFSRvFontStyle;
    fOpenDialog: TOpenDialog;
    fSaveDialog: TSaveDialog;
    fFullFileName: string;
    fHTMLTitle: String;
    fHTMLSaveOptions: TRVSaveOptions;
    fRVPrint: TRVPrint;
    fpsd: TPrinterSetupDialog;
    fFindDialog: TFindDialog;
    fRd: TReplaceDialog;
    fCellsOperation: TNFSCellsOperation;
    fOnReadOnlyChanged: TNotifyEvent;
    fStandardFont: TNFSRvFontObj;
    fOnBeforUseStandardFont: TNotifyEvent;
    function GetRTFString: string;
    procedure SetRTFString(const Value: string);
    procedure CaretMove(Sender: TObject);
    function GetListNo(rve: TCustomRichViewEdit; ItemNo: Integer): Integer;
    procedure StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
              UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
    function AddOrGetFontStyleNo(aFontInfo: TFontInfo): Integer;
    procedure DisplayUnicodeWarning;
    function GetRVFErrors: String;
    function GetFocusedControl: TWinControl;
    procedure FindDialogFind(Sender: TObject);
    procedure ReplaceDialog(Sender: TObject);
    function IsEqualText(s1, s2: String; CaseSensitive: Boolean): Boolean;
    procedure ShowInfo(const msg,cpt: String);
  protected
    procedure SetReadOnly(const Value: Boolean); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AsRTFString: string read GetRTFString write SetRTFString;
    procedure ClearIt;
    procedure ClearAndFormated;
    function GetStyleNo(aFont: TFont): Integer;
    function AddNewJumpFont(aFont: TFont): Integer;
    function MergeRTF(aRTFString1, aRTFString2: string): string; overload;
    function MergeRTF(aRTFString1, aRTFString2: string; const aMitUmbruch: Boolean = true; const aCanvas: TCanvas = nil; aPageWidth: Integer = 800): string; overload;
    function isRTFText(aValue: string): Boolean;
    function RTFTextEmpty(aRTFString: string): Boolean;
    function AsString: string;
    procedure SetFont(aFont: TFont); overload;
    procedure SetFont(aStyleNo: Integer); overload;
    procedure SetFontname(aFontname: string);
    class function PlainText(aRTFString: string): string;
    function LoadTextFromFile(aFilename: string): string;
    function FontStyle: TNFSRvFontStyle;
    function AddTextStyle(aStylename, aFontname: string; aFontsize: integer): TFontinfo;
    function AddParaStyle(aStylename: string; Alignment: TRvAlignment): TParaInfo;
    procedure SetStandardTextStyle;
    procedure ClearRvStyleText;
    function GetTextStyleId(aStyleName: string; const aDefaultValueIfNotFound: Integer): Integer;
    procedure MoveCaretToTheEnd;
    procedure MoveCaretToTheBeginning;
    function RTFAsString: string;
    procedure setStringStandard(aValue: string);
    procedure SetRTF(aValue: string);
    function RTFEmpty(aRTFString: string): Boolean;
    function GetParentForm: TForm;
    procedure Clear(const aTextStyleNo: Integer = -1; const aParaStyleNo: Integer = -1);
    procedure InsertRTF(aValue: string);
    procedure Open;
    procedure Save;
    procedure ClearAll;
    procedure PrintPreview;
    procedure Print;
    procedure DoUndo;
    procedure DoCut;
    procedure DoCopy;
    procedure DoPaste;
    procedure DoDelete;
    procedure DoSelectAll;
    procedure DoSearch;
    procedure DoSearchAndReplace;
    procedure DoInsertPagebreak;
    procedure DoInsertFile;
    procedure DoInsertPicture;
    procedure DoInsertLine;
  published
    property OnClear: TNotifyEvent read FOnClear write FOnClear;
    property OnBeforeClear: TNotifyEvent read FOnBeforeClear write FOnBeforeClear;
    property OnChangedBullet: TNFSToolbarButtonChangedEvent read FOnChangedBullet write FOnChangedBullet;
    property OnChangedNumbering: TNFSToolbarButtonChangedEvent read FOnChangedNumbering write FOnChangedNumbering;
    property OnReadOnlyChanged: TNotifyEvent read fOnReadOnlyChanged write fOnReadOnlyChanged;
    property OnBeforUseStandardFont: TNotifyEvent read fOnBeforUseStandardFont write fOnBeforUseStandardFont;
    function CellsOperation: TNFSCellsOperation;
    property StandardFont: TNFSRvFontObj read fStandardFont write FStandardFont;
  end;

procedure Register;

implementation

uses
  Winapi.Windows, RVUni, Form.NFSRichViewEditPreview, RvFuncs,
  Form.NFSRichViewEditLine, RvItem, RvTable, System.UITypes,
  RvMisc, RVGrHandler;

procedure Register;
begin
  RegisterComponents('Optima', [TNFSRichViewEdit]);
end;

{ TNFSRichViewEdit }

constructor TNFSRichViewEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fRvStyle := TRvStyle.Create(Self);
  fRVPrint := TRvPrint.Create(Self);
  fpsd     := TPrinterSetupDialog.Create(Self);
  fFindDialog := TFindDialog.Create(Self);
  fFindDialog.OnFind := FindDialogFind;
  fFindDialog.Options := [frDown,frFindNext];
  fRd := TReplaceDialog.Create(Self);
  fRd.Options := [frDown,frDisableUpDown];
  fRd.OnReplace := ReplaceDialog;
  fCellsOperation := TNFSCellsOperation.Create(Self);
  fStandardFont   := TNFSRvFontObj.Create;


  Style := FRvStyle;
  OnCaretMove := CaretMove;
  OnStyleConversion := StyleConversion;
  fFont := TFont.Create;
  fNFSRvFontStyle := TNFSRvFontStyle.Create(TRichViewEdit(Self));
  fOpenDialog := nil;
  fSaveDialog := nil;
  fFullFileName := '';
  fHTMLTitle := '';
end;


destructor TNFSRichViewEdit.Destroy;
begin
  FreeAndNil(fFont);
  FreeAndNil(fRvStyle);
  FreeAndNil(fNFSRvFontStyle);
  if fOpenDialog <> nil then
    FreeAndNil(fOpenDialog);
  if fSaveDialog <> nil then
    FreeAndNil(fSaveDialog);
  FreeAndNil(fCellsOperation);
  FreeAndNil(fStandardFont);
  inherited;
end;


procedure TNFSRichViewEdit.ClearAndFormated;
begin
  ClearIt;
  Format;
end;

procedure TNFSRichViewEdit.ClearIt;
begin
  if Assigned(OnBeforeClear) then
    OnBeforeClear(Self);
  RVData.clear;
  if Assigned(OnClear) then
    OnClear(Self);
end;

procedure TNFSRichViewEdit.ClearRvStyleText;
begin
  fRvStyle.TextStyles.Clear;
end;

function TNFSRichViewEdit.GetRTFString: string;
var
  List: TStringList;
  m   : TMemoryStream;
begin
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  try
    SaveRTFToStream(m, false);
    m.Position := 0;
    List.LoadFromStream(m);
    Result := List.Text;
  finally
    FreeAndNil(List);
    FreeAndNil(m);
  end;
end;

function TNFSRichViewEdit.GetStyleNo(aFont: TFont): Integer;
var
  fi: TFontInfo;
begin
  fi := TFontInfo.Create(nil);
  try
    fi.Assign(aFont);
    Result := AddOrGetFontStyleNo(fi);
  finally
    FreeAndNil(fi);
  end;
end;

function TNFSRichViewEdit.AddNewJumpFont(aFont: TFont): Integer;
var
  fi: TFontInfo;
begin
  fi := TFontInfo.Create(nil);
  try
    fi.Assign(aFont);
    fi.Jump := true;
    Result := AddOrGetFontStyleNo(fi);
  finally
    FreeAndNil(fi);
  end;
end;


function TNFSRichViewEdit.isRTFText(aValue: string): Boolean;
begin
  Result := false;
  if System.Copy(aValue, 1,7)  = '{\rtf1\' then
    Result := true;
end;


procedure TNFSRichViewEdit.DisplayUnicodeWarning;
var
  wasclear: Boolean;
begin
  wasclear := ItemCount=0;
  if not fRvStyle.TextStyles[CurTextStyleNo].Unicode then
    Application.MessageBox('Loading/Inserting Unicode data using non-Unicode text style.'#13+
                           'Text will be converted.'#13+
                           'Choose "Unicode" style in combo to use Unicode text style',
                           'Warning', MB_OK or MB_ICONEXCLAMATION);
  if wasclear then
    RVData.Clear;
end;


function TNFSRichViewEdit.FontStyle: TNFSRvFontStyle;
begin
  Result := fNFSRvFontStyle;
end;

function TNFSRichViewEdit.GetRVFErrors: String;
begin
  Result := '';
  if rvfwUnknownPicFmt in RVFWarnings then
    Result := Result+'unknown picture format;';
  if rvfwUnknownCtrls in RVFWarnings then
    Result := Result+'unknown control class;';
  if rvfwConvUnknownStyles in RVFWarnings then
    Result := Result+'text, paragraph or list style is not present;';
  if rvfwConvLargeImageIdx in RVFWarnings then
    Result := Result+'invalid image-list index;';
  if rvfwUnknownStyleProperties in RVFWarnings then
    Result := Result+'unknown property of text, paragraph or list style;';
  if Result<>'' then
    Result := #13'('+Result+')';
end;

function TNFSRichViewEdit.LoadTextFromFile(aFilename: string): String;
var
  ext: string;
  r: Boolean;
begin
  Result := '';
  r := true;
  RVData.clear;
  if not FileExists(aFilename) then
    exit;
  ext := ExtractFileExt(aFilename);

  if  (not SameText(ext, '.rvf'))
  and (not SameText(ext, '.rtf'))
  and (not SameText(ext, '.txt')) then
  begin
    Result := 'Ungültiges Textformat';
    exit;
  end;


  if SameText(ext, '.rvf') then
    r := LoadRVF(aFilename);
  if SameText(ext, '.rtf') then
    r := LoadRTF(aFilename);

  if RV_TestFileUnicode(aFilename)=rvutYes then
  begin
    DisplayUnicodeWarning;
    r := LoadTextW(aFileName,CurTextStyleNo,CurParaStyleNo,False);
  end
  else
  begin
    if SameText(ext, '.txt') then
      r := LoadText(aFilename, CurTextStyleNo,CurParaStyleNo,False);
  end;

  if not r then
  begin
    Result := 'Fehler beim Laden ' + sLineBreak + GetRVFErrors;
  end;

  Format;


end;

procedure TNFSRichViewEdit.SetFont(aFont: TFont);
begin
  FFont.Assign(aFont);
  ApplyStyleConversion(TEXT_APPLYFONT);
end;



procedure TNFSRichViewEdit.SetFont(aStyleNo: Integer);
var
  f: TFontInfo;
begin
  f := Style.TextStyles.Items[aStyleNo];
  if f = nil then
    exit;
  FFont.Name  := f.FontName;
  FFont.Size  := f.Size;
  FFont.Color := F.Color;
  FFont.Style := f.Style;
  ApplyStyleConversion(TEXT_APPLYFONT);
end;

procedure TNFSRichViewEdit.SetFontname(aFontname: string);
begin
  FFontname := aFontname;
  ApplyStyleConversion(TEXT_APPLYFONTNAME);
end;

procedure TNFSRichViewEdit.SetRTFString(const Value: string);
var
  List: TStringList;
  m   : TMemoryStream;
begin
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  try
    ClearIt;
    if isRTFText(Value) then
    begin
      List.Text := Value;
      List.SaveToStream(m);
      m.Position := 0;
      LoadRTFFromStream(m);
    end
    else
      Add(Value, CurTextStyleNo);
    Format;
  finally
    FreeAndNil(List);
    FreeAndNil(m);
  end;
end;

procedure TNFSRichViewEdit.setStringStandard(aValue: string);
var
  x: TFontInfo;
  TextStyleInt: Integer;
  ParaStyleInt: Integer;
begin
  if Assigned(fOnBeforUseStandardFont) then
    fOnBeforUseStandardFont(Self);
  ClearIt;
  aValue := PlainText(aValue);
  x := TFontInfo.Create(nil);
  x.FontName := StandardFont.Fontname;
  x.Size     := StandardFont.Fontsize;
  x.Color    := StandardFont.Fontcolor;
  x.Style    := StandardFont.Style;
  TextStyleInt := fRvStyle.FindTextStyle(x);
  AddParaStyle('Standard', StandardFont.Alignment);
  ParaStyleInt :=  fNFSRvFontStyle.GetParaStyleId('Standard');
  //fRvStyle.ParaStyles[i1].Alignment := StandardFont.Alignment;
  //Add(aValue, TextStyleInt);

  TRichViewEdit(Self).CurParaStyleNo := ParaStyleInt;
  TRichViewEdit(Self).CurTextStyleNo := TextStyleInt;

  InsertRTF(aValue);

  //AddNL(aValue, TextStyleInt, ParaStyleInt);
  Format;
  FreeAndNil(x);
end;



procedure TNFSRichViewEdit.SetStandardTextStyle;
var
  OldTextStyleNo: Integer;
begin
  OldTextStyleNo := CurTextStyleNo;
  CurTextStyleNo := fNFSRvFontStyle.Standard.TextNo;
  CurParaStyleNo := fNFSRvFontStyle.Standard.ParaNo;
  if Assigned(OnCurTextStyleChanged) and (OldTextStyleNo = CurTextStyleNo) then
    OnCurTextStyleChanged(Self);
end;


procedure TNFSRichViewEdit.StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
  UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
var
  FontInfo: TFontInfo;
begin
  FontInfo := TFontInfo.Create(nil);
  try
    FontInfo.Assign(Style.TextStyles[StyleNo]);
    case UserData of
      TEXT_BOLD:
        begin
          {
          btn := GetButtonFromTag(Ord(tbBold));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsBold]
          else
            FontInfo.Style := FontInfo.Style-[fsBold];
          }
        end;
      TEXT_ITALIC:
        begin
          {
          btn := GetButtonFromTag(Ord(tbItalic));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsItalic]
          else
            FontInfo.Style := FontInfo.Style-[fsItalic];
            }
        end;
      TEXT_UNDERLINE:
        begin
          {
          btn := GetButtonFromTag(Ord(tbUnderline));
          if btn.Down then
            FontInfo.Style := FontInfo.Style+[fsUnderline]
          else
            FontInfo.Style := FontInfo.Style-[fsUnderline];
            }
        end;
      TEXT_APPLYFONTNAME:
        FontInfo.FontName := FFontname;
      TEXT_APPLYFONTSIZE:
        FontInfo.Size     := FFontsize;
      TEXT_APPLYFONT:
        FontInfo.Assign(FFont);
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
    NewStyleNo := AddOrGetFontStyleNo(FontInfo);
  finally
    FontInfo.Free;
  end;
end;



function TNFSRichViewEdit.AddOrGetFontStyleNo(aFontInfo: TFontInfo): Integer;
begin
  Result := Style.FindTextStyle(aFontInfo);
  if Result = -1 then
  begin
    Style.TextStyles.Add;
    Result := Style.TextStyles.Count-1;
    Style.TextStyles[Result].Assign(aFontInfo);
    Style.TextStyles[Result].Standard := False;
  end;
end;

function TNFSRichViewEdit.AddParaStyle(aStylename: string;
  Alignment: TRvAlignment): TParaInfo;
begin
  Result := fNFSRvFontStyle.AddParaStyle(aStylename, Alignment);
end;

function TNFSRichViewEdit.AddTextStyle(aStylename, aFontname: string;
  aFontsize: integer): TFontinfo;
begin
  Result := fNFSRvFontStyle.AddTextStyle(aStylename, aFontname, aFontsize);
end;

function TNFSRichViewEdit.MergeRTF(aRTFString1, aRTFString2: string): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
begin
  rh    := TRvReportHelper.Create(Self);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rh.RichView.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rh.RichView.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveTextStyles];
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveParaStyles];
    rv       := rh.RichView;
    rv.Style := Style;

    // Load RTFString1
    List.Text := aRTFString1;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);


    // Load RTFString2
    List.Text := aRTFString2;
    m.Clear;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    // New RTFString
    m.Position := 0;
    rv.SaveRTFToStream(m, false);
    m.Position := 0;
    List.LoadFromStream(m);
    Result := List.Text;

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;
end;


function TNFSRichViewEdit.MergeRTF(aRTFString1, aRTFString2: string; const aMitUmbruch: Boolean = true; const aCanvas: TCanvas = nil; aPageWidth: Integer = 800): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
  s: string;
  s1: string;
  iPos: Integer;
begin
  rh    := TRvReportHelper.Create(nil);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rv       := rh.RichView;
    rv.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rv.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveTextStyles];
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveParaStyles];
    rv.Style := Style;

    // Load RTFString1
    List.Text := aRTFString1;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);
//    rv.SaveRTF('C:\RTFTest\Test1.rtf', false);

    // Load RTFString2
    List.Text := aRTFString2;
    m.Clear;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    if not aMitUmbruch then
      rv.Add('@~BREAK~@',0);
    rv.LoadRTFFromStream(m);

    // New RTFString
    m.Position := 0;

    if aCanvas <> nil then
      rh.Init(aCanvas, aPageWidth); // <-- Wenn man eine RTF Tabellen hat, dann ist es unbedingt notwendig das ein Canvas übergeben wird.
                                    //     Sollte kein Canvas übergeben werden, dann

    try
      rv.SaveRTFToStream(m, false); // <-- gibt es hier eine exception [@tb 08.05.2015]
    except
      on E: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;

    m.Position := 0;


    List.LoadFromStream(m);

    s := Trim(List.Text);
    iPos := Pos('@~BREAK~@', s);
    if iPos > 0 then
    begin
      s1 := System.copy(s, 1, iPos-1);
      Delete(s, 1, iPos+15);
      s := s1 + s;
    end;

    Result := s;


    // Result := trim(List.Text);

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;
end;


function TNFSRichViewEdit.RTFTextEmpty(aRTFString: string): Boolean;
begin
  Result := Trim(AsString) = '';
end;

function TNFSRichViewEdit.AsString: string;
begin
  Result := String(GetAllText(Self));
end;

procedure TNFSRichViewEdit.CaretMove(Sender: TObject);
var
  FirstParaItemNo: Integer;
  rve: TCustomRichViewEdit;
  ListNo: Integer;
begin
  rve := TopLevelEditor;
  FirstParaItemNo := rve.CurItemNo;
  if FirstParaItemNo < 0 then
    exit;
  while not rve.IsParaStart(FirstParaItemNo) do
    dec(FirstParaItemNo);
  if rve.GetItemStyle(FirstParaItemNo)=rvsListMarker then
  begin
    ListNo := GetListNo(rve, FirstParaItemNo);
    if Assigned(FOnChangedBullet) then
      FOnChangedBullet(Self, not Style.ListStyles[ListNo].HasNumbering);
    if Assigned(FOnChangedNumbering) then
      FOnChangedNumbering(Self, Style.ListStyles[ListNo].AllNumbered);
  end
  else
  begin
    if Assigned(FOnChangedBullet) then
      FOnChangedBullet(Self, false);
    if Assigned(FOnChangedNumbering) then
      FOnChangedNumbering(Self, false);
  end;
end;


function TNFSRichViewEdit.CellsOperation: TNFSCellsOperation;
begin
  Result := fCellsOperation;
end;

function TNFSRichViewEdit.GetListNo(rve: TCustomRichViewEdit;
  ItemNo: Integer): Integer;
var
  Level, StartFrom: Integer;
  Reset: Boolean;
begin
  GetListMarkerInfo(ItemNo, Result, Level, StartFrom, Reset);
end;


class function TNFSRichViewEdit.PlainText(aRTFString: string): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
begin

  if System.Copy(aRTFString, 1,7)  <> '{\rtf1\' then
  begin
    Result := aRTFString;
    exit;
  end;

  rh    := TRvReportHelper.Create(nil);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rh.RichView.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rh.RichView.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveTextStyles];
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveParaStyles];
    rv       := rh.RichView;
    rv.Style := Style;

    // Load RTFString
    List.Text := aRTFString;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    Result := string(GetAllText(rv));


  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;
end;


function TNFSRichViewEdit.GetTextStyleId(aStyleName: string;
  const aDefaultValueIfNotFound: Integer): Integer;
begin
  Result := FontStyle.GetTextStyleId(aStyleName, aDefaultValueIfNotFound);
end;


procedure TNFSRichViewEdit.MoveCaretToTheEnd;
var
  ItemNo, Offs: Integer;
begin
  ItemNo := ItemCount-1;
  Offs   := GetOffsAfterItem(ItemNo);
  SetSelectionBounds(ItemNo,Offs,ItemNo,Offs);
end;

procedure TNFSRichViewEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

procedure TNFSRichViewEdit.MoveCaretToTheBeginning;
var
  ItemNo, Offs: Integer;
begin
  ItemNo := 0;
  Offs   := GetOffsBeforeItem(ItemNo);
  SetSelectionBounds(ItemNo,Offs,ItemNo,Offs);
end;



function TNFSRichViewEdit.RTFAsString: string;
var
  Stream: TMemoryStream;
  List: TStringList;
  s: string;
begin
  List := TStringList.Create;
  Stream := TMemoryStream.Create;
  try
    SaveRTFToStream(Stream, false);
    Stream.Position := 0;
    List.LoadFromStream(Stream);
    Result := List.Text;
    s := System.copy(Result, Length(Result)-6, Length(Result));
    if s = '#$D#$A' then
      Result := System.copy(Result, 1, Length(Result)-6);

  finally
    FreeAndNil(Stream);
    FreeAndNil(List);
  end;
end;


function TNFSRichViewEdit.GetParentForm: TForm;
var
  wParent: TWinControl;
  bCancel: Boolean;
begin
  Result := nil;
  try
    wParent := Parent;
    if not Assigned(wParent) then
      exit;
    bCancel := false;
    while not bCancel do
    begin
      if not Assigned(wParent) then
        exit;
      if wParent is TForm then
      begin
        Result := TForm(wParent);
        exit;
      end;
      wParent := wParent.Parent;
    end;
  except
  end;
end;



function TNFSRichViewEdit.GetFocusedControl: TWinControl;
var
  Form: TForm;
begin
  Result := nil;
  try
    Form := GetParentForm;
    if not Assigned(Form) then
      exit;
    if not Form.Visible then
      exit;
    Result := Form.ActiveControl;
  except
    Result := nil;
  end;
end;

procedure TNFSRichViewEdit.Clear(const aTextStyleNo: Integer = -1; const aParaStyleNo: Integer = -1);
begin
  RVData.Clear;
  if aTextStyleNo > -1 then
    CurParaStyleNo := aParaStyleNo;
  if aParaStyleNo > -1 then
    CurTextStyleNo := aTextStyleNo;
  if aTextStyleNo = -1 then
    CurTextStyleNo := FontStyle.Standard.TextNo;
  if aParaStyleNo = -1 then
    CurParaStyleNo := FontStyle.Standard.ParaNo;
end;

procedure TNFSRichViewEdit.SetReadOnly(const Value: Boolean);
begin
  inherited;
  if Assigned(fOnReadOnlyChanged) then
    fOnReadOnlyChanged(Self);
end;

procedure TNFSRichViewEdit.SetRTF(aValue: string);
var
  strList: TStringList;
  m   : TMemoryStream;
  ro  : Boolean;
  FocusedControl: TWinControl;
  Error: string;
begin
  if FontStyle = nil then
  begin
    Error := 'procedure TRichViewEditObj.SetRTF(aValue: string) --> FontStyle ist nil';
    //_logger.Error(Error);
    //ShowMessage(Error);
  end;
  try
    FocusedControl := GetFocusedControl;
    try
      ro := ReadOnly;
    except
      on E: Exception do
      begin
        Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (0)';
        //_logger.Error(Error);
        //ShowMessage(Error);
        raise;
      end;
    end;
    try
      ReadOnly := false;
      if (FontStyle.Standard.TextNo > 0) and (FontStyle.Standard.ParaNo > 0) then
        Clear
      else
        Clear(CurTextStyleNo, CurParaStyleNo);
      if aValue = '' then
        exit;
      if Pos('{\rtf1\', aValue) <= 0 then
      begin
        try
          InsertText(aValue);
        except
          on E: Exception do
          begin
            Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (1)';
            //_logger.Error(Error);
            //ShowMessage(Error);
            raise;
          end;
        end;
        try
          MoveCaretToTheBeginning;
        except
          on E: Exception do
          begin
            Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (2)';
            //_logger.Error(Error);
            //ShowMessage(Error);
            raise;
          end;
        end;
        exit;
      end;

      strList := TStringList.Create;
      m    := TMemoryStream.Create;
      try
        strList.Text := aValue;
        strList.SaveToStream(m);
        m.Position := 0;
        try
          LoadRTFFromStream(m);
        except
          on E: Exception do
          begin
            Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (3)';
            //_logger.Error(Error);
            //ShowMessage(Error);
            raise;
          end;
        end;
      finally
        FreeAndNil(strList);
        FreeAndNil(m);
      end;
      try
        Format;
        if Assigned(OnSpellingCheck) then
          StartLiveSpelling;
      except
        on E: Exception do
        begin
          Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (4)';
          //_logger.Error(Error);
          //ShowMessage(Error);
          raise;
        end;
      end;
    finally
      try
        ReadOnly := ro;
      except
        on E: Exception do
        begin
          Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (5)';
          //_logger.Error(Error);
          //ShowMessage(Error);
          raise;
        end;
      end;
      try
        if Assigned(FocusedControl) then
        begin
          if FocusedControl.CanFocus then
          begin
            try
              FocusedControl.SetFocus;
            except
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          //Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (6)';
          //_logger.Error(Error);
          //ShowMessage(Error);
          //raise;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
       Error := e.Message + #13 +  'TRichViewEditObj.SetRTF (7)';
      //_logger.Error(Error);
      //ShowMessage(Error);
      raise;
    end;
  end;
end;

function TNFSRichViewEdit.RTFEmpty(aRTFString: string): Boolean;
var
  Form: TForm;
  Style: TRvStyle;
  rv   : TRichViewEdit;
begin
  Form := TForm.Create(nil);
  Style := TRvStyle.Create(nil);
  rv    := TRichViewEdit.Create(Form);
  try
    rv.Parent := Form;
    rv.Style := Style;
    SetRTF(aRTFString);
    Result := Trim(AsString) = '';
  finally
    FreeAndNil(rv);
    FreeAndNil(Style);
    FreeAndNil(Form);
  end;
end;


procedure TNFSRichViewEdit.InsertRTF(aValue: string);
var
  List: TStringList;
  m   : TMemoryStream;
begin
  if not isRTFText(aValue) then
  begin
    InsertText(aValue);
    exit;
  end;
  List := TStringList.Create;
  m    := TMemoryStream.Create;
  try
    List.Text := aValue;
    List.SaveToStream(m);
    m.Position := 0;
    InsertRTFFromStreamEd(m);
  finally
    FreeAndNil(List);
    FreeAndNil(m);
  end;
  Format;
end;


procedure TNFSRichViewEdit.Open;
var
  iCurTextStyleNo, iCurParaStyleNo: Integer;
  r: Boolean;
  ErrorMessage: String;
begin
  if fOpenDialog = nil then
    fOpenDialog := TOpenDialog.Create(Self);
  try
    fOpenDialog.Title := 'Laden und importieren';
    fOpenDialog.Filter :=  'RTF Files (*.rtf)|*.rtf|'+
                          'RichView Format Files(*.rvf)|*.rvf|'+
                          'Text Files - autodetect (*.txt)|*.txt|'+
                          'ANSI Text Files (*.txt)|*.txt|'+
                          'Unicode Text Files (*.txt)|*.txt';
    if fOpenDialog.Execute then
    begin
      Screen.Cursor := crHourglass;
      iCurTextStyleNo := CurTextStyleNo;
      iCurParaStyleNo := CurParaStyleNo;

      Clear;
      Style.DefUnicodeStyle := -1;
      CurTextStyleNo := iCurTextStyleNo;
      CurParaStyleNo := iCurParaStyleNo;
      case fOpenDialog.FilterIndex of
        2: // RVF
          r := LoadRVF(fOpenDialog.FileName);
        1: // RTF
          r := LoadRTF(fOpenDialog.FileName);
        3: // Text
          if RV_TestFileUnicode(fOpenDialog.FileName)=rvutYes then
          begin
            DisplayUnicodeWarning;
            r := LoadTextW(fOpenDialog.FileName,CurTextStyleNo,CurParaStyleNo,False)
          end
          else
            r := LoadText(fOpenDialog.FileName,CurTextStyleNo,CurParaStyleNo,False);
        4: // ANSI text
          r := LoadText(fOpenDialog.FileName,CurTextStyleNo,CurParaStyleNo,False);
        5: // Unicode text
          begin
            DisplayUnicodeWarning;
            r := LoadTextW(fOpenDialog.FileName,CurTextStyleNo,CurParaStyleNo,False)
          end;
        else
          r := False;
      end;
      fFullFileName := fOpenDialog.FileName;
      Screen.Cursor := crDefault;
      if not r then
      begin
        ErrorMessage := 'Error during loading';
        if fOpenDialog.FilterIndex=1 then
          ErrorMessage := ErrorMessage + GetRVFErrors;
        Application.MessageBox(PChar(ErrorMessage), 'Error', 0);
      end;
      Format;
    end;
  finally

  end;
end;

procedure TNFSRichViewEdit.Save;
var
  r: Boolean;
begin
  if fSaveDialog = nil then
  begin
    fSaveDialog := TSaveDialog.Create(Self);
    fSaveDialog.Options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn];
  end;
  try
    fSaveDialog.Title  := 'Save & Export';
    fSaveDialog.Filter :=  'RTF Files (*.rtf)|*.rtf|'+
                          'RichView Format files(*.rvf)|*.rvf|'+
                          'Text (*.txt)|*.txt|'+
                          'Unicode Text (*.txt)|*.txt|'+
                          'HTML - with CSS (*.htm;*.html)|*.htm;*.html|'+
                          'HTML - Simplified (*.htm;*.html)|*.htm;*.html';
    fSaveDialog.DefaultExt := 'rvf';
    if fSaveDialog.Execute then
    begin
      Screen.Cursor := crHourglass;
      case fSaveDialog.FilterIndex of
        2: // RVF
          r := SaveRVF(fSaveDialog.FileName, False);
        1: // RTF
          r := SaveRTF(fSaveDialog.FileName, False);
        3: // ANSI Text (byte per character)
          r := SaveText(fSaveDialog.FileName, 80);
        4: // Unicode Text (2 bytes per character)
          r := SaveTextW(fSaveDialog.FileName, 80);
        5: // HTML with CSS
          r := SaveHTMLEx(fSaveDialog.FileName, fHTMLTitle,'img', '',
            '', '', fHTMLSaveOptions);
        6: // HTML
          r := SaveHTML(fSaveDialog.FileName, fHTMLTitle,'img',
            fHTMLSaveOptions);
        else
          r := False;
      end;
      Screen.Cursor := crDefault;
      if not r then
        Application.MessageBox('Error during saving', 'Error', 0);
    end;
  finally
  end;
end;

procedure TNFSRichViewEdit.ClearAll;
begin
  if MessageDlg('Möchten Sie wirklich den gesamten Text entfernen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  Clear;
  Format;
end;

procedure TNFSRichViewEdit.PrintPreview;
var
  Preview: Tfrm_NFSRichViewEditPreview;
begin
  try
    fRVPrint.AssignSource(Self);
    fRVPrint.FormatPages(rvdoALL);
    if fRVPrint.PagesCount>0 then
    begin
      Preview := Tfrm_NFSRichViewEditPreview.Create(nil);
      try
        Preview.rvpp.RVPrint := fRVPrint;
        Preview.btn_FirstClick(nil); //  Show First Page
        Preview.Caption := fFullFileName;
        Preview.FormStyle := fsStayOnTop;
        Preview.ShowModal;
      finally
        FreeAndNil(Preview);
      end;
    end;
  finally
    //AfterShowForm(fStyle);
  end;
end;


procedure TNFSRichViewEdit.Print;
var
  PrintIt: Boolean;
begin
  PrintIt := fpsd.Execute;
  if PrintIt then
  begin
    fRVPrint.AssignSource(Self);
    fRVPrint.FormatPages(rvdoALL);
    if fRVPrint.PagesCount>0 then
      fRVPrint.Print(fFullFileName,1,False);
  end;
end;



procedure TNFSRichViewEdit.DoUndo;
begin
  Undo;
end;

procedure TNFSRichViewEdit.DoCut;
begin
  CopyDef;
  DeleteSelection;
end;

procedure TNFSRichViewEdit.DoDelete;
var
  ItemNo, Offs: Integer;
begin
  try
    if SelectionExists then
      DeleteSelection
    else
    begin
      ItemNo := TopLevelEditor.CurItemNo;
      Offs   := TopLevelEditor.OffsetInCurItem;
      SetSelectionBounds(ItemNo, Offs, ItemNo, offs +1);
      DeleteSelection;
    end;
  except
  end;
end;

procedure TNFSRichViewEdit.DoInsertPagebreak;
begin
  InsertPageBreak;
end;

procedure TNFSRichViewEdit.DoPaste;
begin
  Paste;
end;


procedure TNFSRichViewEdit.DoCopy;
begin
  CopyDef;
end;


procedure TNFSRichViewEdit.DoSearch;
begin
  fFindDialog.Execute;
end;

procedure TNFSRichViewEdit.DoSelectAll;
begin
  SelectAll;
  if Visible and Enabled and Focused then
     SetFocus;
  Invalidate;
end;

procedure TNFSRichViewEdit.DoSearchAndReplace;
var
  s: String;
  p: Integer;
begin
  s := '';
  if Visible and Enabled and Focused then
     SetFocus;
  if SelectionExists then
  begin
    s := GetSelText;
    p := Pos(#13,s);
    if p<>0 then s := System.Copy(s,1,p-1);
    fRd.FindText := s;
  end;
  fRd.Execute;
end;

procedure TNFSRichViewEdit.DoInsertFile;
var r: Boolean;
begin
  if fOpenDialog = nil then
    fOpenDialog := TOpenDialog.Create(Self);
  fOpenDialog.Title  := 'Datei einfügen';
  fOpenDialog.Filter :=  'RTF Files(*.rtf)|*.rtf|'+
                        'RichView Format Files(*.rvf)|*.rvf|'+
                        'Text Files - autodetect (*.txt)|*.txt|'+
                        'ANSI Text Files (*.txt)|*.txt|'+
                        'Unicode Text Files (*.txt)|*.txt|'+
                        'OEM Text Files (*.txt)|*.txt';
  if fOpenDialog.Execute then
  begin
    Screen.Cursor := crHourglass;
    case fOpenDialog.FilterIndex of
      2: // RVF
        r := InsertRVFFromFileEd(fOpenDialog.FileName);
      1: // RTF
        r := InsertRTFFromFileEd(fOpenDialog.FileName);
      3: // Text
        begin
          if RV_TestFileUnicode(fOpenDialog.FileName)=rvutYes then
            r := InsertTextFromFileW(fOpenDialog.FileName)
          else
            r := InsertTextFromFile(fOpenDialog.FileName);
        end;
      4: // ANSI Text
        r := InsertTextFromFile(fOpenDialog.FileName);
      5: // Unicode Text
        r := InsertTextFromFileW(fOpenDialog.FileName);
      6: // OEM Text
        r := InsertOEMTextFromFile(fOpenDialog.FileName);
      else
        r := False;
    end;
    Screen.Cursor := crDefault;
    if not r then
      Application.MessageBox('Error reading file', 'Error',
                             MB_OK or MB_ICONSTOP);
  end;
end;


procedure TNFSRichViewEdit.DoInsertPicture;
var
  gr: TGraphic;
  pic: TPicture;
//  fStyle: TFormStyle;
begin
  //fStyle := BeforeShowForm;
  if fOpenDialog = nil then
    fOpenDialog := TOpenDialog.Create(Self);
  try
    fOpenDialog.Title  := 'Inserting Image';
    fOpenDialog.Filter := 'Graphics(*.bmp;*.wmf;*.emf;*.ico;*.jpg)|*.bmp;*.wmf;*.emf;*.ico;*.jpg|All(*.*)|*.*';
    if fOpenDialog.Execute then
      try
        pic := TPicture.Create;
        try
          pic.LoadFromFile(fOpenDialog.FileName);
          gr := RVGraphicHandler.CreateGraphic(TGraphicClass(pic.Graphic.ClassType));
          //gr := RV_CreateGraphics(TGraphicClass(pic.Graphic.ClassType)); // Veraltet
          gr.Assign(pic.Graphic);
        finally
          pic.Free;
        end;
        if gr<>nil then
        begin
          InsertPicture('',gr,rvvaBaseLine);
        end;
      except
        Application.MessageBox(PChar('Cannot read picture from file '+ fOpenDialog.FileName), 'Error',
          MB_OK or MB_ICONSTOP);
      end;
  finally
    //AfterShowForm(fStyle);
  end;
end;

procedure TNFSRichViewEdit.DoInsertLine;
var
  Form: Tfrm_NFSRichViewEditLine;
  //fStyle: TFormStyle;
begin
  //fStyle := BeforeShowForm;
  Form := Tfrm_NFSRichViewEditLine.Create(Self);
  try
    Form.FormStyle := fsStayOnTop;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    if Form.cob_Linienart.ItemIndex = -1 then
      exit;
    if Form.cob_Linienart.ItemIndex = 0 then
      InsertBreak(Form.edt_Width.Value, rvbsLine, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 1 then
      InsertBreak(Form.edt_Width.Value, rvbsDotted, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 2 then
      InsertBreak(Form.edt_Width.Value, rvbsDashed, Form.btn_Color.Color);
    if Form.cob_Linienart.ItemIndex = 3 then
      InsertBreak(Form.edt_Width.Value, rvbsRectangle, Form.btn_Color.Color);
  finally
    FreeAndNil(Form);
    //AfterShowForm(fStyle);
  end;
end;

function TNFSRichViewEdit.IsEqualText(s1, s2: String; CaseSensitive: Boolean): Boolean;
begin
  if CaseSensitive then
    Result := s1=s2
  else
    Result := AnsiLowerCase(s1)=AnsiLowerCase(s2);
end;

procedure TNFSRichViewEdit.FindDialogFind(Sender: TObject);
begin
  if not SearchText(fFindDialog.FindText,
                           GetRVESearchOptions(fFindDialog.Options)) then
    Application.MessageBox('Nichts weiter gefunden', 'Suche wurde beendet.', MB_OK or MB_ICONEXCLAMATION);
end;

procedure TNFSRichViewEdit.ShowInfo(const msg,cpt: String);
begin
  Application.MessageBox(PChar(msg),PChar(cpt),MB_OK or MB_ICONINFORMATION);
end;

procedure TNFSRichViewEdit.ReplaceDialog(Sender: TObject);
var c: Integer;
begin
  if frReplace in frd.Options then
  begin
    if IsEqualText(GetSelText, frd.FindText, frMatchCase in frd.Options) then
      InsertText(frd.ReplaceText,False);
    if not SearchText(frd.FindText,GetRVESearchOptions(frd.Options)) then
      ShowInfo('Suchtext wurde nicht gefunden','Suchen and Ersetzen');
  end
  else
    if frReplaceAll in frd.Options then
    begin
      c := 0;
      if IsEqualText(GetSelText, frd.FindText, frMatchCase in frd.Options) then
      begin
        InsertText(frd.ReplaceText,False);
        inc(c);
      end;
      while SearchText(frd.FindText,GetRVESearchOptions(frd.Options)) do
      begin
        InsertText(frd.ReplaceText,False);
        inc(c);
      end;
      ShowInfo(SysUtils.Format('Es wurden %d Einträge ersetzt',[c]),'Ersetzen');
    end;
end;
















end.
