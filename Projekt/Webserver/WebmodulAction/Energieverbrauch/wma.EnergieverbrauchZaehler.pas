unit wma.EnergieverbrauchZaehler;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerReadAll, wma.EnergieverbrauchZaehlerUpdate,
  wma.EnergieverbrauchZaehlerDelete;

type
  TwmaEnergieverbrauchZaehler = class
  private
    fReadAll: TwmaEnergieverbrauchZaehlerReadAll;
    fDBUpdate: TwmaEnergieverbrauchZaehlerUpdate;
    fDBDelete: TwmaEnergieverbrauchZaehlerDelete;
  public
    constructor Create;
    destructor Destroy; override;
    property ReadAll: TwmaEnergieverbrauchZaehlerReadAll read fReadAll write fReadAll;
    property DBUdate: TwmaEnergieverbrauchZaehlerUpdate read fDBUpdate write fDBUpdate;
    property DBDelete: TwmaEnergieverbrauchZaehlerDelete read fDBDelete write fDBDelete;
  end;

implementation

{ TwmaEnergieverbrauchZaehler }

constructor TwmaEnergieverbrauchZaehler.Create;
begin
  fReadAll  := TwmaEnergieverbrauchZaehlerReadAll.Create;
  fDBUpdate := TwmaEnergieverbrauchZaehlerUpdate.Create;
  fDBDelete := TwmaEnergieverbrauchZaehlerDelete.Create;
end;

destructor TwmaEnergieverbrauchZaehler.Destroy;
begin
  FreeAndNil(fReadAll);
  FreeAndNil(fDBUpdate);
  FreeAndNil(fDBDelete);
  inherited;
end;

end.
