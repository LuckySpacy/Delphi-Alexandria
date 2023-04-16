unit Datenmodul.Style;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.ImageList, FMX.ImgList;

type
  Tdm_Style = class(TDataModule)
    StyleBook: TStyleBook;
    Iml_SpeedButton: TImageList;
    iml_Icons8: TImageList;
    iml_Icons8_16x16: TImageList;
    iml_Icons8_64x64: TImageList;
    Iml_Icons8_32x32: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm_Style: Tdm_Style;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  FMX.Objects, System.UITypes;

procedure Tdm_Style.DataModuleCreate(Sender: TObject);
   {
var
  rec: TRectangle;
  i1: Integer;
   }
begin
    {
  for i1 := 0 to StyleBook.Styles.Count -1 do
  begin
    rec := TRectangle(StyleBook.Styles[i1].Style.FindStyleResource('backgroundstyle'));
    if rec <> nil then
      rec.Fill.Color := TAlphaColors.Coral;
  end;
  rec := TRectangle(StyleBook.Style.FindStyleResource('backgroundstyle'));
  if rec <> nil then
    rec.Fill.Color := TAlphaColors.Coral;
     }
end;

end.
