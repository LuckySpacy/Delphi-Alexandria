unit Form.Bild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Objects, FMX.TabControl, Objekt.BildList, Objekt.Bild, Objekt.Album,
  FMX.ImgList, FMX.Gestures, System.Actions, FMX.ActnList;

type
  Tfrm_Bild = class(Tfrm_Base)
    TabControl1: TTabControl;
    tab1: TTabItem;
    Img1: TImage;
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    tab2: TTabItem;
    Tab3: TTabItem;
    Img2: TImage;
    Img3: TImage;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Img1Click(Sender: TObject);
  private
    fAlbum: TAlbum;
    fIndex: Integer;
    fTabList: TList;
    fImageList: TList;
    fBereichMax: Integer;
    fBereichMin: Integer;
    procedure LadeBilder(aIndex: Integer);
    procedure LoadImage(aFullFilename, aOrientation: string; aImage: TImage);
    function getTabImage(aTag: Integer): TImage;
    function getTab(aPosition: Integer): TTabItem;
    procedure VerschiebeNachRechts;
    procedure VerschiebeNachLinks;
    procedure ErzeugeTabs(aAnzahl: Integer);
    procedure ClearImageList;
    procedure BuildImageList;
  public
    procedure setActiv; override;
    procedure LadeBild(aAlbum: TAlbum; aId: string);
  end;

var
  frm_Bild: Tfrm_Bild;

implementation

{$R *.fmx}

{ Tfrm_Bild }


procedure Tfrm_Bild.FormCreate(Sender: TObject);
begin //
  inherited;
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
  TabControl1.Touch.GestureManager := GestureManager1;
  Img1.Touch.GestureManager := GestureManager1;
  {
  fTabList.Add(tab1);
  fTabList.Add(tab2);
  fTabList.Add(tab3);

  fImageList.Add(Img1);
  fImageList.Add(Img2);
  fImageList.Add(Img3);
  }
  fTabList := TList.Create;
  fImageList := TList.Create;

end;

procedure Tfrm_Bild.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fTabList);
  FreeAndNil(fImageList);
  inherited;
end;



function Tfrm_Bild.getTab(aPosition: Integer): TTabItem;
var
  i1: Integer;
begin
  for i1 := 0 to TabControl1.TabCount -1 do
  begin
    if TabControl1.Tabs[i1].Index = aPosition then
    begin
      Result := TabControl1.Tabs[i1];
      exit;
    end;
  end;
  {
  for i1 := 0 to fTabList.count -1 do
  begin
    if TTabItem(fTabList.Items[i1]).Index = aPosition then
    begin
      Result := TTabItem(fTabList.Items[i1]);
      exit;
    end;
  end;
  }
end;

function Tfrm_Bild.getTabImage(aTag: Integer): TImage;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fImageList.count -1 do
  begin
    if TImage(fImageList.Items[i1]).Tag = aTag then
    begin
      Result := TImage(fImageList.Items[i1]);
      exit;
    end;
  end;
end;

procedure Tfrm_Bild.Img1Click(Sender: TObject);
begin
  inherited;
  TabControl1.Next;
end;

procedure Tfrm_Bild.LadeBild(aAlbum: TAlbum; aId: string);
var
  Bild: TBild;
  i1: Integer;
begin
  fAlbum := aAlbum;
  for i1 := 0 to fAlbum.AlbumBilder.Count -1 do
  begin
    Bild := TBild(aAlbum.AlbumBilder.Items[i1]);
    if Bild.Id = aId then
    begin
      fIndex := i1;
      break;
      {
      Image.Bitmap.LoadFromFile(Bild.FullFilename);
      if SameText(bild.Orientation, 'Rotate270') then
        Image.Bitmap.Rotate(-270);
      if SameText(bild.Orientation, 'Rotate180') then
        Image.Bitmap.Rotate(180);
      exit;
      }
    end;
  end;
  fBereichMax := 0;
  fBereichMin := 0;
  ErzeugeTabs(fAlbum.AlbumBilder.Count-1);
  LadeBilder(fIndex);
end;

procedure Tfrm_Bild.LadeBilder(aIndex: Integer);
var
  Bild: TBild;
  Tab: TTabItem;
  Img: TImage;
