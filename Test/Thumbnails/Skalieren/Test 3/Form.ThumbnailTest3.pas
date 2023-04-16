unit Form.ThumbnailTest3;

interface

uses
  System.SysUtils, System.Types,  System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Permissions, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.TabControl, Objekt.ExifProperty, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Gestures;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    img_Ori: TImage;
    Button2: TButton;
    TabItem2: TTabItem;
    Img_Thumbnail: TImage;
    TabItem3: TTabItem;
    mem: TMemo;
    btn_Scale: TButton;
    TabItem4: TTabItem;
    lv: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_ScaleClick(Sender: TObject);
    procedure img_OriGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure TabItem1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    fPfad: string;
    fExifProperty : TExifProperty;
    {$IFDEF ANDROID}
    fOK : Boolean;
    procedure PermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
   {$ENDIF}
    procedure Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
    procedure LadeBildInListView;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  System.UITypes, System.IOUtils, System.Math


  {$IFDEF ANDROID}
   ,Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os,
   DW.EXIF, DW.UIHelper
{$ENDIF}
;


var
  FLastDistance: Integer;



procedure TForm2.FormCreate(Sender: TObject);
  {$IFDEF ANDROID}
var
  p:Tarray<string>;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  p:=[JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_SETTINGS),
        JStringToString(TJManifest_permission.JavaClass.CAMERA),
        JStringToString(TJManifest_permission.JavaClass.MANAGE_DOCUMENTS)];
   PermissionsService.RequestPermissions(p,PermissionsResult,nil);
  {$ENDIF}
  fExifProperty := TExifProperty.Create;
  mem.Lines.Clear;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin   //
  FreeAndNil(fExifProperty);
end;

procedure TForm2.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TImage;
  LImageCenter: TPointF;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if LObj is TImage then
    begin
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin
        { zoom the image }
        LImage := TImage(LObj.GetObject);
        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,
          LImage.Height / 2);
        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
        LImage.Position.X := LImageCenter.X - LImage.Width / 2;
        LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;
      end;
      FLastDistance := EventInfo.Distance;
    end;
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  fPfad := System.IOUtils.TPath.Combine(TPath.GetSharedDocumentsPath, 'ThumbnailTest');
end;


procedure TForm2.img_OriGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TImage;
  LImageCenter: TPointF;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if LObj is TImage then
    begin
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin
        { zoom the image }
        LImage := TImage(LObj.GetObject);
        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,
          LImage.Height / 2);
        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
        LImage.Position.X := LImageCenter.X - LImage.Width / 2;
        LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;
      end;
      FLastDistance := EventInfo.Distance;
    end;
  end;
end;

