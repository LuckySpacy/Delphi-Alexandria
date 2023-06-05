unit DB.TSILast;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBTSILast = class(TDBBasis)
  private
    fDatum: TDateTime;
    fAkId: Integer;
    fWochen: Integer;
    fWert: real;
    procedure setAkId(const Value: Integer);
    procedure setDatum(const Value: TDateTime);
    procedure setWert(const Value: real);
    procedure setWochen(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AkId: Integer read fAkId write setAkId;
    property Wochen: Integer read fWochen write setWochen;
    property Datum: TDateTime read fDatum write setDatum;
    property Wert: real read fWert write setWert;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAktie(aAkId, aWochen: Integer);
  end;

implementation

{ TDBTSILast }

constructor TDBTSILast.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('TL_AK_ID', ftInteger);
  FFeldList.Add('TL_WOCHEN', ftInteger);
  FFeldList.Add('TL_DATUM', ftDate);
  FFeldList.Add('TL_WERT', ftFloat);
end;

destructor TDBTSILast.Destroy;
begin

  inherited;
end;


function TDBTSILast.getTableName: string;
begin
  Result := 'TSILAST';
end;


function TDBTSILast.getGeneratorName: string;
begin
  Result := 'TL_ID';
end;


function TDBTSILast.getTablePrefix: string;
begin
  Result := 'TL';
end;

procedure TDBTSILast.Init;
begin
  inherited;
  fDatum  := 0;
  fAkId   := 0;
  fWochen := 0;
  fWert := 0;
  FuelleDBFelder;
end;

procedure TDBTSILast.FuelleDBFelder;
begin
  fFeldList.FieldByName('TL_ID').AsInteger     := fID;
  fFeldList.FieldByName('TL_AK_ID').AsInteger  := fAKID;
  fFeldList.FieldByName('TL_WOCHEN').AsInteger := fWochen;
  fFeldList.FieldByName('TL_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('TL_WERT').AsFloat     := fWert;
  inherited;
end;


procedure TDBTSILast.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID   := aQuery.FieldByName('TL_AK_ID').AsInteger;
  fWochen := aQuery.FieldByName('TL_WOCHEN').AsInteger;
  fDatum  := aQuery.FieldByName('TL_DATUM').AsDateTime;
  fWert   := aQuery.FieldByName('TL_WERT').AsFloat;
  FuelleDBFelder;
end;


procedure TDBTSILast.SaveToDB;
begin
  inherited;

end;

procedure TDBTSILast.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBTSILast.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  FuelleDBFelder;
end;

procedure TDBTSILast.setWert(const Value: real);
begin
  UpdateV(fWert, Value, 4);
  FuelleDBFelder;
end;

procedure TDBTSILast.setWochen(const Value: Integer);
begin
  UpdateV(fWochen, Value);
  FuelleDBFelder;
end;


procedure TDBTSILast.ReadAktie(aAkId, aWochen: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where tl_ak_id = ' + IntToStr(aAkId) +
                     ' and   tl_wochen = ' + IntToStr(aWochen);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
