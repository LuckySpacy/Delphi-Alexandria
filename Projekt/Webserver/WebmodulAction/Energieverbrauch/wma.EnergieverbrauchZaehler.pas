unit wma.EnergieverbrauchZaehler;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerReadAll;

type
  TwmaEnergieverbrauchZaehler = class
  private
    fReadAll: TwmaEnergieverbrauchZaehlerReadAll;
  public
    constructor Create;
    destructor Destroy; override;
    property ReadAll: TwmaEnergieverbrauchZaehlerReadAll read fReadAll write fReadAll;
  end;

implementation

{ TwmaEnergieverbrauchZaehler }

constructor TwmaEnergieverbrauchZaehler.Create;
begin
  fReadAll := TwmaEnergieverbrauchZaehlerReadAll.Create;
end;

destructor TwmaEnergieverbrauchZaehler.Destroy;
begin
  FreeAndNil(fReadAll);
  inherited;
end;

end.
