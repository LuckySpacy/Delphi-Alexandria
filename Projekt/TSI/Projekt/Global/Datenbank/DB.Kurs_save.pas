unit DB.Kurs;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBKurs = class(TDBBasis)
  private
    fKurs: real;
    fDatum: TDateTime;
    fAkId: Integer;
    procedure setAkId(const Value: Integer);
    procedure setDatum(const Value: TDateTime);
    procedure setKurs(const Value: real);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AKId: Integer read fAkId write setAkId;
    property Datum: TDateTime read fDatum write setDatum;
    property Kurs: real read fKurs write setKurs;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LastKurs(aAkId: Integer);
    procedure LastKursFromStartDate(aAkId: Integer; aDatum: TDateTime);
    procedure ErsterKurs(aAkId: Integer);
  end;

implementation

{ TDBKurs }

constructor TDBKurs.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('KU_AK_ID', ftInteger);
  FFeldList.Add('KU_DATUM', ftDate);
  FFeldList.Add('KU_KURS', ftFloat);
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
  FuelleDBFelder;
end;

procedure TDBKurs.SaveToDB;
begin
  inherited;

end;

procedure TDBKurs.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBKurs.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  FuelleDBFelder;
end;

procedure TDBKurs.setKurs(const Value: real);
begin
  UpdateV(fKurs, Value, 2);
  FuelleDBFelder;
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
  fQuery.SQL.Text := ' select min(ku_datum) from kurs where ku_DELETE != ' + QuotedStr('T') +
                     ' and ku_ak_id = ' + IntToStr(aAkId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

end.

