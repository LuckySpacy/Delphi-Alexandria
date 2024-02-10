unit wma.EnergieverbrauchVerbrauchVerbrauchJahre;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError;

type
  TwmaEnergieverbrauchVerbrauchJahre = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchVerbrauchJahre }

uses
  Payload.EnergieverbrauchVerbrauchMonate, DB.EnergieverbrauchVerbrauchMonatList,
  DateUtils, Json.EnergieverbrauchVerbrauchMonateList, Json.EnergieverbrauchVerbrauchMonate,
  DB.EnergieverbrauchVerbrauchMonat, JSON.EnergieverbrauchVerbrauchJahreList, JSON.EnergieverbrauchVerbrauchJahre;


constructor TwmaEnergieverbrauchVerbrauchJahre.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchVerbrauchJahre.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchVerbrauchJahre.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  PEnergieverbrauchVerbrauchMonate: TPEnergieverbrauchVerbrauchMonate;
  DBVerbrauchMonateList: TDBEnergieverbrauchVerbrauchMonatList;
  DBVerbrauchMonate: TDBEnergieverbrauchVerbrauchMonat;
  JJahrList: TJEnergieverbrauchVerbrauchJahreList;
  JJahr: TJEnergieverbrauchVerbrauchJahre;
  DatumVon: TDateTime;
  DatumBis: TDateTime;
  MinJahr: Integer;
  MaxJahr: Integer;
  Jahr: Integer;
  i1: Integer;
  Verbrauch: Currency;
begin
  inherited;
  PEnergieverbrauchVerbrauchMonate := TPEnergieverbrauchVerbrauchMonate.Create;
  DBVerbrauchMonate := TDBEnergieverbrauchVerbrauchMonat.Create(nil);
  DBVerbrauchMonateList := TDBEnergieverbrauchVerbrauchMonatList.Create;
  JJahrList := TJEnergieverbrauchVerbrauchJahreList.Create;
  try
    DBVerbrauchMonate.Trans := fTrans;
    DBVerbrauchMonateList.Trans := fTrans;
    PEnergieverbrauchVerbrauchMonate.JsonString := aRequest.Content;

    if (PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsString = '') or (PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger = 0) then
      JErrorList.setError('Wert für VM_ZA_ID ist leer', c.JsonError.cJIdPayloadNichtKorrekt);
    if (PEnergieverbrauchVerbrauchMonate.FieldByName('JAHR').AsString = '') or (PEnergieverbrauchVerbrauchMonate.FieldByName('JAHR').AsInteger = 0) then
      JErrorList.setError('Wert für JAHR ist leer', c.JsonError.cJIdPayloadNichtKorrekt);

    if JErrorList.Count > 0 then
    begin
      aResponse.Content := JErrorList.JsonString;
      exit;
    end;

    MinJahr := DBVerbrauchMonate.MinJahr(PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger);
    MaxJahr := DBVerbrauchMonate.MaxJahr(PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger);

    for Jahr := MinJahr to MaxJahr do
    begin
      DatumVon := StrToDate('01.01.' + Jahr.ToString);
      DatumBis := StrToDate('31.12.' + Jahr.ToString);
      DBVerbrauchMonateList.ReadZeitraum(PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger, MonthOf(DatumVon), YearOf(DatumVon), MonthOf(DatumBis), YearOf(DatumBis));
      Verbrauch := 0;
      for i1 := 0 to DBVerbrauchMonateList.Count -1 do
      begin
        Verbrauch := Verbrauch + DBVerbrauchMonateList.Item[i1].Wert;
      end;
      JJahr := JJahrList.Add;
      JJahr.FieldByName('ZA_ID').AsInteger := PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger;
      JJahr.FieldByName('WERT').AsFloat := Verbrauch;
      JJahr.FieldByName('JAHR').AsInteger := Jahr;
    end;
    aResponse.Content := JJahrList.JsonString;
  finally
    FreeAndNil(PEnergieverbrauchVerbrauchMonate);
    FreeAndNil(DBVerbrauchMonateList);
    FreeAndNil(DBVerbrauchMonate);
    FreeAndNil(JJahrList);
  end;


end;

end.
