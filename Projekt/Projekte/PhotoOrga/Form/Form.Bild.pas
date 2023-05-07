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
    TabItem1: TTabItem;
    Img1: TImage;
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Img2: TImage;
    Img3: TImage;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    fAlbum: TAlbum;
    fIndex: Integer;
    procedure LadeBilder(aIndex: Integer);
    procedure LoadImage(aFullFilename, aOrientation: string; aImage: TImage);
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
end;

procedure Tfrm_Bild.FormDestroy(Sender: TObject);
begin //
  inherited;

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
  LadeBilder(fIndex);
end;

procedure Tfrm_Bild.LadeBilder(aIndex: Integer);
var
  Bild: TBild;
begin
  // muss überprüft werden.

  img1.Bitmap.Clear(TAlphaColors.White);
  img2.Bitmap.Clear(TAlphaColors.White);
  img3.Bitmap.Clear(TAlphaColors.White);

  if aIndex > 0 then
    Dec(aIndex);

  Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
  LoadImage(Bild.FullFilename, Bild.Orientation, Img1);

  if fAlbum.AlbumBilder.Count-1 > aIndex +1 then
    inc(aIndex);
  Bild := TBild(fAlbum.AlbumBilder.Items[aIndex]);
  LoadImage(Bild.FullFilename, Bild.Orientation, Img2);

  if fAlbum.AlbumBilder.Count-1 > aIndex +1 then
    inc(aIndex);
   Bild := TBild(fAlbum.AlbumBilder.Items[aIndex+1]);
  LoadImage(Bild.FullFilename, Bild.Orientation, Img3);

  TabControl1.ActiveTab := TabItem1;

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
      end;
    sgiRight:
      begin
        TabControl1.Previous;
        Handled := True;
      end;
  end;
end;



end.
