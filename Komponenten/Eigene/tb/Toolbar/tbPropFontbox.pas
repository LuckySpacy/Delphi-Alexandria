unit tbPropFontbox;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls;


type
  TtbPropFontbox = class(TPersistent)
  private
    FPosition: Integer;
    FMargins: TMargins;
    FVisible: Boolean;
    FFontbox: TCombobox;
    FOnChange: TNotifyEvent;
    FWidth: Integer;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
    procedure SetPosition(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    procedure SetFontFavoriten(aFontFavList: TStrings);
    property FontBox: TCombobox read FFontbox write FFontbox;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Position: Integer read FPosition write SetPosition;
    property Visible: Boolean read FVisible write SetVisible;
    property Margins: TMargins read FMargins write FMargins;
    property Witdh: Integer read FWidth write SetWidth;
  end;


implementation

{ TtbPropFontbox }

constructor TtbPropFontbox.Create(aOwner: TComponent);
begin
  FFontbox := nil;
  FMargins := TMargins.Create(nil);
  FMargins.OnChange := DoMarginChange;
  FVisible := true;
  FWidth := 145;
end;

destructor TtbPropFontbox.Destroy;
begin
  FreeAndNil(FMargins);
  inherited;
end;

procedure TtbPropFontbox.SetFontFavoriten(aFontFavList: TStrings);
var
  i1, i2: Integer;
  SelectedFontname: string;
begin
  SelectedFontname := '';
  if FFontbox.ItemIndex > -1 then
    SelectedFontname := FFontbox.Items[FFontbox.ItemIndex];
  for i2 := 0 to aFontFavLIst.Count - 1 do
  begin
    for i1 := FFontbox.Items.Count - 1 downto 0 do
    begin
      if FFontbox.Items[i1] = aFontFavList.Strings[i2] then
      begin
        FFontbox.Items.Delete(i1);
        break;
      end;
    end;
  end;
  for i2 := aFontFavLIst.Count - 1 downto 0 do
  begin
    FFontbox.Items.Insert(0, aFontFavList.Strings[i2]);
  end;
  if SelectedFontname = '' then
    exit;
  for i1 := 0 to FFontbox.Items.Count - 1 do
  begin
    if SelectedFontname = FFontbox.Items[i1] then
    begin
      FFontbox.ItemIndex := i1;
      break;
    end;
  end;

end;


procedure TtbPropFontbox.DoMarginChange(Sender: TObject);
begin
  if not Assigned(FFontbox) then
    exit;
  FFontbox.Margins.Left   := FMargins.Left;
  FFontbox.Margins.Top    := FMargins.Top;
  FFontbox.Margins.Right  := FMargins.Right;
  FFontbox.Margins.Bottom := FMargins.Bottom;
end;


procedure TtbPropFontbox.SetPosition(const Value: Integer);
begin
  if Value = FPosition then
    exit;
  FPosition := Value;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TtbPropFontbox.SetVisible(const Value: Boolean);
begin
  if not Assigned(FFontbox) then
    exit;
  if FVisible = Value then
    exit;
  FVisible := Value;
  FFontbox.Visible := FVisible;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TtbPropFontbox.SetWidth(const Value: Integer);
begin
  if FWidth = Value then
    exit;
  FWidth := Value;
  if not Assigned(FFontbox) then
    exit;
  FFontbox.Width := FWidth;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
