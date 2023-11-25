unit tbPropButton;

interface

uses
  Classes, SysUtils, Contnrs, Buttons, Controls;



type
  TtbPropButton = class(TPersistent)
  private
    FVisible: Boolean;
    FToolButton: TSpeedButton;
    FMargins: TMargins;
    FOnChange: TNotifyEvent;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property ToolButton: TSpeedButton read FToolButton write FToolButton;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Margins: TMargins read FMargins write FMargins;
  end;




implementation

{ TtbPropButton }

constructor TtbPropButton.Create(aOwner: TComponent);
begin
  FMargins := TMargins.Create(nil);
  FMargins.OnChange := DoMarginChange;
end;

destructor TtbPropButton.Destroy;
begin
  FreeAndNil(FMargins);
  inherited;
end;

procedure TtbPropButton.DoMarginChange(Sender: TObject);
begin
  if not Assigned(FToolbutton) then
    exit;
  FToolButton.Margins.Left   := FMargins.Left;
  FToolButton.Margins.Top    := FMargins.Top;
  FToolButton.Margins.Right  := FMargins.Right;
  FToolButton.Margins.Bottom := FMargins.Bottom;
end;


procedure TtbPropButton.SetVisible(const Value: Boolean);
var
  OldValue: Boolean;
begin
  FVisible := Value;
  if Assigned(FToolButton) then
  begin
    OldValue := FToolButton.Visible;
    FToolButton.Visible := FVisible;
    if (Assigned(FOnChange)) and (OldValue <> FVisible) then
      FOnChange(Self);
  end;
end;

end.
