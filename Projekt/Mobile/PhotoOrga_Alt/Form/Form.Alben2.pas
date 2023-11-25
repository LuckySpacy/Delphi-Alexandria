unit Form.Alben2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, DB.Bilder, FMX.Objects, FMX.Layouts, FMX.ListBox, DB.BilderList,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Controls.Presentation;

type
  Tfrm_Alben2 = class(Tfrm_Base)
    ListBox1: TListBox;
    lb: TListBoxItem;
    Image2: TImage;
    lv: TListView;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fDBBilder: TDBBilder;
    fDBBilderList: TDBBilderList;
  public
    procedure setActiv; override;
    procedure LoadAlben;
  end;

var
  frm_Alben2: Tfrm_Alben2;

implementation

{$R *.fmx}

{ Tfrm_Alben2 }

uses
  objekt.PhotoOrga;


procedure Tfrm_Alben2.FormCreate(Sender: TObject);
begin //
  inherited;
  fDBBilder := TDBBilder.Create;
  fDBBilder.Connection := PhotoOrga.Connection;
  fDBBilderList := TDBBilderList.Create;
  fDBBilderList.Connection := PhotoOrga.Connection;
end;

procedure Tfrm_Alben2.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fDBBilder);
  FreeAndNil(fDBBilderList);
  inherited;
end;

procedure Tfrm_Alben2.setActiv;
begin
  inherited;
  Label1.Text := IntToStr(Self.Width) + ' / ' + lv.Width.ToString;
end;


procedure Tfrm_Alben2.LoadAlben;
  procedure LinkBitmap(aBitmap: TBitmap; aName: string; aItem: TListViewItem);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Bitmap := aBitmap;
    end;
  end;
var
  i1, i2: Integer;
  LI: TListBoxItem;
  TI : TImage;
  Item: TListViewItem;
  ListItemImage: TListItemImage;
  AnzahlBilder: Integer;
begin
  //fDBBilder.Read_Bild('D:\Bachmann\Daten\OneDrive\Bilder\Eigene Aufnahmen', '03407b58f76d0cf341f8c0692d08b6f1.jpg');
  //fDBBilder.LoadBildIntoBitmap(Image1.Bitmap);
  //fDBBilder.LoadBildIntoBitmap(Image2.Bitmap);
  //fDBBilderList.ReadDir('D:\Bachmann\Daten\OneDrive\Bilder\Eigene Aufnahmen');
  {
  for i1 := 0 to 5 do
  begin
    //ListBox1.Items.a
    LI := TListBoxItem (lb.clone (lb));
    for i2 := 0 to LI.ChildrenCount-1 do
    begin
      if LI.Children[i2] is TImage then
      begin
        TI := TImage (LI.Children[i2]);
        break;
      end;
    end;
    if TI <> nil then
      fDBBilderList.Item[i1].LoadBildIntoBitmap(TI.Bitmap);
  end;
  }
  //fDBBilderList.ReadDir('D:\Bachmann\Daten\OneDrive\Bilder\Eigene Aufnahmen');
  fDBBilderList.Readall;
  lv.Items.Clear;
  AnzahlBilder := 20;
  AnzahlBilder := fDBBilderList.Count;
//  Image1.Bitmap := fDBBilderList.Item[0].ShortBitmap;
//  if AnzahlBilder > 0 then
//    fDBBilderList.Item[0].LoadShortImageIntoBitmap(Image1.Bitmap);
  i1 := 0;
  while i1 < AnzahlBilder -1 do
  begin
    Item := lv.Items.Add;
    LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img1', Item);
    inc(i1);
    if i1 < AnzahlBilder -1 then
      LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img2', Item);
    inc(i1);
    if i1 < AnzahlBilder -1 then
      LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img3', Item);
    inc(i1);
    if i1 < AnzahlBilder -1 then
      LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img4', Item);
    inc(i1);
  end;

end;


end.
