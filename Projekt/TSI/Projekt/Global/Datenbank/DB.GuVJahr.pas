unit DB.GuVJahr;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBGuVJahr = class(TDBBasis)
  private
    fAkId: Integer;
    fJahr: Integer;
    fStartDatum: TDateTime;
    fEndDatum: TDateTime;
    fStartWert: real;
    fEndWert: real;
    fProzent: real;
    procedure setAkId(const Value: Integer);
    procedure setJahr(const Value: Integer);
    procedure setStartDatum(const Value: TDateTime);
    procedure setEndDatum(const Value: TDateTime);
    procedure setStartWert(const Value: real);
    procedure setEndWert(const Value: real);
    procedure setProzent(const Value: real);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AkId: Integer read fAkId write setAkId;
    property Jahr: Integer read fJahr write setJahr;
    property StartDatum: TDateTime read fStartDatum write setStartDatum;
    property EndDatum: TDateTime read fEndDatum write setEndDatum;
    property StartWert: real read fStartWert write setStartWert;
    property EndWert: real read fEndWert write setEndWert;
    property Prozent: real read fProzent write setProzent;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadJahr(aAkId, aJahr: Integer);
  end;


implementation

{ TDBAbwProz }

constructor TDBGuVJahr.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('GV_AK_ID', ftInteger);
  FFeldList.Add('GV_JAHR', ftInteger);
  FFeldList.Add('GV_STARTDATUM', ftDate);
  FFeldList.Add('GV_ENDDATUM', ftDate);
  FFeldList.Add('GV_STARTWERT', ftFloat);
  FFeldList.Add('GV_ENDWERT', ftFloat);
  FFeldList.Add('GV_PROZENT', ftFloat);
end;

destructor TDBGuVJahr.Destroy;
begin

  inherited;
end;

function TDBGuVJahr.getGeneratorName: string;
begin
  Result := 'GV_ID';
end;

function TDBGuVJahr.getTableName: string;
begin
  Result := 'GUVJAHR';
end;

function TDBGuVJahr.getTablePrefix: string;
begin
  Result := 'GV';
end;


procedure TDBGuVJahr.Init;
begin
  inherited;
  fAkId := 0;
  fJahr := 0;
  fStartDatum := 0;
  fEndDatum   := 0;
  fStartWert  := 0;
  fEndWert    := 0;
  fProzent    := 0;
  FuelleDBFelder;
end;


procedure TDBGuVJahr.FuelleDBFelder;
begin
  fFeldList.FieldByName('GV_ID').AsInteger           := fID;
  fFeldList.FieldByName('GV_AK_ID').AsInteger        := fAKID;
  fFeldList.FieldByName('GV_JAHR').AsInteger         := fJahr;
  fFeldList.FieldByName('GV_STARTDATUM').AsDateTime  := fStartDatum;
  fFeldList.FieldByName('GV_ENDDATUM').AsDateTime    := fEndDatum;
  fFeldList.FieldByName('GV_STARTWERT').AsFloat      := fStartWert;
  fFeldList.FieldByName('GV_ENDWERT').AsFloat        := fEndWert;
  fFeldList.FieldByName('GV_PROZENT').AsFloat        := fProzent;

  inherited;

end;



procedure TDBGuVJahr.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID     := aQuery.FieldByName('GV_AK_ID').AsInteger;
  fJahr     := aQuery.FieldByName('GV_JAHR').AsInteger;
  fStartDatum     := aQuery.FieldByName('GV_STARTDATUM').AsDateTime;
  fEndDatum     := aQuery.FieldByName('GV_ENDDATUM').AsDateTime;
  fStartWert     := aQuery.FieldByName('GV_STARTWERT').AsFloat;
  fEndWert     := aQuery.FieldByName('GV_ENDWERT').AsFloat;
  fProzent     := aQuery.FieldByName('GV_PROZENT').AsFloat;
  FuelleDBFelder;
end;


procedure TDBGuVJahr.SaveToDB;
begin
  inherited;

end;

procedure TDBGuVJahr.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setEndDatum(const Value: TDateTime);
begin
  UpdateV(fEndDatum, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setEndWert(const Value: real);
begin
  UpdateV(fEndWert, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setJahr(const Value: Integer);
begin
  UpdateV(fJahr, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setProzent(const Value: real);
begin
  UpdateV(fProzent, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setStartDatum(const Value: TDateTime);
begin
  UpdateV(fStartDatum, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahr.setStartWert(const Value: real);
begin
  UpdateV(fStartWert, Value,2);
  FuelleDBFelder;
end;



procedure TDBGuVJahr.ReadJahr(aAkId, aJahr: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where gv_ak_id = ' + IntToStr(aAkId) +
                     ' and   gv_jahr = ' + IntToStr(aJahr);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
