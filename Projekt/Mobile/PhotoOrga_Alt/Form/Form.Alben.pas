unit Form.Alben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, Frame.Album,
  Form.Base, DB.BilderList, DB.Bilder, FMX.Gestures;

type
  Tfrm_Alben = class(Tfrm_Base)
    ScrollBox: TScrollBox;
    GestureManager1: TGestureManager;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ScrollBoxGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    fAlbumList: TList;
    fOnAlbumClick: TNotifyEvent;
    fDBBilderList: TDBBilderList;
    function getLastPathName(aDirectory: string): string;
    function AddAlbum(aPfad: string): Tfra_Album;
    procedure ZeigeAlben;
    procedure SearchFiles(aDir: string);
    procedure SearchDirectories(aDir: string);
    procedure AlbumClick(Sender: TObject);
  public
    procedure setActiv; override;
    procedure LoadAlben;
    property OnAlbumClick: TNotifyEvent read fOnAlbumClick write fOnAlbumClick;
  end;

var
  frm_Alben: Tfrm_Alben;

implementation

{$R *.fmx}

uses
  System.IOUtils, Objekt.PhotoOrga, Objekt.Bild, FMX.DialogService;



procedure Tfrm_Alben.FormCreate(Sender: TObject);
begin //
  fAlbumList := TList.Create;
  fDBBilderList := TDBBilderList.Create;
end;


procedure Tfrm_Alben.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fAlbumList);
  FreeAndNil(fDBBilderList);
end;

procedure Tfrm_Alben.setActiv;
begin
  inherited;
  LoadAlben;
end;


procedure Tfrm_Alben.FormResize(Sender: TObject);
begin
  ZeigeAlben;
end;

procedure Tfrm_Alben.FormShow(Sender: TObject);
begin
//  LoadAlben;
end;


{
procedure Tfrm_Alben.LoadAlben;
var
  i1: Integer;
  Album: Tfra_Album;
begin
  fDBBilderList.Connection := PhotoOrga.Connection;
  fDBBilderList.Read_DirList;
  for i1 := 0 to fDBBilderList.Count -1 do
  begin
    Album := AddAlbum;
    fAlbumList.Add(Album);
    Album.Image.Bitmap := fDBBilderList.Item[i1].ShortBitmap;
    Album.Pfad := fDBBilderList.Item[i1].Pfad;
    Album.lbl_Name.Text := getLastPathName(fDBBilderList.Item[i1].Pfad);
    Album.OnAlbumClick := AlbumClick;
  end;
  ZeigeAlben;
end;
}

procedure Tfrm_Alben.LoadAlben;
var
  i1, i2: Integer;
  List: TList;
  Album: Tfra_Album;
  Bild: TBild;
  AnzahlAlbenPfadList: Integer;
  AlbumVorhanden: Boolean;
begin
  //PhotoOrga.sendNotification('PhotoOrga.BilderList.AlbenPfadList.Count=' + PhotoOrga.BilderList.AlbenPfadList.Count.ToString);
  AnzahlAlbenPfadList := PhotoOrga.BilderList.AlbenPfadList.Count;
  for i1 := 0 to AnzahlAlbenPfadList -1 do
  begin

    List := PhotoOrga.BilderList.AlbenPfadList.Item[i1].List;
    if List.Count <= 0 then
      continue;
    Bild := TBild(List.Items[0]);
    AlbumVorhanden := false;
    for i2 := 0 to fAlbumList.Count -1 do
    begin
      if Tfra_Album(fAlbumList.Items[i2]).Pfad = PhotoOrga.BilderList.AlbenPfadList.item[i1].pfad then
      begin
        AlbumVorhanden := true;
        break;
      end;
    end;
    if AlbumVorhanden then
      continue;
    Album := AddAlbum(PhotoOrga.BilderList.AlbenPfadList.item[i1].pfad);
    fAlbumList.Add(Album);
    Album.Image.Bitmap.Assign(Bild.getBitmap);

    if Bild.Orientation = 'Rotate270' then
      Album.Image.Bitmap.Rotate(-270);
    if Bild.Orientation = 'Rotate180' then
      Album.Image.Bitmap.Rotate(180);

    //Bild.setBitmap(Album.Image.Bitmap);
    Album.Pfad := Bild.Pfad;
    Album.lbl_Name.Text := getLastPathName(Bild.Pfad);
  end;
  ZeigeAlben;
end;

