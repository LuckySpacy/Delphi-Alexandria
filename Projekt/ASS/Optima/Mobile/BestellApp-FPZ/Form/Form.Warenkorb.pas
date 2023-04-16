unit Form.Warenkorb;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Objects, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ImgList;

type
  Tfrm_Warenkorb = class(Tfrm_Base)
    lv: TListView;
    gly_Back: TGlyph;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure UpdateListView;
  public
    procedure setActiv; override;
  end;

var
  frm_Warenkorb: Tfrm_Warenkorb;

implementation

{$R *.fmx}


uses
  Objekt.FPZ, Objekt.Artikel;


{ Tfrm_Warenkorb }

procedure Tfrm_Warenkorb.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Back.OnClick := GoBack;
  gly_Back.HitTest := true;
end;

procedure Tfrm_Warenkorb.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Warenkorb.setActiv;
begin
  inherited;
  UpdateListView;
end;

procedure Tfrm_Warenkorb.UpdateListView;
var
  i1: Integer;
  Artikel: TArtikel;
  Item: TListViewItem;
begin
  lv.BeginUpdate;
  try
    lv.Items.Clear;
    for i1 := 0 to FPZ.ArtikelList.Count -1 do
    begin
      Artikel := FPZ.ArtikelList.Item[i1];
      Item := lv.Items.Add;
      Item.Data['Artikelnummer'] := Artikel.Nr;
      Item.Data['Artikelbezeichnung'] := Artikel.Bez;
      Item.TagObject := Artikel;
    end;

  finally
    lv.EndUpdate;
  end;
end;

end.
