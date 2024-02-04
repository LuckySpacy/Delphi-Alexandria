unit wma.Energieverbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehler,
  wma.EnergieverbrauchZaehlerstand, wma.EnergieverbrauchVerbrauch;

type
  TwmaEnergieverbrauch = class
  private
    fZaehler: TwmaEnergieverbrauchZaehler;
    fZaehlerstand: TwmaEnergieverbrauchZaehlerstand;
    fVerbrauch: TwmaEnergieverbrauchVerbrauch;
  public
    constructor Create;
    destructor Destroy; override;
    property Zaehler: TwmaEnergieverbrauchZaehler read fZaehler write fZaehler;
    property Zaehlerstand: TwmaEnergieverbrauchZaehlerstand read fZaehlerstand write fZaehlerstand;
    property Verbrauch: TwmaEnergieverbrauchVerbrauch read fVerbrauch write fVerbrauch;
  end;

implementation

{ TwmaEnergieverbrauch }

constructor TwmaEnergieverbrauch.Create;
begin
  fZaehler := TwmaEnergieverbrauchZaehler.Create;
  fZaehlerstand := TwmaEnergieverbrauchZaehlerstand.Create;
  fVerbrauch    := TwmaEnergieverbrauchVerbrauch.Create;
end;

destructor TwmaEnergieverbrauch.Destroy;
begin
  FreeAndNil(fZaehler);
  FreeAndNil(fZaehlerstand);
  FreeAndNil(fVerbrauch);
  inherited;
end;

end.