(*
procedure Tfrm_Alben.LoadAlben;
var
  s: string;
begin
  s := TPath.GetCameraPath;
  SearchDirectories(s);
  s := TPath.GetSharedCameraPath;
  SearchDirectories(s);

  {$IFDEF ANDROID}
  S := TPath.GetPicturesPath;
  SearchDirectories(s);
  S := TPath.GetSharedPicturesPath;
  SearchDirectories(s);
  {$ENDIF ANDROID}


  ZeigeAlben;
end;
*)


procedure Tfrm_Alben.ScrollBoxGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  //Caption := 'Hurra';
end;

procedure Tfrm_Alben.SearchDirectories(aDir: string);
  procedure SearchSubDir(aDir: string);
  var
    i1: Integer;
    dirList: TStringDynArray;
  begin
    dirList := TDirectory.GetDirectories(aDir);
    for i1 := 0 to Length(dirList) -1 do
    begin
      SearchFiles(dirList[i1]);
      SearchSubDir(dirList[i1]);
    end;
  end;
begin
  SearchFiles(aDir);
  SearchSubDir(aDir);
end;


procedure Tfrm_Alben.SearchFiles(aDir: string);
var
  i1: Integer;
  Filename: string;
  Files: TStringDynArray;
  Ext: string;
  Album: Tfra_Album;
begin
  Files := TDirectory.GetFiles(aDir);
  for i1 := 0 to Length(Files) -1 do
  begin
    Filename := Files[i1];
    Ext := ExtractFileExt(Filename);
    if SameText('.jpg', Ext) then
    begin
      Album := AddAlbum(aDir);
      fAlbumList.Add(Album);
      Album.Image.Bitmap.LoadThumbnailFromFile(Filename, Album.Image.Width, Album.Image.Height);
      Album.Pfad := aDir;
      Album.lbl_Name.Text := getLastPathName(aDir);
      break;
    end;
  end;
end;



function Tfrm_Alben.AddAlbum(aPfad: string): Tfra_Album;
begin
  Result := Tfra_Album.Create(Self);
  Result.Name := 'Album_' + IntToStr(fAlbumList.Count);
  Result.Parent := Scrollbox;
  Result.Position.X := 5;
  Result.Position.Y := 5;
  Result.OnAlbumClick := AlbumClick;
  Result.Pfad := aPfad;
end;

function Tfrm_Alben.getLastPathName(aDirectory: string): string;
var
  List: TStringList;
begin
  Result := '';
  List := TStringList.Create;
  try
    List.Delimiter := TPath.DirectorySeparatorChar;
    List.StrictDelimiter := true;
    List.DelimitedText := aDirectory;
    if List.Count > 0 then
      Result := List.Strings[List.Count-1];
  finally
    FreeAndNil(List);
  end;

end;



procedure Tfrm_Alben.ZeigeAlben;
var
  i1: Integer;
  Album: Tfra_Album;
  iLeftPos: Integer;
  iTopPos: Integer;
  iCheck: Integer;
  AlbumWidth: Integer;
  AlbumHeight: Integer;
begin
  if fAlbumList.Count = 0 then
    exit;

  AlbumWidth  := trunc(Tfra_Album(fAlbumList.List[0]).Width);
  AlbumHeight := trunc(Tfra_Album(fAlbumList.List[0]).Height);
  iTopPos := 0;
  //AlbumWidth  := 640;
  //AlbumHeight := 480;

  iLeftPos := MaxInt - AlbumWidth - 1000;

  for i1 := 0 to fAlbumList.Count -1 do
  begin
    Album := Tfra_Album(fAlbumList.List[i1]);
    iLeftPos := iLeftPos + AlbumWidth + 5;
    iCheck := iLeftPos + AlbumWidth + 5;
    if iCheck > ScrollBox.Width then
    begin
      iLeftPos := 5;
      if iTopPos = 0 then
        iTopPos := 3
      else
        iTopPos := iTopPos + AlbumHeight + 3;
    end;
    Album.position.X := iLeftPos;
    Album.Position.Y := iTopPos;
    Album.Repaint;
  end;
  Self.Invalidate;

end;



procedure Tfrm_Alben.AlbumClick(Sender: TObject);
begin
  if Assigned(fonAlbumClick) then
    fOnAlbumClick(Sender);
end;





procedure Tfrm_Alben.Button1Click(Sender: TObject);
var
  DBBilderList: TDBBilderList;
begin
  DBBilderList := TDBBilderList.Create;
  try
    DBBilderList.Connection := PhotoOrga.Connection;
    DBBilderList.ReadAllToBilderList;
  finally
    FreeAndNil(DBBilderList);
  end;
  TDialogService.ShowMessage(PhotoOrga.BilderList.AlbenPfadList.count.tostring);
end;

end.
