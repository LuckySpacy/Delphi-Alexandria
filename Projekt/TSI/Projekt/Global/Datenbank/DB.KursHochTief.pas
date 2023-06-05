unit DB.KursHochTief;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBKursHochTief = class(TDBBasis)
  private
    fAkId: Integer;
    fTiefJahrKurs: Currency;
    fTiefHJahrKurs: Currency;
    fHochJahrDatum: TDateTime;
    fHochHJahrDatum: TDateTime;
    fTiefJahrDatum: TDateTime;
    fTiefHJahrDatum: TDateTime;
    fHochJahrKurs: Currency;
    fHochHJahrKurs: Currency;
    fLetzterKursDatum: TDateTime;
    fLetzterKurs: Currency;
    fKGV: real;
    fEPS: real;
    fKGVSort: string;
    procedure setAkId(const Value: Integer);
    procedure setHochHJahrDatum(const Value: TDateTime);
    procedure setHochHJahrKurs(const Value: Currency);
    procedure setHochJahrDatum(const Value: TDateTime);
    procedure setHochJahrKurs(const Value: Currency);
    procedure setTiefHJahrDatum(const Value: TDateTime);
    procedure setTiefHJahrKurs(const Value: Currency);
    procedure setTiefJahrDatum(const Value: TDateTime);
    procedure setTiefJahrKurs(const Value: Currency);
    procedure setLetzterKurs(const Value: Currency);
    procedure setLetzterKursDatum(const Value: TDateTime);
    procedure setEPS(const Value: real);
    procedure setKGV(const Value: real);
    procedure setKGVSort(const Value: string);protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    function getKGVSort(aKGV: real): string;
  public
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAktie(aAkId: Integer);
    property AkId: Integer read fAkId write setAkId;
    property HochJahrKurs: Currency read fHochJahrKurs write setHochJahrKurs;
    property HochJahrDatum: TDateTime read fHochJahrDatum write setHochJahrDatum;
    property HochHJahrKurs: Currency read fHochHJahrKurs write setHochHJahrKurs;
    property HochHJahrDatum: TDateTime read fHochHJahrDatum write setHochHJahrDatum;
    property TiefJahrKurs: Currency read fTiefJahrKurs write setTiefJahrKurs;
    property TiefJahrDatum: TDateTime read fTiefJahrDatum write setTiefJahrDatum;
    property TiefHJahrKurs: Currency read fTiefHJahrKurs write setTiefHJahrKurs;
    property TiefHJahrDatum: TDateTime read fTiefHJahrDatum write setTiefHJahrDatum;
    property LetzterKurs: Currency read fLetzterKurs write setLetzterKurs;
    property LetzterKursDatum: TDateTime read fLetzterKursDatum write setLetzterKursDatum;
    property EPS: real read fEPS write setEPS;
    property KGV: real read fKGV write setKGV;
    property KGVSort: string read fKGVSort write setKGVSort;
  end;

implementation

{ TDBKursHochTief }

constructor TDBKursHochTief.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('HT_AK_ID', ftInteger);
  FFeldList.Add('HT_HOCH_JAHRKURS', ftFloat);
  FFeldList.Add('HT_HOCH_JAHRDATUM', ftDate);
  FFeldList.Add('HT_HOCH_HJAHRKURS', ftFloat);
  FFeldList.Add('HT_HOCH_HJAHRDATUM', ftDate);
  FFeldList.Add('HT_TIEF_JAHRKURS', ftFloat);
  FFeldList.Add('HT_TIEF_JAHRDATUM', ftDate);
  FFeldList.Add('HT_TIEF_HJAHRKURS', ftFloat);
  FFeldList.Add('HT_TIEF_HJAHRDATUM', ftDate);
  FFeldList.Add('HT_LETZTERKURS', ftFloat);
  FFeldList.Add('HT_LETZTERKURSDATUM', ftDate);
  FFeldList.Add('HT_EPS', ftFloat);
  FFeldList.Add('HT_KGV', ftFloat);
  FFeldList.Add('HT_KGVSORT', ftString);
end;

destructor TDBKursHochTief.Destroy;
begin

  inherited;
end;

function TDBKursHochTief.getGeneratorName: string;
begin
  Result := 'HT_ID';
end;

function TDBKursHochTief.getTableName: string;
begin
  Result := 'KURSHOCHTIEF';
end;


function TDBKursHochTief.getTablePrefix: string;
begin
  Result := 'HT';
end;


procedure TDBKursHochTief.Init;
begin
  inherited;
  FuelleDBFelder;
end;


