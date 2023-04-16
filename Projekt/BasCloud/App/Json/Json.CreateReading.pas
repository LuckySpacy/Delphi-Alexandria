unit Json.CreateReading;

interface

uses
  Generics.Collections, Rest.Json;

type

  TDataClass_001 = class
  private
    FId: String;
    FType: String;
  public
    property id: String read FId write FId;
    property &type: String read FType write FType;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass_001;
  end;

  TDeviceClass = class
  private
    FData: TDataClass_001;
  public
    property data: TDataClass_001 read FData write FData;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDeviceClass;
  end;

  TRelationshipsClass = class
  private
    FDevice: TDeviceClass;
  public
    property device: TDeviceClass read FDevice write FDevice;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TRelationshipsClass;
  end;

  TAttributesClass = class
  private
    FTimestamp: String;
    FValue: Extended;
  public
    property timestamp: String read FTimestamp write FTimestamp;
    property value: Extended read FValue write FValue;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TAttributesClass;
  end;

  TDataClass = class
  private
    FAttributes: TAttributesClass;
    FRelationships: TRelationshipsClass;
    FType: String;
  public
    property attributes: TAttributesClass read FAttributes write FAttributes;
    property relationships: TRelationshipsClass read FRelationships write FRelationships;
    property &type: String read FType write FType;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass;
  end;

  TJCreateReading = class
  private
    FData: TDataClass;
  public
    property data: TDataClass read FData write FData;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJCreateReading;
  end;

implementation

{TDataClass_001}


function TDataClass_001.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TDataClass_001.FromJsonString(AJsonString: string): TDataClass_001;
begin
  result := TJson.JsonToObject<TDataClass_001>(AJsonString)
end;

{TDeviceClass}

constructor TDeviceClass.Create;
begin
  inherited;
  FData := TDataClass_001.Create();
end;

destructor TDeviceClass.Destroy;
begin
  FData.free;
  inherited;
end;

function TDeviceClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TDeviceClass.FromJsonString(AJsonString: string): TDeviceClass;
begin
  result := TJson.JsonToObject<TDeviceClass>(AJsonString)
end;

{TRelationshipsClass}

constructor TRelationshipsClass.Create;
begin
  inherited;
  FDevice := TDeviceClass.Create();
end;

destructor TRelationshipsClass.Destroy;
begin
  FDevice.free;
  inherited;
end;

function TRelationshipsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TRelationshipsClass.FromJsonString(AJsonString: string): TRelationshipsClass;
begin
  result := TJson.JsonToObject<TRelationshipsClass>(AJsonString)
end;

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
  FRelationships := TRelationshipsClass.Create();
end;

destructor TDataClass.Destroy;
begin
  FAttributes.free;
  FRelationships.free;
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

constructor TJCreateReading.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJCreateReading.Destroy;
begin
  FData.free;
  inherited;
end;

function TJCreateReading.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJCreateReading.FromJsonString(AJsonString: string): TJCreateReading;
begin
  result := TJson.JsonToObject<TJCreateReading>(AJsonString);
end;

end.
