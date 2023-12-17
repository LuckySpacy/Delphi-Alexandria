unit Datenmodul.Bilder;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList,
  FMX.SVGIconImageList;

type
  Tdm_Bilder = class(TDataModule)
    SVGIconImageList: TSVGIconImageList;
    SVGIconImageList_Blue: TSVGIconImageList;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm_Bilder: Tdm_Bilder;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
