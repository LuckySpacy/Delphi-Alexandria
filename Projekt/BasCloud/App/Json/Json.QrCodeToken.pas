unit Json.QrCodeToken;

interface

uses Generics.Collections, Rest.Json;

type

  TJQrCodeToken = class
  private
    FExpires: Extended;
    FToken: String;
  public
    property expires: Extended read FExpires write FExpires;
    property token: String read FToken write FToken;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJQrCodeToken;
  end;

implementation

{TRootClass}


function TJQrCodeToken.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJQrCodeToken.FromJsonString(AJsonString: string): TJQrCodeToken;
begin
  result := TJson.JsonToObject<TJQrCodeToken>(AJsonString)
end;

end.

