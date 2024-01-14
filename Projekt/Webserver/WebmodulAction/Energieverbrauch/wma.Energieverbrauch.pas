unit wma.Energieverbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehler;

type
  TwmaEnergieverbrauch = class
  private
    fZaehler: TwmaEnergieverbrauchZaehler;
  public
    constructor Create;
    destructor Destroy; override;
    property Zaehler: TwmaEnergieverbrauchZaehler read fZaehler write fZaehler;
  end;

implementation

{ TwmaEnergieverbrauch }

constructor TwmaEnergieverbrauch.Create;
begin
  fZaehler := TwmaEnergieverbrauchZaehler.Create;
end;

destructor TwmaEnergieverbrauch.Destroy;
begin
  FreeAndNil(fZaehler);
  inherited;
end;

end.