procedure TDBKursHochTief.FuelleDBFelder;
begin
  fFeldList.FieldByName('HT_ID').AsInteger       := fID;
  fFeldList.FieldByName('HT_AK_ID').AsInteger    := fAKID;
  fFeldList.FieldByName('HT_HOCH_JAHRKURS').AsFloat      := fHochJahrKurs;
  fFeldList.FieldByName('HT_HOCH_JAHRDATUM').AsDateTime  := fHochJahrDatum;
  fFeldList.FieldByName('HT_HOCH_HJAHRKURS').AsFloat     := fHochHJahrKurs;
  fFeldList.FieldByName('HT_HOCH_HJAHRDATUM').AsDateTime := fHochHJahrDatum;
  fFeldList.FieldByName('HT_TIEF_JAHRKURS').AsFloat      := fTiefJahrKurs;
  fFeldList.FieldByName('HT_TIEF_JAHRDATUM').AsDateTime  := fTiefJahrDatum;
  fFeldList.FieldByName('HT_TIEF_HJAHRKURS').AsFloat     := fTiefHJahrKurs;
  fFeldList.FieldByName('HT_TIEF_HJAHRDATUM').AsDateTime := fTiefHJahrDatum;
  fFeldList.FieldByName('HT_LETZTERKURS').AsFloat         := fLetzterKurs;
  fFeldList.FieldByName('HT_LETZTERKURSDATUM').AsDateTime := fLetzterKursDatum;
  fFeldList.FieldByName('HT_EPS').AsFloat                 := fEPS;
  fFeldList.FieldByName('HT_KGV').AsFloat                 := fKGV;
  fFeldList.FieldByName('HT_KGVSORT').AsString            := fKGVSort;
  inherited;
end;


procedure TDBKursHochTief.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID           := aQuery.FieldByName('HT_AK_ID').AsInteger;
  fHochJahrKurs   := aQuery.FieldByName('HT_HOCH_JAHRKURS').AsFloat;
  fHochJahrDatum  := aQuery.FieldByName('HT_HOCH_JAHRDATUM').AsDateTime;
  fHochHJahrKurs  := aQuery.FieldByName('HT_HOCH_HJAHRKURS').AsFloat;
  fHochHJahrDatum := aQuery.FieldByName('HT_HOCH_HJAHRDATUM').AsDateTime;
  fTiefJahrKurs   := aQuery.FieldByName('HT_TIEF_JAHRKURS').AsFloat;
  fTiefJahrDatum  := aQuery.FieldByName('HT_TIEF_JAHRDATUM').AsDateTime;
  fTiefHJahrKurs  := aQuery.FieldByName('HT_TIEF_HJAHRKURS').AsFloat;
  fTiefHJahrDatum := aQuery.FieldByName('HT_TIEF_HJAHRDATUM').AsDateTime;
  fLetzterKurs      := aQuery.FieldByName('HT_LETZTERKURS').AsFloat;
  fLetzterKursDatum := aQuery.FieldByName('HT_LETZTERKURSDATUM').AsDateTime;
  fEPS              := aQuery.FieldByName('HT_EPS').AsFloat;
  fKGV              := aQuery.FieldByName('HT_KGV').AsFloat;
  fKGVSort          := aQuery.FieldByName('HT_KGVSORT').AsString;
  FuelleDBFelder;
end;

procedure TDBKursHochTief.SaveToDB;
begin
  inherited;

end;


procedure TDBKursHochTief.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;


procedure TDBKursHochTief.setEPS(const Value: real);
begin
  UpdateV(fEPS, Value, 2);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setHochHJahrDatum(const Value: TDateTime);
begin
  UpdateV(fHochHJahrDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setHochHJahrKurs(const Value: Currency);
begin
  UpdateV(fHochHJahrKurs, Value, 4);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setHochJahrDatum(const Value: TDateTime);
begin
  UpdateV(fHochJahrDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setHochJahrKurs(const Value: Currency);
begin
  UpdateV(fHochJahrKurs, Value, 4);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setKGV(const Value: real);
begin
  UpdateV(fKGV, Value, 2);
  FuelleDBFelder;
  setKGVSort(getKGVSort(fKGV));
end;

procedure TDBKursHochTief.setKGVSort(const Value: string);
begin
  UpdateV(fKGVSort, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setLetzterKurs(const Value: Currency);
begin
  UpdateV(fLetzterKurs, Value, 4);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setLetzterKursDatum(const Value: TDateTime);
begin
  UpdateV(fLetzterKursDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setTiefHJahrDatum(const Value: TDateTime);
begin
  UpdateV(fTiefHJahrDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setTiefHJahrKurs(const Value: Currency);
begin
  UpdateV(fTiefHJahrKurs, Value, 4);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setTiefJahrDatum(const Value: TDateTime);
begin
  UpdateV(fTiefJahrDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.setTiefJahrKurs(const Value: Currency);
begin
  UpdateV(fTiefJahrKurs, Value, 4);
  FuelleDBFelder;
end;

procedure TDBKursHochTief.ReadAktie(aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where ht_ak_id = ' + IntToStr(aAkId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;



function TDBKursHochTief.getKGVSort(aKGV: real): string;
var
  rValue: real;
  iVorkomma: Integer;
  rNachkomma: real;
  sNachkomma: string;
  sVorkomma: string;
  sResult: string;
begin
  rValue := aKGV;
  iVorkomma  := trunc(rValue);
  rNachkomma := rValue - iVorkomma;
  sVorkomma := IntToStr(iVorkomma);
  sNachkomma := FloatToStr(rNachkomma);
  sNachkomma := copy(sNachkomma, 3, 2);
  while Length(sVorkomma) < 10 do
    sVorkomma := '0' + sVorkomma;
  Result := sVorkomma + sNachkomma;
end;

end.
