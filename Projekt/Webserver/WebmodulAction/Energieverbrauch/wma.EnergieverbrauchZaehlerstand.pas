unit wma.EnergieverbrauchZaehlerstand;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerstandRead,
  wma.EnergieverbrauchZaehlerstandUpdate;

type
  TwmaEnergieverbrauchZaehlerstand = class
  private
    fLese: TwmaEnergieverbrauchZaehlerstandRead;
    fDBUpdate: TwmaEnergieverbrauchZaehlerstandUpdate;
  public
    constructor Create;
    destructor Destroy; override;
    property Lese: TwmaEnergieverbrauchZaehlerstandRead read fLese write fLese;
    property DBUdate: TwmaEnergieverbrauchZaehlerstandUpdate read fDBUpdate write fDBUpdate;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstand }

constructor TwmaEnergieverbrauchZaehlerstand.Create;
begin
  fLese := TwmaEnergieverbrauchZaehlerstandRead.Create;
  fDBUpdate := TwmaEnergieverbrauchZaehlerstandUpdate.Create;
end;

destructor TwmaEnergieverbrauchZaehlerstand.Destroy;
begin
  FreeAndNil(Lese);
  FreeAndNil(fDBUpdate);
  inherited;
end;

end.
