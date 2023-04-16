unit DB.Historie2;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db,
  c_Historie;

type
  TDBHistorie2 = class(TDBBasis)
  private
    fHT_ID: Integer;
    fTabelleId: Integer;
    fFremd_ID: Integer;
    fOptimaTabelleID: TOptimaTabelleID;
    fHistorieEvent: THistorieEvent;
    procedure setFremd_ID(const Value: Integer);
    procedure setHT_ID(const Value: Integer);
    procedure setTabelleId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TNFSQuery); override;
    procedure SaveToDB; override;
    property TabelleId: Integer read fTabelleId write setTabelleId;
    property HT_ID: Integer read fHT_ID write setHT_ID;
    property Fremd_ID: Integer read fFremd_ID write setFremd_ID;
    property OptimaTabelleId: TOptimaTabelleID read fOptimaTabelleID;
    property HistorieEvent: THistorieEvent read fHistorieEvent;
  end;

var
  Historie2: TDBHistorie2;


implementation

{ TDBHistorie2 }

uses
  Vcl.Dialogs;

constructor TDBHistorie2.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('H2_TABELLEID', ftInteger);
  FFeldList.Add('H2_HT_ID', ftInteger);
  FFeldList.Add('H2_FREMD_ID', ftInteger);
  Init;
end;

destructor TDBHistorie2.Destroy;
begin

  inherited;
end;

procedure TDBHistorie2.Init;
begin
  inherited;
  fTabelleId := 0;
  fHT_ID     := 0;
  fFremd_Id  := 0;
end;

function TDBHistorie2.getGeneratorName: string;
begin
  Result := 'H2_ID';
end;

function TDBHistorie2.getTableName: string;
begin
  Result := 'HISTORIE2';
end;

function TDBHistorie2.getTablePrefix: string;
begin
  Result := 'H2';
end;



procedure TDBHistorie2.FuelleDBFelder;
begin
  fFeldList.FieldByName('H2_ID').AsInteger        := fID;
  fFeldList.FieldByName('H2_TABELLEID').AsInteger := fTabelleId;
  fFeldList.FieldByName('H2_HT_ID').AsInteger     := fHT_ID;
  fFeldList.FieldByName('H2_FREMD_ID').AsInteger  := fFremd_ID;
  inherited;
end;



procedure TDBHistorie2.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fID        := aQuery.FieldByName('h2_id').AsInteger;
  fTabelleId := aQuery.FieldByName('H2_TABELLEID').AsInteger;
  fHT_ID     := aQuery.FieldByName('H2_HT_ID').AsInteger;
  fFremd_ID  := aQuery.FieldByName('H2_FREMD_ID').AsInteger;
  FuelleDBFelder;
end;

procedure TDBHistorie2.SaveToDB;
begin
  inherited;
end;



procedure TDBHistorie2.setFremd_ID(const Value: Integer);
begin
  fFremd_ID := Value;
  fFeldList.FieldByName('H2_FREMD_ID').AsInteger := Value;
end;

procedure TDBHistorie2.setHT_ID(const Value: Integer);
begin
  fHT_ID := Value;
  fFeldList.FieldByName('H2_HT_ID').AsInteger := Value;
end;

procedure TDBHistorie2.setTabelleId(const Value: Integer);
begin
  fTabelleId := Value;
  fFeldList.FieldByName('H2_TABELLEID').AsInteger := Value;
end;


initialization
  Historie2 := nil;

finalization
 if Historie2 <> nil then
   FreeAndNil(Historie2);

end.

