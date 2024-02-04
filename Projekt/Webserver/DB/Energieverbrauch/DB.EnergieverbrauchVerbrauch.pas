unit DB.EnergieverbrauchVerbrauch;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  c.JsonError, Json.EnergieverbrauchZaehler, db.TBTransaction, Json.ErrorList;

type
  TDBEnergieverbrauchVerbrauch = class(TDBBasis)
  private
    fZaId: Integer;
    fDatum: TDateTime;
    fWert: Currency;
    procedure setDatum(const Value: TDateTime);
    procedure setWert(const Value: Currency);
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
    property Datum: TDateTime read fDatum write setDatum;
    procedure DeleteBereich(aZaId: Integer; aDatumVon, aDatumBis: TDateTime);
    procedure DeleteAllByZaehler(aZaId: Integer);
    function getLetzterVerbrauch(aZaId: Integer; aDatum: TDateTime): Currency;
  end;

implementation

{ TDBEnergieverbrauchVerbrauch }

constructor TDBEnergieverbrauchVerbrauch.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('VB_ZA_ID', ftString);
  fFeldList.Add('VB_WERT', ftFloat);
  fFeldList.Add('VB_DATUM', ftDateTime);
  Init;
end;


destructor TDBEnergieverbrauchVerbrauch.Destroy;
begin

  inherited;
end;

procedure TDBEnergieverbrauchVerbrauch.Init;
begin
  inherited;
  fZaId      := 0;
  fDatum     := 0;
  fWert      := 0;
  FuelleDBFelder;
end;


procedure TDBEnergieverbrauchVerbrauch.FuelleDBFelder;
begin
  fFeldList.FieldByName('VB_ZA_ID').AsInteger  := fZaId;
  fFeldList.FieldByName('VB_WERT').AsFloat     := fWert;
  fFeldList.FieldByName('VB_DATUM').AsDateTime := fDatum;
  inherited;
end;

procedure TDBEnergieverbrauchVerbrauch.FuelleDBFelderFromJson;
begin
  inherited;

end;

function TDBEnergieverbrauchVerbrauch.getGeneratorName: string;
begin
  Result := 'VB_ID';
end;


function TDBEnergieverbrauchVerbrauch.getTableName: string;
begin
  Result := 'VERBRAUCH';
end;

function TDBEnergieverbrauchVerbrauch.getTablePrefix: string;
begin
  Result := 'VB';
end;


procedure TDBEnergieverbrauchVerbrauch.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fZaId := aQuery.FieldByName('VB_ZA_ID').AsInteger;
  fWert := aQuery.FieldByName('VB_WERT').AsFloat;
  fDatum := aQuery.FieldByName('VB_DATUM').AsDateTime;
  FuelleDBFelder;
end;

procedure TDBEnergieverbrauchVerbrauch.SaveToDB;
begin
  inherited;

end;

procedure TDBEnergieverbrauchVerbrauch.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('VB_DATUM').AsDateTime := fDatum;
end;

procedure TDBEnergieverbrauchVerbrauch.setWert(const Value: Currency);
begin
  UpdateV(fWert, Value);
  fFeldList.FieldByName('VB_WERT').AsFloat := fWert;
end;

procedure TDBEnergieverbrauchVerbrauch.setZaId(const Value: Integer);
begin
  UpdateV(fZaId, Value);
  fFeldList.FieldByName('VB_ZA_ID').AsInteger := fZaId;
end;

procedure TDBEnergieverbrauchVerbrauch.DeleteAllByZaehler(aZaId: Integer);
begin
  fQuery.Close;
  fQuery.Sql.Text := ' delete from verbrauch' +
                     ' where vb_za_id = :zaId';
  fQuery.ParamByName('zaid').AsInteger      := aZaId;
  fQuery.OpenTrans;
  fQuery.ExecSQL;
  fQuery.CommitTrans;
end;

procedure TDBEnergieverbrauchVerbrauch.DeleteBereich(aZaId: Integer; aDatumVon, aDatumBis: TDateTime);
begin //
  fQuery.Close;
  fQuery.Sql.Text := ' delete from verbrauch' +
                     ' where vb_datum >= :datumvon' +
                     ' and   vb_datum <= :datumbis' +
                     ' and   vb_za_id = :zaId';
  fQuery.ParamByName('datumvon').AsDateTime := trunc(aDatumVon);
  fQuery.ParamByName('datumbis').AsDateTime := trunc(aDatumBis);
  fQuery.ParamByName('zaid').AsInteger      := aZaId;
  fQuery.OpenTrans;
  fQuery.ExecSQL;
  fQuery.CommitTrans;
end;

function TDBEnergieverbrauchVerbrauch.getLetzterVerbrauch(aZaId: Integer; aDatum: TDateTime): Currency;
begin //
  fQuery.Close;
  fQuery.Sql.Text := ' select * from verbrauch' +
                     ' where vb_datum <= :datum' +
                     ' and   vb_za_id = :zaId'+
                     ' order by vb_datum desc';
  fQuery.ParamByName('datum').AsDateTime := trunc(aDatum);
  fQuery.ParamByName('zaid').AsInteger      := aZaId;
  fQuery.OpenTrans;
  fQuery.Open;
  if not fQuery.Eof then
    Result := fQuery.FieldByName('vb_wert').AsFloat
  else
    Result := 0;
  fQuery.CommitTrans;
end;



end.
