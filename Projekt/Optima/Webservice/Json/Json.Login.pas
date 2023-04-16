unit Json.Login;

interface

uses
  Generics.Collections, Rest.Json;

type

  TJLogin = class
  private
    FBenutzer: String;
    FPasswort: String;
  public
    property Benutzer: String read FBenutzer write FBenutzer;
    property Passwort: String read FPasswort write FPasswort;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJLogin;
  end;

implementation

{TRootClass}

function TJLogin.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJLogin.FromJsonString(AJsonString: string): TJLogin;
begin
  result := TJson.JsonToObject<TJLogin>(AJsonString)
end;

end.
