unit Frame.Bild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Objekt.Bild, FMX.Controls.Presentation;

type
  Tfra_Bild = class(TFrame)
    Rectangle1: TRectangle;
    Img: TImage;
    Label1: TLabel;
    procedure ImgClick(Sender: TObject);
  private
    fOnBildKlick: TNotifyEvent;
    fBild: TBild;
  public
    property OnBildKlick: TNotifyEvent read fOnBildKlick write fOnBildKlick;
    property Bild: TBild read fBild write fBild;
  end;

implementation

{$R *.fmx}

procedure Tfra_Bild.ImgClick(Sender: TObject);
begin
  Label1.Text := intToStr(round(Height)) + ' / ' + intToStr(round(Width));
//  if Assigned(fOnBildKlick) then
//    fonBildKlick(Self);
end;



end.
