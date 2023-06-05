unit DB.Dateiformat;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBDateiformat = class(TDBBasis)
  private
    fTrennzeichen: string;
    fPosHoch: Integer;
    fPosSchluss: Integer;
    fDatumFormat: string;
    fPosTief: Integer;
    fPosDatum: Integer;
    fPosVolumen: Integer;
    fPosEroeffnung: Integer;
    fSSID: Integer;
    procedure setDatumFormat(const Value: string);
    procedure setDF_SSID(const Value: Integer);
    procedure setPosDatum(const Value: Integer);
    procedure setPosEroeffnung(const Value: Integer);
    procedure setPosHoch(const Value: Integer);
    procedure setPosSchluss(const Value: Integer);
    procedure setPosTief(const Value: Integer);
    procedure setPosVolumen(const Value: Integer);
    procedure setTrennzeichen(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    property SSID: Integer read fSSID write setDF_SSID;
    property PosDatum: Integer read fPosDatum write setPosDatum;
    property PosEroeffnung: Integer read fPosEroeffnung write setPosEroeffnung;
    property PosHoch: Integer read fPosHoch write setPosHoch;
    property PosTief: Integer read fPosTief write setPosTief;
    property PosSchluss: Integer read fPosSchluss write setPosSchluss;
    property PosVolumen: Integer read fPosVolumen write setPosVolumen;
    property DatumFormat: string read fDatumFormat write setDatumFormat;
    property Trennzeichen: string read fTrennzeichen write setTrennzeichen;
    procedure ReadSSId(aSSId: Integer);
  end;

implementation

{ TDBDateiformat }

constructor TDBDateiformat.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('DF_SS_ID', ftInteger);
  fFeldList.Add('DF_POSDATUM', ftInteger);
  fFeldList.Add('DF_POSEROEFFNUNG', ftInteger);
  fFeldList.Add('DF_POSHOCH', ftInteger);
  fFeldList.Add('DF_POSTIEF', ftInteger);
  fFeldList.Add('DF_POSSCHLUSS', ftInteger);
  fFeldList.Add('DF_POSVOLUMEN', ftInteger);
  fFeldList.Add('DF_DATUMFORMAT', ftString);
  fFeldList.Add('DF_TRENNZEICHEN', ftString);
  Init;
end;

destructor TDBDateiformat.Destroy;
begin

  inherited;
end;

procedure TDBDateiformat.Init;
begin
  inherited;
  fSSId          := 0;
  fPosHoch       := 0;
  fPosSchluss    := 0;
  fDatumFormat   := '';
  fPosTief       := 0;
  fPosDatum      := 0;
  fPosVolumen    := 0;
  fPosEroeffnung := 0;
  fTrennzeichen  := '';
  FuelleDBFelder;
end;

procedure TDBDateiformat.FuelleDBFelder;
begin
  inherited;
  fFeldList.FieldByName('DF_ID').AsInteger            := fID;
  fFeldList.FieldByName('DF_SS_ID').AsInteger         := fSSID;
  fFeldList.FieldByName('DF_POSDATUM').AsInteger      := fPosDatum;
  fFeldList.FieldByName('DF_POSEROEFFNUNG').AsInteger := fPosEroeffnung;
  fFeldList.FieldByName('DF_POSHOCH').AsInteger       := fPosHoch;
  fFeldList.FieldByName('DF_POSTIEF').AsInteger       := fPosTief;
  fFeldList.FieldByName('DF_POSSCHLUSS').AsInteger    := fPosSchluss;
  fFeldList.FieldByName('DF_POSVOLUMEN').AsInteger    := fPosVolumen;
  fFeldList.FieldByName('DF_DATUMFORMAT').AsString    := fDatumFormat;
  fFeldList.FieldByName('DF_TRENNZEICHEN').AsString   := fTrennzeichen;
end;

function TDBDateiformat.getGeneratorName: string;
begin
  Result := 'DF_ID';
end;

function TDBDateiformat.getTableName: string;
begin
  Result := 'Dateiformat';
end;

function TDBDateiformat.getTablePrefix: string;
begin
  Result := 'DF';
end;



procedure TDBDateiformat.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId            := aQuery.FieldByName('DF_ID').AsInteger;
  fSSId          := aQuery.FieldByName('DF_SS_ID').AsInteger;
  fPosHoch       := aQuery.FieldByName('DF_POSHOCH').AsInteger;
  fPosSchluss    := aQuery.FieldByName('DF_POSSCHLUSS').AsInteger;
  fPosTief       := aQuery.FieldByName('DF_POSTIEF').AsInteger;
  fPosDatum      := aQuery.FieldByName('DF_POSDATUM').AsInteger;
  fPosVolumen    := aQuery.FieldByName('DF_POSVOLUMEN').AsInteger;
  fPosEroeffnung := aQuery.FieldByName('DF_POSEROEFFNUNG').AsInteger;
  fDatumFormat   := aQuery.FieldByName('DF_DATUMFORMAT').AsString;
  fTrennzeichen  := aQuery.FieldByName('DF_TRENNZEICHEN').AsString;
  FuelleDBFelder;
end;

procedure TDBDateiformat.SaveToDB;
begin
  inherited;

end;

procedure TDBDateiformat.setDatumFormat(const Value: string);
begin
  UpdateV(fDatumFormat, Value);
  fFeldList.FieldByName('DF_DATUMFORMAT').AsString := fDatumFormat;
end;

procedure TDBDateiformat.setDF_SSID(const Value: Integer);
begin
  UpdateV(fSSID, Value);
  fFeldList.FieldByName('DF_SS_ID').AsInteger := fSSID;
end;

procedure TDBDateiformat.setPosDatum(const Value: Integer);
begin
  UpdateV(fPosDatum, Value);
  fFeldList.FieldByName('DF_POSDATUM').AsInteger := fPosDatum;
end;

procedure TDBDateiformat.setPosEroeffnung(const Value: Integer);
begin
  UpdateV(fPosEroeffnung, Value);
  fFeldList.FieldByName('DF_POSEROEFFNUNG').AsInteger := fPosEroeffnung;
end;

procedure TDBDateiformat.setPosHoch(const Value: Integer);
begin
  UpdateV(fPosHoch, Value);
  fFeldList.FieldByName('DF_POSHOCH').AsInteger := fPosHoch;
end;

procedure TDBDateiformat.setPosSchluss(const Value: Integer);
begin
  UpdateV(fPosSchluss, Value);
  fFeldList.FieldByName('DF_POSSCHLUSS').AsInteger := fPosSchluss;
end;

procedure TDBDateiformat.setPosTief(const Value: Integer);
begin
  UpdateV(fPosTief, Value);
  fFeldList.FieldByName('DF_POSTIEF').AsInteger := fPosTief;
end;

procedure TDBDateiformat.setPosVolumen(const Value: Integer);
begin
  UpdateV(fPosVolumen, Value);
  fFeldList.FieldByName('DF_POSVOLUMEN').AsInteger := fPosVolumen;
end;

procedure TDBDateiformat.setTrennzeichen(const Value: string);
begin
  UpdateV(fTrennzeichen, Value);
  fFeldList.FieldByName('DF_TRENNZEICHEN').AsString := fTrennzeichen;
end;

procedure TDBDateiformat.ReadSSId(aSSId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where DF_SS_ID = ' + IntToStr(aSSId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

end.
