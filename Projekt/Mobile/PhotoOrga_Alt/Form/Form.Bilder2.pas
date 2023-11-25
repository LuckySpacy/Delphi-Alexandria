unit Form.Bilder2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.ImgList, FMX.Objects, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  DB.BilderList, DB.Bilder, types.PhotoOrga, Objekt.Bild, system.Permissions;

type
  Tfrm_Bilder2 = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    lay_ImageListBox: TLayout;
    lv: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    fDBBilderList: TDBBilderList;
    fOnBildClick: TBildClickEvent;
    {$IFDEF ANDROID}
    fOK : Boolean;
    procedure PermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
   {$ENDIF}
    function GetRootPath: string;
    procedure saveThumbnail(aBild: TBild);
   public
    procedure LadeBilder(aDir: string);
    procedure setActiv; override;
    property OnBildClick: TBildClickEvent read fOnBildClick write fOnBildClick;
  end;

var
  frm_Bilder2: Tfrm_Bilder2;

implementation

{$R *.fmx}

uses
  FMX.DialogService, Objekt.PhotoOrga, Objekt.AlbenPfadList, Objekt.AlbenPfad,


{$IFDEF ANDROID}
   Androidapi.Helpers,
   Androidapi.JNI.JavaTypes,
   Androidapi.JNI.Os,
{$ENDIF}

  System.IOUtils;



procedure Tfrm_Bilder2.FormCreate(Sender: TObject);
begin  //
  inherited;
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
  fDBBilderList := TDBBilderList.Create;
end;

procedure Tfrm_Bilder2.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fDBBilderList);
  inherited;
end;

procedure Tfrm_Bilder2.setActiv;
begin
  inherited;

end;

procedure Tfrm_Bilder2.LadeBilder(aDir: string);
  procedure LinkBitmap(Bild: TBild; aName: string; aItem: TListViewItem);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Bitmap := Bild.getBitmap;
      ListItemImage.TagObject := Bild;
      ListItemImage.ScalingMode := TImageScalingMode.StretchWithAspect;
      {
      if Bild.Orientation = 'Rotate270' then
        ListItemImage.Bitmap.Rotate(-270);
      if Bild.Orientation = 'Rotate180' then
        ListItemImage.Bitmap.Rotate(180);
        }
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
    PhotoOrga.AktBilderList := PhotoOrga.BilderList.AlbenPfad(aDir);
    if PhotoOrga.AktBilderList = nil then
      exit;
    AnzahlBilder := PhotoOrga.AktBilderList.Count;
    i1 := 0;
    while i1 < AnzahlBilder do
    begin
      Item := lv.Items.Add;
      //LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img1', Item);
      for i2 := 1 to 3 do
      begin
        if i1 < AnzahlBilder  then
        begin
          Bild := TBild(PhotoOrga.AktBilderList.Items[i1]);
          LinkBitmap(Bild, 'Img' + IntToStr(i2), Item);
        end
        else
          break;
        inc(i1);
      end;
    end;
  finally
     lv.EndUpdate;
  end;
end;

