unit Json.AnsichtList;

interface

uses Generics.Collections, Rest.Json;

type

  TDataClass = class
  private
    FHT_EPS: String;
    FHT_KGV: String;
    FHT_KGVSORT: String;
    FHT_LETZTERKURS: String;
    FHT_LETZTERKURSDATUM: String;
    FAk_aktie: String;
    FAk_aktiv: String;
    FAk_bi_id: String;
    FAk_depot: String;
    FAk_id: String;
    FAk_link: String;
    FAk_symbol: String;
    FAk_wkn: String;
    FAp_datum1: String;
    FAp_datum14: String;
    FAp_datum180: String;
    FAp_datum30: String;
    FAp_datum365: String;
    FAp_datum60: String;
    FAp_datum7: String;
    FAp_datum90: String;
    FAp_wert1: String;
    FAp_wert14: String;
    FAp_wert180: String;
    FAp_wert30: String;
    FAp_wert365: String;
    FAp_wert60: String;
    FAp_wert7: String;
    FAp_wert90: String;
    FHt_hoch_hjahrdatum: String;
    FHt_hoch_hjahrkurs: String;
    FHt_hoch_jahrdatum: String;
    FHt_hoch_jahrkurs: String;
    FHt_tief_hjahrdatum: String;
    FHt_tief_hjahrkurs: String;
    FHt_tief_jahrdatum: String;
    FHt_tief_jahrkurs: String;
    FTl_datum12: String;
    FTl_datum27: String;
    FTl_wert12: String;
    FTl_wert27: String;
  public
    property HT_EPS: String read FHT_EPS write FHT_EPS;
    property HT_KGV: String read FHT_KGV write FHT_KGV;
    property HT_KGVSORT: String read FHT_KGVSORT write FHT_KGVSORT;
    property HT_LETZTERKURS: String read FHT_LETZTERKURS write FHT_LETZTERKURS;
    property HT_LETZTERKURSDATUM: String read FHT_LETZTERKURSDATUM write FHT_LETZTERKURSDATUM;
    property ak_aktie: String read FAk_aktie write FAk_aktie;
    property ak_aktiv: String read FAk_aktiv write FAk_aktiv;
    property ak_bi_id: String read FAk_bi_id write FAk_bi_id;
    property ak_depot: String read FAk_depot write FAk_depot;
    property ak_id: String read FAk_id write FAk_id;
    property ak_link: String read FAk_link write FAk_link;
    property ak_symbol: String read FAk_symbol write FAk_symbol;
    property ak_wkn: String read FAk_wkn write FAk_wkn;
    property ap_datum1: String read FAp_datum1 write FAp_datum1;
    property ap_datum14: String read FAp_datum14 write FAp_datum14;
    property ap_datum180: String read FAp_datum180 write FAp_datum180;
    property ap_datum30: String read FAp_datum30 write FAp_datum30;
    property ap_datum365: String read FAp_datum365 write FAp_datum365;
    property ap_datum60: String read FAp_datum60 write FAp_datum60;
    property ap_datum7: String read FAp_datum7 write FAp_datum7;
    property ap_datum90: String read FAp_datum90 write FAp_datum90;
    property ap_wert1: String read FAp_wert1 write FAp_wert1;
    property ap_wert14: String read FAp_wert14 write FAp_wert14;
    property ap_wert180: String read FAp_wert180 write FAp_wert180;
    property ap_wert30: String read FAp_wert30 write FAp_wert30;
    property ap_wert365: String read FAp_wert365 write FAp_wert365;
    property ap_wert60: String read FAp_wert60 write FAp_wert60;
    property ap_wert7: String read FAp_wert7 write FAp_wert7;
    property ap_wert90: String read FAp_wert90 write FAp_wert90;
    property ht_hoch_hjahrdatum: String read FHt_hoch_hjahrdatum write FHt_hoch_hjahrdatum;
    property ht_hoch_hjahrkurs: String read FHt_hoch_hjahrkurs write FHt_hoch_hjahrkurs;
    property ht_hoch_jahrdatum: String read FHt_hoch_jahrdatum write FHt_hoch_jahrdatum;
    property ht_hoch_jahrkurs: String read FHt_hoch_jahrkurs write FHt_hoch_jahrkurs;
    property ht_tief_hjahrdatum: String read FHt_tief_hjahrdatum write FHt_tief_hjahrdatum;
    property ht_tief_hjahrkurs: String read FHt_tief_hjahrkurs write FHt_tief_hjahrkurs;
    property ht_tief_jahrdatum: String read FHt_tief_jahrdatum write FHt_tief_jahrdatum;
    property ht_tief_jahrkurs: String read FHt_tief_jahrkurs write FHt_tief_jahrkurs;
    property tl_datum12: String read FTl_datum12 write FTl_datum12;
    property tl_datum27: String read FTl_datum27 write FTl_datum27;
    property tl_wert12: String read FTl_wert12 write FTl_wert12;
    property tl_wert27: String read FTl_wert27 write FTl_wert27;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TDataClass;
  end;

  TJAnsichtList = class
  private
    FData: TArray<TDataClass>;
  public
    property data: TArray<TDataClass> read FData write FData;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TJAnsichtList;
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

{TJAnsichtList}

destructor TJAnsichtList.Destroy;
var
  LdataItem: TDataClass;
begin

 for LdataItem in FData do
   LdataItem.free;

  inherited;
end;

function TJAnsichtList.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TJAnsichtList.FromJsonString(AJsonString: string): TJAnsichtList;
begin
  result := TJson.JsonToObject<TJAnsichtList>(AJsonString)
end;

function TJAnsichtList.Add: TDataClass;
begin
  Result := TDataClass.Create;
  SetLength(FData, Length(fData)+1);
  FData[high(fData)] := Result;
end;

end.

