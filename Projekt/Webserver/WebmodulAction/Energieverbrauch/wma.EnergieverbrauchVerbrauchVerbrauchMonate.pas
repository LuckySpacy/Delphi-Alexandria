unit wma.EnergieverbrauchVerbrauchVerbrauchMonate;

interface

uses
  System.SysUtils, System.Variants, System.Classes, wma.BaseEnergieverbrauch, Web.HTTPApp,
  c.JsonError;

type
  TwmaEnergieverbrauchVerbrauchMonate = class(TwmaBaseEnergieverbrauch)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoIt(aRequest: TWebRequest; aResponse: TWebResponse); override;
  end;

implementation

{ TwmaEnergieverbrauchVerbrauchMonate }

uses
  Payload.EnergieverbrauchVerbrauchMonate, DB.EnergieverbrauchVerbrauchMonatList,
  DateUtils, Json.EnergieverbrauchVerbrauchMonateList, Json.EnergieverbrauchVerbrauchMonate;


constructor TwmaEnergieverbrauchVerbrauchMonate.Create;
begin
  inherited;

end;

destructor TwmaEnergieverbrauchVerbrauchMonate.Destroy;
begin

  inherited;
end;

procedure TwmaEnergieverbrauchVerbrauchMonate.DoIt(aRequest: TWebRequest;
  aResponse: TWebResponse);
var
  PEnergieverbrauchVerbrauchMonate: TPEnergieverbrauchVerbrauchMonate;
  DBVerbrauchMonateList: TDBEnergieverbrauchVerbrauchMonatList;
  JMonatList: TJEnergieverbrauchVerbrauchMonateList;
  JMonat: TJEnergieverbrauchVerbrauchMonate;
  DatumVon: TDateTime;
  DatumBis: TDateTime;
  i1: Integer;
begin
  inherited;
  PEnergieverbrauchVerbrauchMonate := TPEnergieverbrauchVerbrauchMonate.Create;
  DBVerbrauchMonateList := TDBEnergieverbrauchVerbrauchMonatList.Create;
  JMonatList := TJEnergieverbrauchVerbrauchMonateList.Create;
  try
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

    DatumVon := StrToDate('01.01.' + PEnergieverbrauchVerbrauchMonate.FieldByName('JAHR').AsString);
    DatumBis := StrToDate('31.12.' + PEnergieverbrauchVerbrauchMonate.FieldByName('JAHR').AsString);
    DBVerbrauchMonateList.ReadZeitraum(PEnergieverbrauchVerbrauchMonate.FieldByName('VM_ZA_ID').AsInteger, MonthOf(DatumVon), YearOf(DatumVon), MonthOf(DatumBis), YearOf(DatumBis));
    for i1 := 0 to DBVerbrauchMonateList.Count -1 do
    begin
      JMonat := JMonatList.Add;
      DBVerbrauchMonateList.Item[i1].LoadToJsonObjekt(JMonat);
    end;
    aResponse.Content := JMonatList.JsonString;
  finally
    FreeAndNil(PEnergieverbrauchVerbrauchMonate);
    FreeAndNil(DBVerbrauchMonateList);
    FreeAndNil(JMonatList);
  end;


end;

end.