(*
procedure Tfrm_Bilder2.LadeBilder(aDir: string);
  procedure LinkBitmap(aDBBilder: TDBBilder; aName: string; aItem: TListViewItem);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Bitmap := aDBBilder.ShortBitmap;
      ListItemImage.TagObject := aDBBilder;
    end;
  end;
  {
  procedure LinkBitmap(aBitmap: TBitmap; aName: string; aItem: TListViewItem);
  var
    ListItemImage: TListItemImage;
  begin
    if (aItem.Objects.FindDrawable(aName) <> nil) then
    begin
      ListItemImage := TListItemImage(aItem.Objects.FindDrawable(aName));
      ListItemImage.Bitmap := aBitmap;
      if SameText(aName, 'Img1') then
        ListItemImage.OnSelect := BitmapSelect1;
      if SameText(aName, 'Img2') then
        ListItemImage.OnSelect := BitmapSelect2;
      if SameText(aName, 'Img3') then
        ListItemImage.OnSelect := BitmapSelect3;
      if SameText(aName, 'Img4') then
        ListItemImage.OnSelect := BitmapSelect4;
    end;
  end;
  }
var
  i1, i2: Integer;
  AnzahlBilder: Integer;
  Item: TListViewItem;
begin
  fDBBilderList.Connection := PhotoOrga.Connection;
  fDBBilderList.ReadDir(aDir);
  lv.Items.Clear;
  AnzahlBilder := fDBBilderList.Count;
  i1 := 0;
  while i1 < AnzahlBilder -1 do
  begin
    Item := lv.Items.Add;
    //LinkBitmap(fDBBilderList.Item[i1].ShortBitmap, 'Img1', Item);
    for i2 := 1 to 4 do
    begin
      if i1 < AnzahlBilder -1  then
        LinkBitmap(fDBBilderList.Item[i1], 'Img' + IntToStr(i2), Item);
      inc(i1);
    end;
    {
    inc(i1);
    if i1 < AnzahlBilder  then
      LinkBitmap(fDBBilderList.Item[i1], 'Img2', Item);
    inc(i1);
    if i1 < AnzahlBilder  then
      LinkBitmap(fDBBilderList.Item[i1], 'Img3', Item);
    inc(i1);
    if i1 < AnzahlBilder  then
      LinkBitmap(fDBBilderList.Item[i1], 'Img4', Item);
    inc(i1);
    }
  end;
end;
*)

procedure Tfrm_Bilder2.lvItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin //

end;

procedure Tfrm_Bilder2.lvItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
var
  i1: Integer;
  Bild: TBild;
begin
  //TDialogService.ShowMessage(TDBBilder(ItemObject.TagObject).Bildname);
  saveThumbnail(TBild(ItemObject.TagObject));
  if Assigned(fOnBildClick) then
  begin
    if ItemObject.TagObject <> nil then
    begin
      Bild := TBild(ItemObject.TagObject);
      fOnBildClick(Bild, 0);
    end;
  end;

  {
  if Assigned(fOnBildClick) then
  begin
    DBBilder := TDBBilder(ItemObject.TagObject);
    for i1 := 0 to fDBBilderList.Count -1 do
    begin
      if fDBBilderList.Item[i1].Id = DBBilder.Id then
      begin
        fOnBildClick(fDBBilderList, i1);
        exit;
      end;
    end;
  end;
  }
end;

procedure Tfrm_Bilder2.saveThumbnail(aBild: TBild);
var
  Pfad: string;
  Filename: string;
  List: TStringList;
  {$IFDEF ANDROID}
  p:Tarray<string>;
  {$ENDIF}
begin
  // storage/emulated/0/Documents/ThumbnailTest
  Thumbnails werden nicht richtig erzeugt.  -->  Das Erzeugen der Thumbnails muss getestet und überprüft werden.
  //Pfad := System.IOUtils.TPath.Combine(GetRootPath, 'ThumbnailTest');
  Pfad := System.IOUtils.TPath.Combine(TPath.GetSharedDocumentsPath, 'ThumbnailTest');
  if not DirectoryExists(Pfad) then
    ForceDirectories(Pfad);
  //filename := System.IOUtils.TPath.Combine(Pfad, 'Test0815.txt');
  filename := System.IOUtils.TPath.Combine(Pfad, aBild.Bildname);
  aBild.getBitmap.SaveToFile(Filename);

  {$IFDEF ANDROID}
  p:=[JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
        JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)];
   PermissionsService.RequestPermissions(p,PermissionsResult,nil);
  {$ENDIF}

  //List := TStringList.Create;
  //List.Add('Hallo Thomas');
  //List.SaveToFile(filename);
  //FreeAndNil(List);
end;

function Tfrm_Bilder2.GetRootPath: string;
var
  s: string;
  iPos: Integer;
begin
  s := System.IOUtils.TPath.GetSharedMoviesPath;
  iPos := System.SysUtils.LastDelimiter(System.IOUtils.TPath.DirectorySeparatorChar, s);
  Result := copy(s, 1, iPos);
end;

{$IFDEF ANDROID}
procedure Tfrm_Bilder2.PermissionsResult(Sender: TObject;
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

end.
