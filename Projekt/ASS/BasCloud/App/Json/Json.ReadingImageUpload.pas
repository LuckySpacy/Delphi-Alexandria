unit Json.ReadingImageUpload;

interface

uses Generics.Collections, Rest.Json;

type

  TAttributesClass = class
  private
    FExpires: String;
    FUrl: String;
  public
    property expires: String read FExpires write FExpires;
    property url: String read FUrl write FUrl;
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

  TJReadingImageUpload = class
  private
    FData: TDataClass;
    FJsonapi: String;
  public
    property data: TDataClass read FData write FData;
    property jsonapi: String read FJsonapi write FJsonapi;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJReadingImageUpload;
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

constructor TJReadingImageUpload.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJReadingImageUpload.Destroy;
begin
  FData.free;
  inherited;
end;

function TJReadingImageUpload.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJReadingImageUpload.FromJsonString(AJsonString: string): TJReadingImageUpload;
begin
  result := TJson.JsonToObject<TJReadingImageUpload>(AJsonString)
end;

end.
