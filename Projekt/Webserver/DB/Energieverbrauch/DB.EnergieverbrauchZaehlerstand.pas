unit DB.EnergieverbrauchZaehlerstand;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  c.JsonError, Json.EnergieverbrauchZaehler, db.TBTransaction, Json.ErrorList;

type
  TDBEnergieverbrauchZaehlerstand = class(TDBBasis)
  private
    fZaId: Integer;
    fWertStr: string;
    fTimestamp: string;
    fDatum: TDateTime;
    fWert: Currency;
    procedure setDatum(const Value: TDateTime);
    procedure setTimestamp(const Value: string);
    procedure setWert(const Value: Currency);
    procedure setWertStr(const Value: string);
    procedure setZaId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure FuelleDBFelderFromJson; override;
    //function getTableId: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    procedure SaveToDB; override;
    property ZaId: Integer read fZaId write setZaId;
    property Wert: Currency read fWert write setWert;
    property WertStr: string read fWertStr write setWertStr;
    property Datum: TDateTime read fDatum write setDatum;
    property Timestamp: string read fTimestamp write setTimestamp;
    function getLetzterEndpunkt(aZaId: Integer; aDatum: TDateTime): TDateTime;
    function getNaechsterEndpunkt(aZaId: Integer; aDatum: TDateTime): TDateTime;
    function getEndpunktWert(aZaId: Integer;aDatum: TDateTime): Extended;
  end;

implementation

{ TDBEnergieverbrauchZaehlerstand }


constructor TDBEnergieverbrauchZaehlerstand.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('ZS_ZA_ID', ftString);
  fFeldList.Add('ZS_WERT', ftFloat);
  fFeldList.Add('ZS_DATUM', ftDateTime);
  fFeldList.Add('ZS_WERTSTR', ftString);
  fFeldList.Add('ZS_TIMESTAMP', ftString);
  Init;
end;

destructor TDBEnergieverbrauchZaehlerstand.Destroy;
begin
  inherited;
end;

procedure TDBEnergieverbrauchZaehlerstand.Init;
begin
  inherited;
  fZaId      := 0;
  fWertStr   := '';
  fTimestamp := '';
  fDatum     := 0;
  fWert      := 0;
  FuelleDBFelder;
end;




procedure TDBEnergieverbrauchZaehlerstand.FuelleDBFelder;
begin
  fFeldList.FieldByName('ZS_ZA_ID').AsInteger  := fZaId;
  fFeldList.FieldByName('ZS_WERT').AsFloat     := fWert;
  fFeldList.FieldByName('ZS_WERTSTR').AsString := fWertStr;
  fFeldList.FieldByName('ZS_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('ZS_TIMESTAMP').AsString := fTimestamp;
  inherited;
end;

procedure TDBEnergieverbrauchZaehlerstand.FuelleDBFelderFromJson;
begin
  inherited;

end;

function TDBEnergieverbrauchZaehlerstand.getGeneratorName: string;
begin
  Result := 'ZS_ID';
end;

function TDBEnergieverbrauchZaehlerstand.getTableName: string;
begin
  Result := 'ZAEHLERSTAND';
end;

function TDBEnergieverbrauchZaehlerstand.getTablePrefix: string;
begin
  Result := 'ZS';
end;



procedure TDBEnergieverbrauchZaehlerstand.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fZaId := aQuery.FieldByName('ZS_ZA_ID').AsInteger;
  fWert := aQuery.FieldByName('ZS_WERT').AsFloat;
  fWertStr := aQuery.FieldByName('ZS_WERTSTR').AsString;
  fDatum := aQuery.FieldByName('ZS_DATUM').AsDateTime;
  fTimestamp := aQuery.FieldByName('ZS_TIMESTAMP').AsString;
  FuelleDBFelder;
end;



procedure TDBEnergieverbrauchZaehlerstand.SaveToDB;
begin
  inherited;

end;









procedure TDBEnergieverbrauchZaehlerstand.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('ZS_DATUM').AsDateTime := trunc(fDatum);
end;

procedure TDBEnergieverbrauchZaehlerstand.setTimestamp(const Value: string);
begin
  UpdateV(fTimestamp, Value);
  fFeldList.FieldByName('ZS_TIMESTAMP').AsString := fTimestamp;
end;

procedure TDBEnergieverbrauchZaehlerstand.setWert(const Value: Currency);
begin
  UpdateV(fWert, Value);
  fFeldList.FieldByName('ZS_WERT').AsFloat := fWert;
end;

procedure TDBEnergieverbrauchZaehlerstand.setWertStr(const Value: string);
begin
  UpdateV(fWertStr, Value);
  fFeldList.FieldByName('ZS_WERTSTR').AsString := fWertStr;
end;

procedure TDBEnergieverbrauchZaehlerstand.setZaId(const Value: Integer);
begin
  UpdateV(fZaId, Value);
  fFeldList.FieldByName('ZS_ZA_ID').AsInteger := fZaId;
end;

function TDBEnergieverbrauchZaehlerstand.getLetzterEndpunkt(aZaId: Integer; aDatum: TDateTime): TDateTime;
begin
  fQuery.Close;
  fQuery.Sql.Text := ' select zs_datum from zaehlerstand' +
                     ' where zs_delete != :del' +
                     ' and   zs_datum < :datum' +
                     ' and   zs_za_id = :zaid' +
                     ' order by zs_datum desc' ;
  fQuery.ParamByName('datum').AsDateTime := trunc(aDatum);
  fQuery.ParamByName('zaid').AsInteger   := aZaId;
  fQuery.ParamByName('del').AsString     := 'T';
  fQuery.OpenTrans;
  fQuery.Open;
  if not fQuery.Eof then
    Result := trunc(fQuery.Fields[0].AsDateTime)
  else
    Result := 0;
  fQuery.Close;
  fQuery.RollbackTrans;
end;

function TDBEnergieverbrauchZaehlerstand.getNaechsterEndpunkt(aZaId: Integer; aDatum: TDateTime): TDateTime;
begin
  fQuery.Close;
  fQuery.Sql.Text := ' select zs_datum from zaehlerstand' +
                     ' where zs_delete != :del' +
                     ' and   zs_datum > :datum' +
                     ' and   zs_za_id = :zaid' +
                     ' order by zs_datum' ;
  fQuery.ParamByName('datum').AsDateTime := trunc(aDatum);
  fQuery.ParamByName('zaid').AsInteger := aZaId;
  fQuery.ParamByName('del').AsString     := 'T';
  fQuery.OpenTrans;
  fQuery.Open;
  if not fQuery.Eof then
    Result := trunc(fQuery.Fields[0].AsDateTime)
  else
    Result := 0;
  fQuery.Close;
  fQuery.RollbackTrans;
end;

function TDBEnergieverbrauchZaehlerstand.getEndpunktWert(aZaId: Integer; aDatum: TDateTime): Extended;
begin
  fQuery.Close;
  fQuery.Sql.Text := ' select zs_wert from zaehlerstand' +
                     ' where zs_delete != :del' +
                     ' and   zs_datum = :datum'+
                     ' and   zs_za_id = :zaid';
  fQuery.ParamByName('del').AsString     := 'T';
  fQuery.ParamByName('datum').AsDateTime := trunc(aDatum);
  fQuery.ParamByName('zaid').AsInteger := aZaId;
  fQuery.OpenTrans;
  fQuery.Open;
  if not fQuery.Eof then
    Result := fQuery.Fields[0].AsFloat
  else
    Result := 0;
  fQuery.Close;
  fQuery.RollbackTrans;
end;


end.
