unit Json.Device;

interface

uses Generics.Collections, Rest.Json;

type

TLinksClass_004 = class
private
  FRelated: String;
  FSelf: String;
public
  property related: String read FRelated write FRelated;
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass_004;
end;

TSetpointsClass = class
private
  FLinks: TLinksClass_004;
public
  property links: TLinksClass_004 read FLinks write FLinks;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TSetpointsClass;
end;

TLinksClass_003 = class
private
  FRelated: String;
  FSelf: String;
public
  property related: String read FRelated write FRelated;
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass_003;
end;

TReadingsClass = class
private
  FLinks: TLinksClass_003;
public
  property links: TLinksClass_003 read FLinks write FLinks;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TReadingsClass;
end;

TLinksClass_002 = class
private
  FRelated: String;
  FSelf: String;
public
  property related: String read FRelated write FRelated;
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass_002;
end;

TPropertyClass = class
private
  FLinks: TLinksClass_002;
public
  property links: TLinksClass_002 read FLinks write FLinks;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TPropertyClass;
end;

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

TConnectorClass = class
private
  FLinks: TLinksClass_001;
public
  property links: TLinksClass_001 read FLinks write FLinks;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TConnectorClass;
end;

TRelationshipsClass = class
private
  FConnector: TConnectorClass;
  FProperty: TPropertyClass;
  FReadings: TReadingsClass;
  FSetpoints: TSetpointsClass;
public
  property connector: TConnectorClass read FConnector write FConnector;
  property &property: TPropertyClass read FProperty write FProperty;
  property readings: TReadingsClass read FReadings write FReadings;
  property setpoints: TSetpointsClass read FSetpoints write FSetpoints;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TRelationshipsClass;
end;

TAttributesClass = class
private
  FAggregation: String;
  FAksId: String;
  FDescription: String;
  FFrequency: String;
  FInterval: Extended;
  FLocalAksId: String;
  FType: String;
  FUnit: String;
public
  property aggregation: String read FAggregation write FAggregation;
  property aksId: String read FAksId write FAksId;
  property description: String read FDescription write FDescription;
  property frequency: String read FFrequency write FFrequency;
  property interval: Extended read FInterval write FInterval;
  property localAksId: String read FLocalAksId write FLocalAksId;
  property &type: String read FType write FType;
  property &unit: String read FUnit write FUnit;
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

TJDevice = class
private
  FData: TDataClass;
  FJsonapi: String;
public
  property data: TDataClass read FData write FData;
  property jsonapi: String read FJsonapi write FJsonapi;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TJDevice;
end;

implementation

{TLinksClass_004}


function TLinksClass_004.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_004.FromJsonString(AJsonString: string): TLinksClass_004;
begin
  result := TJson.JsonToObject<TLinksClass_004>(AJsonString)
end;

{TSetpointsClass}

constructor TSetpointsClass.Create;
begin
  inherited;
  FLinks := TLinksClass_004.Create();
end;

destructor TSetpointsClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TSetpointsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TSetpointsClass.FromJsonString(AJsonString: string): TSetpointsClass;
begin
  result := TJson.JsonToObject<TSetpointsClass>(AJsonString)
end;

{TLinksClass_003}


function TLinksClass_003.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_003.FromJsonString(AJsonString: string): TLinksClass_003;
begin
  result := TJson.JsonToObject<TLinksClass_003>(AJsonString)
end;

{TReadingsClass}

constructor TReadingsClass.Create;
begin
  inherited;
  FLinks := TLinksClass_003.Create();
end;

destructor TReadingsClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TReadingsClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TReadingsClass.FromJsonString(AJsonString: string): TReadingsClass;
begin
  result := TJson.JsonToObject<TReadingsClass>(AJsonString)
end;

{TLinksClass_002}


function TLinksClass_002.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_002.FromJsonString(AJsonString: string): TLinksClass_002;
begin
  result := TJson.JsonToObject<TLinksClass_002>(AJsonString)
end;

{TPropertyClass}

constructor TPropertyClass.Create;
begin
  inherited;
  FLinks := TLinksClass_002.Create();
end;

destructor TPropertyClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TPropertyClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TPropertyClass.FromJsonString(AJsonString: string): TPropertyClass;
begin
  result := TJson.JsonToObject<TPropertyClass>(AJsonString)
end;

{TLinksClass_001}


function TLinksClass_001.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_001.FromJsonString(AJsonString: string): TLinksClass_001;
begin
  result := TJson.JsonToObject<TLinksClass_001>(AJsonString)
end;

{TConnectorClass}

constructor TConnectorClass.Create;
begin
  inherited;
  FLinks := TLinksClass_001.Create();
end;

destructor TConnectorClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TConnectorClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TConnectorClass.FromJsonString(AJsonString: string): TConnectorClass;
begin
  result := TJson.JsonToObject<TConnectorClass>(AJsonString)
end;

{TRelationshipsClass}

constructor TRelationshipsClass.Create;
begin
  inherited;
  FConnector := TConnectorClass.Create();
  FProperty := TPropertyClass.Create();
  FReadings := TReadingsClass.Create();
  FSetpoints := TSetpointsClass.Create();
end;

destructor TRelationshipsClass.Destroy;
begin
  FConnector.free;
  FProperty.free;
  FReadings.free;
  FSetpoints.free;
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

constructor TJDevice.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJDevice.Destroy;
begin
  FData.free;
  inherited;
end;

function TJDevice.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJDevice.FromJsonString(AJsonString: string): TJDevice;
begin
  result := TJson.JsonToObject<TJDevice>(AJsonString)
end;

end.

