unit DB.AbwProz;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBAbwProz = class(TDBBasis)
  private
    fDatum7: TDateTime;
    fDatum14: TDateTime;
    fDatum30: TDateTime;
    fDatum60: TDateTime;
    fDatum90: TDateTime;
    fDatum180: TDateTime;
    fDatum365: TDateTime;
    fDatum1: TDateTime;
    fAkId: Integer;
    fWert7: real;
    fWert14: real;
    fWert30: real;
    fWert60: real;
    fWert90: real;
    fWert180: real;
    fWert365: real;
    fWert1: real;
    procedure setAkId(const Value: Integer);
    procedure setDatum7(const Value: TDateTime);
    procedure setDatum14(const Value: TDateTime);
    procedure setDatum30(const Value: TDateTime);
    procedure setDatum60(const Value: TDateTime);
    procedure setDatum90(const Value: TDateTime);
    procedure setDatum180(const Value: TDateTime);
    procedure setDatum365(const Value: TDateTime);
    procedure setDatum1(const Value: TDateTime);
    procedure setWert7(const Value: real);
    procedure setWert14(const Value: real);
    procedure setWert30(const Value: real);
    procedure setWert60(const Value: real);
    procedure setWert90(const Value: real);
    procedure setWert180(const Value: real);
    procedure setWert365(const Value: real);
    procedure setWert1(const Value: real);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AkId: Integer read fAkId write setAkId;
    property Datum7: TDateTime read fDatum7 write setDatum7;
    property Datum14: TDateTime read fDatum14 write setDatum14;
    property Datum30: TDateTime read fDatum30 write setDatum30;
    property Datum60: TDateTime read fDatum60 write setDatum60;
    property Datum90: TDateTime read fDatum90 write setDatum90;
    property Datum180: TDateTime read fDatum180 write setDatum180;
    property Datum365: TDateTime read fDatum365 write setDatum365;
    property Datum1: TDateTime read fDatum1 write setDatum1;
    property Wert7: real read fWert7 write setWert7;
    property Wert14: real read fWert14 write setWert14;
    property Wert30: real read fWert30 write setWert30;
    property Wert60: real read fWert60 write setWert60;
    property Wert90: real read fWert90 write setWert90;
    property Wert180: real read fWert180 write setWert180;
    property Wert365: real read fWert365 write setWert365;
    property Wert1: real read fWert1 write setWert1;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAktie(aAkId: Integer);
  end;

implementation

{ TDBAbwProz }

constructor TDBAbwProz.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('AP_AK_ID', ftInteger);
  FFeldList.Add('AP_DATUM7', ftDate);
  FFeldList.Add('AP_DATUM14', ftDate);
  FFeldList.Add('AP_DATUM30', ftDate);
  FFeldList.Add('AP_DATUM60', ftDate);
  FFeldList.Add('AP_DATUM90', ftDate);
  FFeldList.Add('AP_DATUM180', ftDate);
  FFeldList.Add('AP_DATUM365', ftDate);
  FFeldList.Add('AP_WERT7', ftFloat);
  FFeldList.Add('AP_WERT14', ftFloat);
  FFeldList.Add('AP_WERT30', ftFloat);
  FFeldList.Add('AP_WERT60', ftFloat);
  FFeldList.Add('AP_WERT90', ftFloat);
  FFeldList.Add('AP_WERT180', ftFloat);
  FFeldList.Add('AP_WERT365', ftFloat);
  FFeldList.Add('AP_DATUM1', ftDate);
  FFeldList.Add('AP_WERT1', ftFloat);
end;

destructor TDBAbwProz.Destroy;
begin

  inherited;
end;

function TDBAbwProz.getGeneratorName: string;
begin
  Result := 'AP_ID';
end;

function TDBAbwProz.getTableName: string;
begin
  Result := 'ABWPROZ';
end;

function TDBAbwProz.getTablePrefix: string;
begin
  Result := 'AP';
end;

procedure TDBAbwProz.Init;
begin
  inherited;
  fDatum7   := 0;
  fDatum14  := 0;
  fDatum30  := 0;
  fDatum90  := 0;
  fDatum180  := 0;
  fDatum365  := 0;
  fDatum1    := 0;
  fAkId   := 0;
  fWert7 := 0;
  fWert14 := 0;
  fWert30 := 0;
  fWert90 := 0;
  fWert180 := 0;
  fWert365 := 0;
  fWert1   := 0;
  FuelleDBFelder;
end;



