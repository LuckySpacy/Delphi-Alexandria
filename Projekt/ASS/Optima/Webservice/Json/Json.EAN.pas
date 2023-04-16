unit Json.EAN;

interface

uses
  Generics.Collections, Rest.Json;

type

  TJEAN = class
  private
    FEAN: String;
  public
    property EAN: String read FEAN write FEAN;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJEAN;
  end;

implementation


{TJEAN}


function TJEAN.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJEAN.FromJsonString(AJsonString: string): TJEAN;
begin
  result := TJson.JsonToObject<TJEAN>(AJsonString)
end;

end.
