unit Json.EventsCollection;

interface

uses Generics.Collections, Rest.Json;

type

TMetaClass = class
private
  FCreatedAt: String;
public
  property createdAt: String read FCreatedAt write FCreatedAt;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TMetaClass;
end;

TAttributesClass = class
private
  FDeviceId: String;
  FDueDate: String;
  FNote: String;
  FState: String;
  FTaskId: String;
public
  property deviceId: String read FDeviceId write FDeviceId;
  property dueDate: String read FDueDate write FDueDate;
  property note: String read FNote write FNote;
  property state: String read FState write FState;
  property taskId: String read FTaskId write FTaskId;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TAttributesClass;
end;

TLinksClass_001 = class
private
  FSelf: String;
public
  property self: String read FSelf write FSelf;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass_001;
end;

TDataClass = class
private
  FAttributes: TAttributesClass;
  FId: String;
  FLinks: TLinksClass_001;
  FMeta: TMetaClass;
  FType: String;
public
  property attributes: TAttributesClass read FAttributes write FAttributes;
  property id: String read FId write FId;
  property links: TLinksClass_001 read FLinks write FLinks;
  property meta: TMetaClass read FMeta write FMeta;
  property &type: String read FType write FType;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TDataClass;
end;

TLinksClass = class
private
  FFirst: String;
public
  property first: String read FFirst write FFirst;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TLinksClass;
end;

TJEventsCollection = class
private
  FData: TArray<TDataClass>;
  FJsonapi: String;
  FLinks: TLinksClass;
public
  property data: TArray<TDataClass> read FData write FData;
  property jsonapi: String read FJsonapi write FJsonapi;
  property links: TLinksClass read FLinks write FLinks;
  constructor Create;
  destructor Destroy; override;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TJEventsCollection;
end;

implementation

{TMetaClass}


function TMetaClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMetaClass.FromJsonString(AJsonString: string): TMetaClass;
begin
  result := TJson.JsonToObject<TMetaClass>(AJsonString)
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

{TLinksClass_001}


function TLinksClass_001.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_001.FromJsonString(AJsonString: string): TLinksClass_001;
begin
  result := TJson.JsonToObject<TLinksClass_001>(AJsonString)
end;

{TDataClass}

constructor TDataClass.Create;
begin
  inherited;
  FLinks := TLinksClass_001.Create();
  FAttributes := TAttributesClass.Create();
  FMeta := TMetaClass.Create();
end;

destructor TDataClass.Destroy;
begin
  FLinks.free;
  FAttributes.free;
  FMeta.free;
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

{TLinksClass}


function TLinksClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass.FromJsonString(AJsonString: string): TLinksClass;
begin
  result := TJson.JsonToObject<TLinksClass>(AJsonString)
end;

{TRootClass}

constructor TJEventsCollection.Create;
begin
  inherited;
  FLinks := TLinksClass.Create();
end;

destructor TJEventsCollection.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  FLinks.free;
  inherited;
end;

function TJEventsCollection.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJEventsCollection.FromJsonString(AJsonString: string): TJEventsCollection;
begin
  result := TJson.JsonToObject<TJEventsCollection>(AJsonString)
end;

end.
