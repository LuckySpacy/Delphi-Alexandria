unit Form.Bilder3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, FMX.ImgList, FMX.Objects, FMX.Layouts, types.PhotoOrga, frame.Bild,
  Objekt.fraBildList;

type
  Tfrm_Bilder3 = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    scr: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fOnBildClick: TBildClickEvent;
    fBildList: TfraBildList;
    procedure ErzeugeBilder;
    procedure SetzeBilder;
    procedure Bildgeklickt(Sender: TObject);

  public
    procedure LadeBilder(aDir: string; AMask: string = '*.*');
    procedure setActiv; override;
    property OnBildClick: TBildClickEvent read fOnBildClick write fOnBildClick;
  end;

var
  frm_Bilder3: Tfrm_Bilder3;

implementation

{$R *.fmx}

uses
  Objekt.PhotoOrga, Objekt.Bild;


procedure Tfrm_Bilder3.FormCreate(Sender: TObject);
begin  //
  inherited;
  fBildList := TfraBildList.Create;
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
end;

procedure Tfrm_Bilder3.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(fBildList);
  inherited;
end;

procedure Tfrm_Bilder3.LadeBilder(aDir, AMask: string);
begin
  PhotoOrga.AktBilderList := PhotoOrga.BilderList.AlbenPfad(aDir);
  ErzeugeBilder;
  SetzeBilder;
end;

procedure Tfrm_Bilder3.setActiv;
begin
  inherited;

end;

procedure Tfrm_Bilder3.SetzeBilder;
var
  i1: Integer;
  iTop: Integer;
  iLeft: Integer;
  iRow: Integer;
  fraBild: Tfra_Bild;
begin
  iTop := 0;
  iLeft := 0;
  iRow  := 0;
  for i1 := 0 to fBildList.Count -1 do
  begin
    fraBild := fBildList.Item[i1];
    if iRow = 4 then
    begin
      iRow := 0;
      iTop := iTop + round(fraBild.Height) + 5;
      iLeft := 0;
    end;
    fraBild.Position.X := iLeft;
    fraBild.Position.Y := iTop;
    iLeft := iLeft + round(fraBild.Width) + 5;
    inc(iRow);
  end;
end;


procedure Tfrm_Bilder3.ErzeugeBilder;
var
  i1: Integer;
  fraBild: Tfra_Bild;
  Bild: TBild;
begin
  fBildList.clear;
  for i1 := 0 to PhotoOrga.AktBilderList.Count -1 do
  begin
    fraBild := fBildList.Add;
    fraBild.Parent := scr;
    Bild := TBild(PhotoOrga.AktBilderList.Items[i1]);
    //fraBild.Img.Bitmap.Assign(Bild.getBitmap);
    fraBild.Tag := i1;
    fraBild.Bild := Bild;
    fraBild.OnBildKlick := Bildgeklickt;

    if Bild.Orientation = 'Rotate270' then
      fraBild.Img.Bitmap.Rotate(-270);
    if Bild.Orientation = 'Rotate180' then
      fraBild.Img.Bitmap.Rotate(180);

    fraBild.Img.MarginWrapMode := TImageWrapMode.Original;
    fraBild.Width := 80;
    fraBild.Height := 80;

  end;
end;

procedure Tfrm_Bilder3.Bildgeklickt(Sender: TObject);
begin
  if Assigned(fOnBildClick) then
    fOnBildClick(Tfra_Bild(Sender).Bild, Tfra_Bild(Sender).Tag);
end;



end.
