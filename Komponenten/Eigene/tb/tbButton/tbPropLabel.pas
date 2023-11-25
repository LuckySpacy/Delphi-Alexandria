unit tbPropLabel;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls, ExtCtrls, Graphics;

type
  TtbHAlign = (tbHLeft, tbHRight, tbHNone);
  TtbVAlign = (tbVTop, tbVBottom);
  TtbHTextAlign = (tbHTextLeft, tbHTextRight, tbHTextCenter);
  TtbVTextAlign = (tbVTextTop, tbVTextBottom, tbVTextCenter);


type
  TtbPropLabel = class(TPersistent)
  private
    FHAlign: TtbHAlign;
    FVAlign: TtbVAlign;
    FHMargin: Integer;
    FVMargin: Integer;
    FCaption: string;
    FLabel  : TLabel;
    FImage  : TImage;
    FHTextAlign: TtbHTextAlign;
    FVTextAlign: TtbVTextAlign;
    FRightFromImage: Boolean;
    FFont: TFont;
    FWordwrap: Boolean;
    procedure setCaption(const Value: string);
    procedure setWidth;
    procedure setHeight;
    procedure SetHTextAlign(const Value: TtbHTextAlign);
    procedure SetVTextAlign(const Value: TtbVTextAlign);
    procedure SetHAlign(const Value: TtbHAlign);
    procedure SetVAlign(const Value: TtbVAlign);
    procedure SetHMargin(const Value: Integer);
    procedure SetVMargin(const Value: Integer);
    procedure setFont(const Value: TFont);
    procedure setWordwrap(const Value: Boolean);
  protected
  public
    destructor Destroy; override;
    constructor Create(aLabel: TLabel; aImage: TImage); reintroduce;
    procedure DoResize;
    property RightFromImage: Boolean read FRightFromImage write FRightFromImage;
  published
    property HAlign: TtbHAlign read FHAlign write SetHAlign;
    property VAlign: TtbVAlign read FVAlign write SetVAlign;
    property HMargin: Integer read FHMargin write SetHMargin;
    property VMargin: Integer read FVMargin write SetVMargin;
    property Caption: string read FCaption write setCaption;
    property HTextAlign: TtbHTextAlign read FHTextAlign write SetHTextAlign;
    property VTextAlign: TtbVTextAlign read FVTextAlign write SetVTextAlign;
    property Font: TFont read FFont write setFont;
    property Wordwrap: Boolean read FWordwrap write setWordwrap;
  end;


implementation

{ TtbPropLabel }

constructor TtbPropLabel.Create(aLabel: TLabel; aImage: TImage);
begin
  FLabel  := aLabel;
  FImage  := aImage;
  FHAlign := tbHLeft;
  FVAlign := tbVTop;
  FHMargin := 3;
  FVMargin := 0;
  FHTextAlign := tbHTextCenter;
  FVTextAlign := tbVTextCenter;
  FRightFromImage := false;
  FFont := TFont.Create;
  setWordwrap(true);
  DoResize;
end;

destructor TtbPropLabel.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

procedure TtbPropLabel.DoResize;
begin
  setWidth;
  setHeight;
  SetHTextAlign(FHTextAlign);
  SetVTextAlign(FVTextAlign);
end;

procedure TtbPropLabel.setCaption(const Value: string);
begin
  if FLabel = nil then
    exit;
  FCaption := Value;
  FLabel.Caption := Value;
  FLabel.Invalidate;
end;

procedure TtbPropLabel.setFont(const Value: TFont);
begin
  if FLabel = nil then
    exit;
  FFont.Assign(Value);
  FLabel.Font.Assign(Value);
end;

procedure TtbPropLabel.SetHAlign(const Value: TtbHAlign);
begin
  FHAlign := Value;
  DoResize;
end;

procedure TtbPropLabel.setHeight;
begin
  if FVAlign = tbVTop then
  begin
    FLabel.Top    := FVMargin;
    FLabel.Height := FLabel.Parent.Height;
  end;
  if FVAlign = tbVBottom then
  begin
    FLabel.Top    := 0;
    FLabel.Height := FLabel.Parent.Height - FVMargin;
  end;
  FLabel.Invalidate;
end;

procedure TtbPropLabel.SetHMargin(const Value: Integer);
begin
  FHMargin := Value;
  DoResize;
end;

procedure TtbPropLabel.SetHTextAlign(const Value: TtbHTextAlign);
begin
  if FLabel = nil then
    exit;
  FHTextAlign := Value;
  if Value = tbHTextLeft then
    FLabel.Alignment := taLeftJustify;
  if Value = tbHTextRight then
    FLabel.Alignment := taRightJustify;
  if Value = tbHTextCenter then
    FLabel.Alignment := taCenter;
  FLabel.Invalidate;
end;

procedure TtbPropLabel.SetVAlign(const Value: TtbVAlign);
begin
  FVAlign := Value;
  DoResize;
end;

procedure TtbPropLabel.SetVMargin(const Value: Integer);
begin
  FVMargin := Value;
  DoResize;
end;

procedure TtbPropLabel.SetVTextAlign(const Value: TtbVTextAlign);
begin
  if FLabel = nil then
    exit;
  FVTextAlign := Value;
  if Value = tbVTextTop then
    FLabel.Layout := tlTop;
  if Value = tbVTextCenter then
    FLabel.Layout := tlCenter;
  if Value = tbVTextBottom then
    FLabel.Layout := tlBottom;
end;

procedure TtbPropLabel.setWidth;
var
  ImageLeft: Integer;
begin
  if FLabel = nil then
    exit;
  if not FRightFromImage then
  begin
    if FHAlign = tbHLeft then
    begin
      FLabel.Left := FHMargin;
      FLabel.Width := FImage.Left - FLabel.Left;
      if (FImage.Left < FLabel.Left) or (not FImage.Visible) then
        FLabel.Width := FLabel.Parent.Width - FLabel.Left;
    end;
    if FHAlign = tbHRight then
    begin
      FLabel.Width := FImage.Left + FImage.Width - FLabel.Parent.Width - FHMargin;
    end;
  end;

  if FRightFromImage then
  begin
    ImageLeft := FImage.Left;
    if not FImage.Visible then
      ImageLeft := 0;
    FLabel.Left := FHMargin + ImageLeft + FImage.Width;
    FLabel.Width := FLabel.Parent.Width - FLabel.Left;
  end;

  FLabel.Invalidate;
end;

procedure TtbPropLabel.setWordwrap(const Value: Boolean);
begin
  if FLabel = nil then
    exit;
  FWordwrap := Value;
  FLabel.WordWrap := Value;
end;

end.
