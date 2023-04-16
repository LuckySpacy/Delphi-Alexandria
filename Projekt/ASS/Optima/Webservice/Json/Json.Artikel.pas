unit Json.Artikel;

interface

uses
  Generics.Collections, Rest.Json;

type

  TJArtikel = class
  private
    FBez: String;
    FEAN: String;
    FId: String;
    FNr: String;
  public
    property Bez: String read FBez write FBez;
    property EAN: String read FEAN write FEAN;
    property Id: String read FId write FId;
    property Nr: String read FNr write FNr;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJArtikel;
  end;

implementation

{TJArtikel}


function TJArtikel.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJArtikel.FromJsonString(AJsonString: string): TJArtikel;
begin
  result := TJson.JsonToObject<TJArtikel>(AJsonString);
end;

end.


end.
