unit Objekt.NFSRvFontstyle;

interface

uses
  SysUtils, Classes, RvEdit, RVStyle, Graphics, Objekt.NFSRvFont;

type
  RFontStandardNo = Record
    TextNo: Integer;
    ParaNo: Integer;
  end;

type
  TNFSRvFontstyle = class
  private
    fRv: TRichViewEdit;
    fStandard: RFontStandardNo;
    function GetFontInfo(aStyleName: string): TFontInfo;
    function GetParaInfo(aStyleName: string): TParaInfo;
  public
    constructor Create(aEditor: TRichViewEdit);
    destructor Destroy; override;
    procedure Init;
    function GetCurrentFontStyleAsString: String;
    function GetFontStyleAsString(aTextStyleNo, aParaStyleNo: Integer): String;
    procedure SetFontStyle(aStyleName, aValue: string);
    function AddTextStyle(aStylename, aFontname: string; aFontsize: integer): TFontinfo;
    function AddParaStyle(aStylename: string; Alignment: TRvAlignment): TParaInfo;
    function GetParaStyleId(aStyleName: string; const aDefaultValueIfNotFound: Integer = 0): Integer;
    function GetTextStyleId(aStyleName: string; const aDefaultValueIfNotFound: Integer = 0): Integer;
    procedure SetStandardStyle(aStyleName: string);
    function GetFontHintText(aValue: string): string;
    property Standard: RFontStandardNo read fStandard write fStandard;
  end;


implementation

{ TNFSRvFontstyle }

constructor TNFSRvFontstyle.Create(aEditor: TRichViewEdit);
begin
  fRv := aEditor;
  fStandard.TextNo := 0;
  fStandard.ParaNo := 0;
end;

destructor TNFSRvFontstyle.Destroy;
begin

  inherited;
end;

procedure TNFSRvFontstyle.Init;
begin

end;



function TNFSRvFontstyle.AddParaStyle(aStylename: string;
  Alignment: TRvAlignment): TParaInfo;
begin
  Result := nil;
  if not Assigned(fRv.Style) then
    exit;
  Result := GetParaInfo(aStyleName);
  if not Assigned(Result) then
    Result := fRv.Style.ParaStyles.Add;
  Result.StyleName := aStylename;
  Result.Alignment := Alignment;
end;

function TNFSRvFontstyle.AddTextStyle(aStylename, aFontname: string;
  aFontsize: integer): TFontinfo;
begin
  Result := nil;
  if not Assigned(fRv.Style) then
    exit;
  Result := GetFontInfo(aStyleName);
  if not Assigned(Result) then
    Result := fRv.Style.TextStyles.Add;
  Result.StyleName := aStylename;
  Result.FontName  := aFontname;
  Result.Size      := aFontsize;
  Result.Style     := [];
end;


function TNFSRvFontstyle.GetCurrentFontStyleAsString: String;
begin
  Result := GetFontStyleAsString(fRv.CurTextStyleNo, fRv.CurParaStyleNo);
end;

function TNFSRvFontstyle.GetFontHintText(aValue: string): string;
var
  FontList: TStringList;
  Ausrichtung: string;
  Style      : string;
begin
  Result := '';
  FontList  := TStringList.Create;
  try
    FontList.Text := aValue;
    if FontList.Values['Alignment_Left'] = '1' then
      Ausrichtung := 'Links';
    if FontList.Values['Alignment_Center'] = '1' then
      Ausrichtung := 'Zentriert';
    if FontList.Values['Alignment_Right'] = '1' then
      Ausrichtung := 'Rechts';
    if FontList.Values['Alignment_Justify'] = '1' then
      Ausrichtung := 'Blocksatz';

    Style := '';
    if FontList.Values['Style_Bold'] = '1' then
      Style := Style + 'Fett';
    if FontList.Values['Style_Italic'] = '1' then
    begin
      if Style > '' then
        Style := Style + ',Kursiv'
      else
        Style := Style + 'Kursiv';
    end;
    if FontList.Values['Style_Underline'] = '1' then
    begin
      if Style > '' then
        Style := Style + ',Unterstrichen'
      else
        Style := Style + 'Unterstrichen';
    end;
    if Style > '' then
      Style := '(' + Style + ')';

    Result := 'Schriftname = ' + FontList.Values['Name'] + #13 +
              'Schriftgröße = ' + FontList.Values['Size'] + #13 +
              'Ausrichtung  = ' + Ausrichtung + #13;
    if Style > '' then
      Result := Result + 'Style = ' + Style;
  finally
    FreeAndNil(FontList);
  end;
end;

