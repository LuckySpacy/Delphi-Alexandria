unit tbRichviewEdit;

interface

uses
  SysUtils, Classes, Controls, RVScroll, RichView, RVEdit, RVStyle, RVReport, Graphics,
  RvGetText, CRVData, RVRVData;

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


type
  TtbToolbarButtonChangedEvent = procedure(Sender: TObject; aDown: Boolean) of object;
//  TtbStyleChangedEvent = procedure(Sender: TObject; FontInfo: TFontInfo) of object;

type
  TtbFontStyle = Record
    Bold: Boolean;
    Italic: Boolean;
    Underline: Boolean;
  End;

type
  TtbRichviewEdit = class(TRichViewEdit)
  private
    FFontname: string;
    FFontsize: Integer;
    FFont    : TFont;
    FFontColor: TColor;
    FBackgroundcolor: TColor;
    FRvStyle: TRvStyle;
    FOnClear: TNotifyEvent;
    FOnBeforeClear: TNotifyEvent;
    FOnChangedBullet: TtbToolbarButtonChangedEvent;
    FOnChangedNumbering: TtbToolbarButtonChangedEvent;
    function GetRTFString: string;
    procedure SetRTFString(const Value: string);
    procedure CaretMove(Sender: TObject);
    function GetListNo(rve: TCustomRichViewEdit; ItemNo: Integer): Integer;
    procedure StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
              UserData: Integer; AppliedToText: Boolean; var NewStyleNo: Integer);
    function AddOrGetFontStyleNo(aFontInfo: TFontInfo): Integer;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AsRTFString: string read GetRTFString write SetRTFString;
    procedure ClearIt;
    procedure ClearAndFormated;
    function GetStyleNo(aFont: TFont): Integer;
    function AddNewJumpFont(aFont: TFont): Integer;
    function MergeRTF(aRTFString1, aRTFString2: string): string;
    function isRTFText(aValue: string): Boolean;
    function RTFTextEmpty(aRTFString: string): Boolean;
    function AsString: string;
    procedure SetFont(aFont: TFont); overload;
    procedure SetFont(aStyleNo: Integer); overload;
    procedure SetFontname(aFontname: string);
  published
    property OnClear: TNotifyEvent read FOnClear write FOnClear;
    property OnBeforeClear: TNotifyEvent read FOnBeforeClear write FOnBeforeClear;
    property OnChangedBullet: TtbToolbarButtonChangedEvent read FOnChangedBullet write FOnChangedBullet;
    property OnChangedNumbering: TtbToolbarButtonChangedEvent read FOnChangedNumbering write FOnChangedNumbering;
    class function PlainText(aRTFString: string): string;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TtbRichviewEdit]);
end;

{ TtbRichviewEdit }


constructor TtbRichviewEdit.Create(AOwner: TComponent);
begin
  inherited;
  FRvStyle := TRvStyle.Create(Self);
  Style := FRvStyle;
  OnCaretMove := CaretMove;
  OnStyleConversion := StyleConversion;
  FFont := TFont.Create;
end;

destructor TtbRichviewEdit.Destroy;
begin
  FreeAndNil(FFont);
  FreeAndNil(FRvStyle);
  inherited;
end;


procedure TtbRichviewEdit.ClearAndFormated;
begin
  ClearIt;
  Format;
end;

procedure TtbRichviewEdit.ClearIt;
begin
  if Assigned(OnBeforeClear) then
    OnBeforeClear(Self);
  clear;
  if Assigned(OnClear) then
    OnClear(Self);
end;



function TtbRichviewEdit.GetRTFString: string;
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


function TtbRichviewEdit.GetStyleNo(aFont: TFont): Integer;
var
//  i1: Integer;
  fi: TFontInfo;
begin
  fi := TFontInfo.Create(nil);
  try
    fi.Assign(aFont);
    Result := AddOrGetFontStyleNo(fi);
  finally
    FreeAndNil(fi);
  end;
  {
  for i1 := 0 to Style.TextStyles.Count - 1 do
  begin
    fi := Style.TextStyles.Items[i1];
    if  (fi.FontName = aFont.Name)
    and (fi.Size = aFont.Size)
    and (fi.Color = aFont.Color)
    and (fi.Style = aFont.Style) then
    begin
      Result := i1;
      exit;
    end;
  end;
  fi := Style.TextStyles.Add;
  fi.FontName := aFont.Name;
  fi.Size := aFont.Size;
  fi.Color := aFont.Color;
  fi.Style := aFont.Style;
  Result := Style.TextStyles.Count -1;
  }
end;

function TtbRichviewEdit.AddNewJumpFont(aFont: TFont): Integer;
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

function TtbRichviewEdit.isRTFText(aValue: string): Boolean;
begin
  Result := false;
  if System.Copy(aValue, 1,7)  = '{\rtf1\' then
    Result := true;
end;

// Dem Richviewedit einen Font setzen.
procedure TtbRichviewEdit.SetFont(aFont: TFont);
begin
  FFont.Assign(aFont);
  ApplyStyleConversion(TEXT_APPLYFONT);
end;

procedure TtbRichviewEdit.SetFont(aStyleNo: Integer);
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


procedure TtbRichviewEdit.SetFontname(aFontname: string);
begin
  FFontname := aFontname;
  ApplyStyleConversion(TEXT_APPLYFONTNAME);
end;

procedure TtbRichviewEdit.SetRTFString(const Value: string);
var
  List: TStringList;
  m   : TMemoryStream;
begin
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  try
    ClearIt;
    //CurTextStyleNo
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


procedure TtbRichviewEdit.StyleConversion(Sender: TCustomRichViewEdit; StyleNo,
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
      // add your code here....
    end;
    NewStyleNo := AddOrGetFontStyleNo(FontInfo);
  finally
    FontInfo.Free;
  end;
end;

function TtbRichviewEdit.AddOrGetFontStyleNo(aFontInfo: TFontInfo): Integer;
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

function TtbRichviewEdit.MergeRTF(aRTFString1, aRTFString2: string): string;
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



function TtbRichviewEdit.RTFTextEmpty(aRTFString: string): Boolean;
begin
  Result := Trim(AsString) = '';
end;

function TtbRichviewEdit.AsString: string;
begin
  Result := String(GetAllText(Self));
end;

procedure TtbRichviewEdit.CaretMove(Sender: TObject);
var FirstParaItemNo: Integer;
    rve: TCustomRichViewEdit;
    ListNo: Integer;
begin
  rve := TopLevelEditor;
  FirstParaItemNo := rve.CurItemNo;
  if FirstParaItemNo<0 then // document is cleared
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

function TtbRichviewEdit.GetListNo(rve: TCustomRichViewEdit;
  ItemNo: Integer): Integer;
var Level, StartFrom: Integer;
    Reset: Boolean;
begin
  GetListMarkerInfo(ItemNo, Result, Level, StartFrom, Reset);
end;


class function TtbRichviewEdit.PlainText(aRTFString: string): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
begin
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




end.
