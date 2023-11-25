unit NFSToolbarbutton;

interface

uses
  SysUtils, Classes, Controls, Buttons, Windows, Graphics;

type
  TNFSToolbarbutton = class(TSpeedbutton)
  private
    fButtonFrameColor: TColor;
    fUseButtonFrame: Boolean;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ButtonFrameColor: TColor read fButtonFrameColor write fButtonFrameColor;
    property UseButtonFrame: Boolean read fUseButtonFrame write fUseButtonFrame;
  published
  end;

implementation

{ TPropNFSToolbutton }

{$R Toolbar.res}

constructor TNFSToolbarbutton.Create(AOwner: TComponent);
begin
  inherited;
  fButtonFrameColor := clSilver;
  fUseButtonFrame   := false;
end;

destructor TNFSToolbarbutton.Destroy;
begin

  inherited;
end;

procedure TNFSToolbarbutton.Paint;
var
  PaintRect: TRect;
begin
  inherited;
  if not fUseButtonFrame then
    exit;
  if Down then
    exit;
  PaintRect := ClientRect;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := fButtonFrameColor;
  Canvas.Rectangle(Paintrect);
end;


end.
