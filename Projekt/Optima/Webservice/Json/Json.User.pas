unit Json.User;

interface

uses Generics.Collections, Rest.Json;

type

  TJUser = class
  private
    FMaId: String;
    FNachname: String;
    FVorname: String;
  public
    property MaId: String read FMaId write FMaId;
    property Nachname: String read FNachname write FNachname;
    property Vorname: String read FVorname write FVorname;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJUser;
  end;

implementation

{TRootClass}


function TJUser.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJUser.FromJsonString(AJsonString: string): TJUser;
begin
  result := TJson.JsonToObject<TJUser>(AJsonString)
end;

end.
