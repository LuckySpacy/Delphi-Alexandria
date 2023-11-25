unit Objekt.NFSRvFont;

interface

uses
  SysUtils, Classes, Graphics, RvStyle;

{$M+}

type
  TNFSRvFontObj = class
  private
    fFontname : string;
    fFontsize : Integer;
    fFontcolor: TColor;
    fStyle    : TFontStyles;
    fAlignment: TRVAlignment;
    fOnFontnameChanged: TNotifyEvent;
    fOnFontSizeChanged: TNotifyEvent;
    fOnFontStyleChanged: TNotifyEvent;
    fOnFontAlignmentChanged: TNotifyEvent;
    fOnFontColorChanged: TNotifyEvent;
    procedure setFontname(const Value: string);
    procedure setFontsize(const Value: Integer);
    procedure setStyle(const Value: TFontStyles);
    procedure setAlignment(const Value: TRVAlignment);
    procedure setFontcolor(const Value: TColor);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure SetFont(aValue: string);
    function AsString: string;
    property OnFontnameChanged: TNotifyEvent read fOnFontnameChanged write fOnFontnameChanged;
    property OnFontSizeChanged: TNotifyEvent read fOnFontSizeChanged write fOnFontSizeChanged;
    property OnFontStyleChanged: TNotifyEvent read fOnFontStyleChanged write fOnFontStyleChanged;
    property OnFontAlignmentChanged: TNotifyEvent read fOnFontAlignmentChanged write fOnFontAlignmentChanged;
    property OnFontColorChanged: TNotifyEvent read fOnFontColorChanged write fOnFontColorChanged;
  published
    property Fontname: string  read fFontname  write setFontname;
    property Fontsize: Integer read fFontsize  write setFontsize;
    property Fontcolor: TColor read fFontcolor write setFontcolor;
    property Style: TFontStyles read fStyle write setStyle;
    property Alignment: TRVAlignment read fAlignment write setAlignment;
  end;


implementation

{ TNFSRvFontObj }

constructor TNFSRvFontObj.Create;
begin
  Init;
end;

destructor TNFSRvFontObj.Destroy;
begin

  inherited;
end;

procedure TNFSRvFontObj.Init;
begin
  fFontname  := 'Arial';
  fFontsize  := 8;
  fFontcolor := clBlack;
  fStyle     := [];
  fAlignment := rvaLeft;
end;




function TNFSRvFontObj.AsString: string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Add('Name=' + fFontName);
    List.Add('Size=' + IntToStr(fFontSize));
    List.Add('Color=' + ColorToString(fFontColor));
    List.Add('Style_Bold=0');
    List.Add('Style_Italic=0');
    List.Add('Style_Underline=0');
    List.Add('Alignment_Left=0');
    List.Add('Alignment_Right=0');
    List.Add('Alignment_Center=0');
    List.Add('Alignment_Justify=0');

    if (fsBold in fStyle) then
      List.Values['Style_Bold'] := '1';
    if (fsItalic in fStyle) then
      List.Values['Style_Italic'] := '1';
    if (fsUnderline in fStyle) then
      List.Values['Style_Underline'] := '1';

    case fAlignment of
      rvaLeft:
        List.Values['Alignment_Left'] := '1';
      rvaCenter:
        List.Values['Alignment_Center'] := '1';
      rvaRight:
        List.Values['Alignment_Right'] := '1';
      rvaJustify:
        List.Values['Alignment_Justify'] := '1';
    end;

    Result := List.Text;

  finally
    FreeAndNil(List);
  end;
end;



procedure TNFSRvFontObj.SetFont(aValue: string);
var
  List: TStringList;
begin
  Init;
  if aValue = '' then
    exit;
  List := TStringList.Create;
  try
    List.Text  := aValue;
    fFontname  := List.Values['Name'];

    if not TryStrToInt(List.Values['Size'], fFontsize) then
      fFontSize := 8;

    try
      fFontcolor := StringToColor(List.Values['Color']);
    except
      fFontcolor := clBlack;
    end;

    if List.Values['Style_Bold'] = '1' then
      fStyle := Style + [fsBold];
    if List.Values['Style_Italic'] = '1' then
      fStyle := Style + [fsItalic];
    if List.Values['Style_Underline'] = '1' then
      fStyle := Style + [fsUnderline];

    if List.Values['Alignment_Left'] = '1' then
      fAlignment := rvaLeft;
    if List.Values['Alignment_Center'] = '1' then
      fAlignment := rvaCenter;
    if List.Values['Alignment_Right'] = '1' then
      fAlignment := rvaRight;
    if List.Values['Alignment_Justify'] = '1' then
      fAlignment := rvaJustify;

  finally
    FreeAndNil(List);
  end;
end;

procedure TNFSRvFontObj.setFontcolor(const Value: TColor);
begin
  fFontcolor := Value;
  if Assigned(fOnFontColorChanged) then
    fOnFontColorChanged(Self);
end;

procedure TNFSRvFontObj.setFontname(const Value: string);
begin
  fFontname := Value;
  if Assigned(fOnFontnameChanged) then
    fOnFontnameChanged(Self);
end;

procedure TNFSRvFontObj.setFontsize(const Value: Integer);
begin
  fFontsize := Value;
  if Assigned(fOnFontSizeChanged) then
    fOnFontSizeChanged(Self);
end;

procedure TNFSRvFontObj.setStyle(const Value: TFontStyles);
begin
  fStyle := Value;
  if Assigned(fOnFontStyleChanged) then
    fOnFontStyleChanged(Self);
end;

procedure TNFSRvFontObj.setAlignment(const Value: TRVAlignment);
begin
  fAlignment := Value;
  if Assigned(fOnFontAlignmentChanged) then
    fOnFontAlignmentChanged(Self);
end;


end.
