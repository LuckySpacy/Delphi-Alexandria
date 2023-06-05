unit Json.AktieList;

interface


uses
  Generics.Collections, Rest.Json;

type

  TDataClass = class
  private
    FAktie: String;
    FAktiv: String;
    FBiId: String;
    FDepot: String;
    FEPS: String;
    FISIN: String;
    FLink: String;
    FSymbol: String;
    FWKN: String;
    FId: String;
  public
    property Aktie: String read FAktie write FAktie;
    property Aktiv: String read FAktiv write FAktiv;
    property BiId: String read FBiId write FBiId;
    property Depot: String read FDepot write FDepot;
    property EPS: String read FEPS write FEPS;
    property ISIN: String read FISIN write FISIN;
    property Link: String read FLink write FLink;
    property Symbol: String read FSymbol write FSymbol;
    property WKN: String read FWKN write FWKN;
    property id: String read FId write FId;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass;
  end;

  TJAktieList = class
  private
    FData: TArray<TDataClass>;
  public
    property data: TArray<TDataClass> read FData write FData;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJAktieList;
    function Add: TDataClass;
  end;

implementation

{TDataClass}


function TDataClass.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TDataClass.FromJsonString(AJsonString: string): TDataClass;
begin
  result := TJson.JsonToObject<TDataClass>(AJsonString)
end;

{TJAktieList}


destructor TJAktieList.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  inherited;
end;

function TJAktieList.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJAktieList.FromJsonString(AJsonString: string): TJAktieList;
begin
  result := TJson.JsonToObject<TJAktieList>(AJsonString)
end;

function TJAktieList.Add: TDataClass;
begin
  Result := TDataClass.Create;
  SetLength(FData, Length(fData)+1);
  FData[high(fData)] := Result;
end;


end.
