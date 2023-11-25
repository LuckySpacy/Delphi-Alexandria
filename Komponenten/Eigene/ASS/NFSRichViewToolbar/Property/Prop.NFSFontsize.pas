unit Prop.NFSFontsize;

interface

uses
  Classes, SysUtils, Contnrs, Controls, StdCtrls, NFSToolbarFontSize;

type
  TPropNFSFontSize = class(TPersistent)
  private
    fPosition: Integer;
    fMargins: TMargins;
    fVisible: Boolean;
    fOnChange: TNotifyEvent;
    fFontSizeBox: TNFSToolbarFontSize;
    procedure SetVisible(const Value: Boolean);
    procedure DoMarginChange(Sender: TObject);
    procedure SetPosition(const Value: Integer);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); reintroduce;
    property FontSizeBox: TNFSToolbarFontSize read fFontSizeBox write fFontSizeBox;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
    property Position: Integer read FPosition write SetPosition;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Margins: TMargins read FMargins write FMargins;
  end;


implementation

{ TPropNFSFontSize }

constructor TPropNFSFontSize.Create(aOwner: TComponent);
begin
  fFontSizeBox := nil;
  fMargins := TMargins.Create(nil);
  fMargins.OnChange := DoMarginChange;
  fVisible := true;
end;

destructor TPropNFSFontSize.Destroy;
begin
  FreeAndNil(fMargins);
  inherited;
end;

procedure TPropNFSFontSize.DoMarginChange(Sender: TObject);
begin
  if not Assigned(fFontSizeBox) then
    exit;
  fFontSizeBox.Margins.Left   := fMargins.Left;
  fFontSizeBox.Margins.Top    := fMargins.Top;
  fFontSizeBox.Margins.Right  := fMargins.Right;
  fFontSizeBox.Margins.Bottom := fMargins.Bottom;
end;

procedure TPropNFSFontSize.SetPosition(const Value: Integer);
begin
  if Value = fPosition then
    exit;
  fPosition := Value;
  //if Assigned(fOnChange) then
  //  FOnChange(Self);
end;

procedure TPropNFSFontSize.SetVisible(const Value: Boolean);
begin
  if not Assigned(fFontSizeBox) then
    exit;
  if fVisible = Value then
    exit;
  fVisible := Value;
  fFontSizeBox.Visible := fVisible;
  if Assigned(fOnChange) then
    FOnChange(Self);
end;

end.
