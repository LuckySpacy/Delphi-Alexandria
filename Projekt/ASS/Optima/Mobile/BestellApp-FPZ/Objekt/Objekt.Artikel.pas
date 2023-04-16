unit Objekt.Artikel;

interface

uses
  System.SysUtils, System.Types, System.Classes;

type
  TArtikel = class
  private
    fId: Integer;
    fBez: string;
    fEan: string;
    fNr: string;
    fMenge: real;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read fId write fId;
    property Bez: string read fBez write fBez;
    property Ean: string read fEan write fEan;
    property Nr: string read fNr write fNr;
    property Menge: real read fMenge write fMenge;
    procedure Init;
  end;

implementation

{ TArtikel }

constructor TArtikel.Create;
begin
  Init;
end;

destructor TArtikel.Destroy;
begin

  inherited;
end;

procedure TArtikel.Init;
begin
  fId  := 0;
  fBez   := '';
  fEan   := '';
  fNr    := '';
  fMenge := 0;
end;

end.
