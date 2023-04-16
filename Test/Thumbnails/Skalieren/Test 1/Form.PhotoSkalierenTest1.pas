unit Form.PhotoSkalierenTest1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, Form.Image, fmx.Objects, Objekt.PhotoShrink,
  FMX.TabControl, Form.ListView;

type
  Tfrm_PhotoSkalieren = class(TForm)
    Panel1: TPanel;
    btn_Laden: TButton;
    btn_Shrink: TButton;
    TabControl1: TTabControl;
    tbs_Image: TTabItem;
    tbs_Listview: TTabItem;
    btn_LadeListview: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_LadenClick(Sender: TObject);
    procedure btn_ShrinkClick(Sender: TObject);
    procedure btn_LadeListviewClick(Sender: TObject);
  private
    fFormImage: Tfrm_Image;
    fFormListview: Tfrm_ListView;
    fPhotoShrink: TPhotoShrink;
  public
  end;

var
  frm_PhotoSkalieren: Tfrm_PhotoSkalieren;

implementation

{$R *.fmx}

uses
  system.IOUtils;






procedure Tfrm_PhotoSkalieren.FormCreate(Sender: TObject);
begin //
  fFormImage := Tfrm_Image.Create(Self);
  while fFormImage.ChildrenCount > 0 do
    fFormImage.Children[0].Parent := tbs_Image;

  fFormListview := Tfrm_Listview.Create(Self);
  while fFormListview.ChildrenCount > 0 do
    fFormListview.Children[0].Parent := tbs_Listview;


  fPhotoShrink := TPhotoShrink.Create;
end;

procedure Tfrm_PhotoSkalieren.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fPhotoShrink);
end;


procedure Tfrm_PhotoSkalieren.btn_LadeListviewClick(Sender: TObject);
begin
  TabControl1.ActiveTab := tbs_Listview;
  fFormListview.LadeBilder('d:\Bachmann\Daten\OneDrive\Asus-PC-2018\Programmierung\Delphi\Alexandria\Test\Thumbnails\Skalieren\Test 1\Shrink\');
end;

procedure Tfrm_PhotoSkalieren.btn_LadenClick(Sender: TObject);
var
  i1: Integer;
  List: TList;
  x: TImage;
  Pfad: string;
  Files: TStringDynArray;
  AnzahlBilder: Integer;
  Bitmap: TBitmap;
begin
  //Pfad := system.IOUtils.TPath.GetHomePath;
  //Pfad := system.IOUtils.TPath.Combine(Pfad, 'Bild');
  Pfad := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Programmierung\Delphi\Alexandria\Test\Thumbnails\Skalieren\Test 1\Shrink\';
  if not DirectoryExists(Pfad) then
    exit;
  Files := TDirectory.GetFiles(Pfad);
  AnzahlBilder := Length(Files);
  List := fFormImage.ImageList;
  for i1 := 0 to List.count -1 do
  begin
    x := TImage(List.Items[i1]);
    if i1 < AnzahlBilder -1 then
      x.Bitmap.LoadFromFile(Files[i1]);

  end;

end;


procedure Tfrm_PhotoSkalieren.btn_ShrinkClick(Sender: TObject);
var
  i1: Integer;
  Quelle: string;
  Ziel: string;
  Files: TStringDynArray;
  AnzahlBilder: Integer;
  iWidth, iHeight: Integer;
begin
  Quelle := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Programmierung\Delphi\Alexandria\Test\Thumbnails\Skalieren\Test 1\Bild\';
  Ziel   := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Programmierung\Delphi\Alexandria\Test\Thumbnails\Skalieren\Test 1\Shrink\';
  if not DirectoryExists(Quelle) then
    exit;
  Files := TDirectory.GetFiles(Quelle);
  AnzahlBilder := Length(Files);
  for i1 := 0 to AnzahlBilder -1 do
  begin
    fPhotoShrink.DoIt(Files[i1], Ziel, 100);
  end;
end;




end.
