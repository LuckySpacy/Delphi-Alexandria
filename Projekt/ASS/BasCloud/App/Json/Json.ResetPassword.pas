unit Json.ResetPassword;

interface

uses Generics.Collections, Rest.Json;

type
  TAttributesClass = class
  private
    FEmail: String;
  public
    property email: String read FEmail write FEmail;
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

  TJresetPassword = class
  private
    FData: TDataClass;
  public
    property data: TDataClass read FData write FData;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJresetPassword;
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

{TJresetPassword}

constructor TJresetPassword.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJresetPassword.Destroy;
begin
  FData.free;
  inherited;
end;

function TJresetPassword.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJresetPassword.FromJsonString(AJsonString: string): TJresetPassword;
begin
  result := TJson.JsonToObject<TJresetPassword>(AJsonString)
end;





end.
