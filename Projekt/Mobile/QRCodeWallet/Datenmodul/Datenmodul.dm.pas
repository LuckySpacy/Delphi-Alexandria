unit Datenmodul.dm;

interface

uses
  System.SysUtils, System.Classes;

type
  Tdm = class(TDataModule)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
