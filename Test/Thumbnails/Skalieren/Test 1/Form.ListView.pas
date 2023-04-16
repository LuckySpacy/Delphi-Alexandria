unit Form.ListView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  Tfrm_Listview = class(TForm)
    lv: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fBitmapList: TList;
    procedure ClearBitmapList;
  public
    procedure LadeBilder(aDir: string);
  end;

var
  frm_Listview: Tfrm_Listview;

implementation

{$R *.fmx}

uses
  System.IOUtils;

{ Tfrm_Listview }


procedure Tfrm_Listview.FormCreate(Sender: TObject);
begin
  fBitmapList := TList.Create;
end;

procedure Tfrm_Listview.FormDestroy(Sender: TObject);
begin
  ClearBitmapList;
  FreeAndNil(fBitmapList);
end;


procedure Tfrm_Listview.ClearBitmapList;
var
  i1: Integer;
  x: TBitmap;
begin
  for i1 := fBitmapList.Count -1 downto 0 do
  begin
    x := TBitmap(fBitmapList.Items[i1]);
    FreeAndNil(x);
  end;
end;


procedure Tfrm_Listview.LadeBilder(aDir: string);
  function getListViewItem(aName: string; aItem: TListViewItem): TListItemImage;
  begin
    Result := nil;
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      Result := TListItemImage(aItem.Objects.FindDrawable(aName));
    end;
  end;
var
  i1, i2: Integer;
  Files: TStringDynArray;
  AnzahlBilder: Integer;
  Item: TListViewItem;
  ListItemImage: TListItemImage;
  Bitmap: TBitmap;
begin
  ClearBitmapList;
  lv.Items.Clear;
  Files := TDirectory.GetFiles(aDir);
  AnzahlBilder := Length(Files);
  i1 := 0;
  while i1 < AnzahlBilder -1 do
  begin
    Item := lv.Items.Add;
    for i2 := 1 to 4 do
    begin
      Bitmap := TBitmap.Create;
      fBitmapList.Add(Bitmap);

      ListItemImage := getListViewItem('Img' + IntToStr(i2), Item);
      Bitmap.LoadFromFile(Files[i1]);
      ListItemImage.Bitmap := Bitmap;
      inc(i1);
      if i1 >= AnzahlBilder  then
        exit;
    end;
  end;
end;

end.
