unit DB.GuVJahre;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBGuVJahre = class(TDBBasis)
  private
    fAkId: Integer;
    fJahr1: Integer;
    fProzent1: real;
    fJahr2: Integer;
    fProzent2: real;
    fJahr3: Integer;
    fProzent3: real;
    fJahr4: Integer;
    fProzent4: real;
    fJahr5: Integer;
    fProzent5: real;
    fJahr6: Integer;
    fProzent6: real;
    fDurchschnitt: real;
    fProz365Tage: real;
    fTSI27: real;
    fAbwProz: real;
    fAbwProzSort: real;
    procedure setAkId(const Value: Integer);
    procedure setJahr1(const Value: Integer);
    procedure setProzent1(const Value: real);
    procedure setJahr2(const Value: Integer);
    procedure setProzent2(const Value: real);
    procedure setJahr3(const Value: Integer);
    procedure setProzent3(const Value: real);
    procedure setJahr4(const Value: Integer);
    procedure setProzent4(const Value: real);
    procedure setJahr5(const Value: Integer);
    procedure setProzent5(const Value: real);
    procedure setJahr6(const Value: Integer);
    procedure setProzent6(const Value: real);
    procedure setDurchschnitt(const Value: real);
    procedure setProz365Tage(const Value: real);
    procedure setTSI27(const Value: real);
    procedure setAbwProz(const Value: real);
    procedure setAbwProzSort(const Value: real);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property AkId: Integer read fAkId write setAkId;
    property Jahr1: Integer read fJahr1 write setJahr1;
    property Prozent1: real read fProzent1 write setProzent1;
    property Jahr2: Integer read fJahr2 write setJahr2;
    property Prozent2: real read fProzent2 write setProzent2;
    property Jahr3: Integer read fJahr3 write setJahr3;
    property Prozent3: real read fProzent3 write setProzent3;
    property Jahr4: Integer read fJahr4 write setJahr4;
    property Prozent4: real read fProzent4 write setProzent4;
    property Jahr5: Integer read fJahr5 write setJahr5;
    property Prozent5: real read fProzent5 write setProzent5;
    property Jahr6: Integer read fJahr6 write setJahr6;
    property Prozent6: real read fProzent6 write setProzent6;
    property Durchschnitt: real read fDurchschnitt write setDurchschnitt;
    property Proz365Tage: real read fProz365Tage write setProz365Tage;
    property TSI27: real read fTSI27 write setTSI27;
    property AbwProz: real read fAbwProz write setAbwProz;
    property AbwProzSort: real read fAbwProzSort write setAbwProzSort;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAkId(aAkId: Integer);
  end;

implementation

{ TDBGuVJahr }

constructor TDBGuVJahre.Create(AOwner: TComponent);
begin
  inherited;

  FFeldList.Add('GJ_AK_ID', ftInteger);
  FFeldList.Add('GJ_JAHR1', ftInteger);
  FFeldList.Add('GJ_PROZENT1', ftFloat);
  FFeldList.Add('GJ_JAHR2', ftInteger);
  FFeldList.Add('GJ_PROZENT2', ftFloat);
  FFeldList.Add('GJ_JAHR3', ftInteger);
  FFeldList.Add('GJ_PROZENT3', ftFloat);
  FFeldList.Add('GJ_JAHR4', ftInteger);
  FFeldList.Add('GJ_PROZENT4', ftFloat);
  FFeldList.Add('GJ_JAHR5', ftInteger);
  FFeldList.Add('GJ_PROZENT5', ftFloat);
  FFeldList.Add('GJ_JAHR6', ftInteger);
  FFeldList.Add('GJ_PROZENT6', ftFloat);
  FFeldList.Add('GJ_DURCHSCHNITT', ftFloat);
  FFeldList.Add('GJ_PROZ365TAGE', ftFloat);
  FFeldList.Add('GJ_TSI27', ftFloat);
  FFeldList.Add('GJ_ABWPROZ', ftFloat);
  FFeldList.Add('GJ_ABWPROZSORT', ftFloat);
end;

destructor TDBGuVJahre.Destroy;
begin
  inherited;
end;

procedure TDBGuVJahre.FuelleDBFelder;
begin
  fFeldList.FieldByName('GJ_ID').AsInteger        := fID;
  fFeldList.FieldByName('GJ_AK_ID').AsInteger     := fAKID;
  fFeldList.FieldByName('GJ_JAHR1').AsInteger     := fJahr1;
  fFeldList.FieldByName('GJ_PROZENT1').AsFloat    := fProzent1;
  fFeldList.FieldByName('GJ_JAHR2').AsInteger     := fJahr2;
  fFeldList.FieldByName('GJ_PROZENT2').AsFloat    := fProzent2;
  fFeldList.FieldByName('GJ_JAHR3').AsInteger     := fJahr3;
  fFeldList.FieldByName('GJ_PROZENT3').AsFloat    := fProzent3;
  fFeldList.FieldByName('GJ_JAHR4').AsInteger     := fJahr4;
  fFeldList.FieldByName('GJ_PROZENT4').AsFloat    := fProzent4;
  fFeldList.FieldByName('GJ_JAHR5').AsInteger     := fJahr5;
  fFeldList.FieldByName('GJ_PROZENT5').AsFloat    := fProzent5;
  fFeldList.FieldByName('GJ_JAHR6').AsInteger     := fJahr6;
  fFeldList.FieldByName('GJ_PROZENT6').AsFloat    := fProzent6;
  fFeldList.FieldByName('GJ_DURCHSCHNITT').AsFloat := fDurchschnitt;
  fFeldList.FieldByName('GJ_TSI27').AsFloat := fTSI27;
  fFeldList.FieldByName('GJ_PROZ365TAGE').AsFloat := fProz365Tage;
  fFeldList.FieldByName('GJ_ABWPROZ').AsFloat := fAbwProz;
  fFeldList.FieldByName('GJ_ABWPROZSORT').AsFloat := fAbwProzSort;
  inherited;
