unit Form.ZaehlerModify;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts,
  FMX.Edit;

type
  Tfrm_ZaehlerModify = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    Layout1: TLayout;
    Label1: TLabel;
    Edit1: TEdit;
    btn_Save: TCornerButton;
    btn_Neu: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure Back(Sender: TObject);
  public
  end;

var
  frm_ZaehlerModify: Tfrm_ZaehlerModify;

implementation

{$R *.fmx}

{ Tfrm_ZaehlerModify }



procedure Tfrm_ZaehlerModify.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Return.HitTest := true;
  gly_Return.OnClick := Back;
end;

procedure Tfrm_ZaehlerModify.FormDestroy(Sender: TObject);
begin //
  inherited;

end;


procedure Tfrm_ZaehlerModify.Back(Sender: TObject);
begin
  DoZurueck(Self);

end;

end.