begin
  // muss überprüft werden.


  fIndex := aIndex;
  fBereichMin := fIndex - 1;
  fBereichMax := fIndex + 1;

  if fBereichMin < 0 then
    fBereichMin := 0;

  if fBereichMax > fAlbum.AlbumBilder.Count -1 then
    fBereichMax := fAlbum.AlbumBilder.Count -1;


  BuildImageList;



  exit;

  Tab := getTab(aIndex);
  Img := getTabImage(Tab.Tag);
  Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
  LoadImage(Bild.FullFilename, Bild.Orientation, Img);

  if aIndex -1 > 0 then
  begin
    Tab := getTab(aIndex-1);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex-1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;

  if aIndex +1 < fAlbum.AlbumBilder.Count then
  begin
    Tab := getTab(aIndex+1);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex+1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;


  exit;

  img1.Bitmap.Clear(TAlphaColors.White);
  img2.Bitmap.Clear(TAlphaColors.White);
  img3.Bitmap.Clear(TAlphaColors.White);


  if aIndex = 0 then
  begin
    Tab := getTab(0);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
    if fAlbum.AlbumBilder.Count > 1 then
    begin
      Tab := getTab(2);
      Img := getTabImage(Tab.Tag);
      Bild := TBild(fAlbum.AlbumBilder.Items[aIndex+1]);
      LoadImage(Bild.FullFilename, Bild.Orientation, Img);
    end;
    fIndex := aIndex;
    TabControl1.ActiveTab := getTab(0);
    exit;
  end;

  if aIndex = fAlbum.AlbumBilder.Count -1 then
  begin
    Tab := getTab(2);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
    if fAlbum.AlbumBilder.Count > 1 then
    begin
      Tab := getTab(1);
      Img := getTabImage(Tab.Tag);
      Bild := TBild(fAlbum.AlbumBilder.Items[aIndex-1]);
      LoadImage(Bild.FullFilename, Bild.Orientation, Img);
    end;
    fIndex := aIndex;
    TabControl1.ActiveTab := getTab(2);
    exit;
  end;

  if aIndex < fAlbum.AlbumBilder.Count -1 then
  begin
    Tab := getTab(4);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex+1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;

  if aIndex -1 > 0 then
  begin
    Tab := getTab(2);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[aIndex-1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;


  Tab := getTab(3);
  Img := getTabImage(Tab.Tag);
  Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
  LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  fIndex := aIndex;
  TabControl1.ActiveTab := Tab;

end;

procedure Tfrm_Bild.LoadImage(aFullFilename, aOrientation: string; aImage: TImage);
begin
  aImage.Bitmap.LoadFromFile(aFullFilename);
  if SameText(aOrientation, 'Rotate270') then
    aImage.Bitmap.Rotate(-270);
  if SameText(aOrientation, 'Rotate180') then
    aImage.Bitmap.Rotate(180);
end;

procedure Tfrm_Bild.setActiv;
begin
  inherited;

end;

procedure Tfrm_Bild.TabControl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        //if NextTabAction.Enabled then
          TabControl1.Next;
        Handled := True;
        VerschiebeNachRechts;
      end;
    sgiRight:
      begin
        TabControl1.Previous;
        Handled := True;
        VerschiebeNachLinks;
      end;
  end;
end;



procedure Tfrm_Bild.VerschiebeNachLinks;
var
  tab: TTabItem;
  Img: TImage;
  Bild: TBild;
  i1: Integer;
  MyIndex: Integer;
begin

  if fIndex > 0 then
    Dec(fIndex);


  LadeBilder(fIndex);
  exit;

  if fIndex > 0 then
  begin
    Tab := getTab(fIndex-1);
    Img := getTabImage(Tab.tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[fIndex-1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;

  exit;
  if fIndex = 0 then
    exit;

  Dec(fIndex);

  if fIndex = 0 then
  begin
    TabControl1.ActiveTab.Index := 0;
    exit;
  end;

  Tab := getTab(4);
  Tab.Index := 0;
  MyIndex := fIndex;

  for i1 := TabControl1.ActiveTab.Index - 1 downto 0 do
  begin
    dec(myIndex);
    if MyIndex < 0 then
      exit;
    Tab := getTab(i1+1);
    Img := getTabImage(Tab.tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[myIndex]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;

end;




procedure Tfrm_Bild.VerschiebeNachRechts;
var
  tab: TTabItem;
  Img: TImage;
  Bild: TBild;
  i1: Integer;
  MyIndex: Integer;
begin
  if fIndex +1 > fAlbum.AlbumBilder.Count -1 then
    exit;
  inc(fIndex);
  LadeBilder(fIndex);

  exit;

  if fIndex + 1 < fAlbum.AlbumBilder.Count then
  begin
    Tab := getTab(fIndex+1);
    Img := getTabImage(Tab.Tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[fIndex +1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;



  exit;
  MyIndex := fIndex;
  if fIndex + 1 > fAlbum.AlbumBilder.Count -1 then
    exit;
  if (TabControl1.ActiveTab.Index > 1) and (fIndex < fAlbum.AlbumBilder.Count -1) then
  begin
    Tab := getTab(1);
    Tab.Index := 3;
  end;
  for i1 := TabControl1.ActiveTab.Index + 1 to 3 do
  begin
    inc(myIndex);
    if myIndex > fAlbum.AlbumBilder.Count -1 then
      exit;
    Tab := getTab(i1+1);
    Img := getTabImage(Tab.tag);
    Bild := TBild(fAlbum.AlbumBilder.Items[myIndex]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;
end;


procedure Tfrm_Bild.BuildImageList;
var
  i1: Integer;
  Img: TImage;
  TabItem: TTabItem;
  AktivTabItem: TTabItem;
  Bild : TBild;
begin
  ClearImageList;
  for i1 := fBereichMin to fBereichMax do
  begin
    TabItem := getTab(i1);
    if i1 = fIndex then
      AktivTabItem := TabItem;
    Img := getTabImage(i1);
    if Img <> nil then
    begin
      Bild := TBild(fAlbum.AlbumBilder.Items[i1]);
      LoadImage(Bild.FullFilename, Bild.Orientation, Img);
      continue;
    end;
    Img := TImage.Create(TabItem);
    Img.Parent := TabItem;
    Img.Align := TAlignLayout.Client;
    Img.Tag   := TabItem.Tag;
    Img.OnGesture := TabControl1Gesture;
    Img.Touch.GestureManager := GestureManager1;
    Img.Touch.StandardGestures := [TStandardGesture.sgLeft, TStandardGesture.sgRight];
    fImageList.Add(Img);
    Bild := TBild(fAlbum.AlbumBilder.Items[i1]);
    LoadImage(Bild.FullFilename, Bild.Orientation, Img);
  end;

  TabControl1.ActiveTab := AktivTabItem;


end;

procedure Tfrm_Bild.ClearImageList;
var
  i1: Integer;
  Img: TImage;
begin
  for i1 := fImageList.Count -1 downto 0 do
  begin
    Img := TImage(fImageList.Items[i1]);
    if fIndex = Img.Tag then
      continue;
    FreeAndNil(Img);
    fImageList.Delete(i1);
  end;
  //fImageList.Clear;
end;

procedure Tfrm_Bild.ErzeugeTabs(aAnzahl: Integer);
var
  i1: Integer;
  x: TTabItem;
  Img: TImage;
begin
  fImageList.Clear;
  for i1 := TabControl1.TabCount -1 downto 0 do
  begin
    x := TabControl1.Tabs[i1];
    FreeAndNil(x);
  end;
  for i1 := 0 to aAnzahl do
  begin
    x := TabControl1.Add;
    x.Tag := i1;
    //x.OnGesture := TabControl1Gesture;
    //x.Touch.GestureManager := GestureManager1;
    {
    Img := TImage.Create(x);
    Img.Parent := x;
    Img.Align := TAlignLayout.Client;
    Img.Tag   := x.Tag;
    Img.OnGesture := TabControl1Gesture;
    Img.Touch.GestureManager := GestureManager1;
    Img.Touch.StandardGestures := [TStandardGesture.sgLeft, TStandardGesture.sgRight];
    //Img.OnClick := Img1Click;
    fImageList.Add(Img);
    }
  end;
end;


end.
