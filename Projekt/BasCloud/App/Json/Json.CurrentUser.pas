unit Json.CurrentUser;

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

  TTenantClass = class
  private
    FLinks: TLinksClass_001;
  public
    property links: TLinksClass_001 read FLinks write FLinks;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TTenantClass;
  end;

  TRelationshipsClass = class
  private
    FTenant: TTenantClass;
  public
    property tenant: TTenantClass read FTenant write FTenant;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TRelationshipsClass;
  end;

  TAttributesClass = class
  private
    FEmail: String;
    FRole: String;
  public
    property email: String read FEmail write FEmail;
    property role: String read FRole write FRole;
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

  TJCurrentUser = class
  private
    FData: TDataClass;
    FJsonapi: String;
  public
    property data: TDataClass read FData write FData;
    property jsonapi: String read FJsonapi write FJsonapi;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJCurrentUser;
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

{TTenantClass}

constructor TTenantClass.Create;
begin
  inherited;
  FLinks := TLinksClass_001.Create();
end;

destructor TTenantClass.Destroy;
begin
  FLinks.free;
  inherited;
end;

function TTenantClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TTenantClass.FromJsonString(AJsonString: string): TTenantClass;
begin
  result := TJson.JsonToObject<TTenantClass>(AJsonString)
end;

{TRelationshipsClass}

constructor TRelationshipsClass.Create;
begin
  inherited;
  FTenant := TTenantClass.Create();
end;

destructor TRelationshipsClass.Destroy;
begin
  FTenant.free;
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

{TJCurrentUser}

constructor TJCurrentUser.Create;
begin
  inherited;
  FData := TDataClass.Create();
end;

destructor TJCurrentUser.Destroy;
begin
  FData.free;
  inherited;
end;

function TJCurrentUser.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJCurrentUser.FromJsonString(AJsonString: string): TJCurrentUser;
begin
  result := TJson.JsonToObject<TJCurrentUser>(AJsonString)
end;

end.

