unit wma.EnergieverbrauchZaehlerstandRead;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerstandReadZeitraum;

type
  TwmaEnergieverbrauchZaehlerstandRead = class
  private
    fZeitraum: TwmaEnergieverbrauchZaehlerstandReadZeitraum;
  public
    constructor Create;
    destructor Destroy; override;
    property Zeitraum: TwmaEnergieverbrauchZaehlerstandReadZeitraum read fZeitraum write fZeitraum;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstandRead }

constructor TwmaEnergieverbrauchZaehlerstandRead.Create;
begin
  fZeitraum := TwmaEnergieverbrauchZaehlerstandReadZeitraum.Create;
end;

destructor TwmaEnergieverbrauchZaehlerstandRead.Destroy;
begin
  FreeAndNil(fZeitraum);
  inherited;
end;

end.
