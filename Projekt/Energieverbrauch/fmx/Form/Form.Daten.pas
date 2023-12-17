unit Form.Daten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts;

type
  Tfrm_Daten = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure Back(Sender: TObject);
  public
  end;

var
  frm_Daten: Tfrm_Daten;

implementation

{$R *.fmx}

{ Tfrm_Daten }


procedure Tfrm_Daten.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
end;

procedure Tfrm_Daten.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Daten.Back(Sender: TObject);
begin
  DoZurueck(Self);
end;


end.
