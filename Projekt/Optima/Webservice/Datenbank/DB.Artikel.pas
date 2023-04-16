unit DB.Artikel;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db, DB.BasisHistorie;

type
  TDBArtikel = class(TDBBasisHistorie)
  private
    fBez: string;
    fArNr: Integer;
    fEan: string;
    function getEan: string;
 protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getTableId: Integer; override;
    procedure FuelleDBFelder; override;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TNFSQuery); override;
    procedure SaveToDB; override;
    property ArNr: Integer read fArNr write fArNr;
    property Bez: string read fBez write fBez;
    property Ean: string read getEan write fEan;

  end;

implementation

{ TDBArtikel }



{ TDBArtikel }

constructor TDBArtikel.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('AR_NR', ftInteger);
  FFeldList.Add('AR_BEZ', ftString);
  Init;
end;

destructor TDBArtikel.Destroy;
begin

  inherited;
end;

procedure TDBArtikel.Init;
begin
  inherited;
  fBez  := '';
  fArNr := 0;
  fEan  := '';
  FuelleDBFelder;
end;

function TDBArtikel.getGeneratorName: string;
begin
  Result := 'AR_ID';
end;

function TDBArtikel.getTableId: Integer;
begin
  Result := 0;
end;

function TDBArtikel.getTableName: string;
begin
  Result := 'ARTIKEL';
end;

function TDBArtikel.getTablePrefix: string;
begin
  Result := 'AR';
end;

procedure TDBArtikel.FuelleDBFelder;
begin
  fFeldList.FieldByName('AR_BEZ').AsString   := fBez;
  fFeldList.FieldByName('AR_NR').AsInteger   := fArNr;

  inherited;

end;


procedure TDBArtikel.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fArNr := aQuery.FieldByName('AR_NR').AsInteger;
  fBez  := aQuery.FieldByName('AR_BEZ').AsString;
end;



function TDBArtikel.getEan: string;
begin

end;










procedure TDBArtikel.SaveToDB;
begin
  inherited;

end;

end.
