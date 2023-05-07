unit Frame.Bild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, types.PhotoOrga, Objekt.Bild;

type
  Tfra_Bild = class(TFrame)
    Rectangle: TRectangle;
    Image: TImage;
    procedure FrameResized(Sender: TObject);
    procedure ImageClick(Sender: TObject);
  private
    fOnBildClick: TNotifyStrEvent;
    fBild: TBild;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property OnBildClick: TNotifyStrEvent read fOnBildClick write fOnBildClick;
    property Bild: TBild read fBild write fBild;
  end;

implementation

{$R *.fmx}

{ Tfra_Bild }

constructor Tfra_Bild.Create(AOwner: TComponent);
begin //
  inherited;
 // Image.Position.X := 2;
 // Image.Position.Y := 2;
  //Image.Width := 100;
  //Image.Height := 100;
  fBild := nil;
end;

destructor Tfra_Bild.Destroy;
begin  //

  inherited;
end;

procedure Tfra_Bild.FrameResized(Sender: TObject);
begin
  //Image.Width  := Self.Width-2;
  //Image.Height := Self.Height-2;
end;

procedure Tfra_Bild.ImageClick(Sender: TObject);
begin
  if Assigned(fOnBildClick) then
    fOnBildClick(fBild.Id);
end;

end.
