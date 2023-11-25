unit tbPropImage;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls, ExtCtrls, Graphics;

type
  TtbPropImage = class(TPersistent)
  private
    FLabel  : TLabel;
    FImage  : TImage;
    FAlignLeft: Boolean;
    FAlignRight: Boolean;
    FMargin: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FOnValueChanged: TNotifyEvent;
    procedure setAlignLeft(const Value: Boolean);
    procedure setAlignRight(const Value: Boolean);
    procedure setMargin(const Value: Integer);
    procedure setHeight(const Value: Integer);
    procedure setWidth(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aLabel: TLabel; aImage: TImage); reintroduce;
    procedure DoResize;
    property OnValueChanged: TNotifyEvent read FOnValueChanged write FOnValueChanged;
  published
    property AlignLeft: Boolean read FAlignLeft write setAlignLeft;
    property AlignRight: Boolean read FAlignRight write setAlignRight;
    property Margin: Integer read FMargin write setMargin;
    property Height: Integer read FHeight write setHeight;
    property Width: Integer read FWidth write setWidth;
  end;



implementation

{ TtbPropImage }

constructor TtbPropImage.Create(aLabel: TLabel; aImage: TImage);
begin
  FLabel  := aLabel;
  FImage  := aImage;
  FMargin := 10;
  FAlignRight := false;
  FAlignLeft  := true;
  FHeight     := 16;
  FWidth      := 16;
end;

destructor TtbPropImage.Destroy;
begin

  inherited;
end;

procedure TtbPropImage.DoResize;
begin
  if FImage = nil then
    exit;
  FImage.Width  := FWidth;
  FImage.Height := FHeight;
  if FAlignLeft then
  begin
    FImage.Left := FMargin;
  end;
  if FAlignRight then
  begin
    FImage.Left := FImage.Parent.Width - FImage.Width - FMargin;
  end;

  FImage.Top := trunc(FImage.Parent.Height / 2) - trunc(FImage.Height /2);

end;

procedure TtbPropImage.setAlignLeft(const Value: Boolean);
begin
  FAlignLeft := Value;
  if Value then
    FAlignRight := false;
  if Assigned(FOnValueChanged) then
    FOnValueChanged(Self);
end;

procedure TtbPropImage.setAlignRight(const Value: Boolean);
begin
  FAlignRight := Value;
  if Value then
    FAlignLeft := false;
  if Assigned(FOnValueChanged) then
    FOnValueChanged(Self);
end;

procedure TtbPropImage.setHeight(const Value: Integer);
begin
  FHeight := Value;
  if Assigned(FOnValueChanged) then
    FOnValueChanged(Self);
end;

procedure TtbPropImage.setMargin(const Value: Integer);
begin
  FMargin := Value;
  if Assigned(FOnValueChanged) then
    FOnValueChanged(Self);
end;

procedure TtbPropImage.setWidth(const Value: Integer);
begin
  FWidth := Value;
  if Assigned(FOnValueChanged) then
    FOnValueChanged(Self);
end;

end.