function TNFSRvFontstyle.GetFontInfo(aStyleName: string): TFontInfo;
var
  i1: Integer;
  f : TFontInfo;
begin
  Result := nil;
  if not Assigned(fRV.Style) then
    exit;
  for i1 := 0 to fRv.Style.TextStyles.Count -1 do
  begin
    f := fRv.Style.TextStyles.Items[i1];
    if SameText(f.StyleName, aStyleName) then
    begin
      Result := f;
      break;
    end;
  end;
end;

function TNFSRvFontstyle.GetFontStyleAsString(aTextStyleNo,
  aParaStyleNo: Integer): String;
var
  FontInfos: TFontInfos;
  FontInfo: TFontInfo;
  ParaInfos: TParaInfos;
  ParaInfo : TParaInfo;
  FontObj : TNFSRvFontObj;
begin
  Result := '';
  if not Assigned(fRv.Style) then
    exit;
  FontInfos := fRv.Style.TextStyles;
  FontInfo  := FontInfos.Items[aTextStyleNo];
  ParaInfos := fRv.Style.ParaStyles;
  ParaInfo  := ParaInfos.Items[aParaStyleNo];
  FontObj   := TNFSRvFontObj.Create;
  try
    FontObj.Fontname  := FontInfo.FontName;
    FontObj.Fontsize  := FontInfo.Size;
    FontObj.Fontcolor := FontInfo.Color;
    FontObj.Style     := FontInfo.Style;
    FontObj.Alignment := ParaInfo.Alignment;
    Result := FontObj.AsString;
  finally
    FreeAndNil(FontObj);
  end;
end;

function TNFSRvFontstyle.GetParaInfo(aStyleName: string): TParaInfo;
var
  i1: Integer;
  p : TParaInfo;
begin
  Result := nil;
  if not Assigned(fRv) then
    exit;
  for i1 := 0 to fRv.Style.ParaStyles.Count -1 do
  begin
    p := fRv.Style.ParaStyles.Items[i1];
    if SameText(p.StyleName, aStyleName) then
    begin
      Result := p;
      break;
    end;
  end;
end;

function TNFSRvFontstyle.GetParaStyleId(aStyleName: string;
  const aDefaultValueIfNotFound: Integer): Integer;
var
  i1: Integer;
begin
  Result := aDefaultValueIfNotFound;
  if not Assigned(fRv.Style) then
    exit;
  for i1 := 0 to fRv.Style.ParaStyles.Count -1 do
  begin
    if SameText(aStyleName, fRv.Style.ParaStyles[i1].StyleName) then
    begin
      Result := i1;
      exit;
    end;
  end;
end;

function TNFSRvFontstyle.GetTextStyleId(aStyleName: string;
  const aDefaultValueIfNotFound: Integer): Integer;
var
  i1: Integer;
begin
  Result := aDefaultValueIfNotFound;
  if not Assigned(fRv.Style) then
    exit;
  for i1 := 0 to fRv.Style.TextStyles.Count -1 do
  begin
    if SameText(aStyleName, fRv.Style.TextStyles[i1].StyleName) then
    begin
      Result := i1;
      exit;
    end;
  end;
end;


procedure TNFSRvFontstyle.SetFontStyle(aStyleName, aValue: string);
var
  FontInfo: TFontInfo;
  ParaInfo: TParaInfo;
  FontObj : TNFSRvFontObj;
begin
  if not Assigned(fRv.Style) then
    exit;

  FontInfo := GetFontInfo(aStyleName);
  ParaInfo := GetParaInfo(aStyleName);

  if not Assigned(FontInfo) then
  begin
    FontInfo := fRv.Style.TextStyles.Add;
    FontInfo.StyleName := aStyleName;
  end;

  if not Assigned(ParaInfo) then
  begin
    ParaInfo := fRv.Style.ParaStyles.Add;
    ParaInfo.StyleName := aStyleName;
  end;

  FontObj := TNFSRvFontObj.Create;
  try
    FontObj.SetFont(aValue);
    FontInfo.FontName  := FontObj.Fontname;
    FontInfo.Size      := FontObj.Fontsize;
    FontInfo.Color     := FontObj.Fontcolor;
    FontInfo.Style     := FontObj.Style;
    ParaInfo.Alignment := FontObj.Alignment;
  finally
    FreeAndNil(FontObj);
  end;

end;

procedure TNFSRvFontstyle.SetStandardStyle(aStyleName: string);
begin
  fStandard.TextNo := GetTextStyleId(aStyleName);
  fStandard.ParaNo := GetParaStyleId(aStyleName);
end;

end.
