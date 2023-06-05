unit DB.Aktie;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;

type
  TDBAktie = class(TDBBasis)
  private
    fSymbol: string;
    fAktiv: Boolean;
    fLink: string;
    fDepot: Boolean;
    fAktie: string;
    fBiId: Integer;
    fWKN: string;
    fISIN: string;
    fEPS: real;
    fTickerSymbol: string;
    procedure setISIN(const Value: string);
    procedure setEPS(const Value: real);
    procedure setTickerSymbol(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
    procedure setAktie(const Value: string);
    procedure setAktiv(const Value: Boolean);
    procedure setBiId(const Value: Integer);
    procedure setDebot(const Value: Boolean);
    procedure setLink(const Value: string);
    procedure setSymbol(const Value: string);
    procedure setWKN(const Value: string);
  public
    property Aktie: string read fAktie write setAktie;
    property WKN: string read fWKN write setWKN;
    property Link: string read fLink write setLink;
    property BiId: Integer read fBiId write setBiId;
    property Symbol: string read fSymbol write setSymbol;
    property ISIN: string read fISIN write setISIN;
    property Depot: Boolean read fDepot write setDebot;
    property Aktiv: Boolean read fAktiv write setAktiv;
    property EPS: real read fEPS write setEPS;
    property TickerSymbol: string read fTickerSymbol write setTickerSymbol;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    procedure ReadWKN(aWKN: String);
  end;

implementation

{ TDBAktie }


constructor TDBAktie.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('AK_AKTIE', ftString);
  FFeldList.Add('AK_WKN', ftString);
  FFeldList.Add('AK_LINK', ftString);
  FFeldList.Add('AK_BI_ID', ftInteger);
  FFeldList.Add('AK_SYMBOL', ftString);
  FFeldList.Add('AK_DEPOT', ftString);
  FFeldList.Add('AK_AKTIV', ftString);
  FFeldList.Add('AK_ISIN', ftString);
  FFeldList.Add('AK_EPS', ftFloat);
  FFeldList.Add('AK_TICKERSYMBOL', ftString);
end;

destructor TDBAktie.Destroy;
begin

  inherited;
end;

procedure TDBAktie.Init;
begin
  inherited;
  FuelleDBFelder;
end;

function TDBAktie.getTableName: string;
begin
  Result := 'Aktie';
end;

function TDBAktie.getTablePrefix: string;
begin
  Result := 'AK';
end;


procedure TDBAktie.FuelleDBFelder;
begin
  fFeldList.FieldByName('AK_ID').AsInteger     := fID;
  fFeldList.FieldByName('AK_AKTIE').AsString   := fAktie;
  fFeldList.FieldByName('AK_WKN').AsString     := fWKN;
  fFeldList.FieldByName('AK_LINK').AsString    := fLink;
  fFeldList.FieldByName('AK_BI_ID').AsInteger  := fBiId;
  fFeldList.FieldByName('AK_SYMBOL').AsString  := fSymbol;
  fFeldList.FieldByName('AK_ISIN').AsString    := fISIN;
  fFeldList.FieldByName('AK_DEPOT').AsString   := BoolToStr(fDepot);
  fFeldList.FieldByName('AK_AKTIV').AsString   := BoolToStr(fAktiv);
  fFeldList.FieldByName('AK_EPS').AsFloat      := fEPS;
  fFeldList.FieldByName('AK_TICKERSYMBOL').AsString := fTickerSymbol;

  inherited;
end;

function TDBAktie.getGeneratorName: string;
begin
  Result := 'AK_ID';
end;

procedure TDBAktie.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fAktie  := aQuery.FieldByName('AK_AKTIE').AsString;
  fWKN  := aQuery.FieldByName('AK_WKN').AsString;
  fLink  := aQuery.FieldByName('AK_LINK').AsString;
  fBiId  := aQuery.FieldByName('AK_BI_ID').AsInteger;
  fSymbol  := aQuery.FieldByName('AK_SYMBOL').AsString;
  fISIN    := aQuery.FieldByName('AK_ISIN').AsString;
  fDepot  := aQuery.FieldByName('AK_DEPOT').AsBoolean;
  fAktiv  := aQuery.FieldByName('AK_AKTIV').AsBoolean;
  fEPS    := aQuery.FieldByName('AK_EPS').Asfloat;
  fTickerSymbol := aQuery.FieldByName('AK_TICKERSYMBOL').AsString;
  FuelleDBFelder;
end;


procedure TDBAktie.SaveToDB;
begin
  inherited;

end;

procedure TDBAktie.setAktie(const Value: string);
begin
  UpdateV(fAktie, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setAktiv(const Value: Boolean);
begin
  UpdateV(fAktiv, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setBiId(const Value: Integer);
begin
  UpdateV(fBiId, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setDebot(const Value: Boolean);
begin
  UpdateV(fDepot, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setEPS(const Value: real);
begin
  UpdateV(fEPS, Value, 2);
  FuelleDBFelder;
end;

procedure TDBAktie.setISIN(const Value: string);
begin
  UpdateV(fISIN, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setLink(const Value: string);
begin
  UpdateV(fLink, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setSymbol(const Value: string);
begin
  UpdateV(fSymbol, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setTickerSymbol(const Value: string);
begin
  UpdateV(fTickerSymbol, Value);
  FuelleDBFelder;
end;

procedure TDBAktie.setWKN(const Value: string);
begin
  UpdateV(fWKN, Value);
  FuelleDBFelder;
end;


procedure TDBAktie.ReadWKN(aWKN: String);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where AK_WKN = ' + QuotedStr(aWKN);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.


