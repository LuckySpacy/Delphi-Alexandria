unit Prop.NFSFontbox;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls;


type
  TPropNFSFontbox = class(TPersistent)
  private
    fPosition: Integer;
    fMargins: TMargins;
    fVisible: Boolean;
    fFontbox: TCombobox;
    fOnChange: TNotifyEvent;
    fWidth: Integer;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
    procedure SetPosition(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    procedure SetFontFavoriten(aFontFavList: TStrings);
    property FontBox: TCombobox read fFontbox write fFontbox;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
    property Position: Integer read fPosition write SetPosition;
  published
    property Visible: Boolean read fVisible write SetVisible;
    property Margins: TMargins read fMargins write FMargins;
    property Witdh: Integer read fWidth write SetWidth;
  end;


implementation

{ TPropNFSFontbox }

constructor TPropNFSFontbox.Create(aOwner: TComponent);
begin
  fFontbox := nil;
  fMargins := TMargins.Create(nil);
  fMargins.OnChange := DoMarginChange;
  fVisible := true;
  fWidth := 145;
end;

destructor TPropNFSFontbox.Destroy;
begin
  FreeAndNil(fMargins);
  inherited;
end;

procedure TPropNFSFontbox.SetFontFavoriten(aFontFavList: TStrings);
var
  i1, i2: Integer;
  SelectedFontname: string;
begin
  SelectedFontname := '';
  if fFontbox.ItemIndex > -1 then
    SelectedFontname := fFontbox.Items[fFontbox.ItemIndex];
  for i2 := 0 to aFontFavLIst.Count - 1 do
  begin
    for i1 := fFontbox.Items.Count - 1 downto 0 do
    begin
      if fFontbox.Items[i1] = aFontFavList.Strings[i2] then
      begin
        fFontbox.Items.Delete(i1);
        break;
      end;
    end;
  end;
  for i2 := aFontFavLIst.Count - 1 downto 0 do
  begin
    fFontbox.Items.Insert(0, aFontFavList.Strings[i2]);
  end;
  if SelectedFontname = '' then
    exit;
  for i1 := 0 to fFontbox.Items.Count - 1 do
  begin
    if SelectedFontname = fFontbox.Items[i1] then
    begin
      fFontbox.ItemIndex := i1;
      break;
    end;
  end;
end;


procedure TPropNFSFontbox.DoMarginChange(Sender: TObject);
begin
  if not Assigned(fFontbox) then
    exit;
  fFontbox.Margins.Left   := fMargins.Left;
  fFontbox.Margins.Top    := fMargins.Top;
  fFontbox.Margins.Right  := fMargins.Right;
  fFontbox.Margins.Bottom := fMargins.Bottom;
end;


procedure TPropNFSFontbox.SetPosition(const Value: Integer);
begin
  if Value = fPosition then
    exit;
  fPosition := Value;
 // if Assigned(fOnChange) then
 //   FOnChange(Self);
end;


procedure TPropNFSFontbox.SetVisible(const Value: Boolean);
begin
  if not Assigned(fFontbox) then
    exit;
  if fVisible = Value then
    exit;
  fVisible := Value;
  fFontbox.Visible := fVisible;
  if Assigned(fOnChange) then
    FOnChange(Self);
end;

procedure TPropNFSFontbox.SetWidth(const Value: Integer);
begin
  if fWidth = Value then
    exit;
  fWidth := Value;
  if not Assigned(fFontbox) then
    exit;
  fFontbox.Width := fWidth;
  if Assigned(fOnChange) then
    FOnChange(Self);
end;

end.
