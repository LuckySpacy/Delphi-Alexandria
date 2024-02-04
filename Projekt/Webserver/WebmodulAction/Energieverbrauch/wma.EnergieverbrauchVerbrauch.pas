unit wma.EnergieverbrauchVerbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerstandRead,
  wma.EnergieverbrauchKomplNeuBerechnen;

type
  TwmaEnergieverbrauchVerbrauch = class
  private
    fKomplNeuBerechnen: TwmaEnergieverbrauchKomplNeuBerechnen;
  public
    constructor Create;
    destructor Destroy; override;
    property KomplNeuBerechnen: TwmaEnergieverbrauchKomplNeuBerechnen read fKomplNeuBerechnen write fKomplNeuBerechnen;
  end;

implementation

{ TwmaEnergieverbrauchVerbrauch }

constructor TwmaEnergieverbrauchVerbrauch.Create;
begin
  fKomplNeuBerechnen := TwmaEnergieverbrauchKomplNeuBerechnen.Create;
end;

destructor TwmaEnergieverbrauchVerbrauch.Destroy;
begin
  FreeAndNil(fKomplNeuBerechnen);
  inherited;
end;

end.
