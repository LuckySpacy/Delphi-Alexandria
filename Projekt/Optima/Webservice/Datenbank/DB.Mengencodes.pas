unit DB.Mengencodes;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, NFSQuery, DB.Basis, Data.db, DB.BasisHistorie;

type
  TDBMengencodes = class(TDBBasisHistorie)
  private
    fEan: string;
    fArId: Integer;
 protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getTableId: Integer; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TNFSQuery); override;
    procedure SaveToDB; override;
    property Ean: string read fEan write fEan;
    property ArId: Integer read fArId write fArId;
    procedure Read_EAN(aValue: string);

  end;

implementation

{ TDBMengencodes }

constructor TDBMengencodes.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('MC_BARCODE', ftString);
  FFeldList.Add('MC_AR_ID', ftInteger);
  Init;
end;

destructor TDBMengencodes.Destroy;
begin

  inherited;
end;

procedure TDBMengencodes.Init;
begin
  inherited;
  fEan := '';
  fArId := 0;
  FuelleDBFelder;
end;

procedure TDBMengencodes.FuelleDBFelder;
begin
  fFeldList.FieldByName('MC_BARCODE').AsString   := fEan;
  fFeldList.FieldByName('MC_AR_ID').AsInteger    := fArId;
  inherited;
end;

function TDBMengencodes.getGeneratorName: string;
begin
  Result := 'MC_ID';
end;

function TDBMengencodes.getTableId: Integer;
begin
  Result := 0;
end;

function TDBMengencodes.getTableName: string;
begin
  Result := 'MENGENCODES';
end;

function TDBMengencodes.getTablePrefix: string;
begin
  Result := 'MC';
end;



procedure TDBMengencodes.LoadByQuery(aQuery: TNFSQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fArId      := aQuery.FieldByName('MC_AR_ID').AsInteger;
  fEan       := aQuery.FieldByName('MC_BARCODE').AsString;
  FuelleDBFelder;
end;


procedure TDBMengencodes.SaveToDB;
begin
  inherited;

end;


procedure TDBMengencodes.Read_EAN(aValue: string);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select mc_id, mc_barcode, mc_ar_id, mc_delete, mc_update ' +
                     ' from mengencodes' +
                     ' where mc_delete != "T"' +
                     ' and   mc_barcode = ' + QuotedStr(aValue);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
