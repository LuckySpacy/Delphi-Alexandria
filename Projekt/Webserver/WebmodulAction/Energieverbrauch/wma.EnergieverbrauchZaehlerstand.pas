unit wma.EnergieverbrauchZaehlerstand;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerstandRead,
  wma.EnergieverbrauchZaehlerstandUpdate, wma.EnergieverbrauchZaehlerstandDelete;

type
  TwmaEnergieverbrauchZaehlerstand = class
  private
    fLese: TwmaEnergieverbrauchZaehlerstandRead;
    fDBUpdate: TwmaEnergieverbrauchZaehlerstandUpdate;
    fDBDelete: TwmaEnergieverbrauchZaehlerstandDelete;
  public
    constructor Create;
    destructor Destroy; override;
    property Lese: TwmaEnergieverbrauchZaehlerstandRead read fLese write fLese;
    property DBUdate: TwmaEnergieverbrauchZaehlerstandUpdate read fDBUpdate write fDBUpdate;
    property DBDelete: TwmaEnergieverbrauchZaehlerstandDelete read fDBDelete write fDBDelete;
  end;

implementation

{ TwmaEnergieverbrauchZaehlerstand }

constructor TwmaEnergieverbrauchZaehlerstand.Create;
begin
  fLese := TwmaEnergieverbrauchZaehlerstandRead.Create;
  fDBUpdate := TwmaEnergieverbrauchZaehlerstandUpdate.Create;
  fDBDelete := TwmaEnergieverbrauchZaehlerstandDelete.Create;
end;

destructor TwmaEnergieverbrauchZaehlerstand.Destroy;
begin
  FreeAndNil(Lese);
  FreeAndNil(fDBUpdate);
  FreeAndNil(fDBDelete);
  inherited;
end;

end.
