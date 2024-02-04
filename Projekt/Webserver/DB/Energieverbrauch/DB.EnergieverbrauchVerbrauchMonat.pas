unit DB.EnergieverbrauchVerbrauchMonat;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db, DB.TBQuery,
  c.JsonError, Json.EnergieverbrauchZaehler, db.TBTransaction, Json.ErrorList;

type
  TDBEnergieverbrauchVerbrauchMonat = class(TDBBasis)
  private
    fZaId: Integer;
    fWert: Currency;
    fJahr: Integer;
    fMonat: Integer;
    procedure setWert(const Value: Currency);
    procedure setZaId(const Value: Integer);
    procedure setJahr(const Value: Integer);
    procedure setMonat(const Value: Integer);
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
    property Monat: Integer read fMonat write setMonat;
    property Jahr: Integer read fJahr write setJahr;
  end;

implementation

{ TDBEnergieverbrauchVerbrauchMonat }

constructor TDBEnergieverbrauchVerbrauchMonat.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('VM_ZA_ID', ftString);
  fFeldList.Add('VM_WERT', ftFloat);
  fFeldList.Add('VM_JAHR', ftInteger);
  fFeldList.Add('VM_MONAT', ftInteger);
  Init;
end;

destructor TDBEnergieverbrauchVerbrauchMonat.Destroy;
begin

  inherited;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.Init;
begin
  inherited;
  fZaId      := 0;
  fJahr      := 0;
  fMonat     := 0;
  fWert      := 0;
  FuelleDBFelder;
end;


procedure TDBEnergieverbrauchVerbrauchMonat.FuelleDBFelder;
begin
  fFeldList.FieldByName('VM_ZA_ID').AsInteger  := fZaId;
  fFeldList.FieldByName('VM_WERT').AsFloat     := fWert;
  fFeldList.FieldByName('VM_JAHR').AsInteger   := fJahr;
  fFeldList.FieldByName('VM_MONAT').AsInteger  := fMonat;
  inherited;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.FuelleDBFelderFromJson;
begin
  inherited;

end;

function TDBEnergieverbrauchVerbrauchMonat.getGeneratorName: string;
begin
  Result := 'VM_ID';
end;

function TDBEnergieverbrauchVerbrauchMonat.getTableName: string;
begin
  Result := 'VERBRAUCHMONAT';
end;

function TDBEnergieverbrauchVerbrauchMonat.getTablePrefix: string;
begin
  Result := 'VM';
end;


procedure TDBEnergieverbrauchVerbrauchMonat.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fZaId  := aQuery.FieldByName('VM_ZA_ID').AsInteger;
  fWert  := aQuery.FieldByName('VM_WERT').AsFloat;
  fJahr  := aQuery.FieldByName('VM_JAHR').AsInteger;
  fMonat := aQuery.FieldByName('VM_MONAT').AsInteger;
  FuelleDBFelder;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.SaveToDB;
begin
  inherited;

end;


procedure TDBEnergieverbrauchVerbrauchMonat.setJahr(const Value: Integer);
begin
  UpdateV(fJahr, Value);
  fFeldList.FieldByName('VM_JAHR').AsInteger := fJahr;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.setMonat(const Value: Integer);
begin
  UpdateV(fMonat, Value);
  fFeldList.FieldByName('VM_MONAT').AsInteger := fMonat;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.setWert(const Value: Currency);
begin
  UpdateV(fWert, Value);
  fFeldList.FieldByName('VM_WERT').AsFloat := fWert;
end;

procedure TDBEnergieverbrauchVerbrauchMonat.setZaId(const Value: Integer);
begin
  UpdateV(fZaId, Value);
  fFeldList.FieldByName('VM_ZA_ID').AsInteger := fZaId;
end;

end.
