unit tbButton;

interface

uses
  SysUtils, Classes, Controls, Graphics, Messages,
  ExtCtrls, Windows, StdCtrls, tbPropLabel, tbPropImage;

type
  TTBButtonState = (tbBtnOver, tbBtnDown, tbBtnNone);
  TTBButton = class(TCustomControl)
  private
    FFlat: Boolean;
    FState: TTBButtonState;
    FLabel: TLabel;
    FLabelRect: TRect;
    FImageRect: TRect;
    FSelectColor: TColor;
    FDownColor: TColor;
    FMerkeLabelAlign: TAlign;
    FImage: TImage;
    FCursor: TCursor;
    FPropLabel: TtbPropLabel;
    FMemWidth: Integer;
    FMemHeight: Integer;
    FPropImage: TtbPropImage;
    FImages: TImageList;
    FImageIndex: Integer;
    FOnClick: TNotifyEvent;
    FOnRClick: TNotifyEvent;
    FIcon: TIcon;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure ButtonDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure ButtonUp(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
    //procedure AssignLabel(const Value: TLabel);
    procedure SetImageIndex(const Value: Integer);
    procedure LoadImage;
    procedure SetImages(const Value: TImageList);
    procedure ValuesChanged(Sender: TObject);
    function KeyDataToShiftState(KeyData: Longint): TShiftState;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
    procedure WMKeyUp(var Message: TMessage); message WM_KEYUP;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setIcon(aIcon: TIcon);
  published
    property Color default clBtnFace;
    property Flat: Boolean read FFlat write FFlat;
    property SelectColor: TColor read FSelectColor write FSelectColor;
    property DownColor: TColor read FDownColor write FDownColor;
    property BtnLabel: TtbPropLabel read FPropLabel write FPropLabel;
    property BtnImage: TtbPropImage read FPropImage write FPropImage;
    property Images: TImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnRClick: TNotifyEvent read FOnRClick write FOnRClick;
    property Anchors;
    property Align;
    property TabStop;
  end;

procedure Register;

implementation

uses
  Types, System.UITypes;

procedure Register;
begin
  RegisterComponents('Samples', [TTBButton]);
end;

{ TTBFarbbutton1Test }


constructor TTBButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIcon := nil;
  FPropLabel := nil;
  //ParentColor := true;
  Width := 75;
  Height := 25;
  FMemWidth  := Width;
  FMemHeight := Height;
  FFlat  := true;
  FState := tbBtnNone;
  FLabelRect.Top := 0;
  FLabelRect.Left := 0;
  FLabel := TLabel.Create(Self);
  //FLabel.SetSubComponent(True);
  FLabel.Parent := Self;
  FImage := TImage.Create(Self);
  FImage.Parent := Self;
  FImage.SetSubComponent(true);
  FImage.OnMouseDown := ButtonDown;
  FImage.OnMouseUp   := ButtonUp;
  FLabel.AutoSize  := false;
  FSelectColor := clSkyBlue;
  FDownColor   := clSkyBlue;
  FLabel.OnMouseDown := ButtonDown;
  FLabel.OnMouseUp   := ButtonUp;
  ParentColor := true;
  FPropImage := TtbPropImage.Create(FLabel, FImage);
  FPropLabel := TtbPropLabel.Create(FLabel, FImage);
  If (AOwner<>nil) And (csDesigning In ComponentState) And Not (csReading In AOwner.ComponentState) then
  begin
    FPropLabel.Caption := 'Button';
    FImages := nil;
    FImageIndex := -1;
  end;
  FImage.Center    := true;
  FImage.Height    := 16;
  FImage.Width     := 16;
  //FImage.Left      := Width - FImage.Width - 3;
  FImage.Top       := trunc(Height/2) - trunc(FImage.Height / 2);
  //FImage.Anchors   := [akTop,akRight,akBottom];
  FPropImage.OnValueChanged := ValuesChanged;
end;

destructor TTBButton.Destroy;
begin
  FreeAndNil(FLabel);
  FreeAndNil(FImage);
  FreeAndNil(FPropLabel);
  FreeAndNil(FPropImage);
  if Assigned(FIcon) then
    FreeAndNil(FIcon);
  inherited;
end;


procedure TTBButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TTBButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) and (Assigned(FOnClick)) then
    FOnClick(Self);