procedure TDBAbwProz.FuelleDBFelder;
begin
  fFeldList.FieldByName('AP_ID').AsInteger       := fID;
  fFeldList.FieldByName('AP_AK_ID').AsInteger    := fAKID;
  fFeldList.FieldByName('AP_DATUM7').AsDateTime  := fDatum7;
  fFeldList.FieldByName('AP_DATUM14').AsDateTime := fDatum14;
  fFeldList.FieldByName('AP_DATUM30').AsDateTime := fDatum30;
  fFeldList.FieldByName('AP_DATUM60').AsDateTime := fDatum60;
  fFeldList.FieldByName('AP_DATUM90').AsDateTime := fDatum90;
  fFeldList.FieldByName('AP_DATUM180').AsDateTime := fDatum180;
  fFeldList.FieldByName('AP_DATUM365').AsDateTime := fDatum365;
  fFeldList.FieldByName('AP_DATUM1').AsDateTime   := fDatum1;
  fFeldList.FieldByName('AP_WERT7').AsFloat      := fWert7;
  fFeldList.FieldByName('AP_WERT14').AsFloat     := fWert14;
  fFeldList.FieldByName('AP_WERT30').AsFloat     := fWert30;
  fFeldList.FieldByName('AP_WERT60').AsFloat     := fWert60;
  fFeldList.FieldByName('AP_WERT90').AsFloat     := fWert90;
  fFeldList.FieldByName('AP_WERT180').AsFloat     := fWert180;
  fFeldList.FieldByName('AP_WERT365').AsFloat     := fWert365;
  fFeldList.FieldByName('AP_WERT1').AsFloat       := fWert1;
  inherited;
end;



procedure TDBAbwProz.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID     := aQuery.FieldByName('AP_AK_ID').AsInteger;
  fDatum7   := aQuery.FieldByName('AP_DATUM7').AsDateTime;
  fDatum14  := aQuery.FieldByName('AP_DATUM14').AsDateTime;
  fDatum30  := aQuery.FieldByName('AP_DATUM30').AsDateTime;
  fDatum60  := aQuery.FieldByName('AP_DATUM30').AsDateTime;
  fDatum90  := aQuery.FieldByName('AP_DATUM60').AsDateTime;
  fDatum180  := aQuery.FieldByName('AP_DATUM180').AsDateTime;
  fDatum365  := aQuery.FieldByName('AP_DATUM365').AsDateTime;
  fDatum1    := aQuery.FieldByName('AP_DATUM1').AsDateTime;
  fWert7    := aQuery.FieldByName('AP_WERT7').AsFloat;
  fWert14   := aQuery.FieldByName('AP_WERT14').AsFloat;
  fWert30   := aQuery.FieldByName('AP_WERT30').AsFloat;
  fWert60   := aQuery.FieldByName('AP_WERT60').AsFloat;
  fWert90   := aQuery.FieldByName('AP_WERT90').AsFloat;
  fWert180   := aQuery.FieldByName('AP_WERT180').AsFloat;
  fWert365   := aQuery.FieldByName('AP_WERT365').AsFloat;
  fWert1     := aQuery.FieldByName('AP_WERT1').AsFloat;
  FuelleDBFelder;
end;

procedure TDBAbwProz.SaveToDB;
begin
  inherited;

end;

procedure TDBAbwProz.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum14(const Value: TDateTime);
begin
  UpdateV(fDatum14, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum30(const Value: TDateTime);
begin
  UpdateV(fDatum30, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum7(const Value: TDateTime);
begin
  UpdateV(fDatum7, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum60(const Value: TDateTime);
begin
  UpdateV(fDatum60, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum90(const Value: TDateTime);
begin
  UpdateV(fDatum90, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum180(const Value: TDateTime);
begin
  UpdateV(fDatum180, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum365(const Value: TDateTime);
begin
  UpdateV(fDatum365, Value);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setDatum1(const Value: TDateTime);
begin
  UpdateV(fDatum1, Value);
  FuelleDBFelder;
end;



procedure TDBAbwProz.setWert14(const Value: real);
begin
  UpdateV(fWert14, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert30(const Value: real);
begin
  UpdateV(fWert30, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert7(const Value: real);
begin
  UpdateV(fWert7, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert60(const Value: real);
begin
  UpdateV(fWert60, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert90(const Value: real);
begin
  UpdateV(fWert90, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert180(const Value: real);
begin
  UpdateV(fWert180, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert365(const Value: real);
begin
  UpdateV(fWert365, Value, 4);
  FuelleDBFelder;
end;

procedure TDBAbwProz.setWert1(const Value: real);
begin
  UpdateV(fWert1, Value, 4);
  FuelleDBFelder;
end;





procedure TDBAbwProz.ReadAktie(aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where ap_ak_id = ' + IntToStr(aAkId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

end.
