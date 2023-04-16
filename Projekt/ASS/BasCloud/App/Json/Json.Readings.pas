unit Json.Readings;

interface

uses
  Generics.Collections, Rest.Json, System.SysUtils, DateUtils;

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

  TDeviceClass = class
  private
    FLinks: TLinksClass_002;
  public
    property links: TLinksClass_002 read FLinks write FLinks;
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

  TJReadings = class
  private
    FData: TArray<TDataClass>;
    FJsonapi: String;
    FLinks: TLinksClass;
    FMeta: TMetaClass;
    function getDateFromTimestamp(aTimeStamp: string): TDateTime;
  public
    property data: TArray<TDataClass> read FData write FData;
    property jsonapi: String read FJsonapi write FJsonapi;
    property links: TLinksClass read FLinks write FLinks;
    property meta: TMetaClass read FMeta write FMeta;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    function getLastReadingIndex: Integer;
    class function FromJsonString(AJsonString: string): TJReadings;
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

{TDeviceClass}

constructor TDeviceClass.Create;
begin
  inherited;
  FLinks := TLinksClass_002.Create();
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

constructor TJReadings.Create;
begin
  inherited;
  FLinks := TLinksClass.Create();
  FMeta := TMetaClass.Create();
end;

destructor TJReadings.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  FLinks.free;
  FMeta.free;
  inherited;
end;

function TJReadings.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJReadings.FromJsonString(AJsonString: string): TJReadings;
begin
  result := TJson.JsonToObject<TJReadings>(AJsonString)
end;


function TJReadings.getLastReadingIndex: Integer;
var
  i1: Integer;
  LastDatum: TDateTime;
  AktDatum : TDateTime;
begin
  Result := 0;
  LastDatum := 0;
  for i1 := 0 to Length(FData) -1 do
  begin
    AktDatum := getDateFromTimestamp(fData[i1].meta.createdAt);
    if AktDatum > LastDatum then
    begin
      LastDatum := AktDatum;
      Result := i1;
    end;
  end;
end;

function TJReadings.getDateFromTimestamp(aTimeStamp: string): TDateTime;
var
  Jahr, Monat, Tag: Word;
  Std, Min, Sek, Mill: Word;
  sJahr, sMonat, sTag: string;
  sStd, sMin, sSek, sMill: string;
begin
  try
    sJahr  := copy(aTimeStamp, 1, 4);
    sMonat := copy(aTimeStamp, 6, 2);
    sTag   := copy(aTimeStamp, 9, 2);
    sStd   := copy(aTimeStamp, 12,2);
    sMin   := copy(aTimeStamp, 15,2);
    sSek   := copy(aTimeStamp, 18,2);
    sMill  := copy(aTimeStamp, 21,3);
    Jahr   := StrToInt(sJahr);
    Monat  := StrToInt(sMonat);
    Tag    := StrToInt(sTag);
    Std    := StrToInt(sStd);
    Min    := StrToInt(sMin);
    Sek    := StrToInt(sSek);
    Mill   := StrToInt(sMill);
    Result := EncodeDateTime(Jahr, Monat, Tag, Std, Min, Sek, Mill);
  except
    Result := 0;
  end;
end;

end.