end;


procedure TTBButton.Paint;
var
  Rect: TRect;
  NewRect: TRect;
begin
  //inherited;

  Rect := GetClientRect;

  Canvas.Pen.Color   := Parent.Brush.Color;
  Canvas.Brush.Color := Parent.Brush.Color;

  newRect.Top := Rect.Top -1;
  newRect.Left := Rect.Left -1;
  newRect.Bottom := Rect.Bottom +1;
  newRect.Right := Rect.Right +1;

  Canvas.RoundRect(newRect, 5, 5);

  if (FState = tbBtnNone) then
  begin
    Canvas.Pen.Color := clBtnShadow;
    //Canvas.Pen.Color := Color;
    Canvas.Brush.Color := Color;
    Canvas.RoundRect(Rect, 5, 5);
  end;

  if (FState = tbBtnOver) then
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Brush.Color := FSelectColor;
    Canvas.RoundRect(Rect, 5, 5);
  end;

  if (FState = tbBtnDown) then
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Brush.Color := FDownColor;
    Canvas.RoundRect(Rect, 5, 5);
    Rect.Top := Rect.Top + 1;
    Rect.Left := Rect.Left + 1;
    Rect.Right := Rect.Right - 1;
    Rect.Bottom := Rect.Bottom - 1;
    Canvas.Pen.Color := clBtnHighlight;
    Canvas.RoundRect(Rect, 5, 5);
  end;

  if FPropLabel <> nil then
  begin
    if (FMemWidth <> Width) or (FMemHeight <> Height) then
    begin
      ValuesChanged(nil);
    end;
  end;

  FMemWidth  := Width;
  FMemHeight := Height;

  if (GetFocus = Handle) and (TabStop) then
  begin
    Rect.Left := Rect.Left + 1;
    Rect.Top := Rect.Top + 1;
    Rect.Bottom := Rect.Bottom - 1;
    Rect.Right := Rect.Right - 1;

    Canvas.DrawFocusRect(Rect);
  end;


end;




procedure TTBButton.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  LoadImage;
end;

procedure TTBButton.SetImages(const Value: TImageList);
begin
  FImages := Value;
  LoadImage;
end;

procedure TTBButton.ValuesChanged(Sender: TObject);
begin
  if FPropLabel = nil then
    exit;
  FPropLabel.RightFromImage := FPropImage.AlignLeft;
  FPropImage.DoResize;
  FPropLabel.DoResize;
end;

procedure TTBButton.Loaded;
begin
  inherited Loaded;
  if FLabel = nil then
    exit;
  FLabel.Font.Assign(FPropLabel.Font);
end;

procedure TTBButton.setIcon(aIcon: TIcon);
begin
  if Assigned(FIcon) then
    FreeAndNil(FIcon);
  FIcon := TIcon.Create;
  FIcon.Assign(aIcon);
  LoadImage;
  Invalidate;
end;


procedure TTBButton.LoadImage;
begin
  if FImage = nil then
    exit;
  if (FImages = nil) and (FImages = nil) and (FIcon <> nil) then
  begin
    FImage.Picture.Icon.Assign(FIcon);
    exit;
  end;
  if FImages = nil then
    exit;
  if FImage = nil then
    exit;
  Fimage.Visible := true;
  if FImageIndex < 0 then
    FImage.Visible := false;
  if FImageIndex > FImages.Count -1 then
    FImage.Visible := false;
  if not FImage.Visible then
    exit;
  FImages.GetIcon(FImageIndex, FImage.Picture.Icon);
end;

procedure TTBButton.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

procedure TTBButton.WMExitSizeMove(var Message: TMessage);
begin
  inherited;
  if FPropLabel = nil then
    exit;
  FPropLabel.DoResize;
end;

