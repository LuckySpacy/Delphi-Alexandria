unit Datenmodul.Bilder;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TBilder = class(TDataModule)
    ImageList: TImageList;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Bilder: TBilder;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
