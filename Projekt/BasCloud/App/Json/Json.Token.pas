unit Json.Token;

interface

uses
  Generics.Collections, Rest.Json;

type

  TAttributesClass = class
  private
    FExpires: Int64;
    FToken: String;
  public
    property expires: Int64 read FExpires write FExpires;
    property token: String read FToken write FToken;
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

  TJToken = class
  private
    FData: TDataClass;
  public
    property data: TDataClass read FData write FData;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJToken;
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
constructor TJToken.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJToken.Destroy;
begin
  FData.free;
  inherited;
end;

function TJToken.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJToken.FromJsonString(AJsonString: string): TJToken;
begin
  result := TJson.JsonToObject<TJToken>(AJsonString)
end;


end.
