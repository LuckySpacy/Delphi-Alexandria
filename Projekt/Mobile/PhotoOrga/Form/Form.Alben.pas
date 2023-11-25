unit Form.Alben;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.Controls.Presentation, FMX.Layouts, frame.Album;

type
  Tfrm_Alben = class(Tfrm_Base)
    ScrollBox: TScrollBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOnAlbumClick: TNotifyEvent;
    fAlbumList: TList;
    function AddAlbum(aPfad: string): Tfra_Album;
    procedure AlbumClick(Sender: TObject);
    procedure ZeigeAlben;
   function getLastPathName(aDirectory: string): string;
  public
    procedure setActiv; override;
    procedure LoadAlben;
    property OnAlbumClick: TNotifyEvent read fOnAlbumClick write fOnAlbumClick;
  end;

var
  frm_Alben: Tfrm_Alben;

implementation

{$R *.fmx}

{ Tfrm_Alben }

uses
  Objekt.PhotoOrga, Objekt.Alben, Objekt.Album, Objekt.Bild, Objekt.BildList, System.IOUtils;


procedure Tfrm_Alben.setActiv;
begin
  inherited;
  LoadAlben;
end;

procedure Tfrm_Alben.FormCreate(Sender: TObject);
begin
  inherited;
  fAlbumList := TList.Create;
end;

procedure Tfrm_Alben.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fAlbumList);
  inherited;
end;

procedure Tfrm_Alben.LoadAlben;
var
  i1, i2: Integer;
  Album: TAlbum;
  Bild: TBild;
  FraAlbum: Tfra_Album;
begin
  for i1 := 0 to PhotoOrga.Alben.Count -1 do
  begin
    Album :=  PhotoOrga.Alben.item[i1];
    if Album.Pfad > '' then
    begin
      fraAlbum := AddAlbum(Album.Pfad);
      Bild := TBild(Album.AlbumBilder.Items[0]);
      FraAlbum.Image.Bitmap.assign(Bild.Thumb);
      FraAlbum.lbl_Name.Text := getLastPathName(Album.Pfad);
      fraAlbum.Album := Album;
    end;
  end;
  ZeigeAlben;
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
  fAlbumList.Add(Result);
end;

procedure Tfrm_Alben.AlbumClick(Sender: TObject);
begin
  if Assigned(fonAlbumClick) then
    fOnAlbumClick(Tfra_Album(Sender).Album);
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

function Tfrm_Alben.getLastPathName(aDirectory: string): string;
var
  List: TStringList;
begin
  Result := '';
  List := TStringList.Create;
  try
    if aDirectory[Length(aDirectory)] = TPath.DirectorySeparatorChar then
      Delete(aDirectory, Length(aDirectory), 1);

    List.Delimiter := TPath.DirectorySeparatorChar;
    List.StrictDelimiter := true;
    List.DelimitedText := aDirectory;
    if List.Count > 0 then
      Result := List.Strings[List.Count-1];
  finally
    FreeAndNil(List);
  end;

end;




end.