procedure TTBButton.WMKeyDown(var Message: TMessage);
var
  Key  : word;
  ShiftState: TShiftState;
begin
  inherited;
  Key := TWMKey(Message).CharCode;
  ShiftState := KeyDataToShiftState(TWMKey(Message).KeyData);
  KeyDown(Key, ShiftState);
end;

procedure TTBButton.WMKeyUp(var Message: TMessage);
var
  Key  : word;
  ShiftState: TShiftState;
begin
  inherited;
  Key := TWMKey(Message).CharCode;
  ShiftState := KeyDataToShiftState(TWMKey(Message).KeyData);
  KeyUp(Key, ShiftState);
end;

function TTBButton.KeyDataToShiftState(KeyData: Longint): TShiftState;
const
  AltMask = $20000000;
begin
  Result := [];
  if GetKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if KeyData and AltMask <> 0 then Include(Result, ssAlt);
end;



procedure TTBButton.WMKillFocus(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TTBButton.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  ButtonDown(Self, mbLeft, [], TWMMouse(Message).XPos, TWMMouse(Message).YPos);
end;

procedure TTBButton.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  ButtonUp(Self, mbLeft, [], TWMMouse(Message).XPos, TWMMouse(Message).YPos);
end;

procedure TTBButton.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;


procedure TTBButton.WMSetFocus(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{
procedure TTBButton.AssignLabel(const Value: TLabel);
begin
  FLabel.Assign(Value);
end;
}

procedure TTBButton.ButtonDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
var
  iLabelHeight: Integer;
  iLabelWidth : Integer;
begin
  if FImage = nil then
    exit;
  if FLabel = nil then
    exit;
  if Button = mbLeft then
  begin
    FImageRect.Top  := FImage.Top;
    FImageRect.Left := FImage.Left;
    FLabelRect.Top  := FLabel.Top;
    FLabelRect.Left := FLabel.Left;
    iLabelHeight    := FLabel.Height;
    iLabelWidth     := FLabel.Width;
    FMerkeLabelAlign := FLabel.Align;
    FLabel.Align := alNone;
    FState := tbBtnDown;
    FLabel.Top    := FLabelRect.Top + 1;
    FLabel.Left   := FLabelRect.Left + 1;
    FLabel.Width  := iLabelWidth;
    FLabel.Height := iLabelHeight;
    FLabel.Invalidate;

    FImage.Top  := FImageRect.Top + 1;
    FImage.Left := FImageRect.Left + 1;
    FImage.Invalidate;

    Paint;
  end;
end;

procedure TTBButton.ButtonUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
  if FImage = nil then
    exit;
  if FLabel = nil then
    exit;
  if Button = mbLeft then
  begin
    FState := tbBtnOver;
    FLabel.Top   := FLabelRect.Top;
    FLabel.Left  := FLabelRect.Left;
    FLabel.Align := FMerkeLabelAlign;
    FLabel.Invalidate;

    FImage.Top   := FImageRect.Top;
    FImage.Left  := FImageRect.Left;

    setFocus;
    Paint;

    if Assigned(FOnClick) then
      FOnClick(Self);
  end;

  if Button = mbRight then
  begin
    if Assigned(FOnRClick) then
      FOnRClick(Self);
  end;

end;



procedure TTBButton.CMMouseEnter(var Message: TMessage);
begin
  FState := tbBtnOver;
  inherited;
  if FLabel = nil then
    exit;
  if FImage = nil then
    exit;
  Paint;
  FLabel.Invalidate;
  FImage.Invalidate;
  FCursor := Cursor;
  Cursor := crHandPoint;
  FLabel.Cursor := crHandPoint;
end;

procedure TTBButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FLabel = nil then
    exit;
  if FImage = nil then
    exit;
  FState := tbBtnNone;
  Paint;
  FLabel.Invalidate;
  FImage.Invalidate;
  Cursor := FCursor;
end;


procedure TTBButton.CMParentColorChanged(var Message: TMessage);
begin
{
  if Message.wParam <> 0 then
    FParentColor := TColor(Message.lParam);
    }
  inherited;



end;

end.
