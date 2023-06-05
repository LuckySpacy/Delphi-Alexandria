unit Form.TSIAnsicht;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.StdCtrls,
  Communication.Base, API.Base, Vcl.ComCtrls, Form.RestTest, Objekt.AnsichtList,
  Objekt.Ansicht, Json.AnsichtList, Form.TSI2;

type
  Tfrm_TSIAnsicht = class(TForm)
    NetHTTPClient: TNetHTTPClient;
    NetHTTPRequest: TNetHTTPRequest;
    pg: TPageControl;
    tbs_RestTest: TTabSheet;
    tbs_TSI2: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fCommunication : TCommunicationBase;
    fAPIBase: TAPIBase;
    fFormRestTest: Tfrm_RestTest;
    fFormTSI2: Tfrm_TSI2;
    fAnsichtList: TAnsichtList;
    procedure ReadAnsichtList;
  public
  end;

var
  frm_TSIAnsicht: Tfrm_TSIAnsicht;

implementation

{$R *.dfm}


procedure Tfrm_TSIAnsicht.FormCreate(Sender: TObject);
begin
  fCommunication := TCommunicationBase.Create;
  fAPIBase       := TAPIBase.Create(fCommunication);
  fFormRestTest  := Tfrm_RestTest.Create(Self);
  fFormRestTest.Communication := fCommunication;
  fFormRestTest.Parent := tbs_RestTest;
  fFormRestTest.Align := alClient;
  fFormRestTest.Show;
  fAnsichtList := TAnsichtList.Create;

  fFormTSI2 := Tfrm_TSI2.Create(Self);
  fFormTSI2.Parent := tbs_TSI2;
  fFormTSI2.Align := alClient;
  fFormTSI2.Show;


end;

procedure Tfrm_TSIAnsicht.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fAPIBase);
  FreeAndNil(fCommunication);
  FreeAndNil(fAnsichtList);
end;

procedure Tfrm_TSIAnsicht.FormShow(Sender: TObject);
begin
  ReadAnsichtList;
  fFormTSI2.setAnsichtList(fAnsichtList);
end;

procedure Tfrm_TSIAnsicht.ReadAnsichtList;
var
  JAnsichtList: TJAnsichtList;
  s: string;
  i1: Integer;
  Data: Json.AnsichtList.TDataClass;
  Ansicht: TAnsicht;
begin
  //fCommunication.Get('http://localhost:8080/Ansichtlist');
  fCommunication.Get('http://localhost:8091/Ansichtlist');
  //fCommunication.Get('http://85.214.205.43:8091/Ansichtlist');
  s := fCommunication.Content;
  JAnsichtList := TJAnsichtList.FromJsonString(s);
  try
    fAnsichtList.clear;
    for i1 := 0 to Length(JAnsichtList.Data) -1 do
    begin
      Data := JAnsichtList.data[i1];
      Ansicht := fAnsichtList.Add;
      Ansicht.AkId    := Data.ak_id.ToInteger;
      Ansicht.Aktie   := Data.ak_aktie;
      Ansicht.WKN     := Data.ak_wkn;
      Ansicht.Link    := Data.ak_link;
      Ansicht.BiId    := Data.ak_bi_id.ToInteger;
      Ansicht.Symbol  := Data.ak_symbol;
      Ansicht.Depot   := Data.ak_depot = 'T';
      Ansicht.Aktiv   := Data.ak_aktiv = 'T';
      Ansicht.Datum12 := StrToDate(Data.tl_datum12);
      Ansicht.Wert12  := StrToFloat(Data.tl_wert12);
      Ansicht.Datum27 := StrToDate(Data.tl_datum27);
      Ansicht.Wert27  := StrToFloat(Data.tl_wert27);
      Ansicht.HochJahrKurs := StrToFloat(Data.ht_hoch_jahrkurs);
      Ansicht.HochJahrDatum := StrToDate(Data.ht_hoch_jahrdatum);
      Ansicht.HochHJahrKurs := StrToFloat(Data.ht_hoch_hjahrkurs);
      Ansicht.HochHJahrDatum := StrToDate(data.ht_hoch_hjahrdatum);
      Ansicht.TiefJahrKurs := StrToFloat(Data.ht_tief_jahrkurs);
      Ansicht.TiefJahrDatum := StrToDate(Data.ht_tief_jahrdatum);
      Ansicht.TiefHJahrKurs := StrToFloat(Data.ht_tief_hjahrkurs);
      Ansicht.TiefHJahrDatum := StrToDate(data.ht_tief_hjahrdatum);
      Ansicht.EPS := StrToFloat(data.HT_EPS);
      Ansicht.KGV := StrToFloat(data.HT_KGV);
      Ansicht.KGVSort := data.HT_KGVSORT;
      Ansicht.Datum7 := StrToDate(data.ap_datum7);
      Ansicht.Wert7  := StrToFloat(data.ap_wert7);
      Ansicht.Datum14 := StrToDate(data.ap_datum14);
      Ansicht.Wert14  := StrToFloat(data.ap_wert14);
      Ansicht.Datum30 := StrToDate(data.ap_datum30);
      Ansicht.Wert30  := StrToFloat(data.ap_wert30);
      Ansicht.Datum60 := StrToDate(data.ap_datum60);
      Ansicht.Wert60  := StrToFloat(data.ap_wert60);
      Ansicht.Datum90 := StrToDate(data.ap_datum90);
      Ansicht.Wert90  := StrToFloat(data.ap_wert90);
      Ansicht.Datum180 := StrToDate(data.ap_datum180);
      Ansicht.Wert180  := StrToFloat(data.ap_wert180);
      Ansicht.Datum365 := StrToDate(data.ap_datum365);
      Ansicht.Wert365  := StrToFloat(data.ap_wert365);
      Ansicht.Datum1   := StrToDate(data.ap_datum1);
      Ansicht.Wert1    := StrToFloat(data.ap_wert1);
      Ansicht.LetzterKurs := StrToFloat(data.HT_LETZTERKURS);
      Ansicht.LetzterKursDatum := StrToDate(data.HT_LETZTERKURSDATUM);
    end;
  finally
    FreeAndNil(JAnsichtList);
  end;
end;

procedure Tfrm_TSIAnsicht.Button1Click(Sender: TObject);
begin
  fAPIBase.Get('');
end;



end.
