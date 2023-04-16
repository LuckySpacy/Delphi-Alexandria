unit Objekt.ArtikelList;

interface

uses
  SysUtils, System.Classes, Objekt.BasisList, Objekt.Artikel;

type
  TArtikelList = class(TBasisList)
  private
    function getItem(Index: Integer): TArtikel;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Item[Index: Integer]: TArtikel read getItem;
    function Add: TArtikel;
  end;


implementation

{ TArtikelList }


constructor TArtikelList.Create;
begin
  inherited;

end;

destructor TArtikelList.Destroy;
begin

  inherited;
end;

function TArtikelList.getItem(Index: Integer): TArtikel;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TArtikel(fList.Items[Index]);
end;

function TArtikelList.Add: TArtikel;
begin
  Result := TArtikel.Create;
  fList.Add(Result);
end;


end.
