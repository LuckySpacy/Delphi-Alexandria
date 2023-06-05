unit
  DB.Kurs;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db,
  System.Generics.Collections;

type
  TDBKurs = class(TDBBasis)
  private
    fKurs: real;
    fDatum: TDateTime;
    fAkId: Integer;
    fKGV: real;
    fEPS: real;
    procedure setAkId(const Value: Integer);
    procedure setDatum(const Value: TDateTime);
    procedure setKurs(const Value: real);
    procedure setEPS(const Value: real);
    procedure setKGV(const Value: real);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AKId: Integer read fAkId write setAkId;
    property Datum: TDateTime read fDatum write setDatum;
    property Kurs: real read fKurs write setKurs;
    property EPS: real read fEPS write setEPS;
    property KGV: real read fKGV write setKGV;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LastKurs(aAkId: Integer);
    procedure LastKursFromStartDate(aAkId: Integer; aDatum: TDateTime);
    procedure ErsterKurs(aAkId: Integer);
    procedure MaxKurs(aAkId: Integer; aStartDatum, aEndeDatum: TDateTime);
    procedure MinKurs(aAkId: Integer; aStartDatum, aEndeDatum: TDateTime);
    procedure YearList(aAkId: Integer; var aYearList: TList<Integer>);
    procedure ErsterKursVonStartdatum(aAkId: Integer; aStartDatum: TDateTime);
    procedure LetzterKursVonEnddatum(aAkId: Integer; aStartDatum, aEndDatum: TDateTime);
  end;

implementation

{ TDBKurs }

uses
  DateUtils;

constructor TDBKurs.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('KU_AK_ID', ftInteger);
  FFeldList.Add('KU_DATUM', ftDate);
  FFeldList.Add('KU_KURS', ftFloat);
  FFeldList.Add('KU_EPS', ftFloat);
  FFeldList.Add('KU_KGV', ftFloat);
  Init;
end;

destructor TDBKurs.Destroy;
begin
  inherited;
end;

procedure TDBKurs.Init;
begin
  inherited;
  FuelleDBFelder;
end;

function TDBKurs.getTableName: string;
begin
  Result := 'Kurs';
end;

function TDBKurs.getTablePrefix: string;
begin
  Result := 'KU';
end;

procedure TDBKurs.FuelleDBFelder;
begin
  fFeldList.FieldByName('KU_ID').AsInteger     := fID;
  fFeldList.FieldByName('KU_AK_ID').AsInteger  := fAKID;
  fFeldList.FieldByName('KU_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('KU_KURS').AsFloat     := fKurs;
  fFeldList.FieldByName('KU_EPS').AsFloat      := fEPS;
  fFeldList.FieldByName('KU_KGV').AsFloat      := fKGV;
  inherited;
end;

function TDBKurs.getGeneratorName: string;
begin
  Result := 'KU_ID';
end;

procedure TDBKurs.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID  := aQuery.FieldByName('KU_AK_ID').AsInteger;
  fDatum := aQuery.FieldByName('KU_DATUM').AsDateTime;
  fKurs  := aQuery.FieldByName('KU_KURS').AsFloat;
  fEPS   := aQuery.FieldByName('KU_EPS').AsFloat;
  fKGV   := aQuery.FieldByName('KU_KGV').AsFloat;
  FuelleDBFelder;
end;

procedure TDBKurs.SaveToDB;
begin
  inherited;
end;

procedure TDBKurs.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);  FuelleDBFelder;
end;

procedure TDBKurs.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKurs.setEPS(const Value: real);
begin
  UpdateV(fEPS, Value, 2);
  FuelleDBFelder;
end;

procedure TDBKurs.setKGV(const Value: real);
begin
  UpdateV(fKGV, Value, 2);
  FuelleDBFelder;
end;

procedure TDBKurs.setKurs(const Value: real);
begin
  UpdateV(fKurs, Value, 2);
  FuelleDBFelder;
end;

procedure TDBKurs.YearList(aAkId: Integer; var aYearList: TList<Integer>);
begin
  aYearList.Clear;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select distinct extract (year from ku_datum) from kurs where ku_DELETE != ' + QuotedStr('T') +
                     ' and ku_ak_id = ' + IntToStr(aAkId)+
                     ' order by ku_datum';
  OpenTrans;
  try
    fQuery.Open;
    while not fQuery.Eof do
    begin
      aYearList.Add(fQuery.Fields[0].AsInteger);
      fQuery.Next;
    end;
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.LastKurs(aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs where ku_DELETE != ' + QuotedStr('T') +
                     ' and ku_ak_id = ' + IntToStr(aAkId)+
                     ' order by ku_datum desc';
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.LastKursFromStartDate(aAkId: Integer; aDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs where ku_DELETE != ' + QuotedStr('T') +
                     ' and ku_ak_id = ' + IntToStr(aAkId) +
                     ' and ku_datum >= :datum' +
                     ' order by ku_datum';
  fQuery.ParamByName('datum').AsDateTime := trunc(aDatum);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.ErsterKurs(aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs where ku_DELETE != ' + QuotedStr('T') +
                     ' and ku_ak_id = ' + IntToStr(aAkId)+
                     ' order by ku_datum';
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


procedure TDBKurs.MaxKurs(aAkId: Integer; aStartDatum, aEndeDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs ' +
                     ' where ku_ak_id = ' + IntToStr(aAkId)+
                     ' and ku_datum >= :StartDatum' +
                     ' and ku_datum <= :EndeDatum' +
                     ' order by ku_kurs desc';
  fQuery.ParamByName('StartDatum').AsDateTime := aStartDatum;
  fQuery.ParamByName('EndeDatum').AsDateTime := aEndeDatum;
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.MinKurs(aAkId: Integer; aStartDatum, aEndeDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs ' +
                     ' where ku_ak_id = ' + IntToStr(aAkId)+
                     ' and ku_datum >= :StartDatum' +
                     ' and ku_datum <= :EndeDatum' +
                     ' order by ku_kurs';
  fQuery.ParamByName('StartDatum').AsDateTime := aStartDatum;
  fQuery.ParamByName('EndeDatum').AsDateTime := aEndeDatum;
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.ErsterKursVonStartdatum(aAkId: Integer; aStartDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs ' +
                     ' where ku_ak_id = ' + IntToStr(aAkId)+
                     ' and ku_datum >= :StartDatum' +
                     ' and ku_kurs > 0' +
                     ' order by ku_Datum';
  fQuery.ParamByName('StartDatum').AsDateTime := aStartDatum;
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBKurs.LetzterKursVonEnddatum(aAkId: Integer; aStartDatum, aEndDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from kurs ' +
                     ' where ku_ak_id = ' + IntToStr(aAkId)+
                     ' and ku_datum >= :StartDatum' +
                     ' and ku_datum <= :EndDatum' +
                     ' and ku_kurs > 0' +
                     ' order by ku_Datum desc';
  fQuery.ParamByName('EndDatum').AsDateTime := EndOfTheDay(aEndDatum);
  fQuery.ParamByName('StartDatum').AsDateTime := EndOfTheDay(aStartDatum);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;




end.
