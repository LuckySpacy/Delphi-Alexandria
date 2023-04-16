unit Json.Reading;


interface

uses Generics.Collections, Rest.Json;

type

TLinksClass_001 = class
private
  FRelated: String;
  FSelf: String;
public
  property related: String read FRelated write FRelated;
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass_001;
end;

TDeviceClass = class
private
  FLinks: TLinksClass_001;
public
  property links: TLinksClass_001 read FLinks write FLinks;
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

TMetaClass = class
private
  FCreatedAt: String;
  FUpdatedAt: String;
public
  property createdAt: String read FCreatedAt write FCreatedAt;
  property updatedAt: String read FUpdatedAt write FUpdatedAt;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TMetaClass;
end;

TLinksClass = class
private
  FSelf: String;
public
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass;
end;

TDataClass = class
private
  FAttributes: TAttributesClass;
  FId: String;
  FLinks: TLinksClass;
  FMeta: TMetaClass;
  FRelationships: TRelationshipsClass;
  FType: String;
public
  property attributes: TAttributesClass read FAttributes write FAttributes;
  property id: String read FId write FId;
  property links: TLinksClass read FLinks write FLinks;
  property meta: TMetaClass read FMeta write FMeta;
  property relationships: TRelationshipsClass read FRelationships write FRelationships;
  property &type: String read FType write FType;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TDataClass;
end;

TJReading = class
private
  FData: TDataClass;
  FJsonapi: String;
public
  property data: TDataClass read FData write FData;
  property jsonapi: String read FJsonapi write FJsonapi;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TJReading;
end;

implementation

{TLinksClass_001}


function TLinksClass_001.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_001.FromJsonString(AJsonString: string): TLinksClass_001;
begin
  result := TJson.JsonToObject<TLinksClass_001>(AJsonString)
end;

{TDeviceClass}

constructor TDeviceClass.Create;
begin
  inherited;
  FLinks := TLinksClass_001.Create();
end;

destructor TDeviceClass.Destroy;
begin
  FLinks.free;
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

{TMetaClass}


function TMetaClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMetaClass.FromJsonString(AJsonString: string): TMetaClass;
begin
  result := TJson.JsonToObject<TMetaClass>(AJsonString)
end;

{TLinksClass}


function TLinksClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass.FromJsonString(AJsonString: string): TLinksClass;
begin
  result := TJson.JsonToObject<TLinksClass>(AJsonString)
end;

{TDataClass}

constructor TDataClass.Create;
begin
  inherited;
  FLinks := TLinksClass.Create();
  FMeta := TMetaClass.Create();
  FAttributes := TAttributesClass.Create();
  FRelationships := TRelationshipsClass.Create();
end;

destructor TDataClass.Destroy;
begin
  FLinks.free;
  FMeta.free;
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

constructor TJReading.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJReading.Destroy;
begin
  FData.free;
  inherited;
end;

function TJReading.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJReading.FromJsonString(AJsonString: string): TJReading;
begin
  result := TJson.JsonToObject<TJReading>(AJsonString)
end;

end.

