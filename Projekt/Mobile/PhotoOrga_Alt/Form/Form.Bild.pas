unit Form.Bild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Form.Base, DB.BilderList, FMX.Objects, FMX.ImgList, FMX.Gestures,
  Objekt.Bild, FMX.Controls.Presentation;

type
  Tfrm_Bild = class(Tfrm_Base)
    Rec_Toolbar_Background: TRectangle;
    gly_Back: TGlyph;
    GestureManager1: TGestureManager;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
  private
    fDBBilderList: TDBBilderList;
    fItemIndex: Integer;
  public
    procedure setActiv; override;
    procedure setDBBilderList(aDBBilderList: TDBBilderList);
    procedure LadeBild(aItemIndex: Integer);
    procedure setBild(aBild: TBild);
  end;

var
  frm_Bild: Tfrm_Bild;

implementation

{$R *.fmx}

uses
  System.IOUtils, Objekt.PhotoOrga;

procedure Tfrm_Bild.FormCreate(Sender: TObject);
begin  //
  inherited;
  fDBBilderList := nil;
  gly_Back.HitTest := true;
  gly_Back.OnClick := GoBack;
  fItemIndex := 0;
end;

procedure Tfrm_Bild.FormDestroy(Sender: TObject);
begin //
  inherited;

end;

procedure Tfrm_Bild.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  caption :=  IntToStr(Integer(EventInfo.GestureID));

end;

procedure Tfrm_Bild.Image1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  //caption :=  IntToStr(Integer(EventInfo.GestureID));

  if EventInfo.GestureID = sgiLeft then
    inc(fItemIndex);
  if EventInfo.GestureID = sgiRight then
    dec(fItemIndex);
  if fItemIndex < 0 then
    fItemIndex := 0;
  if fItemIndex > PhotoOrga.AktBilderList.Count -1 then
    fItemIndex := PhotoOrga.AktBilderList.Count -1;
  LadeBild(fItemIndex);
end;

procedure Tfrm_Bild.LadeBild(aItemIndex: Integer);
var
  Filename: string;
  Bild: TBild;
begin //
//  Image1.Bitmap := fDBBilderList.Item[aItemIndex].ShortBitmap;
  //FileName := TPath.Combine(fDBBilderList.Item[aItemIndex].Pfad, fDBBilderList.Item[aItemIndex].Bildname);
  Bild := TBild(PhotoOrga.AktBilderList.items[aItemIndex]);
  Filename := TPath.Combine(Bild.Pfad, Bild.Bildname);
  Label1.Text := Bild.Datum  + ' / ' + Bild.LastWriteTimeUtc;
  Label2.Text := Bild.Orientation;
//  Label2.Text := Bild.Pfad;
//  Label3.Text := Bild.Bildname;
  Image1.Bitmap.LoadFromFile(Filename);
  if Bild.Orientation = 'Rotate270' then
    Image1.Bitmap.Rotate(-270);
  if Bild.Orientation = 'Rotate180' then
    Image1.Bitmap.Rotate(180);
  fItemIndex := aItemIndex;
end;

procedure Tfrm_Bild.setActiv;
begin
  inherited;

end;

procedure Tfrm_Bild.setBild(aBild: TBild);
var
  i1: Integer;
begin
  for i1 := 0 to PhotoOrga.AktBilderList.Count -1 do
  begin
    if TBild(PhotoOrga.AktBilderList.items[i1]).Id = aBild.Id then
    begin
      LadeBild(i1);
      exit;
    end;
  end;
end;

procedure Tfrm_Bild.setDBBilderList(aDBBilderList: TDBBilderList);
begin
  fDBBilderList := aDBBilderList;
end;

end.