{$IFDEF ANDROID}
procedure TForm2.PermissionsResult(Sender: TObject;
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
 var
  n:integer;
 begin
  if length(AGrantResults)>0 then
   for n:=0 to length(AGrantResults)-1 do
    if not (AGrantResults[n] = TPermissionStatus.Granted) then fOK:=false;
 end;
{$ENDIF}


procedure TForm2.btn_ScaleClick(Sender: TObject);
begin
//  Img_Thumbnail.Scale.X := Img_Thumbnail.Scale.X +1;
//  Img_Thumbnail.Scale.Y := Img_Thumbnail.Scale.Y +1;
  Img_Thumbnail.Width := 100;
  Img_Thumbnail.Height := 100;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  Filename: string;
  InfoList: TStringList;
  InfoFilename: string;
begin
  Filename := System.IOUtils.TPath.Combine(fPfad, 'Hurra.jpg');
  InfoFilename := System.IOUtils.TPath.Combine(fPfad, 'BildInfo_Hurra.txt');
  fExifProperty.Load(Filename);
 // exit;
  img_Ori.Bitmap.LoadFromFile(Filename);

  {
  if fExifProperty.Orientation = 'Rotate270' then
    img_Ori.Bitmap.Rotate(-270);
  if fExifProperty.Orientation = 'Rotate180' then
    img_Ori.Bitmap.Rotate(180);
  }

  InfoList := TStringList.Create;
  try
    fExifProperty.LoadInfoToStrings(InfoList);
    InfoList.SaveToFile(InfoFilename);
  finally
    FreeAndNil(InfoList);
  end;



  mem.Lines.Add('CameraMarke = ' + fExifProperty.CameraMarke);
  mem.Lines.Add('CameraModel = ' + fExifProperty.CameraModel);
  mem.Lines.Add('Datum       = ' + fExifProperty.Datum);
  mem.Lines.Add('Latitude    =' + fExifProperty.Latitude);
  mem.Lines.Add('Longitude   =' + fExifProperty.Longitude);
  mem.Lines.Add('Altitude    =' + fExifProperty.Altitude.ToString);
  mem.Lines.Add('Orientation =' + fExifProperty.OrientationStr);

  mem.Lines.Add('Bitmap.Size.Width  := ' + IntToStr(img_Ori.Bitmap.Size.Width));
  mem.Lines.Add('Bitmap.Size.Height := ' + IntToStr(img_Ori.Bitmap.Size.Height));
  mem.Lines.Add('Bitmap.Size.cx     := ' + IntToStr(img_Ori.Bitmap.Size.cx));
  mem.Lines.Add('Bitmap.Size.cy     := ' + IntToStr(img_Ori.Bitmap.Size.cy));



end;


procedure TForm2.Button2Click(Sender: TObject);
var
  Filename: string;
  Zahl1: Integer;
  Zahl2: Integer;
begin

  Filename := System.IOUtils.TPath.Combine(fPfad, 'Test1.jpg');
  //img_Ori.Bitmap.LoadThumbnailFromFile(Filename, 100, 100, false);
  fExifProperty.Load(Filename);

  TryStrToInt(fExifProperty.Tag.ImageLength, Zahl2);
  TryStrToInt(fExifProperty.Tag.ImageWidth, Zahl1);
  Shrink2(100, Zahl1, Zahl2);
  Img_Thumbnail.Bitmap.LoadThumbnailFromFile(Filename, Zahl1, Zahl2, false);
  if fExifProperty.OrientationStr = 'Rotate270' then
    Img_Thumbnail.Bitmap.Rotate(-270);
  if fExifProperty.OrientationStr = 'Rotate180' then
    Img_Thumbnail.Bitmap.Rotate(180);
  Filename := System.IOUtils.TPath.Combine(fPfad, 'ThumbTest1.jpg');
  Img_Thumbnail.Bitmap.SaveToFile(Filename);
  LadeBildInListView;
end;



procedure TForm2.Shrink2(aShrinkValue: Integer; var aZahl1, aZahl2: Integer);
var
  Faktor: real;
begin
  if (aZahl1 < aShrinkValue) and (aZahl2 < aShrinkvalue) then
    exit;

 if (aZahl1 = aZahl2) then
 begin
   aZahl1 := aShrinkValue;
   aZahl2 := aShrinkValue;
   exit;
 end;

  if (aZahl1 > aZahl2) and (aZahl1 >= aShrinkValue) then
  begin
    Faktor  := aZahl2 / aShrinkValue;
    aZahl2  := aShrinkValue;
    aZahl1  := trunc(aZahl1 / Faktor);
  end;

  if (aZahl2 >= aZahl1) and (aZahl2 >= aShrinkValue) then
  begin
    Faktor  := aZahl1 / aShrinkValue;
    aZahl1  := aShrinkValue;
    aZahl2  := trunc(aZahl2 / Faktor);
  end;


end;



procedure TForm2.TabItem1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TImage;
  LImageCenter: TPointF;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    if LObj is TImage then
    begin
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin
        { zoom the image }
        LImage := TImage(LObj.GetObject);
        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,
          LImage.Height / 2);
        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
        LImage.Position.X := LImageCenter.X - LImage.Width / 2;
        LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;
      end;
      FLastDistance := EventInfo.Distance;
    end;
  end;
end;

procedure TForm2.LadeBildInListView;
  procedure LinkBitmap(aBitmap: TBitmap; aName: string; aItem: TListViewItem; aWidth: Single; var aXOffset: Single);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Width := aWidth;
      ListItemImage.PlaceOffset.X := aXOffset;
      ListItemImage.Bitmap := aBitmap;
      ListItemImage.ScalingMode := TImageScalingMode.Original;
      aXOffset := aXOffset + aWidth + 1;
    end;
  end;
var
  Item: TListViewItem;
  Breite: Single;
  imgWidth: Single;
  xOffset: Single;
begin
  Breite := lv.Width - lv.ItemSpaces.Left - lv.ItemSpaces.Right;
  ImgWidth := trunc(Breite/4);
  xOffset := 0;
  lv.Items.Clear;
  Item := lv.Items.Add;
  LinkBitmap(Img_Thumbnail.Bitmap, 'Img1', Item, ImgWidth, xOffset);
  LinkBitmap(Img_Thumbnail.Bitmap, 'Img2', Item, ImgWidth, xOffset);
  LinkBitmap(Img_Thumbnail.Bitmap, 'Img3', Item, ImgWidth, xOffset);
  LinkBitmap(Img_Thumbnail.Bitmap, 'Img4', Item, ImgWidth, xOffset);
end;



end.
