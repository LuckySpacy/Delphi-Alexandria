unit DB.Depotwerte;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBDepotwerte = class(TDBBasis)
  private
    fDpId: Integer;
    fAkId: Integer;
    procedure setAkId(const Value: Integer);
    procedure setDpId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property DpId: Integer read fDpId write setDpId;
    property AkId: Integer read fAkId write setAkId;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAktie(aDpId, aAkId: Integer);
  end;

implementation

{ TDBDepotwerte }

constructor TDBDepotwerte.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('DW_DP_ID', ftInteger);
  FFeldList.Add('DW_AK_ID', ftInteger);
  Init;
end;

destructor TDBDepotwerte.Destroy;
begin

  inherited;
end;

procedure TDBDepotwerte.FuelleDBFelder;
begin
  fFeldList.FieldByName('DW_ID').AsInteger    := fID;
  fFeldList.FieldByName('DW_DP_ID').AsInteger := fDpId;
  fFeldList.FieldByName('DW_AK_ID').AsInteger := fAkId;
  inherited;
end;

function TDBDepotwerte.getGeneratorName: string;
begin
  Result := 'DW_ID';
end;

function TDBDepotwerte.getTableName: string;
begin
  Result := 'DEPOTWERTE';
end;

function TDBDepotwerte.getTablePrefix: string;
begin
  Result := 'DW';
end;

procedure TDBDepotwerte.Init;
begin
  inherited;
  fDpId := 0;
  fAkId := 0;
  FuelleDBFelder;
end;

procedure TDBDepotwerte.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fDpId      := aQuery.FieldByName('DW_DP_ID').AsInteger;
  fAkId      := aQuery.FieldByName('DW_AK_ID').AsInteger;
  FuelleDBFelder;
end;

procedure TDBDepotwerte.ReadAktie(aDpId, aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where dw_dp_id =' + IntToStr(aDpId) +
                     ' and   dw_ak_id =' + IntToStr(aAkId) +
                     ' and   dw_delete != :delete';
  OpenTrans;
  try
    fQuery.ParamByName('delete').AsString := 'T';
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBDepotwerte.SaveToDB;
begin
  inherited;

end;

procedure TDBDepotwerte.setAkId(const Value: Integer);
begin
  UpdateV(fAkId, Value);
  FuelleDBFelder;
end;

procedure TDBDepotwerte.setDpId(const Value: Integer);
begin
  UpdateV(fDpId, Value);
  FuelleDBFelder;
end;

end.
