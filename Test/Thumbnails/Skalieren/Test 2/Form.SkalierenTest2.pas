unit Form.SkalierenTest2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Img_Schrink: TImage;
    btn_Laden: TButton;
    Image1: TImage;
    btn_Save: TButton;
    lbl_Shrink_Width: TLabel;
    lbl_Shrink_Height: TLabel;
    procedure btn_LadenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
  private
    fPfad: string;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}



procedure TForm2.FormCreate(Sender: TObject);
begin  //
  fPfad := 'd:\Bachmann\Daten\OneDrive\Asus-PC-2018\Programmierung\Delphi\Alexandria\Test\Thumbnails\Skalieren\Test 2\';
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin  //

end;

procedure TForm2.btn_LadenClick(Sender: TObject);
begin
  Image1.Bitmap.LoadFromFile(fPfad + 'IMG_20191105_104907.jpg');
//  Img_Schrink.Bitmap.LoadFromFile(fPfad + 'IMG_20191105_104907.jpg');
  Img_Schrink.Bitmap.LoadThumbnailFromFile(fPfad + 'IMG_20191105_104907.jpg', 100, 100, false);
  lbl_Shrink_Width.Text := IntToStr(Img_Schrink.Bitmap.Width);
  lbl_Shrink_Height.Text := IntToStr(Img_Schrink.Bitmap.Height);
end;

procedure TForm2.btn_SaveClick(Sender: TObject);
begin
  Img_Schrink.Bitmap.SaveToFile(fPfad + 'a.jpg');
  Image1.Bitmap.SaveToFile(fPfad + 'b.jpg');
end;



end.
