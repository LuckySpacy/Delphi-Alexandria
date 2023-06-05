unit DB.TSI;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBTSI = class(TDBBasis)
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
    procedure ReadWert(aAkId, aWochen: Integer; aDatum: TDateTime);
  end;

implementation


{ TDBTSI }

constructor TDBTSI.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('TS_AK_ID', ftInteger);
  FFeldList.Add('TS_WOCHEN', ftInteger);
  FFeldList.Add('TS_DATUM', ftDate);
  FFeldList.Add('TS_WERT', ftFloat);
end;

destructor TDBTSI.Destroy;
begin

  inherited;
end;

procedure TDBTSI.Init;
begin
  inherited;
  FuelleDBFelder;
end;


function TDBTSI.getTableName: string;
begin
  Result := 'TSI';
end;

function TDBTSI.getTablePrefix: string;
begin
  Result := 'TS';
end;


procedure TDBTSI.FuelleDBFelder;
begin
  fFeldList.FieldByName('TS_ID').AsInteger     := fID;
  fFeldList.FieldByName('TS_AK_ID').AsInteger  := fAKID;
  fFeldList.FieldByName('TS_WOCHEN').AsInteger := fWochen;
  fFeldList.FieldByName('TS_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('TS_WERT').AsFloat     := fWert;
  inherited;
end;

function TDBTSI.getGeneratorName: string;
begin
  Result := 'TS_ID';
end;


procedure TDBTSI.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID   := aQuery.FieldByName('TS_AK_ID').AsInteger;
  fWochen := aQuery.FieldByName('TS_WOCHEN').AsInteger;
  fDatum  := aQuery.FieldByName('TS_DATUM').AsDateTime;
  fWert   := aQuery.FieldByName('TS_WERT').AsFloat;
  FuelleDBFelder;
end;


procedure TDBTSI.SaveToDB;
begin
  inherited;

end;

procedure TDBTSI.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBTSI.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  FuelleDBFelder;
end;

procedure TDBTSI.setWert(const Value: real);
begin
  UpdateV(fWert, Value, 4);
  FuelleDBFelder;
end;

procedure TDBTSI.setWochen(const Value: Integer);
begin
  UpdateV(fWochen, Value);
  FuelleDBFelder;
end;



procedure TDBTSI.ReadWert(aAkId, aWochen: Integer; aDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where ts_ak_id = ' + IntToStr(aAkId) +
                     ' and   ts_wochen = ' + IntToStr(aWochen) +
                     ' and   ts_datum = :datum';
  OpenTrans;
  try
    fQuery.ParamByName('Datum').AsDateTime := aDatum;
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.


