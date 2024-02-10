unit wma.EnergieverbrauchVerbrauch;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.EnergieverbrauchZaehlerstandRead,
  wma.EnergieverbrauchKomplNeuBerechnen, wma.EnergieverbrauchVerbrauchVerbrauchMonate,
  wma.EnergieverbrauchVerbrauchVerbrauchJahre;

type
  TwmaEnergieverbrauchVerbrauch = class
  private
    fKomplNeuBerechnen: TwmaEnergieverbrauchKomplNeuBerechnen;
    fMonate: TwmaEnergieverbrauchVerbrauchMonate;
    fJahre: TwmaEnergieverbrauchVerbrauchJahre;
  public
    constructor Create;
    destructor Destroy; override;
    property KomplNeuBerechnen: TwmaEnergieverbrauchKomplNeuBerechnen read fKomplNeuBerechnen write fKomplNeuBerechnen;
    property Monate: TwmaEnergieverbrauchVerbrauchMonate read fMonate write fMonate;
    property Jahre: TwmaEnergieverbrauchVerbrauchJahre read fJahre write fJahre;
  end;

implementation

{ TwmaEnergieverbrauchVerbrauch }

constructor TwmaEnergieverbrauchVerbrauch.Create;
begin
  fKomplNeuBerechnen := TwmaEnergieverbrauchKomplNeuBerechnen.Create;
  fMonate := TwmaEnergieverbrauchVerbrauchMonate.Create;
  fJahre   := TwmaEnergieverbrauchVerbrauchJahre.Create;
end;

destructor TwmaEnergieverbrauchVerbrauch.Destroy;
begin
  FreeAndNil(fKomplNeuBerechnen);
  FreeAndNil(fMonate);
  FreeAndNil(fJahre);
  inherited;
end;

end.