end;

function TDBGuVJahre.getGeneratorName: string;
begin
  Result := 'GJ_ID';
end;

function TDBGuVJahre.getTableName: string;
begin
  Result := 'GUVJAHRE';
end;

function TDBGuVJahre.getTablePrefix: string;
begin
  Result := 'GJ';
end;

procedure TDBGuVJahre.Init;
begin
  inherited;
  fAkId         := 0;
  fJahr1        := 0;
  fProzent1     := 0;
  fJahr2        := 0;
  fProzent2     := 0;
  fJahr3        := 0;
  fProzent3     := 0;
  fJahr4        := 0;
  fProzent4     := 0;
  fJahr5        := 0;
  fProzent5     := 0;
  fJahr6        := 0;
  fProzent6     := 0;
  fDurchschnitt := 0;
  fProz365Tage  := 0;
  fTSI27        := 0;
  fAbwProz      := 0;
  fAbwProzSort  := 0;
end;

procedure TDBGuVJahre.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAKID      := aQuery.FieldByName('GJ_AK_ID').AsInteger;
  fJahr1     := aQuery.FieldByName('GJ_JAHR1').AsInteger;
  fProzent1  := aQuery.FieldByName('GJ_PROZENT1').AsFloat;
  fJahr2     := aQuery.FieldByName('GJ_JAHR2').AsInteger;
  fProzent2  := aQuery.FieldByName('GJ_PROZENT2').AsFloat;
  fJahr3     := aQuery.FieldByName('GJ_JAHR3').AsInteger;
  fProzent3  := aQuery.FieldByName('GJ_PROZENT3').AsFloat;
  fJahr4     := aQuery.FieldByName('GJ_JAHR4').AsInteger;
  fProzent4  := aQuery.FieldByName('GJ_PROZENT4').AsFloat;
  fJahr5     := aQuery.FieldByName('GJ_JAHR5').AsInteger;
  fProzent5  := aQuery.FieldByName('GJ_PROZENT5').AsFloat;
  fJahr6     := aQuery.FieldByName('GJ_JAHR6').AsInteger;
  fProzent6  := aQuery.FieldByName('GJ_PROZENT6').AsFloat;
  fDurchschnitt := aQuery.FieldByName('GJ_DURCHSCHNITT').AsFloat;
  fProz365Tage  := aQuery.FieldByName('GJ_PROZ365TAGE').AsFloat;
  fTSI27   := aQuery.FieldByName('GJ_TSI27').AsFloat;
  fAbwProz := aQuery.FieldByName('GJ_ABWPROZ').AsFloat;
  fAbwProzSort := aQuery.FieldByName('GJ_ABWPROZSORT').AsFloat;
  FuelleDBFelder;
end;

procedure TDBGuVJahre.SaveToDB;
begin
  inherited;

end;

procedure TDBGuVJahre.setAbwProz(const Value: real);
begin
  UpdateV(fAbwProz, Value,2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setAbwProzSort(const Value: real);
begin
  UpdateV(fAbwProzSort, Value,2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setDurchschnitt(const Value: real);
begin
  UpdateV(fDurchschnitt, Value,2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr1(const Value: Integer);
begin
  UpdateV(fJahr1, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr2(const Value: Integer);
begin
  UpdateV(fJahr2, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr3(const Value: Integer);
begin
  UpdateV(fJahr3, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr4(const Value: Integer);
begin
  UpdateV(fJahr4, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr5(const Value: Integer);
begin
  UpdateV(fJahr5, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setJahr6(const Value: Integer);
begin
  UpdateV(fJahr6, Value);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProz365Tage(const Value: real);
begin
  UpdateV(fProz365Tage, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent1(const Value: real);
begin
  UpdateV(fProzent1, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent2(const Value: real);
begin
  UpdateV(fProzent2, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent3(const Value: real);
begin
  UpdateV(fProzent3, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent4(const Value: real);
begin
  UpdateV(fProzent4, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent5(const Value: real);
begin
  UpdateV(fProzent5, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setProzent6(const Value: real);
begin
  UpdateV(fProzent6, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.setTSI27(const Value: real);
begin
  UpdateV(fTSI27, Value, 2);
  FuelleDBFelder;
end;

procedure TDBGuVJahre.ReadAkId(aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where gj_ak_id = ' + IntToStr(aAkId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

end.
