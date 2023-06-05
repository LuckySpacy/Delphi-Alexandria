unit Json.Aktie;


interface

uses
  Generics.Collections, Rest.Json;

type

  TJAktie = class
  private
    FAktie: String;
    FAktiv: String;
    FBiId: String;
    FDepot: String;
    FEPS: String;
    FISIN: String;
    FId: String;
    FLink: String;
    FSymbol: String;
    FWKN: String;
  public
    property aktie: String read FAktie write FAktie;
    property aktiv: String read FAktiv write FAktiv;
    property biId: String read FBiId write FBiId;
    property depot: String read FDepot write FDepot;
    property ePS: String read FEPS write FEPS;
    property iSIN: String read FISIN write FISIN;
    property id: String read FId write FId;
    property link: String read FLink write FLink;
    property symbol: String read FSymbol write FSymbol;
    property wKN: String read FWKN write FWKN;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJAktie;
  end;

implementation

{TRootClass}


function TJAktie.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJAktie.FromJsonString(AJsonString: string): TJAktie;
begin
  result := TJson.JsonToObject<TJAktie>(AJsonString)
end;

end.
