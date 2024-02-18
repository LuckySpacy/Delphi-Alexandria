unit Datenmodul.Stylebook;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls;

type
  Tdm_Stylebook = class(TDataModule)
    StyleBook: TStyleBook;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm_Stylebook: Tdm_Stylebook;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
