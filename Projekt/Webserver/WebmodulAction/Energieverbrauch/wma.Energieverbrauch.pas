unit wma.Energieverbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehler,
  wma.EnergieverbrauchZaehlerstand;

type
  TwmaEnergieverbrauch = class
  private
    fZaehler: TwmaEnergieverbrauchZaehler;
    fZaehlerstand: TwmaEnergieverbrauchZaehlerstand;
  public
    constructor Create;
    destructor Destroy; override;
    property Zaehler: TwmaEnergieverbrauchZaehler read fZaehler write fZaehler;
    property Zaehlerstand: TwmaEnergieverbrauchZaehlerstand read fZaehlerstand write fZaehlerstand;
  end;

implementation

{ TwmaEnergieverbrauch }

constructor TwmaEnergieverbrauch.Create;
begin
  fZaehler := TwmaEnergieverbrauchZaehler.Create;
  fZaehlerstand := TwmaEnergieverbrauchZaehlerstand.Create;
end;

destructor TwmaEnergieverbrauch.Destroy;
begin
  FreeAndNil(fZaehler);
  FreeAndNil(fZaehlerstand);
  inherited;
end;

end.
