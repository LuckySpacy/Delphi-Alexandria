unit Json.Devices;

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

  TConnectorClass = class
  private
    FLinks: TLinksClass_002;
  public
    property links: TLinksClass_002 read FLinks write FLinks;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TConnectorClass;
  end;

  TRelationshipsClass = class
  private
    FConnector: TConnectorClass;
    FReadings: TReadingsClass;
    FSetpoints: TSetpointsClass;
  public
    property connector: TConnectorClass read FConnector write FConnector;
    property readings: TReadingsClass read FReadings write FReadings;
    property setpoints: TSetpointsClass read FSetpoints write FSetpoints;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TRelationshipsClass;
  end;

  TAttributesClass = class
  private
    FAksId: String;
    FDescription: String;
    FUnit: String;
  public
    property aksId: String read FAksId write FAksId;
    property description: String read FDescription write FDescription;
    property &unit: String read FUnit write FUnit;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TAttributesClass;
  end;

  TMetaClass_001 = class
  private
    FCreatedAt: String;
    FUpdatedAt: String;
  public
    property createdAt: String read FCreatedAt write FCreatedAt;
    property updatedAt: String read FUpdatedAt write FUpdatedAt;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TMetaClass_001;
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
    FMeta: TMetaClass_001;
    FRelationships: TRelationshipsClass;
    FType: String;
  public
    property attributes: TAttributesClass read FAttributes write FAttributes;
    property id: String read FId write FId;
    property links: TLinksClass_001 read FLinks write FLinks;
    property meta: TMetaClass_001 read FMeta write FMeta;
    property relationships: TRelationshipsClass read FRelationships write FRelationships;
    property &type: String read FType write FType;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass;
  end;

  TPageClass = class
  private
    FCount: Extended;
    FPage: Extended;
    FPageSize: Extended;
    FTotalPages: Extended;
  public
    property count: Extended read FCount write FCount;
    property page: Extended read FPage write FPage;
    property pageSize: Extended read FPageSize write FPageSize;
    property totalPages: Extended read FTotalPages write FTotalPages;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TPageClass;
  end;

  TMetaClass = class
  private
    FPage: TPageClass;
  public
    property page: TPageClass read FPage write FPage;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TMetaClass;
  end;

  TLinksClass = class
  private
    FFirst: String;
  public
    property first: String read FFirst write FFirst;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TLinksClass;
  end;

  TJDevices = class
  private
    FData: TArray<TDataClass>;
    FJsonapi: String;
    FLinks: TLinksClass;
    FMeta: TMetaClass;
  public
    property data: TArray<TDataClass> read FData write FData;
    property jsonapi: String read FJsonapi write FJsonapi;
    property links: TLinksClass read FLinks write FLinks;
    property meta: TMetaClass read FMeta write FMeta;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJDevices;
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

{TConnectorClass}

constructor TConnectorClass.Create;
begin
  inherited;
  FLinks := TLinksClass_002.Create();
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
  FReadings := TReadingsClass.Create();
  FSetpoints := TSetpointsClass.Create();
end;

destructor TRelationshipsClass.Destroy;
begin
  FConnector.free;
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

{TMetaClass_001}


function TMetaClass_001.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TMetaClass_001.FromJsonString(AJsonString: string): TMetaClass_001;
begin
  result := TJson.JsonToObject<TMetaClass_001>(AJsonString)
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
  FMeta := TMetaClass_001.Create();
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

{TPageClass}


function TPageClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TPageClass.FromJsonString(AJsonString: string): TPageClass;
begin
  result := TJson.JsonToObject<TPageClass>(AJsonString)
end;

{TMetaClass}

constructor TMetaClass.Create;
begin
  inherited;
  FPage := TPageClass.Create();
end;

destructor TMetaClass.Destroy;
begin
  FPage.free;
  inherited;
end;

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

{TRootClass}

constructor TJDevices.Create;
begin
  inherited;
  FLinks := TLinksClass.Create();
  FMeta := TMetaClass.Create();
end;

destructor TJDevices.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  FLinks.free;
  FMeta.free;
  inherited;
end;

function TJDevices.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJDevices.FromJsonString(AJsonString: string): TJDevices;
begin
  result := TJson.JsonToObject<TJDevices>(AJsonString)
end;

end.
