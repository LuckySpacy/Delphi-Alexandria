unit Prop.NFSButton;

interface

uses
  Classes, SysUtils, Contnrs, Buttons, Controls;



type
  TPropNFSButton = class(TPersistent)
  private
    fVisible: Boolean;
    fToolButton: TSpeedButton;
    fMargins: TMargins;
    fOnChange: TNotifyEvent;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property ToolButton: TSpeedButton read fToolButton write fToolButton;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  published
    property Visible: Boolean read fVisible write SetVisible;
    property Margins: TMargins read fMargins write fMargins;
  end;

implementation

{ TPropNFSButton }

constructor TPropNFSButton.Create(aOwner: TComponent);
begin
  fMargins := TMargins.Create(nil);
  fMargins.OnChange := DoMarginChange;
end;

destructor TPropNFSButton.Destroy;
begin
  FreeAndNil(fMargins);
  inherited;
end;

procedure TPropNFSButton.DoMarginChange(Sender: TObject);
begin
  if not Assigned(fToolbutton) then
    exit;
  fToolButton.Margins.Left   := fMargins.Left;
  fToolButton.Margins.Top    := fMargins.Top;
  fToolButton.Margins.Right  := fMargins.Right;
  fToolButton.Margins.Bottom := fMargins.Bottom;
end;

procedure TPropNFSButton.SetVisible(const Value: Boolean);
var
  OldValue: Boolean;
begin
  if Value <> fVisible then
    fVisible := Value;
  if Assigned(fToolButton) then
  begin
    OldValue := fToolButton.Visible;
    fToolButton.Visible := fVisible;
    if (Assigned(FOnChange)) and (OldValue <> fVisible) then
      fOnChange(Self);
  end;
end;

end.
