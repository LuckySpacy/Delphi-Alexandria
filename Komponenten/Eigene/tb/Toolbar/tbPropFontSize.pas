unit tbPropFontSize;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls, tbFontSize;


type
  TtbPropFontSize = class(TPersistent)
  private
    FPosition: Integer;
    FMargins: TMargins;
    FVisible: Boolean;
    FOnChange: TNotifyEvent;
    FFontSizeBox: TTbFontSize;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
    procedure SetPosition(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property FontSizeBox: TTbFontSize read FFontSizeBox write FFontSizeBox;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Position: Integer read FPosition write SetPosition;
    property Visible: Boolean read FVisible write SetVisible;
    property Margins: TMargins read FMargins write FMargins;
  end;


implementation

{ TtbPropFontSize }

constructor TtbPropFontSize.Create(aOwner: TComponent);
begin
  FontSizeBox := nil;
  FMargins := TMargins.Create(nil);
  FMargins.OnChange := DoMarginChange;
  FVisible := true;
end;

destructor TtbPropFontSize.Destroy;
begin
  FreeAndNil(FMargins);
  inherited;
end;

procedure TtbPropFontSize.DoMarginChange(Sender: TObject);
begin
  if not Assigned(FFontSizeBox) then
    exit;
  FFontSizeBox.Margins.Left   := FMargins.Left;
  FFontSizeBox.Margins.Top    := FMargins.Top;
  FFontSizeBox.Margins.Right  := FMargins.Right;
  FFontSizeBox.Margins.Bottom := FMargins.Bottom;
end;

procedure TtbPropFontSize.SetPosition(const Value: Integer);
begin
  if Value = FPosition then
    exit;
  FPosition := Value;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TtbPropFontSize.SetVisible(const Value: Boolean);
begin
  if not Assigned(FFontSizeBox) then
    exit;
  if FVisible = Value then
    exit;
  FVisible := Value;
  FFontSizeBox.Visible := FVisible;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
