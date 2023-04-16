unit Objekt.Gebaude;

interface

type
  TGebaude = class
  private
    fGebaudename: string;
    fPlz: string;
    fId: string;
    fStrasse: string;
    fOrt: string;
    fLand: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Id: string read fId write fId;
    property Gebaudename: string read fGebaudename write fGebaudename;
    property Strasse: string read fStrasse write fStrasse;
    property Plz: string read fPlz write fPlz;
    property Ort: string read fOrt write fOrt;
    property Land: string read fLand write fLand;
    procedure Init;
    procedure Copy(aGebaude: TGebaude);
  end;

implementation

{ TGebaude }


constructor TGebaude.Create;
begin
  Init;
end;

destructor TGebaude.Destroy;
begin

  inherited;
end;

procedure TGebaude.Init;
begin
  fGebaudename := '';
  fPlz         := '';
  fId          := '';
  fStrasse     := '';
  fOrt         := '';
  fLand        := '';
end;

procedure TGebaude.Copy(aGebaude: TGebaude);
begin
  aGebaude.Gebaudename := fGebaudename;
  aGebaude.Plz         := fPlz;
  aGebaude.Id          := fId;
  aGebaude.Strasse     := fStrasse;
  aGebaude.Ort         := fOrt;
  aGebaude.Land        := fLand;
end;


end.
