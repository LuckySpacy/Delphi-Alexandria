unit tbToolButton;

interface

uses
  SysUtils, Classes, Controls, Buttons, Windows, Graphics;

type
  TTbToolbutton = class(TSpeedbutton)
  private
    FButtonFrameColor: TColor;
    FUseButtonFrame: Boolean;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ButtonFrameColor: TColor read FButtonFrameColor write FButtonFrameColor;
    property UseButtonFrame: Boolean read FUseButtonFrame write FUseButtonFrame;
  published
  end;


implementation

{ TTbToolbutton }

constructor TTbToolbutton.Create(AOwner: TComponent);
begin
  inherited;
  FButtonFrameColor := clSilver;
  FUseButtonFrame   := false;
end;

destructor TTbToolbutton.Destroy;
begin

  inherited;
end;

procedure TTbToolbutton.Paint;
var
  PaintRect: TRect;
begin
  inherited;
  if not FUseButtonFrame then
    exit;
  if Down then
    exit;
  PaintRect := ClientRect;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := FButtonFrameColor;
  Canvas.Rectangle(Paintrect);
end;

end.
