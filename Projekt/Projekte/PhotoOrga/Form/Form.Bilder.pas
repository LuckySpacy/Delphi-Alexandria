unit Form.Bilder;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.ImgList, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, Objekt.Album,
  Objekt.BildList, Objekt.Bild, FMX.Layouts, frame.BildRow, frame.Bild, types.PhotoOrga;

type
  Tfrm_Bilder = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fFrameBildRowList: TList;
    fOnBildclick: TNotifyStrObjEvent;
    fAlbum: TAlbum;
    procedure ClearAllFrameBildRow;
  public
    procedure LadeBilder(aAlbum: TAlbum);
    procedure setActiv; override;
    procedure BildClick(aValue: string);
    property OnBildClick: TNotifyStrObjEvent read fOnBildclick write fOnBildClick;
  end;

var
  frm_Bilder: Tfrm_Bilder;

implementation

{$R *.fmx}

uses
  Objekt.PhotoOrga;


procedure Tfrm_Bilder.FormCreate(Sender: TObject);
begin
  inherited;
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
  fFrameBildRowList := TList.Create;
end;

procedure Tfrm_Bilder.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fFrameBildRowList);
  inherited;
end;

procedure Tfrm_Bilder.setActiv;
begin //
  inherited;

end;


procedure Tfrm_Bilder.LadeBilder(aAlbum: TAlbum);
var
  i1: Integer;
  fraBildRow: Tfra_BildRow;
begin
  fAlbum := aAlbum;
  ClearAllFrameBildRow;
  i1 := 0;
  while i1 < aAlbum.AlbumBilder.Count -1 do
  begin
    fraBildRow := Tfra_BildRow.Create(Self);
    fraBildRow.Height := 100;
    fraBildRow.parent := ScrollBox1;
    fraBildRow.align  := TAlignLayout.Top;
    fraBildRow.LadeBilderRow(aAlbum, i1);
    fraBildRow.OnBildClick := BildClick;
    fFrameBildRowList.Add(fraBildRow);
  end;
  Self.Invalidate;

end;


procedure Tfrm_Bilder.ClearAllFrameBildRow;
var
  i1: Integer;
  x: Tfra_BildRow;
begin
  for i1 := fFrameBildRowList.Count -1 downto 0 do
  begin
    x := Tfra_BildRow(fFrameBildRowList.Items[i1]);
    FreeAndNil(x);
  end;
  fFrameBildRowList.Clear;
end;



  {
procedure Tfrm_Bilder.LadeBilder(aAlbum: TAlbum);
  procedure LinkBitmap(Bild: TBild; aName: string; aItem: TListViewItem);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Bitmap := Bild.Thumb;
      ListItemImage.TagObject := Bild;
      ListItemImage.ScalingMode := TImageScalingMode.StretchWithAspect;
    end;
  end;
var
  i1, i2: Integer;
  AnzahlBilder: Integer;
  Item: TListViewItem;
  Bild: TBild;
begin
  lv.BeginUpdate;
  try
    lv.Items.Clear;
    i2 := 0;
    if aAlbum.AlbumBilder.Count > 0 then
      Item := lv.Items.Add;
    for i1 := 0 to aAlbum.AlbumBilder.Count -1 do
    begin
      Bild := TBild(aAlbum.AlbumBilder.Items[i1]);
      inc(i2);
      if i2 = 5 then
      begin
        Item := lv.Items.Add;
        i2 := 1;
      end;
      LinkBitmap(Bild, 'Img' + i2.ToString, Item);
    end;
  finally
     lv.EndUpdate;
  end;
end;
  }


procedure Tfrm_Bilder.BildClick(aValue: string);
begin //
  if Assigned(fOnBildclick) then
    fOnBildclick(aValue, fAlbum);
end;

end.
