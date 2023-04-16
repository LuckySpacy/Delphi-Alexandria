unit Json.Tenants;

interface


uses
  Generics.Collections, Rest.Json;

type
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

  TUsersClass = class
  private
    FLinks: TLinksClass_002;
  public
    property links: TLinksClass_002 read FLinks write FLinks;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TUsersClass;
  end;

  TRelationshipsClass = class
  private
    FUsers: TUsersClass;
  public
    property users: TUsersClass read FUsers write FUsers;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TRelationshipsClass;
  end;

  TAttributesClass = class
  private
    FName: String;
    FUrlName: String;
  public
    property name: String read FName write FName;
    property urlName: String read FUrlName write FUrlName;
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
    FPage: Extended;
    FPageSize: Extended;
    FTotalPages: Extended;
  public
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

  TJTenants = class
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
    class function FromJsonString(AJsonString: string): TJTenants;
  end;

implementation


{TLinksClass_002}
function TLinksClass_002.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TLinksClass_002.FromJsonString(AJsonString: string): TLinksClass_002;
begin
  result := TJson.JsonToObject<TLinksClass_002>(AJsonString)
end;


{TUsersClass}
constructor TUsersClass.Create;
begin
  inherited;
  FLinks := TLinksClass_002.Create();
end;

destructor TUsersClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TUsersClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TUsersClass.FromJsonString(AJsonString: string): TUsersClass;
begin
  result := TJson.JsonToObject<TUsersClass>(AJsonString)
end;

{TRelationshipsClass}
constructor TRelationshipsClass.Create;
begin
  inherited;
  FUsers := TUsersClass.Create();
end;

destructor TRelationshipsClass.Destroy;
begin
  FUsers.free;
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
constructor TJTenants.Create;
begin
  inherited;
  FLinks := TLinksClass.Create();
  FMeta := TMetaClass.Create();
end;

destructor TJTenants.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  FLinks.free;
  FMeta.free;
  inherited;
end;

function TJTenants.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJTenants.FromJsonString(AJsonString: string): TJTenants;
begin
  result := TJson.JsonToObject<TJTenants>(AJsonString)
end;


end.
