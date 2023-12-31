unit Form.Daten;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.ImgList, FMX.Objects, FMX.Layouts, Objekt.JZaehler,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  Tfrm_Daten = class(Tfrm_Base)
    Lay_Top: TLayout;
    Rect_Hosteinstellung: TRectangle;
    gly_Return: TGlyph;
    lbl_Ueberschrift: TLabel;
    gly_Add: TGlyph;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fJZaehler: TJZaehler;
    fOnAddZaehlerstand: TNotifyEvent;
    procedure Back(Sender: TObject);
    procedure AddZaehlerstand(Sender: TObject);
  public
    procedure setZaehler(aJZaehler: TJZaehler);
    property OnAddZaehlerstand: TNotifyEvent read fOnAddZaehlerstand write fOnAddZaehlerstand;
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
  gly_Add.HitTest := true;
  gly_Add.OnClick := AddZaehlerstand;
end;

procedure Tfrm_Daten.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Daten.setZaehler(aJZaehler: TJZaehler);
begin
  fJZaehler := aJZaehler;
end;

procedure Tfrm_Daten.AddZaehlerstand(Sender: TObject);
begin //
  if Assigned(fOnAddZaehlerstand) then
    fOnAddZaehlerstand(fJZaehler);
end;

procedure Tfrm_Daten.Back(Sender: TObject);
begin
  DoZurueck(Self);
end;


end.
