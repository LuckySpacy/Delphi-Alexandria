unit Json.Login;

interface

uses
  Generics.Collections, Rest.Json;

type
  TAttributesClass = class
  private
    FEmail: String;
    FPassword: String;
  public
    property email: String read FEmail write FEmail;
    property password: String read FPassword write FPassword;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TAttributesClass;
  end;

  TDataClass = class
  private
    FAttributes: TAttributesClass;
    FType: String;
  public
    property attributes: TAttributesClass read FAttributes write FAttributes;
    property &type: String read FType write FType;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass;
  end;

  TJLogin = class
  private
    FData: TDataClass;
  public
    property data: TDataClass read FData write FData;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJLogin;
  end;



implementation


{TAttributesClass}
function TAttributesClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TAttributesClass.FromJsonString(AJsonString: string): TAttributesClass;
begin
  result := TJson.JsonToObject<TAttributesClass>(AJsonString)
end;

{TDataClass}

constructor TDataClass.Create;
begin
  inherited;
  FAttributes := TAttributesClass.Create();
end;

destructor TDataClass.Destroy;
begin
  FAttributes.free;
  inherited;
end;

function TDataClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TDataClass.FromJsonString(AJsonString: string): TDataClass;
begin
  result := TJson.JsonToObject<TDataClass>(AJsonString)
end;

{TRootClass}
constructor TJLogin.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJLogin.Destroy;
begin
  FData.free;
  inherited;
end;

function TJLogin.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJLogin.FromJsonString(AJsonString: string): TJLogin;
begin
  result := TJson.JsonToObject<TJLogin>(AJsonString)
end;

end.
