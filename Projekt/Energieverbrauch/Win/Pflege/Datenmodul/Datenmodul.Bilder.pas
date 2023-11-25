unit Datenmodul.Bilder;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Vcl.BaseImageCollection, Vcl.ImageCollection, SVGIconImageListBase,
  SVGIconImageList;

type
  Tdm_Bilder = class(TDataModule)
    Img_32: TImageList;
    ImageList1: TImageList;
    ImageCollection1: TImageCollection;
    SVGIconImageList: TSVGIconImageList;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm_Bilder: Tdm_Bilder;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
