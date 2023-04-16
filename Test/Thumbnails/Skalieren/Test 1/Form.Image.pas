unit Form.Image;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts;

type
  Tfrm_Image = class(TForm)
    ScrollBox1: TScrollBox;
    Img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fImageList: TList;
    fImageHeight: Integer;
    fImageWidth: Integer;
    procedure ErzeugeImages;
    procedure SetzeImages(aCols: Integer);
  public
    property ImageHeight: Integer read fImageHeight write fImageHeight;
    property ImageWidth: Integer read fImageWidth write fImageWidth;
    function ImageList: TList;
  end;

var
  frm_Image: Tfrm_Image;

implementation

{$R *.fmx}

uses
  system.IOUtils;


procedure Tfrm_Image.FormCreate(Sender: TObject);
begin //
  fImageList := TList.Create;
  fImageHeight := 100;
  fImageWidth  := 100;
  ErzeugeImages;
  SetzeImages(4);
//  Img1.
end;

procedure Tfrm_Image.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fImageList);
end;



procedure Tfrm_Image.FormShow(Sender: TObject);
begin
  //SetzeImages(4);
end;

function Tfrm_Image.ImageList: TList;
begin
  Result := fImageList;
end;

procedure Tfrm_Image.ErzeugeImages;
var
  i1: Integer;
  x: TImage;
begin
  Img1.Height := fImageHeight;
  Img1.Width  := fImageWidth;
  fImageList.Add(Img1);
  for i1 := 2 to 30 do
  begin
    x := TImage.Create(Self);
    x.Parent := ScrollBox1;
    x.Height := fImageHeight;
    x.Width  := fImageWidth;
    x.Name := 'Img' + IntToStr(i1);
    fImageList.Add(x);
  end;
end;


procedure Tfrm_Image.SetzeImages(aCols: Integer);
var
  iRow: Integer;
  iCol: Integer;
  iLeft: Integer;
  iTop : Integer;
  i1: Integer;
  x: TImage;
begin
  iLeft := 2;
  iTop  := 2;
  iCol  := 0;
  for i1 := 0 to fImageList.Count -1 do
  begin
    if iCol > aCols then
    begin
      iLeft := 2;
      iCol  := 0;
      iTop  := iTop + fImageHeight + 2;
    end;
    if iCol > 0 then
      iLeft := iLeft + fImageWidth + 2;
    x := TImage(fImageList.Items[i1]);
    x.Position.X := iLeft;
    x.Position.Y := iTop;
    inc(iCol);
  end;
end;



end.
