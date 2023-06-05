unit DB.Depotname;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db;
type
  TDBDepotname = class(TDBBasis)
  private
    fBeId: Integer;
    fDepotname: string;
    procedure setBeId(const Value: Integer);
    procedure setDepotname(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    property Depotname: string read fDepotname write setDepotname;
    property BeId: Integer read fBeId write setBeId;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure SaveToDB; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TDBDepotname }

constructor TDBDepotname.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('DP_NAME', ftString);
  FFeldList.Add('DP_BE_ID', ftInteger);
  Init;
end;

destructor TDBDepotname.Destroy;
begin

  inherited;
end;

procedure TDBDepotname.FuelleDBFelder;
begin
  fFeldList.FieldByName('DP_ID').AsInteger    := fID;
  fFeldList.FieldByName('DP_BE_ID').AsInteger := fBeId;
  fFeldList.FieldByName('DP_NAME').AsString   := fDepotname;
  inherited;
end;

function TDBDepotname.getGeneratorName: string;
begin
  Result := 'DP_ID';
end;

function TDBDepotname.getTableName: string;
begin
  Result := 'DEPOT';
end;

function TDBDepotname.getTablePrefix: string;
begin
  Result := 'DP';
end;

procedure TDBDepotname.Init;
begin
  inherited;
  fBeId := 0;
  fDepotname := '';
  FuelleDBFelder;
end;

procedure TDBDepotname.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fBeId      := aQuery.FieldByName('DP_BE_ID').AsInteger;
  fDepotname := aQuery.FieldByName('DP_NAME').AsString;
  FuelleDBFelder;
end;

procedure TDBDepotname.SaveToDB;
begin
  inherited;

end;

procedure TDBDepotname.setBeId(const Value: Integer);
begin
  UpdateV(fBeId, Value);
  FuelleDBFelder;
end;

procedure TDBDepotname.setDepotname(const Value: string);
begin
  UpdateV(fDepotname, Value);
  FuelleDBFelder;
end;

end.
